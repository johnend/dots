#!/usr/bin/env node

/**
 * GloomStalker CLI Wrapper
 * 
 * Usage:
 *   gloomstalker "Add a test for login form"
 *   gloomstalker "Fix API auth bug" --debug
 */

import { gloomstalkerHook } from './dist/hook.js';

const args = process.argv.slice(2);

if (args.length === 0) {
  console.error('Usage: gloomstalker "<task>" [--debug]');
  console.error('');
  console.error('Examples:');
  console.error('  gloomstalker "Add a test for login form"');
  console.error('  gloomstalker "Fix API auth bug" --debug');
  process.exit(1);
}

const task = args[0];
const debug = args.includes('--debug') || args.includes('-d');

gloomstalkerHook(task, { debug })
  .then(files => {
    if (!debug) {
      console.log('');
      console.log('Files to load:');
      files.forEach(f => console.log(`  - ${f}`));
      console.log('');
    }
  })
  .catch(error => {
    console.error('Error:', error.message);
    if (debug) {
      console.error(error.stack);
    }
    process.exit(1);
  });
