#!/usr/bin/env node

import { detectGitStatus } from './detector';
import { formatForAgent, formatJSON } from './formatter';

function main() {
  const args = process.argv.slice(2);
  const workdir = args[0] || process.cwd();
  const format = args.includes('--json') ? 'json' : 'agent';

  try {
    const status = detectGitStatus(workdir);

    if (format === 'json') {
      console.log(formatJSON(status));
    } else {
      console.log(formatForAgent(status));
    }

    process.exit(0);
  } catch (error) {
    console.error('Error detecting git status:', error);
    process.exit(1);
  }
}

main();
