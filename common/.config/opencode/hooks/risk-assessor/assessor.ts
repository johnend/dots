/**
 * Risk assessment and categorization logic
 * Evaluates risk level and determines appropriate action
 */

import { detectDestructiveOperations, detectCriticalTargets } from './detector';

export interface RiskAssessment {
  riskLevel: 'none' | 'low' | 'medium' | 'high' | 'critical';
  shouldBlock: boolean;
  shouldWarn: boolean;
  shouldProceed: boolean;
  score: number;
  reasons: string[];
  recommendations: string[];
  operations: Array<{
    type: string;
    command?: string;
    severity: string;
  }>;
  criticalTargets: string[];
}

export interface AssessmentOptions {
  input: string;
  context?: {
    hasBackup?: boolean;
    isProduction?: boolean;
    userConfirmed?: boolean;
  };
  debug?: boolean;
}

/**
 * Risk level thresholds
 */
const RISK_THRESHOLDS = {
  low: 3,      // score 1-3: Low risk
  medium: 6,   // score 4-6: Medium risk
  high: 9,     // score 7-9: High risk
  critical: 10 // score 10+: Critical risk
};

/**
 * Determine risk level based on score
 */
function getRiskLevel(score: number): 'none' | 'low' | 'medium' | 'high' | 'critical' {
  if (score === 0) return 'none';
  if (score <= RISK_THRESHOLDS.low) return 'low';
  if (score <= RISK_THRESHOLDS.medium) return 'medium';
  if (score <= RISK_THRESHOLDS.high) return 'high';
  return 'critical';
}

/**
 * Generate reasons for risk assessment
 */
function generateReasons(
  operations: Array<{ type: string; command?: string; severity: string }>,
  criticalTargets: string[],
  context?: AssessmentOptions['context']
): string[] {
  const reasons: string[] = [];

  // Operations found
  if (operations.length > 0) {
    const highSeverity = operations.filter(op => op.severity === 'critical' || op.severity === 'high');
    if (highSeverity.length > 0) {
      reasons.push(`${highSeverity.length} high-severity destructive operation(s) detected`);
    } else {
      reasons.push(`${operations.length} destructive operation(s) detected`);
    }
  }

  // Critical targets
  if (criticalTargets.length > 0) {
    reasons.push(`Targets critical file(s)/directory(s): ${criticalTargets.join(', ')}`);
  }

  // Context factors
  if (context?.isProduction) {
    reasons.push('Operation targets production environment');
  }

  if (!context?.hasBackup) {
    reasons.push('No backup detected or confirmed');
  }

  return reasons;
}

/**
 * Generate recommendations based on risk level
 */
function generateRecommendations(
  riskLevel: 'none' | 'low' | 'medium' | 'high' | 'critical',
  operations: Array<{ type: string; command?: string; severity: string }>,
  criticalTargets: string[]
): string[] {
  const recommendations: string[] = [];

  switch (riskLevel) {
    case 'critical':
      recommendations.push('🛑 STOP: This operation is extremely dangerous');
      recommendations.push('Create a backup before proceeding');
      recommendations.push('Verify you are in the correct environment');
      recommendations.push('Consider using safer alternatives');
      if (operations.some(op => op.type.startsWith('git-'))) {
        recommendations.push('Review git documentation for safer approaches');
      }
      break;

    case 'high':
      recommendations.push('⚠️  HIGH RISK: Proceed with extreme caution');
      recommendations.push('Ensure you have a backup');
      recommendations.push('Double-check targets and parameters');
      if (criticalTargets.includes('main') || criticalTargets.includes('master')) {
        recommendations.push('Consider creating a branch instead of modifying main/master');
      }
      break;

    case 'medium':
      recommendations.push('⚡ MEDIUM RISK: Review carefully before proceeding');
      recommendations.push('Verify operation targets are correct');
      recommendations.push('Have a rollback plan ready');
      break;

    case 'low':
      recommendations.push('ℹ️  LOW RISK: Operation appears safe but review first');
      recommendations.push('Verify expected behavior');
      break;

    case 'none':
      // No recommendations needed
      break;
  }

  return recommendations;
}

/**
 * Main risk assessment function
 */
export function assessRisk(options: AssessmentOptions): RiskAssessment {
  const { input, context, debug } = options;

  // Detect destructive operations
  const detection = detectDestructiveOperations(input);
  const criticalTargets = detectCriticalTargets(input);

  if (debug) {
    console.error('[DEBUG] Detection result:', JSON.stringify(detection, null, 2));
    console.error('[DEBUG] Critical targets:', criticalTargets);
  }

  // Calculate total score
  let score = detection.totalScore;

  // Add bonus score for critical targets
  if (criticalTargets.length > 0) {
    score += criticalTargets.length * 2;
  }

  // Add bonus score for production context
  if (context?.isProduction) {
    score += 5;
  }

  // Determine risk level
  const riskLevel = getRiskLevel(score);

  // Map operations for output
  const operations = detection.operations.map(op => ({
    type: op.type,
    command: op.command,
    severity: op.severity,
  }));

  // Generate reasons and recommendations
  const reasons = generateReasons(operations, criticalTargets, context);
  const recommendations = generateRecommendations(riskLevel, operations, criticalTargets);

  // Determine actions
  let shouldBlock = false;
  let shouldWarn = false;
  let shouldProceed = true;

  switch (riskLevel) {
    case 'critical':
      shouldBlock = true;
      shouldProceed = false;
      break;
    case 'high':
      shouldWarn = true;
      shouldProceed = context?.userConfirmed ?? false;
      break;
    case 'medium':
      shouldWarn = true;
      shouldProceed = true;
      break;
    case 'low':
      shouldProceed = true;
      break;
    case 'none':
      shouldProceed = true;
      break;
  }

  return {
    riskLevel,
    shouldBlock,
    shouldWarn,
    shouldProceed,
    score,
    reasons,
    recommendations,
    operations,
    criticalTargets,
  };
}

/**
 * Format risk assessment for display
 */
export function formatRiskAssessment(assessment: RiskAssessment): string {
  const lines: string[] = [];

  // Header
  const emoji = assessment.riskLevel === 'critical' ? '🛑' :
                assessment.riskLevel === 'high' ? '⚠️' :
                assessment.riskLevel === 'medium' ? '⚡' :
                assessment.riskLevel === 'low' ? 'ℹ️' : '✅';

  lines.push(`${emoji} RISK ASSESSMENT: ${assessment.riskLevel.toUpperCase()}`);
  lines.push('');

  // Risk details
  lines.push('**Risk Details:**');
  lines.push(`- Risk Level: ${assessment.riskLevel}`);
  lines.push(`- Risk Score: ${assessment.score}`);
  lines.push(`- Operations: ${assessment.operations.length}`);
  if (assessment.criticalTargets.length > 0) {
    lines.push(`- Critical Targets: ${assessment.criticalTargets.join(', ')}`);
  }
  lines.push('');

  // Reasons
  if (assessment.reasons.length > 0) {
    lines.push('**Why this is risky:**');
    assessment.reasons.forEach(reason => {
      lines.push(`- ${reason}`);
    });
    lines.push('');
  }

  // Operations
  if (assessment.operations.length > 0) {
    lines.push('**Detected Operations:**');
    assessment.operations.forEach(op => {
      lines.push(`- [${op.severity.toUpperCase()}] ${op.type}: ${op.command || 'N/A'}`);
    });
    lines.push('');
  }

  // Recommendations
  if (assessment.recommendations.length > 0) {
    lines.push('**Recommendations:**');
    assessment.recommendations.forEach(rec => {
      lines.push(`${rec}`);
    });
    lines.push('');
  }

  // Action
  if (assessment.shouldBlock) {
    lines.push('❌ **Action: BLOCKED**');
    lines.push('This operation cannot proceed due to critical risk.');
  } else if (assessment.shouldWarn && !assessment.shouldProceed) {
    lines.push('⏸️  **Action: REQUIRES CONFIRMATION**');
    lines.push('User must explicitly confirm to proceed.');
  } else if (assessment.shouldWarn) {
    lines.push('⚠️  **Action: PROCEED WITH CAUTION**');
    lines.push('Review carefully before confirming.');
  } else {
    lines.push('✅ **Action: PROCEED**');
    lines.push('Operation appears safe.');
  }

  return lines.join('\n');
}
