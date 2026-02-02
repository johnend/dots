/**
 * Destructive operation detection logic
 * Analyzes commands/operations to detect potentially dangerous actions
 */

export interface DetectionResult {
  isDestructive: boolean;
  operations: DestructiveOperation[];
  totalScore: number;
}

export interface DestructiveOperation {
  type: OperationType;
  command?: string;
  targets?: string[];
  score: number;
  severity: 'low' | 'medium' | 'high' | 'critical';
}

export type OperationType =
  | 'git-force'
  | 'git-delete'
  | 'git-rewrite'
  | 'file-delete'
  | 'file-overwrite'
  | 'database-drop'
  | 'database-truncate'
  | 'npm-uninstall'
  | 'system-command'
  | 'env-modify';

/**
 * Git operations that are destructive
 */
const GIT_DESTRUCTIVE_PATTERNS = [
  // Force operations
  { pattern: /git\s+push\s+.*--force/i, type: 'git-force' as OperationType, severity: 'critical' as const, score: 10 },
  { pattern: /git\s+push\s+.*-f\b/i, type: 'git-force' as OperationType, severity: 'critical' as const, score: 10 },
  
  // Branch deletion
  { pattern: /git\s+(branch|push)\s+.*(-d|-D|--delete)/i, type: 'git-delete' as OperationType, severity: 'high' as const, score: 8 },
  { pattern: /git\s+push\s+.*:.*\b/i, type: 'git-delete' as OperationType, severity: 'high' as const, score: 8 }, // push :branch (delete remote)
  
  // History rewriting
  { pattern: /git\s+reset\s+--hard/i, type: 'git-rewrite' as OperationType, severity: 'critical' as const, score: 10 },
  { pattern: /git\s+rebase\s+/i, type: 'git-rewrite' as OperationType, severity: 'medium' as const, score: 5 },
  { pattern: /git\s+commit\s+--amend/i, type: 'git-rewrite' as OperationType, severity: 'medium' as const, score: 4 },
  { pattern: /git\s+filter-branch/i, type: 'git-rewrite' as OperationType, severity: 'critical' as const, score: 10 },
  { pattern: /git\s+reflog\s+(expire|delete)/i, type: 'git-rewrite' as OperationType, severity: 'high' as const, score: 8 },
];

/**
 * File operations that are destructive
 */
const FILE_DESTRUCTIVE_PATTERNS = [
  // Deletion
  { pattern: /\brm\s+-rf?\s+/i, type: 'file-delete' as OperationType, severity: 'critical' as const, score: 10 },
  { pattern: /\bdel\s+\/[sf]\s+/i, type: 'file-delete' as OperationType, severity: 'high' as const, score: 8 }, // Windows
  { pattern: /\bremove-item\s+.*-recurse/i, type: 'file-delete' as OperationType, severity: 'high' as const, score: 8 }, // PowerShell
  
  // Overwrite
  { pattern: />\s*[^>]/i, type: 'file-overwrite' as OperationType, severity: 'medium' as const, score: 4 }, // > redirect (overwrite)
  { pattern: /\bmv\s+.*\s+/i, type: 'file-overwrite' as OperationType, severity: 'low' as const, score: 2 }, // move can overwrite
];

/**
 * Database operations that are destructive
 */
const DATABASE_DESTRUCTIVE_PATTERNS = [
  { pattern: /DROP\s+(DATABASE|TABLE|SCHEMA)/i, type: 'database-drop' as OperationType, severity: 'critical' as const, score: 10 },
  { pattern: /TRUNCATE\s+TABLE/i, type: 'database-truncate' as OperationType, severity: 'high' as const, score: 8 },
  { pattern: /DELETE\s+FROM.*WHERE/i, type: 'database-truncate' as OperationType, severity: 'medium' as const, score: 5 },
  { pattern: /DELETE\s+FROM(?!.*WHERE)/i, type: 'database-truncate' as OperationType, severity: 'critical' as const, score: 10 }, // DELETE without WHERE
];

/**
 * NPM/package operations that are destructive
 */
const NPM_DESTRUCTIVE_PATTERNS = [
  { pattern: /npm\s+uninstall\s+/i, type: 'npm-uninstall' as OperationType, severity: 'low' as const, score: 2 },
  { pattern: /yarn\s+remove\s+/i, type: 'npm-uninstall' as OperationType, severity: 'low' as const, score: 2 },
  { pattern: /\brm\s+.*package-lock\.json/i, type: 'file-delete' as OperationType, severity: 'medium' as const, score: 4 },
];

/**
 * System commands that could be destructive
 */
const SYSTEM_DESTRUCTIVE_PATTERNS = [
  { pattern: /\bkill\s+-9/i, type: 'system-command' as OperationType, severity: 'medium' as const, score: 5 },
  { pattern: /\bsudo\s+rm/i, type: 'system-command' as OperationType, severity: 'critical' as const, score: 10 },
  { pattern: /chmod\s+000/i, type: 'system-command' as OperationType, severity: 'high' as const, score: 7 },
];

/**
 * Environment modifications
 */
const ENV_DESTRUCTIVE_PATTERNS = [
  { pattern: /\brm\s+.*\.env/i, type: 'env-modify' as OperationType, severity: 'high' as const, score: 7 },
  { pattern: />\s*\.env/i, type: 'env-modify' as OperationType, severity: 'medium' as const, score: 5 }, // Overwrite .env
];

/**
 * All destructive patterns combined
 */
const ALL_DESTRUCTIVE_PATTERNS = [
  ...GIT_DESTRUCTIVE_PATTERNS,
  ...FILE_DESTRUCTIVE_PATTERNS,
  ...DATABASE_DESTRUCTIVE_PATTERNS,
  ...NPM_DESTRUCTIVE_PATTERNS,
  ...SYSTEM_DESTRUCTIVE_PATTERNS,
  ...ENV_DESTRUCTIVE_PATTERNS,
];

/**
 * Detect destructive operations in a command or prompt
 */
export function detectDestructiveOperations(input: string): DetectionResult {
  const operations: DestructiveOperation[] = [];
  let totalScore = 0;

  for (const pattern of ALL_DESTRUCTIVE_PATTERNS) {
    const match = input.match(pattern.pattern);
    if (match) {
      const operation: DestructiveOperation = {
        type: pattern.type,
        command: match[0],
        score: pattern.score,
        severity: pattern.severity,
      };
      
      operations.push(operation);
      totalScore += pattern.score;
    }
  }

  return {
    isDestructive: operations.length > 0,
    operations,
    totalScore,
  };
}

/**
 * Check if command targets important files/directories
 */
export function detectCriticalTargets(input: string): string[] {
  const criticalPatterns = [
    /\/(usr|etc|var|boot|sys|root)\b/i,  // System directories
    /node_modules/i,
    /\.git\b/i,
    /package\.json/i,
    /\.env/i,
    /config\.(json|yaml|yml)/i,
    /database/i,
    /production/i,
    /prod/i,
    /main\b/i,  // main branch
    /master\b/i, // master branch
  ];

  const targets: string[] = [];
  for (const pattern of criticalPatterns) {
    const match = input.match(pattern);
    if (match) {
      targets.push(match[0]);
    }
  }

  return targets;
}
