import { execSync } from 'child_process';
import { readFileSync } from 'fs';

export interface GitStatus {
  hasChanges: boolean;
  isRepo: boolean;
  summary: {
    modified: string[];
    added: string[];
    deleted: string[];
    renamed: Array<{ from: string; to: string }>;
    staged: string[];
    unstaged: string[];
  };
  diffs: {
    modified: FileDiff[];
    added: FileDiff[];
  };
  recentCommits: Commit[];
  branch: string | null;
  tracking: {
    remote: string | null;
    ahead: number;
    behind: number;
  };
}

export interface FileDiff {
  file: string;
  staged: boolean;
  summary: string;
  patch?: string;
  lines?: number;
  preview?: string;
}

export interface Commit {
  hash: string;
  message: string;
  author: string;
  timestamp: string;
  filesChanged: string[];
}

const MAX_DIFF_SIZE = 5000; // characters
const MAX_FILES_FOR_FULL_DIFF = 5;
const PREVIEW_LINES = 20;

export function detectGitStatus(workdir: string = process.cwd()): GitStatus {
  // Check if git repo
  if (!isGitRepo(workdir)) {
    return {
      hasChanges: false,
      isRepo: false,
      summary: {
        modified: [],
        added: [],
        deleted: [],
        renamed: [],
        staged: [],
        unstaged: [],
      },
      diffs: { modified: [], added: [] },
      recentCommits: [],
      branch: null,
      tracking: { remote: null, ahead: 0, behind: 0 },
    };
  }

  const summary = parseGitStatus(workdir);
  const branch = getCurrentBranch(workdir);
  const tracking = getTrackingInfo(workdir);
  const recentCommits = getRecentCommits(workdir, 3);

  // Decide diff strategy based on file count
  const totalFiles =
    summary.modified.length + summary.added.length + summary.deleted.length;
  const includeDiffs = totalFiles <= MAX_FILES_FOR_FULL_DIFF;

  const diffs = includeDiffs
    ? generateDiffs(workdir, summary)
    : { modified: [], added: [] };

  const hasChanges =
    summary.modified.length > 0 ||
    summary.added.length > 0 ||
    summary.deleted.length > 0 ||
    summary.renamed.length > 0;

  return {
    hasChanges,
    isRepo: true,
    summary,
    diffs,
    recentCommits,
    branch,
    tracking,
  };
}

function isGitRepo(workdir: string): boolean {
  try {
    execSync('git rev-parse --git-dir', { cwd: workdir, stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
}

function parseGitStatus(workdir: string) {
  const output = execSync('git status --porcelain=v1 -uall', {
    cwd: workdir,
    encoding: 'utf-8',
  });

  const modified: string[] = [];
  const added: string[] = [];
  const deleted: string[] = [];
  const renamed: Array<{ from: string; to: string }> = [];
  const staged: string[] = [];
  const unstaged: string[] = [];

  for (const line of output.split('\n')) {
    if (!line.trim()) continue;

    const stagedStatus = line[0];
    const unstagedStatus = line[1];
    const file = line.slice(3);

    // Renamed files: R  old.ts -> new.ts
    if (stagedStatus === 'R') {
      const [from, to] = file.split(' -> ');
      renamed.push({ from, to });
      staged.push(to);
      continue;
    }

    // Staged changes
    if (stagedStatus !== ' ' && stagedStatus !== '?') {
      staged.push(file);
      if (stagedStatus === 'M') modified.push(file);
      if (stagedStatus === 'A') added.push(file);
      if (stagedStatus === 'D') deleted.push(file);
    }

    // Unstaged changes
    if (unstagedStatus !== ' ' && unstagedStatus !== '?') {
      unstaged.push(file);
      if (unstagedStatus === 'M' && !modified.includes(file))
        modified.push(file);
      if (unstagedStatus === 'D' && !deleted.includes(file))
        deleted.push(file);
    }

    // Untracked files
    if (stagedStatus === '?' && unstagedStatus === '?') {
      added.push(file);
      unstaged.push(file);
    }
  }

  return {
    modified: [...new Set(modified)],
    added: [...new Set(added)],
    deleted: [...new Set(deleted)],
    renamed,
    staged: [...new Set(staged)],
    unstaged: [...new Set(unstaged)],
  };
}

function getCurrentBranch(workdir: string): string | null {
  try {
    const branch = execSync('git branch --show-current', {
      cwd: workdir,
      encoding: 'utf-8',
    }).trim();
    return branch || null;
  } catch {
    return null;
  }
}

function getTrackingInfo(workdir: string) {
  try {
    const remote = execSync('git rev-parse --abbrev-ref @{upstream}', {
      cwd: workdir,
      encoding: 'utf-8',
      stdio: ['pipe', 'pipe', 'ignore'],
    }).trim();

    const status = execSync('git rev-list --left-right --count HEAD...@{u}', {
      cwd: workdir,
      encoding: 'utf-8',
      stdio: ['pipe', 'pipe', 'ignore'],
    }).trim();

    const [ahead, behind] = status.split('\t').map(Number);

    return { remote, ahead, behind };
  } catch {
    return { remote: null, ahead: 0, behind: 0 };
  }
}

function getRecentCommits(workdir: string, count: number): Commit[] {
  try {
    // Use custom separator to clearly delineate commits
    const format = '%H%x00%s%x00%an%x00%aI%x00FILES:';
    const output = execSync(
      `git log -n ${count} --format="${format}" --name-only`,
      {
        cwd: workdir,
        encoding: 'utf-8',
      }
    );

    const commits: Commit[] = [];
    
    // Split by the metadata delimiter (each commit starts with hash)
    const lines = output.trim().split('\n');
    let currentCommit: Partial<Commit> | null = null;
    const filesList: string[] = [];
    
    for (const line of lines) {
      // Check if this is a metadata line (contains null bytes)
      if (line.includes('\x00')) {
        // Save previous commit if exists
        if (currentCommit && currentCommit.hash) {
          commits.push({
            ...currentCommit,
            filesChanged: [...filesList],
          } as Commit);
          filesList.length = 0;
        }
        
        // Parse new commit metadata
        const [hash, message, author, timestamp] = line.split('\x00');
        currentCommit = {
          hash: hash.slice(0, 7),
          message,
          author: author || 'Unknown',
          timestamp: timestamp || new Date().toISOString(),
        };
      } else if (line.trim() && currentCommit) {
        // This is a file line
        filesList.push(line.trim());
      }
    }
    
    // Don't forget the last commit
    if (currentCommit && currentCommit.hash) {
      commits.push({
        ...currentCommit,
        filesChanged: [...filesList],
      } as Commit);
    }

    return commits;
  } catch {
    return [];
  }
}

function generateDiffs(
  workdir: string,
  summary: ReturnType<typeof parseGitStatus>
): { modified: FileDiff[]; added: FileDiff[] } {
  const modifiedDiffs: FileDiff[] = [];
  const addedDiffs: FileDiff[] = [];

  // Modified files - show both staged and unstaged diffs if applicable
  for (const file of summary.modified) {
    const isStaged = summary.staged.includes(file);
    const isUnstaged = summary.unstaged.includes(file);
    
    // If file has staged changes, show staged diff
    if (isStaged) {
      const stagedDiff = getDiff(workdir, file, true);
      if (stagedDiff) modifiedDiffs.push(stagedDiff);
    }
    
    // If file has unstaged changes, show unstaged diff
    if (isUnstaged) {
      const unstagedDiff = getDiff(workdir, file, false);
      if (unstagedDiff) modifiedDiffs.push(unstagedDiff);
    }
  }

  // Added files
  for (const file of summary.added) {
    const preview = getFilePreview(workdir, file);
    if (preview) addedDiffs.push(preview);
  }

  return { modified: modifiedDiffs, added: addedDiffs };
}

function getDiff(
  workdir: string,
  file: string,
  staged: boolean
): FileDiff | null {
  try {
    const diffCmd = staged ? 'git diff --cached' : 'git diff';
    const patch = execSync(`${diffCmd} -- "${file}"`, {
      cwd: workdir,
      encoding: 'utf-8',
      maxBuffer: 1024 * 1024 * 5, // 5MB
    });

    const stats = execSync(`git diff --stat -- "${file}"`, {
      cwd: workdir,
      encoding: 'utf-8',
    }).trim();

    const summaryMatch = stats.match(/(\d+) insertion.*?(\d+) deletion/);
    const summary = summaryMatch
      ? `+${summaryMatch[1]} -${summaryMatch[2]} lines`
      : 'modified';

    // Truncate large diffs
    const truncatedPatch =
      patch.length > MAX_DIFF_SIZE
        ? patch.slice(0, MAX_DIFF_SIZE) + '\n... (truncated)'
        : patch;

    return {
      file,
      staged,
      summary,
      patch: truncatedPatch,
    };
  } catch {
    return null;
  }
}

function getFilePreview(workdir: string, file: string): FileDiff | null {
  try {
    const fullPath = `${workdir}/${file}`;
    const content = readFileSync(fullPath, 'utf-8');
    const lines = content.split('\n');
    const preview = lines.slice(0, PREVIEW_LINES).join('\n');
    const totalLines = lines.length;

    return {
      file,
      staged: false,
      summary: `${totalLines} lines (new file)`,
      lines: totalLines,
      preview:
        totalLines > PREVIEW_LINES
          ? preview + `\n... (${totalLines - PREVIEW_LINES} more lines)`
          : preview,
    };
  } catch {
    return null;
  }
}
