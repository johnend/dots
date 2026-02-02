#!/usr/bin/env node

/**
 * CLI wrapper for todo-enforcer
 * Usage: node cli.js "user prompt here" [--has-todos] [--debug]
 */

const path = require('path');

// Import compiled TypeScript modules
const { enforceTodos } = require('./dist/enforcer');

// Parse command line arguments
const args = process.argv.slice(2);

if (args.length === 0 || args.includes('--help') || args.includes('-h')) {
  console.log(`
Todo Enforcer CLI

Usage:
  node cli.js "user prompt" [options]

Options:
  --has-todos         Indicate that todos already exist in session
  --sensitivity=LEVEL Set detection sensitivity (low, medium, high)
  --debug             Show debug output
  --help, -h          Show this help message

Examples:
  node cli.js "Add authentication and write tests"
  node cli.js "Fix typo in README"
  node cli.js "Refactor auth across multiple apps" --debug
  node cli.js "Create API endpoint" --has-todos

Output:
  JSON object with enforcement decision and suggestions
  `);
  process.exit(0);
}

// Extract prompt (first non-flag argument)
const prompt = args.find(arg => !arg.startsWith('--')) || '';

if (!prompt) {
  console.error('Error: No prompt provided');
  process.exit(1);
}

// Parse flags
const hasTodos = args.includes('--has-todos');
const debug = args.includes('--debug');

// Parse sensitivity
let sensitivity = 'medium';
const sensitivityArg = args.find(arg => arg.startsWith('--sensitivity='));
if (sensitivityArg) {
  const value = sensitivityArg.split('=')[1];
  if (['low', 'medium', 'high'].includes(value)) {
    sensitivity = value;
  }
}

// Run enforcement
const result = enforceTodos({
  prompt,
  hasTodos,
  config: {
    sensitivity,
    thresholds: {
      low: 3,
      medium: 2,
      high: 1,
    },
  },
  debug,
});

// Output JSON result
console.log(JSON.stringify(result, null, 2));

// Exit with appropriate code
process.exit(result.shouldBlock ? 1 : 0);
