#!/usr/bin/env node

/**
 * Obsidian Mapper
 * 
 * Infers and caches mappings between code repositories and Obsidian vault locations.
 * Uses fuzzy matching to find appropriate Obsidian folders for documentation.
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

const OBSIDIAN_ROOT = path.join(os.homedir(), 'Developer', 'personal', 'Obsidian');
const MAPPINGS_FILE = path.join(os.homedir(), '.config', 'opencode', 'obsidian-mappings.json');
const FANDUEL_DIR = path.join(os.homedir(), 'Developer', 'fanduel');

/**
 * Load cached mappings from disk
 */
function loadMappings() {
  try {
    if (fs.existsSync(MAPPINGS_FILE)) {
      const content = fs.readFileSync(MAPPINGS_FILE, 'utf-8');
      return JSON.parse(content);
    }
  } catch (error) {
    console.error('Warning: Failed to load mappings:', error.message);
  }
  return { work: {}, personal: {} };
}

/**
 * Save mappings to disk
 */
function saveMappings(mappings) {
  try {
    const dir = path.dirname(MAPPINGS_FILE);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    fs.writeFileSync(MAPPINGS_FILE, JSON.stringify(mappings, null, 2), 'utf-8');
  } catch (error) {
    console.error('Error: Failed to save mappings:', error.message);
    process.exit(1);
  }
}

/**
 * Scan Obsidian directory for potential matches
 */
function scanObsidianFolders(baseDir) {
  const folders = [];
  
  function scan(dir, depth = 0) {
    if (depth > 2) return; // Only scan 2 levels deep
    
    try {
      const entries = fs.readdirSync(dir, { withFileTypes: true });
      
      for (const entry of entries) {
        if (entry.isDirectory() && !entry.name.startsWith('.')) {
          const fullPath = path.join(dir, entry.name);
          const relativePath = path.relative(OBSIDIAN_ROOT, fullPath);
          folders.push({
            name: entry.name,
            path: relativePath,
            fullPath: fullPath
          });
          scan(fullPath, depth + 1);
        }
      }
    } catch (error) {
      // Skip directories we can't read
    }
  }
  
  scan(baseDir);
  return folders;
}

/**
 * Normalize string for fuzzy matching (lowercase, no spaces/dashes/underscores)
 */
function normalize(str) {
  return str.toLowerCase().replace(/[\s\-_]/g, '');
}

/**
 * Calculate similarity score between two strings (0-1)
 */
function similarity(str1, str2) {
  const s1 = normalize(str1);
  const s2 = normalize(str2);
  
  // Exact match
  if (s1 === s2) return 1.0;
  
  // Contains match
  if (s1.includes(s2) || s2.includes(s1)) return 0.8;
  
  // Levenshtein distance (simple version)
  const maxLen = Math.max(s1.length, s2.length);
  if (maxLen === 0) return 1.0;
  
  const distance = levenshteinDistance(s1, s2);
  return 1.0 - (distance / maxLen);
}

/**
 * Simple Levenshtein distance implementation
 */
function levenshteinDistance(str1, str2) {
  const matrix = [];
  
  for (let i = 0; i <= str2.length; i++) {
    matrix[i] = [i];
  }
  
  for (let j = 0; j <= str1.length; j++) {
    matrix[0][j] = j;
  }
  
  for (let i = 1; i <= str2.length; i++) {
    for (let j = 1; j <= str1.length; j++) {
      if (str2.charAt(i - 1) === str1.charAt(j - 1)) {
        matrix[i][j] = matrix[i - 1][j - 1];
      } else {
        matrix[i][j] = Math.min(
          matrix[i - 1][j - 1] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j] + 1
        );
      }
    }
  }
  
  return matrix[str2.length][str1.length];
}

/**
 * Find best matching Obsidian folder for a project
 */
function findBestMatch(projectName, folders) {
  let bestMatch = null;
  let bestScore = 0;
  
  for (const folder of folders) {
    const score = similarity(projectName, folder.name);
    
    if (score > bestScore && score > 0.5) { // Minimum threshold
      bestScore = score;
      bestMatch = folder;
    }
  }
  
  return bestMatch ? { ...bestMatch, score: bestScore } : null;
}

/**
 * Infer Obsidian location for a working directory
 */
function inferLocation(workingDir) {
  const mappings = loadMappings();
  
  // Determine if work or personal
  const isWork = workingDir.startsWith(FANDUEL_DIR);
  const projectType = isWork ? 'work' : 'personal';
  
  // Extract project name from path
  const projectName = path.basename(workingDir);
  
  // Check cache first
  if (mappings[projectType][projectName]) {
    return {
      cached: true,
      projectType,
      projectName,
      obsidianPath: mappings[projectType][projectName],
      fullPath: path.join(OBSIDIAN_ROOT, mappings[projectType][projectName])
    };
  }
  
  // Scan appropriate Obsidian directory
  const searchBase = isWork 
    ? path.join(OBSIDIAN_ROOT, 'Work', 'Domains')
    : path.join(OBSIDIAN_ROOT, 'Personal', 'Projects');
  
  if (!fs.existsSync(searchBase)) {
    return {
      cached: false,
      projectType,
      projectName,
      error: `Search base does not exist: ${searchBase}`,
      obsidianPath: null,
      fullPath: null
    };
  }
  
  const folders = scanObsidianFolders(searchBase);
  const match = findBestMatch(projectName, folders);
  
  if (match) {
    return {
      cached: false,
      projectType,
      projectName,
      obsidianPath: match.path,
      fullPath: match.fullPath,
      confidence: match.score,
      needsConfirmation: true
    };
  }
  
  // No match found
  return {
    cached: false,
    projectType,
    projectName,
    obsidianPath: null,
    fullPath: null,
    error: 'No matching folder found',
    needsUserInput: true
  };
}

/**
 * Cache a confirmed mapping
 */
function cacheMapping(projectType, projectName, obsidianPath) {
  const mappings = loadMappings();
  mappings[projectType][projectName] = obsidianPath;
  saveMappings(mappings);
  
  return {
    success: true,
    projectType,
    projectName,
    obsidianPath,
    fullPath: path.join(OBSIDIAN_ROOT, obsidianPath)
  };
}

/**
 * List all cached mappings
 */
function listMappings() {
  const mappings = loadMappings();
  return mappings;
}

/**
 * Remove a cached mapping
 */
function removeMapping(projectType, projectName) {
  const mappings = loadMappings();
  
  if (mappings[projectType] && mappings[projectType][projectName]) {
    delete mappings[projectType][projectName];
    saveMappings(mappings);
    return { success: true, removed: true };
  }
  
  return { success: false, error: 'Mapping not found' };
}

// CLI Interface
if (require.main === module) {
  const args = process.argv.slice(2);
  const command = args[0];
  
  if (command === 'infer') {
    const workingDir = args[1] || process.cwd();
    const result = inferLocation(workingDir);
    console.log(JSON.stringify(result, null, 2));
  } else if (command === 'cache') {
    const projectType = args[1];
    const projectName = args[2];
    const obsidianPath = args[3];
    
    if (!projectType || !projectName || !obsidianPath) {
      console.error('Usage: obsidian-mapper.js cache <work|personal> <projectName> <obsidianPath>');
      process.exit(1);
    }
    
    const result = cacheMapping(projectType, projectName, obsidianPath);
    console.log(JSON.stringify(result, null, 2));
  } else if (command === 'list') {
    const mappings = listMappings();
    console.log(JSON.stringify(mappings, null, 2));
  } else if (command === 'remove') {
    const projectType = args[1];
    const projectName = args[2];
    
    if (!projectType || !projectName) {
      console.error('Usage: obsidian-mapper.js remove <work|personal> <projectName>');
      process.exit(1);
    }
    
    const result = removeMapping(projectType, projectName);
    console.log(JSON.stringify(result, null, 2));
  } else {
    console.log('Obsidian Mapper - Infer and cache Obsidian vault locations');
    console.log('');
    console.log('Usage:');
    console.log('  obsidian-mapper.js infer [workingDir]     - Infer Obsidian location');
    console.log('  obsidian-mapper.js cache <type> <name> <path> - Cache a mapping');
    console.log('  obsidian-mapper.js list                   - List all cached mappings');
    console.log('  obsidian-mapper.js remove <type> <name>   - Remove a cached mapping');
    console.log('');
    console.log('Examples:');
    console.log('  obsidian-mapper.js infer ~/Developer/fanduel/raf-app');
    console.log('  obsidian-mapper.js cache work raf-app "Work/Domains/Refer-a-Friend"');
    console.log('  obsidian-mapper.js list');
    console.log('  obsidian-mapper.js remove work raf-app');
    process.exit(0);
  }
}

module.exports = {
  inferLocation,
  cacheMapping,
  listMappings,
  removeMapping,
  loadMappings,
  saveMappings
};
