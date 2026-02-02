/**
 * GloomStalker - Integration Hook
 * 
 * Main entry point for Artificer and other agents to use GloomStalker.
 * Call this before executing any task to load the minimal necessary context.
 * 
 * @module gloomstalker/hook
 */

import { fileURLToPath } from 'url';
import { loadContext, formatLoadingResult, getFilePaths, LoadingResult } from './context-loader.js';

// ============================================================================
// Configuration
// ============================================================================

interface GloomStalkerConfig {
  /** Enable debug logging */
  debug?: boolean;
  
  /** Minimum number of files to load (safety net) */
  minFiles?: number;
  
  /** Maximum number of files to load (prevent overload) */
  maxFiles?: number;
  
  /** Override working directory */
  workingDir?: string;
  
  /** Enable token estimation */
  estimateTokens?: boolean;
}

const DEFAULT_CONFIG: GloomStalkerConfig = {
  debug: false,
  minFiles: 2, // At least user prefs + conventions
  maxFiles: 15, // Prevent loading too many files
  estimateTokens: true
};

// ============================================================================
// Main Hook
// ============================================================================

/**
 * GloomStalker Hook - Scout ahead and load minimal context
 * 
 * This is the main function that Artificer calls before executing a task.
 * 
 * @param task - User's task description
 * @param config - Optional configuration
 * @returns Array of file paths to load
 * 
 * @example
 * ```typescript
 * const files = await gloomstalkerHook("Add a test for login form");
 * // For a work project, files might = [
 * //   "~/.config/opencode/context/general/user-preferences.md",
 * //   "~/.config/opencode/context/work/conventions.md",
 * //   "~/.config/opencode/context/work/core/testing-patterns.md",
 * //   "~/.config/opencode/context/work/ui/web/react-patterns.md"
 * // ]
 * ```
 */
export const gloomstalkerHook = async (
  task: string,
  config: GloomStalkerConfig = {}
): Promise<string[]> => {
  const finalConfig = { ...DEFAULT_CONFIG, ...config };
  const workingDir = finalConfig.workingDir || process.cwd();
  
  // Log start if debug enabled
  if (finalConfig.debug) {
    console.log('\n' + '='.repeat(80));
    console.log('🔦 GloomStalker: Scouting ahead...');
    console.log('='.repeat(80));
    console.log(`Task: "${task}"`);
    console.log(`Working Directory: ${workingDir}`);
    console.log('');
  }
  
  // Load context
  const result = loadContext(task, workingDir);
  
  // Apply min/max file limits
  let finalFiles = result.files;
  
  if (finalFiles.length < finalConfig.minFiles!) {
    if (finalConfig.debug) {
      console.warn(`⚠️  Warning: Only ${finalFiles.length} files loaded (min: ${finalConfig.minFiles})`);
      console.warn('    This is expected for generic tasks or non-FanDuel projects.');
    }
  }
  
  if (finalFiles.length > finalConfig.maxFiles!) {
    if (finalConfig.debug) {
      console.warn(`⚠️  Warning: ${finalFiles.length} files loaded (max: ${finalConfig.maxFiles})`);
      console.warn(`    Limiting to top ${finalConfig.maxFiles} files by priority.`);
    }
    finalFiles = finalFiles.slice(0, finalConfig.maxFiles);
  }
  
  // Log result if debug enabled
  if (finalConfig.debug) {
    console.log(formatLoadingResult({
      ...result,
      files: finalFiles,
      totalFiles: finalFiles.length
    }));
    console.log('');
  }
  
  // Return file paths
  const filePaths = finalFiles.map(f => f.path);
  
  if (finalConfig.debug) {
    console.log('🎯 GloomStalker: Context loaded successfully');
    console.log(`   Files: ${filePaths.length}`);
    if (finalConfig.estimateTokens) {
      const totalLines = finalFiles.reduce((sum, f) => {
        // Re-estimate since we might have filtered
        try {
          const fs = require('fs');
          const content = fs.readFileSync(f.path, 'utf-8');
          return sum + content.split('\n').length;
        } catch {
          return sum + 150; // Fallback estimate
        }
      }, 0);
      const tokens = totalLines * 4;
      console.log(`   Estimated Tokens: ~${tokens.toLocaleString()}`);
    }
    console.log('='.repeat(80) + '\n');
  }
  
  return filePaths;
};

// ============================================================================
// Simplified API (for non-async contexts)
// ============================================================================

/**
 * Synchronous version of gloomstalkerHook
 * 
 * Use this when you can't use async/await.
 */
export const gloomstalkerHookSync = (
  task: string,
  config: GloomStalkerConfig = {}
): string[] => {
  const finalConfig = { ...DEFAULT_CONFIG, ...config };
  const workingDir = finalConfig.workingDir || process.cwd();
  
  const result = loadContext(task, workingDir);
  
  let finalFiles = result.files;
  
  // Apply limits
  if (finalFiles.length > finalConfig.maxFiles!) {
    finalFiles = finalFiles.slice(0, finalConfig.maxFiles);
  }
  
  return finalFiles.map(f => f.path);
};

// ============================================================================
// Utility Functions
// ============================================================================

/**
 * Get detailed loading result (for debugging)
 */
export const getLoadingDetails = (
  task: string,
  config: GloomStalkerConfig = {}
): LoadingResult => {
  const workingDir = config.workingDir || process.cwd();
  return loadContext(task, workingDir);
};

/**
 * Print loading result to console (for CLI usage)
 */
export const printLoadingResult = (
  task: string,
  config: GloomStalkerConfig = {}
): void => {
  const result = getLoadingDetails(task, config);
  console.log(formatLoadingResult(result));
};

// ============================================================================
// CLI Support
// ============================================================================

/**
 * CLI entry point (if running directly)
 * 
 * Usage:
 *   node dist/hook.js "Add a test for login form"
 *   node dist/hook.js "Add a test" --debug
 */
// Check if running as CLI (more reliable for ESM)
const isMainModule = import.meta.url === `file://${process.argv[1]}` || 
                     import.meta.url.endsWith(process.argv[1]);

if (isMainModule) {
  const args = process.argv.slice(2);
  
  if (args.length === 0) {
    console.error('Usage: node hook.js "<task>" [--debug]');
    console.error('');
    console.error('Examples:');
    console.error('  node hook.js "Add a test for login form"');
    console.error('  node hook.js "Fix API auth bug" --debug');
    process.exit(1);
  }
  
  const task = args[0];
  const debug = args.includes('--debug') || args.includes('-d');
  
  gloomstalkerHook(task, { debug: true })
    .then(files => {
      if (!debug) {
        console.log('\nFiles to load:');
        files.forEach(f => console.log(`  - ${f}`));
      }
    })
    .catch(error => {
      console.error('Error:', error);
      process.exit(1);
    });
}

// ============================================================================
// Export Default
// ============================================================================

export default {
  gloomstalkerHook,
  gloomstalkerHookSync,
  getLoadingDetails,
  printLoadingResult
};
