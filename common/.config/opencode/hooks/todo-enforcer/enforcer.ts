/**
 * Todo enforcement logic
 * Main orchestration for detecting and enforcing todo creation
 */

import { detectMultiStep, extractActionVerbs, DetectionConfig } from './detector';

export interface EnforcementResult {
  shouldBlock: boolean;
  isMultiStep: boolean;
  score: number;
  confidence: 'low' | 'medium' | 'high';
  message: string | null;
  suggestedTodos: string[];
  indicators: string[];
}

export interface EnforcementOptions {
  prompt: string;
  hasTodos: boolean;
  config?: DetectionConfig;
  debug?: boolean;
}

/**
 * Generate suggested todo breakdown based on prompt
 */
function generateSuggestedTodos(prompt: string): string[] {
  const verbs = extractActionVerbs(prompt);
  
  // If we found action verbs, create suggestions based on them
  if (verbs.length > 0) {
    return verbs.map((verb, index) => {
      const capitalized = verb.charAt(0).toUpperCase() + verb.slice(1);
      return `${capitalized} [specific task based on prompt context]`;
    });
  }
  
  // Fallback: generic suggestions
  return [
    'Break down task into specific steps',
    'Implement main functionality',
    'Add tests and validation',
  ];
}

/**
 * Generate enforcement message explaining why todos are required
 */
function generateEnforcementMessage(
  prompt: string,
  score: number,
  indicators: string[],
  confidence: string,
  suggestedTodos: string[]
): string {
  const lines = [
    '🚦 MULTI-STEP TASK DETECTED',
    '',
    'This request appears to have multiple steps. Please create a todo list before proceeding.',
    '',
    '**Detection Details:**',
    `- Confidence: ${confidence.toUpperCase()}`,
    `- Score: ${score}`,
    `- Indicators: ${indicators.join(', ')}`,
    '',
    '**Why todos are required:**',
    '1. **Visibility** - Track progress in real-time',
    '2. **Recovery** - Resume work if interrupted',
    '3. **Clarity** - Break down complex task into atomic steps',
    '4. **Quality** - Less likely to forget steps',
    '',
    '**Suggested todo breakdown:**',
    ...suggestedTodos.map((todo, i) => `${i + 1}. ${todo}`),
    '',
    'After creating todos, execution will proceed automatically.',
  ];
  
  return lines.join('\n');
}

/**
 * Main enforcement function
 * Decides whether to block execution and what message to show
 */
export function enforceTodos(options: EnforcementOptions): EnforcementResult {
  const { prompt, hasTodos, config, debug } = options;
  
  // Run detection
  const detection = detectMultiStep(prompt, config);
  
  if (debug) {
    console.error('[DEBUG] Detection result:', JSON.stringify(detection, null, 2));
  }
  
  // If not multi-step, allow execution
  if (!detection.isMultiStep) {
    return {
      shouldBlock: false,
      isMultiStep: false,
      score: detection.score,
      confidence: detection.confidence,
      message: null,
      suggestedTodos: [],
      indicators: detection.indicators,
    };
  }
  
  // Multi-step task detected
  // If todos already exist, allow execution
  if (hasTodos) {
    return {
      shouldBlock: false,
      isMultiStep: true,
      score: detection.score,
      confidence: detection.confidence,
      message: null,
      suggestedTodos: [],
      indicators: detection.indicators,
    };
  }
  
  // Multi-step + no todos = BLOCK
  const suggestedTodos = generateSuggestedTodos(prompt);
  const message = generateEnforcementMessage(
    prompt,
    detection.score,
    detection.indicators,
    detection.confidence,
    suggestedTodos
  );
  
  return {
    shouldBlock: true,
    isMultiStep: true,
    score: detection.score,
    confidence: detection.confidence,
    message,
    suggestedTodos,
    indicators: detection.indicators,
  };
}
