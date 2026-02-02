/**
 * GloomStalker - Context Loader
 * 
 * Loads context files based on keyword detection and project metadata.
 * Implements hierarchical context loading strategy.
 * 
 * @module gloomstalker/context-loader
 */

import * as fs from 'fs';
import * as path from 'path';
import { detectKeywords, KeywordMatch } from './keyword-detector.js';

// ============================================================================
// Types
// ============================================================================

export interface ContextFile {
  path: string;
  priority: number;
  reason: string;
  category: 'always' | 'core' | 'domain' | 'project' | 'related';
}

export interface ProjectMetadata {
  version: string;
  project: string;
  description?: string;
  contextFiles: {
    [filename: string]: {
      alwaysLoad: boolean;
      priority: number;
      keywords?: string[];
      description?: string;
    };
  };
  relatedContexts?: string[];
  tags?: string[];
}

export interface LoadingResult {
  files: ContextFile[];
  task: string;
  project?: string;
  keywordMatches: KeywordMatch[];
  totalFiles: number;
  estimatedTokens: number;
}

// ============================================================================
// Constants
// ============================================================================

const CONTEXT_BASE_DIR = path.join(
  process.env.HOME || '~',
  '.config/opencode/context'
);

// General context (always loaded - public patterns)
const GENERAL_DIR = path.join(CONTEXT_BASE_DIR, 'general');
const GENERAL_CORE_DIR = path.join(GENERAL_DIR, 'core');
const GENERAL_UI_DIR = path.join(GENERAL_DIR, 'ui/web');

// Work context (loaded for work projects only)
const WORK_DIR = path.join(CONTEXT_BASE_DIR, 'work');
const WORK_CORE_DIR = path.join(WORK_DIR, 'core');
const WORK_UI_DIR = path.join(WORK_DIR, 'ui/web');
const WORK_PROJECTS_DIR = path.join(WORK_DIR, 'projects');
const WORK_CONVENTIONS_PATH = path.join(WORK_DIR, 'conventions.md');

// Personal context (loaded for personal projects)
const PERSONAL_DIR = path.join(CONTEXT_BASE_DIR, 'personal');
const PERSONAL_PROJECTS_DIR = path.join(PERSONAL_DIR, 'projects');

// User preferences (always loaded)
const USER_PREFS_PATH = path.join(GENERAL_DIR, 'user-preferences.md');

// Average lines per file (for token estimation)
const AVG_LINES_PER_FILE = 150;
const TOKENS_PER_LINE = 4; // Rough estimate

// ============================================================================
// Helper Functions
// ============================================================================

/**
 * Expand ~ to home directory
 */
const expandPath = (filePath: string): string => {
  if (filePath.startsWith('~')) {
    return filePath.replace('~', process.env.HOME || '~');
  }
  return filePath;
};

/**
 * Check if file exists
 */
const fileExists = (filePath: string): boolean => {
  try {
    return fs.existsSync(expandPath(filePath));
  } catch {
    return false;
  }
};

/**
 * Read and parse JSON file
 */
const readJsonFile = <T>(filePath: string): T | null => {
  try {
    const expanded = expandPath(filePath);
    if (!fs.existsSync(expanded)) {
      return null;
    }
    const content = fs.readFileSync(expanded, 'utf-8');
    return JSON.parse(content) as T;
  } catch (error) {
    console.warn(`Failed to read JSON file ${filePath}:`, error);
    return null;
  }
};

/**
 * Estimate line count from file
 */
const estimateLineCount = (filePath: string): number => {
  try {
    const expanded = expandPath(filePath);
    if (!fs.existsSync(expanded)) {
      return AVG_LINES_PER_FILE;
    }
    const content = fs.readFileSync(expanded, 'utf-8');
    return content.split('\n').length;
  } catch {
    return AVG_LINES_PER_FILE;
  }
};

// ============================================================================
// Project Detection
// ============================================================================

export type ProjectType = 'work' | 'personal' | 'unknown';

export interface ProjectInfo {
  name: string;
  type: ProjectType;
}

/**
 * Detect project type based on working directory
 */
const detectProjectType = (workingDir: string, projectName: string): ProjectType => {
  const expanded = expandPath(workingDir);
  
  // Check if in work projects directory
  const workProjectPath = path.join(WORK_PROJECTS_DIR, projectName, 'project-metadata.json');
  if (fileExists(workProjectPath)) {
    return 'work';
  }
  
  // Check if in personal projects directory
  const personalProjectPath = path.join(PERSONAL_PROJECTS_DIR, projectName, 'project-metadata.json');
  if (fileExists(personalProjectPath)) {
    return 'personal';
  }
  
  // Fallback: Check if path contains known work indicators
  if (expanded.includes('fanduel') || expanded.includes('work')) {
    return 'work';
  }
  
  // Fallback: Check if path contains personal indicators
  if (expanded.includes('personal') || expanded.includes('dots')) {
    return 'personal';
  }
  
  return 'unknown';
};

/**
 * Detect project from working directory
 * 
 * Matches against known project paths and metadata files
 * Returns both project name and type (work/personal)
 */
export const detectProject = (workingDir: string): ProjectInfo | null => {
  const expanded = expandPath(workingDir);
  
  // Try to find project-metadata.json in current or parent directories
  let currentDir = expanded;
  let depth = 0;
  const maxDepth = 5; // Don't traverse too far up
  
  while (depth < maxDepth) {
    // Check for project-metadata.json
    const metadataPath = path.join(currentDir, 'project-metadata.json');
    if (fileExists(metadataPath)) {
      const metadata = readJsonFile<ProjectMetadata>(metadataPath);
      if (metadata?.project) {
        const type = detectProjectType(currentDir, metadata.project);
        return { name: metadata.project, type };
      }
    }
    
    // Check against known project names in work projects
    const dirname = path.basename(currentDir);
    const workProjectMetadata = path.join(WORK_PROJECTS_DIR, dirname, 'project-metadata.json');
    if (fileExists(workProjectMetadata)) {
      return { name: dirname, type: 'work' };
    }
    
    // Check against known project names in personal projects
    const personalProjectMetadata = path.join(PERSONAL_PROJECTS_DIR, dirname, 'project-metadata.json');
    if (fileExists(personalProjectMetadata)) {
      return { name: dirname, type: 'personal' };
    }
    
    // Move up one directory
    const parentDir = path.dirname(currentDir);
    if (parentDir === currentDir) {
      break; // Reached root
    }
    currentDir = parentDir;
    depth++;
  }
  
  return null;
};

/**
 * Get project metadata path based on project type
 */
const getProjectMetadataPath = (projectName: string, projectType: ProjectType): string => {
  if (projectType === 'work') {
    return path.join(WORK_PROJECTS_DIR, projectName, 'project-metadata.json');
  } else if (projectType === 'personal') {
    return path.join(PERSONAL_PROJECTS_DIR, projectName, 'project-metadata.json');
  }
  
  // Fallback: Try both locations
  const workPath = path.join(WORK_PROJECTS_DIR, projectName, 'project-metadata.json');
  if (fileExists(workPath)) {
    return workPath;
  }
  
  return path.join(PERSONAL_PROJECTS_DIR, projectName, 'project-metadata.json');
};

/**
 * Load project metadata
 */
const loadProjectMetadata = (projectName: string, projectType: ProjectType): ProjectMetadata | null => {
  const metadataPath = getProjectMetadataPath(projectName, projectType);
  return readJsonFile<ProjectMetadata>(metadataPath);
};

// ============================================================================
// Context File Selection
// ============================================================================

/**
 * Add core files that should always load
 */
const addAlwaysLoadFiles = (files: ContextFile[], projectType: ProjectType): void => {
  // User preferences (always load from general)
  if (fileExists(USER_PREFS_PATH)) {
    files.push({
      path: USER_PREFS_PATH,
      priority: 1,
      reason: 'User preferences (always loaded)',
      category: 'always'
    });
  }
  
  // Work conventions (only load for work projects)
  if (projectType === 'work' && fileExists(WORK_CONVENTIONS_PATH)) {
    files.push({
      path: WORK_CONVENTIONS_PATH,
      priority: 1,
      reason: 'Work conventions (work project detected)',
      category: 'always'
    });
  }
};

/**
 * Add project-specific files
 */
const addProjectFiles = (
  files: ContextFile[],
  projectName: string,
  projectType: ProjectType,
  metadata: ProjectMetadata,
  keywordMatches: KeywordMatch[]
): void => {
  const projectDir = projectType === 'work'
    ? path.join(WORK_PROJECTS_DIR, projectName)
    : path.join(PERSONAL_PROJECTS_DIR, projectName);
  
  // Extract matched keywords for quick lookup
  const matchedKeywords = new Set<string>();
  keywordMatches.forEach(match => {
    match.matchedKeywords.forEach(kw => matchedKeywords.add(kw.toLowerCase()));
  });
  
  // Process each context file in metadata
  for (const [filename, config] of Object.entries(metadata.contextFiles)) {
    const filePath = path.join(projectDir, filename);
    
    if (!fileExists(filePath)) {
      continue;
    }
    
    // Always load files
    if (config.alwaysLoad) {
      files.push({
        path: filePath,
        priority: config.priority,
        reason: `Project core context (${projectName})`,
        category: 'project'
      });
      continue;
    }
    
    // Keyword-based loading
    if (config.keywords && config.keywords.length > 0) {
      const matchedFileKeywords = config.keywords.filter(kw =>
        matchedKeywords.has(kw.toLowerCase())
      );
      
      if (matchedFileKeywords.length > 0) {
        files.push({
          path: filePath,
          priority: config.priority,
          reason: `Project-specific patterns (keywords: ${matchedFileKeywords.join(', ')})`,
          category: 'project'
        });
      }
    }
  }
};

/**
 * Add core pattern files based on keyword matches
 * Loads from general (always) and work (if work project)
 */
const addCoreFiles = (
  files: ContextFile[],
  keywordMatches: KeywordMatch[],
  projectType: ProjectType
): void => {
  for (const match of keywordMatches) {
    if (match.domain === 'core') {
      // Extract filename from match.file (e.g., "core/testing-patterns.md" → "testing-patterns.md")
      const filename = match.file.replace('core/', '');
      
      // Always try general core first
      const generalFilePath = path.join(GENERAL_CORE_DIR, filename);
      if (fileExists(generalFilePath)) {
        files.push({
          path: generalFilePath,
          priority: 2,
          reason: `Core patterns (keywords: ${match.matchedKeywords.join(', ')})`,
          category: 'core'
        });
      }
      
      // For work projects, also check work-specific core patterns
      if (projectType === 'work') {
        const workFilePath = path.join(WORK_CORE_DIR, filename);
        if (fileExists(workFilePath)) {
          files.push({
            path: workFilePath,
            priority: 2,
            reason: `Work core patterns (keywords: ${match.matchedKeywords.join(', ')})`,
            category: 'core'
          });
        }
      }
    }
  }
};

/**
 * Add domain-specific pattern files based on keyword matches
 * Loads from general (always) and work (if work project)
 */
const addDomainFiles = (
  files: ContextFile[],
  keywordMatches: KeywordMatch[],
  projectType: ProjectType
): void => {
  for (const match of keywordMatches) {
    if (match.domain === 'ui') {
      // Extract the filename from match.file (e.g., "ui/web/react-patterns.md" → "react-patterns.md")
      const filename = path.basename(match.file);
      
      // Always try general UI first
      const generalFilePath = path.join(GENERAL_UI_DIR, filename);
      if (fileExists(generalFilePath)) {
        files.push({
          path: generalFilePath,
          priority: 3,
          reason: `UI patterns (keywords: ${match.matchedKeywords.join(', ')})`,
          category: 'domain'
        });
      }
      
      // For work projects, also check work-specific UI patterns
      if (projectType === 'work') {
        const workFilePath = path.join(WORK_UI_DIR, filename);
        if (fileExists(workFilePath)) {
          files.push({
            path: workFilePath,
            priority: 3,
            reason: `Work UI patterns (keywords: ${match.matchedKeywords.join(', ')})`,
            category: 'domain'
          });
        }
      }
    }
  }
};

/**
 * Add related context files from metadata
 */
const addRelatedFiles = (
  files: ContextFile[],
  metadata: ProjectMetadata
): void => {
  if (!metadata.relatedContexts || metadata.relatedContexts.length === 0) {
    return;
  }
  
  for (const relatedPath of metadata.relatedContexts) {
    const expanded = expandPath(relatedPath);
    
    if (fileExists(expanded)) {
      // Extract a short name for the reason
      const filename = path.basename(relatedPath);
      files.push({
        path: expanded,
        priority: 5,
        reason: `Related context (${filename})`,
        category: 'related'
      });
    }
  }
};

/**
 * Remove duplicate files (same path)
 */
const deduplicateFiles = (files: ContextFile[]): ContextFile[] => {
  const seen = new Map<string, ContextFile>();
  
  for (const file of files) {
    const normalized = expandPath(file.path);
    
    if (!seen.has(normalized)) {
      seen.set(normalized, file);
    } else {
      // Keep the one with higher priority (lower number = higher priority)
      const existing = seen.get(normalized)!;
      if (file.priority < existing.priority) {
        seen.set(normalized, file);
      }
    }
  }
  
  return Array.from(seen.values());
};

/**
 * Sort files by priority (lower number = higher priority)
 */
const sortByPriority = (files: ContextFile[]): ContextFile[] => {
  return files.sort((a, b) => {
    if (a.priority !== b.priority) {
      return a.priority - b.priority;
    }
    // Secondary sort by category
    const categoryOrder = { always: 0, project: 1, core: 2, domain: 3, related: 4 };
    return categoryOrder[a.category] - categoryOrder[b.category];
  });
};

// ============================================================================
// Main Loading Logic
// ============================================================================

/**
 * Load context files for a given task and working directory
 * 
 * @param task - User's task description
 * @param workingDir - Current working directory
 * @returns Loading result with files to load and metadata
 */
export const loadContext = (
  task: string,
  workingDir: string = process.cwd()
): LoadingResult => {
  const files: ContextFile[] = [];
  
  // 1. Detect keywords from task
  const detection = detectKeywords(task);
  const keywordMatches = detection.matches;
  
  // 2. Detect current project (returns name + type)
  const projectInfo = detectProject(workingDir);
  const projectName = projectInfo?.name;
  const projectType = projectInfo?.type || 'unknown';
  
  // 3. Always load files (Priority 1)
  addAlwaysLoadFiles(files, projectType);
  
  // 4. Load project-specific files
  if (projectName && projectInfo) {
    const metadata = loadProjectMetadata(projectName, projectInfo.type);
    
    if (metadata) {
      // Add project files (Priority 1 for always-load, 4 for keyword-based)
      addProjectFiles(files, projectName, projectInfo.type, metadata, keywordMatches);
      
      // Add related files (Priority 5)
      addRelatedFiles(files, metadata);
    }
  }
  
  // 5. Load core pattern files (Priority 2)
  // Loads from general/ (always) and work/ (if work project)
  addCoreFiles(files, keywordMatches, projectType);
  
  // 6. Load domain pattern files (Priority 3)
  // Loads from general/ (always) and work/ (if work project)
  addDomainFiles(files, keywordMatches, projectType);
  
  // 7. Deduplicate and sort
  const uniqueFiles = deduplicateFiles(files);
  const sortedFiles = sortByPriority(uniqueFiles);
  
  // 8. Estimate tokens
  const totalLines = sortedFiles.reduce((sum, file) => {
    return sum + estimateLineCount(file.path);
  }, 0);
  const estimatedTokens = totalLines * TOKENS_PER_LINE;
  
  return {
    files: sortedFiles,
    task,
    project: projectName || undefined,
    keywordMatches,
    totalFiles: sortedFiles.length,
    estimatedTokens
  };
};

// ============================================================================
// Utility Functions
// ============================================================================

/**
 * Format loading result for display
 */
export const formatLoadingResult = (result: LoadingResult): string => {
  const lines: string[] = [];
  
  lines.push('='.repeat(80));
  lines.push('GloomStalker Context Loading');
  lines.push('='.repeat(80));
  lines.push('');
  
  lines.push(`Task: "${result.task}"`);
  lines.push(`Project: ${result.project || 'None detected'}`);
  lines.push(`Total Files: ${result.totalFiles}`);
  lines.push(`Estimated Tokens: ~${result.estimatedTokens.toLocaleString()}`);
  lines.push('');
  
  if (result.keywordMatches.length > 0) {
    lines.push('Keyword Matches:');
    for (const match of result.keywordMatches.slice(0, 5)) {
      lines.push(`  - ${match.file} (score: ${match.score})`);
      lines.push(`    Keywords: ${match.matchedKeywords.join(', ')}`);
    }
    lines.push('');
  }
  
  lines.push('Files to Load:');
  lines.push('');
  
  // Group by priority
  const byPriority = new Map<number, ContextFile[]>();
  for (const file of result.files) {
    if (!byPriority.has(file.priority)) {
      byPriority.set(file.priority, []);
    }
    byPriority.get(file.priority)!.push(file);
  }
  
  const priorities = Array.from(byPriority.keys()).sort((a, b) => a - b);
  
  for (const priority of priorities) {
    const filesAtPriority = byPriority.get(priority)!;
    lines.push(`Priority ${priority}:`);
    
    for (const file of filesAtPriority) {
      const relativePath = file.path.replace(process.env.HOME || '~', '~');
      const lineCount = estimateLineCount(file.path);
      lines.push(`  ✓ ${relativePath}`);
      lines.push(`    Reason: ${file.reason}`);
      lines.push(`    Lines: ~${lineCount}`);
    }
    lines.push('');
  }
  
  lines.push('='.repeat(80));
  
  return lines.join('\n');
};

/**
 * Get file paths only (for integration)
 */
export const getFilePaths = (result: LoadingResult): string[] => {
  return result.files.map(f => f.path);
};

// ============================================================================
// Export Default
// ============================================================================

export default {
  loadContext,
  detectProject,
  formatLoadingResult,
  getFilePaths
};
