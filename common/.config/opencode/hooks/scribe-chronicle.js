#!/usr/bin/env node

/**
 * Scribe Chronicle Command
 * 
 * Creates rich documentation in Obsidian vault based on:
 * - Current working directory (work vs personal)
 * - Content type (code, workflow, concept, tool)
 * - Session context from GloomStalker
 * - User's documentation request
 * 
 * Routes documentation to appropriate Obsidian location and formats it accordingly.
 */

const fs = require('fs');
const path = require('path');
const os = require('os');
const { execSync } = require('child_process');

const OBSIDIAN_ROOT = path.join(os.homedir(), 'Developer', 'personal', 'Obsidian');
const OBSIDIAN_MAPPER = path.join(__dirname, 'obsidian-mapper.js');
const GLOOMSTALKER_CLI = path.join(__dirname, 'gloomstalker', 'cli.js');

/**
 * Detect content type from user request
 */
function detectContentType(request, context) {
  const requestLower = request.toLowerCase();
  
  // Code documentation indicators
  if (requestLower.match(/\b(function|class|component|api|endpoint|service|implementation)\b/)) {
    return 'code';
  }
  
  // Workflow documentation indicators
  if (requestLower.match(/\b(workflow|process|flow|pipeline|deployment|how to)\b/)) {
    return 'workflow';
  }
  
  // Learning/concept indicators
  if (requestLower.match(/\b(learn|understand|concept|pattern|theory|how .* works)\b/)) {
    return 'learning';
  }
  
  // Tool/script indicators
  if (requestLower.match(/\b(tool|script|command|setup|config|install)\b/)) {
    return 'tool';
  }
  
  // Default to concept
  return 'concept';
}

/**
 * Determine specific Obsidian folder based on content type and project
 */
function determineObsidianFolder(location, contentType, projectType) {
  const { obsidianPath } = location;
  
  // If we have a specific project path (from inference), use it for project-specific docs
  if (obsidianPath && !obsidianPath.includes('Knowledge')) {
    // This is a domain/project folder
    if (contentType === 'code' || contentType === 'workflow') {
      return obsidianPath; // Use the project-specific folder
    }
  }
  
  // Route based on content type
  if (projectType === 'work') {
    if (contentType === 'learning' || contentType === 'concept' || contentType === 'tool') {
      return 'Work/Knowledge';
    }
    return obsidianPath || 'Work/Knowledge'; // Fallback to Knowledge
  } else {
    // Personal
    if (contentType === 'learning') {
      return 'Personal/Learning/Notes';
    } else if (contentType === 'tool') {
      return 'Personal/Knowledge/Tools';
    } else if (obsidianPath) {
      return obsidianPath; // Project-specific
    }
    return 'Personal/Knowledge';
  }
}

/**
 * Generate file name based on topic and location
 */
function generateFileName(topic, contentType) {
  // Normalize topic to kebab-case
  const normalized = topic
    .trim()
    .replace(/[^\w\s-]/g, '') // Remove special chars
    .replace(/\s+/g, '-')     // Spaces to dashes
    .replace(/-+/g, '-')      // Multiple dashes to single
    .replace(/^-|-$/g, '');   // Trim dashes
  
  // Capitalize first letter of each word for title case
  const titleCase = normalized
    .split('-')
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join('-');
  
  return `${titleCase}.md`;
}

/**
 * Format current date as YYYY-MM-DD
 */
function getCurrentDate() {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

/**
 * Generate documentation template based on content type
 */
function generateTemplate(contentType, topic, projectName, request) {
  const date = getCurrentDate();
  
  const templates = {
    code: `# ${topic}

**Created:** ${date}${projectName ? `\n**Project:** ${projectName}` : ''}

## Overview

[Brief explanation of what this code does]

## Implementation

[Code examples and explanations]

\`\`\`typescript
// Example code here
\`\`\`

## Key Components

- **Component 1:** Description
- **Component 2:** Description

## Usage

[How to use this feature/component]

\`\`\`typescript
// Usage example
\`\`\`

## Notes

- Important considerations
- Edge cases
- Known limitations

## Related

- [Related Documentation]

---

**Tags:** #code #${projectName ? projectName.toLowerCase().replace(/\s+/g, '-') : 'general'}
`,

    workflow: `# ${topic}

**Created:** ${date}${projectName ? `\n**Project:** ${projectName}` : ''}

## Overview

[What this workflow accomplishes]

## Steps

1. **Step 1:** Description
2. **Step 2:** Description
3. **Step 3:** Description

## Flow Diagram

\`\`\`mermaid
graph TD
    A[Start] --> B[Step 1]
    B --> C[Step 2]
    C --> D[Step 3]
    D --> E[End]
\`\`\`

## Examples

### Example 1: [Scenario]

\`\`\`bash
# Commands or code
\`\`\`

**Expected Result:**
[What should happen]

## Troubleshooting

### Issue 1
**Problem:** [Description]
**Solution:** [How to fix]

## Related

- [Related Documentation]

---

**Tags:** #workflow #${projectName ? projectName.toLowerCase().replace(/\s+/g, '-') : 'general'}
`,

    learning: `# ${topic}

**Created:** ${date}
**Status:** 🌱 Learning

## What I Learned

[Main takeaways and concepts]

## Context

[Why I was learning this, what problem it solves]

## Key Concepts

### Concept 1
[Explanation]

### Concept 2
[Explanation]

## Examples

\`\`\`typescript
// Practical examples
\`\`\`

## Resources

- [Link to documentation]
- [Tutorial or article]

## Next Steps

- [ ] Practice by [specific task]
- [ ] Apply to [project or problem]

---

**Tags:** #learning #notes
`,

    tool: `# ${topic}

**Created:** ${date}

## Purpose

[What this tool does and why it's useful]

## Installation

\`\`\`bash
# Installation commands
\`\`\`

## Configuration

\`\`\`yaml
# Configuration example
\`\`\`

## Usage

### Basic Usage

\`\`\`bash
# Basic commands
\`\`\`

### Advanced Usage

\`\`\`bash
# Advanced examples
\`\`\`

## Common Tasks

### Task 1: [Description]
\`\`\`bash
# Commands
\`\`\`

### Task 2: [Description]
\`\`\`bash
# Commands
\`\`\`

## Troubleshooting

**Issue:** [Common problem]
**Solution:** [How to fix]

## Resources

- [Official Documentation]
- [Useful Tutorial]

---

**Tags:** #tools #setup
`,

    concept: `# ${topic}

**Created:** ${date}${projectName ? `\n**Project:** ${projectName}` : ''}

## Overview

[High-level explanation of the concept]

## Problem Statement

[What problem does this solve? Why is it important?]

## Solution

[How this concept/pattern addresses the problem]

## How It Works

[Detailed explanation]

## When to Use

- Use case 1
- Use case 2
- Use case 3

## When NOT to Use

- Situation 1
- Situation 2

## Examples

### Example 1: [Scenario]

\`\`\`typescript
// Example implementation
\`\`\`

[Explanation of what's happening]

## Trade-offs

**Pros:**
- Advantage 1
- Advantage 2

**Cons:**
- Disadvantage 1
- Disadvantage 2

## Related Concepts

- [Related Pattern/Concept 1]
- [Related Pattern/Concept 2]

---

**Tags:** #concept #pattern
`
  };
  
  return templates[contentType] || templates.concept;
}

/**
 * Main chronicle function
 */
async function chronicle(workingDir, request) {
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('📚 SCRIBE CHRONICLE');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  
  // Step 1: Infer Obsidian location using obsidian-mapper
  console.log('📍 Step 1: Determining Obsidian location...');
  const mapperResult = JSON.parse(
    execSync(`node "${OBSIDIAN_MAPPER}" infer "${workingDir}"`, { encoding: 'utf-8' })
  );
  
  if (mapperResult.error && mapperResult.needsUserInput) {
    console.log('❌ Error: Could not determine Obsidian location');
    console.log(`   ${mapperResult.error}`);
    console.log('\nPlease manually specify the Obsidian folder or create one in:');
    console.log(`   Work: ${path.join(OBSIDIAN_ROOT, 'Work', 'Domains')}`);
    console.log(`   Personal: ${path.join(OBSIDIAN_ROOT, 'Personal', 'Projects')}`);
    return { success: false, error: mapperResult.error };
  }
  
  console.log(`   Project: ${mapperResult.projectName}`);
  console.log(`   Type: ${mapperResult.projectType}`);
  
  if (mapperResult.cached) {
    console.log(`   ✓ Using cached location: ${mapperResult.obsidianPath}`);
  } else if (mapperResult.needsConfirmation) {
    console.log(`   ⚠️  Found potential match: ${mapperResult.obsidianPath}`);
    console.log(`   Confidence: ${(mapperResult.confidence * 100).toFixed(0)}%`);
    console.log('\n   REQUIRES CONFIRMATION from Scribe agent');
    console.log('   Scribe should ask user: "Is this the correct location?"');
    // Return for confirmation - Scribe agent will handle asking user
    return {
      success: false,
      needsConfirmation: true,
      location: mapperResult,
      request: request
    };
  }
  
  // Step 2: Detect content type
  console.log('\n🔍 Step 2: Detecting content type...');
  const contentType = detectContentType(request, {});
  console.log(`   Content type: ${contentType}`);
  
  // Step 3: Determine specific folder
  console.log('\n📂 Step 3: Determining target folder...');
  const targetFolder = determineObsidianFolder(mapperResult, contentType, mapperResult.projectType);
  const targetPath = path.join(OBSIDIAN_ROOT, targetFolder);
  console.log(`   Target: ${targetFolder}`);
  
  // Ensure target directory exists
  if (!fs.existsSync(targetPath)) {
    fs.mkdirSync(targetPath, { recursive: true });
    console.log(`   ✓ Created directory: ${targetPath}`);
  }
  
  // Step 4: Generate file name
  console.log('\n📝 Step 4: Generating file name...');
  // Extract topic from request (simplistic - Scribe agent should provide better topic)
  const topic = request.split(' ').slice(0, 5).join(' '); // First 5 words as default
  const fileName = generateFileName(topic, contentType);
  const filePath = path.join(targetPath, fileName);
  console.log(`   File: ${fileName}`);
  
  // Step 5: Check if file exists
  if (fs.existsSync(filePath)) {
    console.log(`   ⚠️  File already exists: ${filePath}`);
    console.log('\n   REQUIRES DECISION from Scribe agent');
    console.log('   Options: overwrite, append, create new file with suffix');
    return {
      success: false,
      fileExists: true,
      filePath: filePath,
      targetFolder: targetFolder,
      contentType: contentType,
      request: request
    };
  }
  
  // Step 6: Generate template
  console.log('\n📄 Step 5: Generating documentation template...');
  const template = generateTemplate(contentType, topic, mapperResult.projectName, request);
  
  // Step 7: Write file
  console.log('\n✍️  Step 6: Writing documentation...');
  fs.writeFileSync(filePath, template, 'utf-8');
  console.log(`   ✓ Created: ${filePath}`);
  
  console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('✅ SUCCESS');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  
  return {
    success: true,
    filePath: filePath,
    relativePath: path.relative(OBSIDIAN_ROOT, filePath),
    contentType: contentType,
    projectName: mapperResult.projectName,
    projectType: mapperResult.projectType,
    message: 'Documentation template created. Scribe agent should now fill in the details based on session context.'
  };
}

// CLI Interface
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.length < 1) {
    console.log('Scribe Chronicle - Create documentation in Obsidian vault');
    console.log('');
    console.log('Usage:');
    console.log('  scribe-chronicle.js <documentation-request> [workingDir]');
    console.log('');
    console.log('Examples:');
    console.log('  scribe-chronicle.js "Document authentication flow" ~/Developer/fanduel/raf-app');
    console.log('  scribe-chronicle.js "How to setup DynamoDB local"');
    console.log('');
    console.log('Note: This CLI creates the file structure. The Scribe agent fills in content.');
    process.exit(0);
  }
  
  const request = args[0];
  const workingDir = args[1] || process.cwd();
  
  chronicle(workingDir, request)
    .then(result => {
      console.log(JSON.stringify(result, null, 2));
      process.exit(result.success ? 0 : 1);
    })
    .catch(error => {
      console.error('Error:', error.message);
      process.exit(1);
    });
}

module.exports = { chronicle, detectContentType, generateFileName };
