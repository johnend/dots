import { GitStatus } from './detector';

export function formatForAgent(status: GitStatus): string {
  if (!status.isRepo) {
    return 'ℹ️  Not a git repository';
  }

  if (!status.hasChanges) {
    return '✓ Working tree clean (no unstaged changes)';
  }

  const parts: string[] = [];

  // Header
  parts.push('📊 Git Status Summary');
  parts.push('═'.repeat(50));
  parts.push('');

  // Branch info
  if (status.branch) {
    parts.push(`Branch: ${status.branch}`);
    if (status.tracking.remote) {
      const { remote, ahead, behind } = status.tracking;
      const trackingInfo = [];
      if (ahead > 0) trackingInfo.push(`${ahead} ahead`);
      if (behind > 0) trackingInfo.push(`${behind} behind`);
      parts.push(`Tracking: ${remote} (${trackingInfo.join(', ') || 'up to date'})`);
    }
    parts.push('');
  }

  // File changes summary
  const { summary } = status;
  const totalChanges =
    summary.modified.length +
    summary.added.length +
    summary.deleted.length +
    summary.renamed.length;

  parts.push(`Total files changed: ${totalChanges}`);

  if (summary.modified.length > 0) {
    parts.push(`  Modified: ${summary.modified.length} file(s)`);
  }
  if (summary.added.length > 0) {
    parts.push(`  Added: ${summary.added.length} file(s)`);
  }
  if (summary.deleted.length > 0) {
    parts.push(`  Deleted: ${summary.deleted.length} file(s)`);
  }
  if (summary.renamed.length > 0) {
    parts.push(`  Renamed: ${summary.renamed.length} file(s)`);
  }

  parts.push('');
  parts.push(`Staged: ${summary.staged.length} file(s)`);
  parts.push(`Unstaged: ${summary.unstaged.length} file(s)`);
  parts.push('');

  // Recent commits
  if (status.recentCommits.length > 0) {
    parts.push('Recent Commits:');
    parts.push('─'.repeat(50));
    for (const commit of status.recentCommits) {
      parts.push(`${commit.hash} - ${commit.message}`);
      parts.push(`  Author: ${commit.author}`);
      parts.push(`  Files: ${commit.filesChanged.join(', ')}`);
      parts.push('');
    }
  }

  // File-by-file details
  parts.push('Changed Files:');
  parts.push('─'.repeat(50));

  // Modified files
  if (summary.modified.length > 0) {
    parts.push('\n📝 Modified:');
    for (const file of summary.modified) {
      const isStaged = summary.staged.includes(file);
      const isUnstaged = summary.unstaged.includes(file);
      const diff = status.diffs.modified.find((d) => d.file === file);
      
      // Show status based on what state the file is in
      let statusDisplay = '';
      if (isStaged && isUnstaged) {
        statusDisplay = '🟡 (staged + unstaged)';
      } else if (isStaged) {
        statusDisplay = '🟢 (staged)';
      } else {
        statusDisplay = '🔴 (unstaged)';
      }
      
      parts.push(`  ${statusDisplay.split(' ')[0]} ${file} ${statusDisplay.slice(2)}`);
      if (diff?.summary) {
        parts.push(`     ${diff.summary}`);
      }
    }
  }

  // Added files
  if (summary.added.length > 0) {
    parts.push('\n➕ Added:');
    for (const file of summary.added) {
      const isStaged = summary.staged.includes(file);
      const statusIcon = isStaged ? '🟢' : '🔴';
      const diff = status.diffs.added.find((d) => d.file === file);
      parts.push(`  ${statusIcon} ${file} ${isStaged ? '(staged)' : '(unstaged)'}`);
      if (diff?.lines) {
        parts.push(`     ${diff.lines} lines`);
      }
    }
  }

  // Deleted files
  if (summary.deleted.length > 0) {
    parts.push('\n🗑️  Deleted:');
    for (const file of summary.deleted) {
      const isStaged = summary.staged.includes(file);
      const statusIcon = isStaged ? '🟢' : '🔴';
      parts.push(`  ${statusIcon} ${file} ${isStaged ? '(staged)' : '(unstaged)'}`);
    }
  }

  // Renamed files
  if (summary.renamed.length > 0) {
    parts.push('\n🔄 Renamed:');
    for (const { from, to } of summary.renamed) {
      parts.push(`  🟢 ${from} → ${to} (staged)`);
    }
  }

  // Diffs (if included)
  if (status.diffs.modified.length > 0 || status.diffs.added.length > 0) {
    parts.push('');
    parts.push('═'.repeat(50));
    parts.push('Diffs:');
    parts.push('═'.repeat(50));

    // Modified file diffs
    for (const diff of status.diffs.modified) {
      parts.push('');
      parts.push(`File: ${diff.file} (${diff.staged ? 'staged' : 'unstaged'})`);
      parts.push('─'.repeat(50));
      if (diff.patch) {
        parts.push(diff.patch);
      }
    }

    // Added file previews
    for (const diff of status.diffs.added) {
      parts.push('');
      parts.push(`File: ${diff.file} (new file, ${diff.summary})`);
      parts.push('─'.repeat(50));
      if (diff.preview) {
        parts.push(diff.preview);
      }
    }
  }

  return parts.join('\n');
}

export function formatJSON(status: GitStatus): string {
  return JSON.stringify(status, null, 2);
}
