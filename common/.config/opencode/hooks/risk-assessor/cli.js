#!/usr/bin/env node

/**
 * CLI wrapper for risk-assessor
 * Usage: node cli.js "command or operation" [--production] [--has-backup] [--debug]
 */

const path = require('path');

// Import compiled TypeScript modules
const { assessRisk, formatRiskAssessment } = require('./dist/assessor');

// Parse command line arguments
const args = process.argv.slice(2);

if (args.length === 0 || args.includes('--help') || args.includes('-h')) {
  console.log(`
Risk Assessor CLI

Usage:
  node cli.js "command or operation" [options]

Options:
  --production      Indicate operation targets production environment
  --has-backup      Indicate backup exists
  --confirmed       User has confirmed the operation
  --debug           Show debug output
  --help, -h        Show this help message

Examples:
  node cli.js "git push --force origin main"
  node cli.js "rm -rf node_modules"
  node cli.js "DROP DATABASE production" --production
  node cli.js "git reset --hard HEAD~1" --has-backup
  node cli.js "git push --force" --debug

Output:
  JSON object with risk assessment and recommendations
  Exit code: 0 = safe, 1 = should warn, 2 = blocked

Risk Levels:
  - none:     No risk detected
  - low:      Minor risk, proceed
  - medium:   Moderate risk, review carefully
  - high:     High risk, requires confirmation
  - critical: Critical risk, blocked
  `);
  process.exit(0);
}

// Extract input (first non-flag argument)
const input = args.find(arg => !arg.startsWith('--')) || '';

if (!input) {
  console.error('Error: No input provided');
  process.exit(1);
}

// Parse flags
const isProduction = args.includes('--production');
const hasBackup = args.includes('--has-backup');
const userConfirmed = args.includes('--confirmed');
const debug = args.includes('--debug');

// Run assessment
const assessment = assessRisk({
  input,
  context: {
    isProduction,
    hasBackup,
    userConfirmed,
  },
  debug,
});

// Output JSON result
console.log(JSON.stringify(assessment, null, 2));

// Determine exit code
// 0 = safe to proceed
// 1 = should warn but can proceed
// 2 = blocked (critical risk)
let exitCode = 0;

if (assessment.shouldBlock) {
  exitCode = 2;
} else if (assessment.shouldWarn) {
  exitCode = 1;
}

process.exit(exitCode);
