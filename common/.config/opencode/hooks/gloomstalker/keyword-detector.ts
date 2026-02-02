/**
 * GloomStalker - Keyword Detection System
 * 
 * Analyzes user tasks to extract keywords and match them against
 * context file metadata for smart context loading.
 * 
 * @module gloomstalker/keyword-detector
 */

// ============================================================================
// Keyword Mappings
// ============================================================================

// Core patterns - loaded from work/core/ or general/core/ based on project type
export const CORE_KEYWORDS: Record<string, string[]> = {
  'testing-patterns.md': [
    'test', 'spec', 'jest', 'cypress', 'playwright', 'vitest', 'e2e', 'end to end',
    'unit test', 'integration test', 'component test',
    'pact', 'contract', 'storybook', 'percy', 'chromatic',
    'rtl', 'testing library', 'test coverage', 'mock', 'snapshot'
  ],
  'state-management.md': [
    'state', 'redux', 'store', 'slice', 'selector', 'action',
    'zustand', 'tanstack query', 'query', 'mutation', 'react query',
    'cache', 'recoil', 'context api', 'reducer', 'thunk', 'jotai'
  ],
  'api-patterns.md': [
    'api', 'fetch', 'axios', 'graphql', 'apollo', 'rest',
    'endpoint', 'request', 'response', 'auth', 'token',
    'jwt', 'authentication', 'authorization', 'http', 'client',
    'interceptor', 'error handling', 'retry', 'urql', 'trpc'
  ],
  'nx-monorepo.md': [
    'nx', 'monorepo', 'affected', 'workspace', 'library',
    'lib', 'project.json', 'nx.json', 'dependency graph',
    'cache', 'affected tests', 'nx cloud'
  ],
  'react-native-patterns.md': [
    'react native', 'native', 'ios', 'android', 'mobile',
    'platform', 'navigation', 'navigation stack', 'tab navigator',
    'flatlist', 'flashlist', 'detox', 'reanimated', 'gesture',
    'safe area', 'asyncstorage', 'expo'
  ]
};

// Domain/UI patterns - loaded from work/ui/web/ or general/ui/web/ based on project type
export const DOMAIN_KEYWORDS: Record<string, string[]> = {
  'ui/web/react-patterns.md': [
    'react', 'component', 'hook', 'useeffect', 'usestate',
    'props', 'jsx', 'tsx', 'render', 'memo', 'callback',
    'suspense', 'lazy', 'error boundary', 'form', 'formik',
    'react hook form', 'usememo', 'usecallback', 'useref'
  ],
  'ui/web/styling-patterns.md': [
    'styled-components', 'styled', 'emotion', 'css', 'css-in-js',
    'theme', 'global style', 'style', 'styling', 'responsive',
    'media query', 'tailwind', 'sass', 'less', 'postcss'
  ],
  'ui/web/fela-styling.md': [
    'fela', 'formation', 'rule', 'renderer'
  ]
};

// ============================================================================
// Types
// ============================================================================

export interface KeywordMatch {
  file: string;
  matchedKeywords: string[];
  score: number;
  domain: 'core' | 'ui';
}

export interface DetectionResult {
  matches: KeywordMatch[];
  task: string;
  extractedKeywords: string[];
}

// ============================================================================
// Keyword Extraction
// ============================================================================

/**
 * Normalize text for keyword matching
 * - Lowercase
 * - Remove punctuation
 * - Handle common variations
 */
export const normalizeText = (text: string): string => {
  return text
    .toLowerCase()
    .replace(/[^\w\s-]/g, ' ') // Remove punctuation except hyphens
    .replace(/\s+/g, ' ') // Collapse whitespace
    .trim();
};

/**
 * Extract potential keywords from user task
 * Uses word boundaries to avoid partial matches
 */
export const extractKeywords = (task: string): string[] => {
  const normalized = normalizeText(task);
  const words = normalized.split(' ');
  
  const keywords: Set<string> = new Set();
  
  // Single words
  words.forEach(word => {
    if (word.length > 2) { // Skip very short words
      keywords.add(word);
    }
  });
  
  // Bigrams (two-word phrases)
  for (let i = 0; i < words.length - 1; i++) {
    keywords.add(`${words[i]} ${words[i + 1]}`);
  }
  
  // Trigrams (three-word phrases)
  for (let i = 0; i < words.length - 2; i++) {
    keywords.add(`${words[i]} ${words[i + 1]} ${words[i + 2]}`);
  }
  
  return Array.from(keywords);
};

// ============================================================================
// Keyword Matching
// ============================================================================

/**
 * Check if a keyword matches a pattern
 * Supports:
 * - Exact match: "test" matches "test"
 * - Partial match: "testing" matches "test"
 * - Fuzzy match: "authentication" matches "auth"
 */
export const matchesKeyword = (extracted: string, pattern: string): boolean => {
  const extractedNorm = normalizeText(extracted);
  const patternNorm = normalizeText(pattern);
  
  // Exact match
  if (extractedNorm === patternNorm) return true;
  
  // Pattern contained in extracted
  if (extractedNorm.includes(patternNorm)) return true;
  
  // Extracted contained in pattern (for longer keywords)
  if (patternNorm.includes(extractedNorm) && extractedNorm.length > 3) return true;
  
  return false;
};

/**
 * Calculate match score for a file based on matched keywords
 * More matches = higher score
 * Longer keyword matches = higher weight
 */
export const calculateScore = (matchedKeywords: string[]): number => {
  return matchedKeywords.reduce((score, keyword) => {
    const length = keyword.length;
    // Longer keywords are more specific, so weight them more
    if (length > 10) return score + 3;
    if (length > 5) return score + 2;
    return score + 1;
  }, 0);
};

/**
 * Match extracted keywords against a keyword set
 */
export const matchAgainstKeywords = (
  extracted: string[],
  patterns: string[]
): string[] => {
  const matched: Set<string> = new Set();
  
  for (const ext of extracted) {
    for (const pattern of patterns) {
      if (matchesKeyword(ext, pattern)) {
        matched.add(pattern);
      }
    }
  }
  
  return Array.from(matched);
};

// ============================================================================
// Main Detection Logic
// ============================================================================

/**
 * Detect keywords in a user task and match against context files
 * 
 * @param task - User's task description
 * @returns Detection results with matched files and scores
 */
export const detectKeywords = (task: string): DetectionResult => {
  const extractedKeywords = extractKeywords(task);
  const matches: KeywordMatch[] = [];
  
  // Match against core keywords
  for (const [file, patterns] of Object.entries(CORE_KEYWORDS)) {
    const matchedKeywords = matchAgainstKeywords(extractedKeywords, patterns);
    
    if (matchedKeywords.length > 0) {
      matches.push({
        file: `core/${file}`,
        matchedKeywords,
        score: calculateScore(matchedKeywords),
        domain: 'core'
      });
    }
  }
  
  // Match against domain keywords
  for (const [file, patterns] of Object.entries(DOMAIN_KEYWORDS)) {
    const matchedKeywords = matchAgainstKeywords(extractedKeywords, patterns);
    
    if (matchedKeywords.length > 0) {
      matches.push({
        file,
        matchedKeywords,
        score: calculateScore(matchedKeywords),
        domain: 'ui'
      });
    }
  }
  
  // Sort by score (highest first)
  matches.sort((a, b) => b.score - a.score);
  
  return {
    matches,
    task,
    extractedKeywords
  };
};

// ============================================================================
// Utility Functions
// ============================================================================

/**
 * Get top N matching files
 */
export const getTopMatches = (
  result: DetectionResult,
  n: number = 5
): KeywordMatch[] => {
  return result.matches.slice(0, n);
};

/**
 * Filter matches by minimum score
 */
export const filterByScore = (
  result: DetectionResult,
  minScore: number = 1
): KeywordMatch[] => {
  return result.matches.filter(match => match.score >= minScore);
};

/**
 * Get all matching files (no filtering)
 */
export const getAllMatches = (result: DetectionResult): KeywordMatch[] => {
  return result.matches;
};

// ============================================================================
// Export Default
// ============================================================================

export default {
  detectKeywords,
  getTopMatches,
  filterByScore,
  getAllMatches,
  extractKeywords,
  matchesKeyword,
  normalizeText
};
