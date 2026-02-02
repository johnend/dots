/**
 * Multi-step task detection logic
 * Analyzes user prompts to determine if they require todo tracking
 */

export interface DetectionResult {
  isMultiStep: boolean;
  score: number;
  indicators: string[];
  confidence: 'low' | 'medium' | 'high';
}

export interface DetectionConfig {
  sensitivity: 'low' | 'medium' | 'high';
  thresholds: {
    low: number;
    medium: number;
    high: number;
  };
}

const DEFAULT_CONFIG: DetectionConfig = {
  sensitivity: 'medium',
  thresholds: {
    low: 3,
    medium: 2,
    high: 1,
  },
};

// Action verbs that indicate work to be done
const ACTION_VERBS = [
  'add', 'create', 'implement', 'write', 'refactor', 'update',
  'fix', 'test', 'deploy', 'build', 'configure', 'setup',
  'remove', 'delete', 'modify', 'change', 'migrate', 'upgrade',
  'install', 'document', 'validate', 'optimize', 'improve',
];

// Conjunctions that indicate multiple steps
const CONJUNCTIONS = /\b(and|then|after|before|also|plus|with)\b/i;

// Cross-cutting patterns
const CROSS_CUTTING_PATTERNS = [
  /\bacross\s+\w+\s+and\s+\w+\b/i,  // "across X and Y"
  /\bmultiple\s+(apps?|projects?|services?|components?|files?)\b/i,
  /\ball\s+\w+\b/i,  // "all components", "all tests"
  /\beverywhere\b/i,
  /\bthroughout\b/i,
];

/**
 * Count action verbs in the prompt
 */
function countActionVerbs(prompt: string): number {
  const lowerPrompt = prompt.toLowerCase();
  let count = 0;
  
  for (const verb of ACTION_VERBS) {
    const regex = new RegExp(`\\b${verb}\\b`, 'g');
    const matches = lowerPrompt.match(regex);
    if (matches) {
      count += matches.length;
    }
  }
  
  return count;
}

/**
 * Check if prompt has conjunctions indicating sequential steps
 */
function hasConjunctions(prompt: string): boolean {
  return CONJUNCTIONS.test(prompt);
}

/**
 * Check if prompt mentions multiple files/components
 */
function mentionsMultipleFiles(prompt: string): boolean {
  const patterns = [
    /\b\d+\s*(files?|components?|services?|tests?|modules?)\b/i,
    /\bseveral\s+(files?|components?|services?)\b/i,
    /\bmany\s+(files?|components?|services?)\b/i,
  ];
  
  return patterns.some(pattern => pattern.test(prompt));
}

/**
 * Check if prompt has cross-cutting concerns
 */
function hasCrossCutting(prompt: string): boolean {
  return CROSS_CUTTING_PATTERNS.some(pattern => pattern.test(prompt));
}

/**
 * Check if prompt is long/complex
 */
function isComplex(prompt: string): boolean {
  return prompt.length > 200;
}

/**
 * Detect if a prompt describes a multi-step task
 */
export function detectMultiStep(
  prompt: string,
  config: DetectionConfig = DEFAULT_CONFIG
): DetectionResult {
  const indicators: string[] = [];
  let score = 0;
  
  // Count action verbs (weight: 2 points if >= 2 verbs)
  const verbCount = countActionVerbs(prompt);
  if (verbCount >= 2) {
    score += 2;
    indicators.push(`${verbCount} action verbs found`);
  }
  
  // Check for conjunctions (weight: 1 point)
  if (hasConjunctions(prompt)) {
    score += 1;
    indicators.push('Sequential conjunctions detected');
  }
  
  // Check complexity (weight: 1 point)
  if (isComplex(prompt)) {
    score += 1;
    indicators.push('Complex request (>200 chars)');
  }
  
  // Check for multiple files (weight: 1 point)
  if (mentionsMultipleFiles(prompt)) {
    score += 1;
    indicators.push('Multiple files/components mentioned');
  }
  
  // Check for cross-cutting concerns (weight: 2 points)
  if (hasCrossCutting(prompt)) {
    score += 2;
    indicators.push('Cross-cutting concerns detected');
  }
  
  // Determine if multi-step based on threshold
  const threshold = config.thresholds[config.sensitivity];
  const isMultiStep = score >= threshold;
  
  // Determine confidence level
  let confidence: 'low' | 'medium' | 'high';
  if (score >= 5) {
    confidence = 'high';
  } else if (score >= 3) {
    confidence = 'medium';
  } else {
    confidence = 'low';
  }
  
  return {
    isMultiStep,
    score,
    indicators,
    confidence,
  };
}

/**
 * Extract action verbs from prompt for todo suggestion
 */
export function extractActionVerbs(prompt: string): string[] {
  const lowerPrompt = prompt.toLowerCase();
  const found: string[] = [];
  
  for (const verb of ACTION_VERBS) {
    const regex = new RegExp(`\\b${verb}\\b`, 'g');
    if (regex.test(lowerPrompt)) {
      found.push(verb);
    }
  }
  
  return found;
}
