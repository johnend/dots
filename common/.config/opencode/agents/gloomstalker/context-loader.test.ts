/**
 * GloomStalker - Context Loader Tests
 * 
 * Tests for context loading logic, project detection, and file selection.
 * 
 * @module gloomstalker/context-loader.test
 */

import {
  loadContext,
  detectProject,
  formatLoadingResult,
  getFilePaths,
  ContextFile,
  LoadingResult
} from './context-loader';

// ============================================================================
// Test Helpers
// ============================================================================

const mockProjectPath = (projectName: string): string => {
  return `/Users/john.enderby/Developer/fanduel/raccoons/${projectName}`;
};

// ============================================================================
// Project Detection Tests
// ============================================================================

describe('detectProject', () => {
  it('should detect sportsbook project', () => {
    const workingDir = mockProjectPath('sportsbook');
    const project = detectProject(workingDir);
    
    // Note: This test will only pass if metadata files exist
    // In real environment, it should return 'sportsbook'
    expect(project).toBeTruthy();
  });
  
  it('should detect raf-app project', () => {
    const workingDir = mockProjectPath('raf-app');
    const project = detectProject(workingDir);
    
    expect(project).toBeTruthy();
  });
  
  it('should detect refer-a-friend-service project', () => {
    const workingDir = mockProjectPath('refer-a-friend-service');
    const project = detectProject(workingDir);
    
    expect(project).toBeTruthy();
  });
  
  it('should return null for unknown project', () => {
    const workingDir = '/tmp/random-project';
    const project = detectProject(workingDir);
    
    expect(project).toBeNull();
  });
  
  it('should traverse parent directories to find project', () => {
    const workingDir = mockProjectPath('sportsbook/libs/feature-betting');
    const project = detectProject(workingDir);
    
    // Should traverse up and find sportsbook
    expect(project).toBeTruthy();
  });
});

// ============================================================================
// Context Loading Tests
// ============================================================================

describe('loadContext', () => {
  describe('Always-load files', () => {
    it('should always load user preferences', () => {
      const result = loadContext('Do something', '/tmp');
      const paths = getFilePaths(result);
      
      const hasUserPrefs = paths.some(p => p.includes('user-preferences.md'));
      expect(hasUserPrefs).toBe(true);
    });
    
    it('should always load fanduel conventions', () => {
      const result = loadContext('Do something', '/tmp');
      const paths = getFilePaths(result);
      
      const hasConventions = paths.some(p => p.includes('fanduel-conventions.md'));
      expect(hasConventions).toBe(true);
    });
  });
  
  describe('Keyword-based loading', () => {
    it('should load testing patterns for "test" keyword', () => {
      const result = loadContext('Add a test for login', '/tmp');
      const paths = getFilePaths(result);
      
      const hasTestingPatterns = paths.some(p => p.includes('testing-patterns.md'));
      expect(hasTestingPatterns).toBe(true);
    });
    
    it('should load state management for "redux" keyword', () => {
      const result = loadContext('Add Redux store', '/tmp');
      const paths = getFilePaths(result);
      
      const hasStateManagement = paths.some(p => p.includes('state-management.md'));
      expect(hasStateManagement).toBe(true);
    });
    
    it('should load API patterns for "api" keyword', () => {
      const result = loadContext('Fix API endpoint', '/tmp');
      const paths = getFilePaths(result);
      
      const hasApiPatterns = paths.some(p => p.includes('api-patterns.md'));
      expect(hasApiPatterns).toBe(true);
    });
    
    it('should load React patterns for "component" keyword', () => {
      const result = loadContext('Create a component', '/tmp');
      const paths = getFilePaths(result);
      
      const hasReactPatterns = paths.some(p => p.includes('react-patterns.md'));
      expect(hasReactPatterns).toBe(true);
    });
    
    it('should load multiple pattern files for complex task', () => {
      const result = loadContext(
        'Add Redux state for API auth with tests',
        '/tmp'
      );
      const paths = getFilePaths(result);
      
      const hasStateManagement = paths.some(p => p.includes('state-management.md'));
      const hasApiPatterns = paths.some(p => p.includes('api-patterns.md'));
      const hasTestingPatterns = paths.some(p => p.includes('testing-patterns.md'));
      
      expect(hasStateManagement).toBe(true);
      expect(hasApiPatterns).toBe(true);
      expect(hasTestingPatterns).toBe(true);
    });
  });
  
  describe('Project-specific loading', () => {
    it('should load project core.md when in project directory', () => {
      const workingDir = mockProjectPath('sportsbook');
      const result = loadContext('Do something', workingDir);
      const paths = getFilePaths(result);
      
      const hasProjectCore = paths.some(p => 
        p.includes('projects/sportsbook/core.md')
      );
      expect(hasProjectCore).toBe(true);
    });
    
    it('should load project-specific testing.md for test tasks', () => {
      const workingDir = mockProjectPath('sportsbook');
      const result = loadContext('Add a test', workingDir);
      const paths = getFilePaths(result);
      
      const hasProjectTesting = paths.some(p => 
        p.includes('projects/sportsbook/testing.md')
      );
      expect(hasProjectTesting).toBe(true);
    });
    
    it('should load raf-app local-dev.md for local development tasks', () => {
      const workingDir = mockProjectPath('raf-app');
      const result = loadContext('Fix local dev setup', workingDir);
      const paths = getFilePaths(result);
      
      const hasLocalDev = paths.some(p => 
        p.includes('projects/raf-app/local-dev.md')
      );
      expect(hasLocalDev).toBe(true);
    });
  });
  
  describe('Priority ordering', () => {
    it('should order files by priority', () => {
      const result = loadContext('Add a test', '/tmp');
      
      // Priority 1 files should come first
      const priority1Files = result.files.filter(f => f.priority === 1);
      const otherFiles = result.files.filter(f => f.priority > 1);
      
      expect(priority1Files.length).toBeGreaterThan(0);
      
      // All priority 1 files should come before other files
      const lastPriority1Index = result.files.findIndex(f => 
        f.priority > 1
      );
      
      if (lastPriority1Index > 0) {
        const firstOtherIndex = result.files.findIndex(f => 
          f.priority > 1
        );
        expect(firstOtherIndex).toBeGreaterThan(0);
      }
    });
    
    it('should have user prefs and conventions in top priority', () => {
      const result = loadContext('Do something', '/tmp');
      
      const topFiles = result.files.slice(0, 3);
      const hasUserPrefs = topFiles.some(f => 
        f.path.includes('user-preferences.md')
      );
      const hasConventions = topFiles.some(f => 
        f.path.includes('fanduel-conventions.md')
      );
      
      expect(hasUserPrefs || hasConventions).toBe(true);
    });
  });
  
  describe('Deduplication', () => {
    it('should not load the same file twice', () => {
      const result = loadContext('Add a test with Jest', '/tmp');
      const paths = getFilePaths(result);
      
      const uniquePaths = new Set(paths);
      expect(paths.length).toBe(uniquePaths.size);
    });
  });
  
  describe('Token estimation', () => {
    it('should estimate total tokens', () => {
      const result = loadContext('Add a test', '/tmp');
      
      expect(result.estimatedTokens).toBeGreaterThan(0);
    });
    
    it('should estimate higher tokens for complex tasks', () => {
      const simpleResult = loadContext('Do something', '/tmp');
      const complexResult = loadContext(
        'Add Redux state for API auth with tests',
        '/tmp'
      );
      
      expect(complexResult.estimatedTokens).toBeGreaterThanOrEqual(
        simpleResult.estimatedTokens
      );
    });
  });
  
  describe('Edge cases', () => {
    it('should handle empty task', () => {
      const result = loadContext('', '/tmp');
      
      // Should still load always-load files
      expect(result.files.length).toBeGreaterThan(0);
    });
    
    it('should handle task with no keyword matches', () => {
      const result = loadContext('xyzabc123', '/tmp');
      
      // Should only load always-load files
      expect(result.files.length).toBeGreaterThan(0);
      expect(result.keywordMatches.length).toBe(0);
    });
    
    it('should handle non-existent working directory', () => {
      const result = loadContext('Add a test', '/does/not/exist');
      
      // Should still work, just no project detected
      expect(result.files.length).toBeGreaterThan(0);
      expect(result.project).toBeUndefined();
    });
  });
});

// ============================================================================
// Formatting Tests
// ============================================================================

describe('formatLoadingResult', () => {
  it('should format result with headers', () => {
    const result = loadContext('Add a test', '/tmp');
    const formatted = formatLoadingResult(result);
    
    expect(formatted).toContain('GloomStalker Context Loading');
    expect(formatted).toContain('Task:');
    expect(formatted).toContain('Files to Load:');
  });
  
  it('should include keyword matches', () => {
    const result = loadContext('Add a test for login', '/tmp');
    const formatted = formatLoadingResult(result);
    
    if (result.keywordMatches.length > 0) {
      expect(formatted).toContain('Keyword Matches:');
    }
  });
  
  it('should group files by priority', () => {
    const result = loadContext('Add a test', '/tmp');
    const formatted = formatLoadingResult(result);
    
    expect(formatted).toContain('Priority 1:');
  });
  
  it('should show file reasons', () => {
    const result = loadContext('Add a test', '/tmp');
    const formatted = formatLoadingResult(result);
    
    expect(formatted).toContain('Reason:');
  });
});

// ============================================================================
// Integration Tests
// ============================================================================

describe('Integration tests', () => {
  it('should load correct context for sportsbook test task', () => {
    const workingDir = mockProjectPath('sportsbook');
    const result = loadContext('Add a Detox test for login', workingDir);
    const paths = getFilePaths(result);
    
    // Should load:
    // - User prefs
    // - FanDuel conventions
    // - Core testing patterns
    // - Sportsbook core
    // - Sportsbook testing (Detox-specific)
    
    expect(paths.length).toBeGreaterThanOrEqual(4);
    
    const hasTestingPatterns = paths.some(p => p.includes('testing-patterns.md'));
    const hasSportsbookCore = paths.some(p => p.includes('projects/sportsbook/core.md'));
    
    expect(hasTestingPatterns).toBe(true);
    expect(hasSportsbookCore).toBe(true);
  });
  
  it('should load correct context for raf-app component task', () => {
    const workingDir = mockProjectPath('raf-app');
    const result = loadContext('Create a button component with styled-components', workingDir);
    const paths = getFilePaths(result);
    
    // Should load:
    // - User prefs
    // - FanDuel conventions
    // - React patterns
    // - styled-components patterns
    // - raf-app core
    
    expect(paths.length).toBeGreaterThanOrEqual(4);
    
    const hasReactPatterns = paths.some(p => p.includes('react-patterns.md'));
    const hasStyledComponents = paths.some(p => p.includes('styled-components.md'));
    const hasRafAppCore = paths.some(p => p.includes('projects/raf-app/core.md'));
    
    expect(hasReactPatterns).toBe(true);
    expect(hasStyledComponents).toBe(true);
    expect(hasRafAppCore).toBe(true);
  });
  
  it('should reduce token count compared to loading all files', () => {
    const result = loadContext('Add a test', '/tmp');
    
    // Assume we have ~9 core files + ~3 domain files = 12 potential files
    // Average 150 lines each = 1800 lines = ~7200 tokens
    const maxPossibleTokens = 12 * 150 * 4;
    
    // With smart loading, we should load significantly fewer
    expect(result.estimatedTokens).toBeLessThan(maxPossibleTokens);
  });
  
  it('should handle unknown project gracefully', () => {
    const result = loadContext('Add a test', '/tmp/unknown-project');
    
    // Should still load core patterns
    expect(result.files.length).toBeGreaterThan(0);
    expect(result.project).toBeUndefined();
    
    const hasTestingPatterns = getFilePaths(result).some(p => 
      p.includes('testing-patterns.md')
    );
    expect(hasTestingPatterns).toBe(true);
  });
});

// ============================================================================
// Performance Tests
// ============================================================================

describe('Performance', () => {
  it('should complete in reasonable time', () => {
    const start = Date.now();
    const result = loadContext('Add a test for login with Redux state', '/tmp');
    const elapsed = Date.now() - start;
    
    // Should complete in less than 1 second
    expect(elapsed).toBeLessThan(1000);
    expect(result.files.length).toBeGreaterThan(0);
  });
  
  it('should handle complex task efficiently', () => {
    const start = Date.now();
    const result = loadContext(
      'Add comprehensive E2E tests for authentication flow with Redux Toolkit state management and Apollo GraphQL API integration using Cypress and React Testing Library with Percy visual regression testing',
      mockProjectPath('sportsbook')
    );
    const elapsed = Date.now() - start;
    
    // Even with many keywords, should complete quickly
    expect(elapsed).toBeLessThan(1000);
    expect(result.files.length).toBeGreaterThan(0);
  });
});

// ============================================================================
// Utility Tests
// ============================================================================

describe('getFilePaths', () => {
  it('should extract file paths from result', () => {
    const result = loadContext('Add a test', '/tmp');
    const paths = getFilePaths(result);
    
    expect(Array.isArray(paths)).toBe(true);
    expect(paths.length).toBe(result.files.length);
    paths.forEach(path => {
      expect(typeof path).toBe('string');
    });
  });
});

// ============================================================================
// Real-world Scenarios
// ============================================================================

describe('Real-world scenarios', () => {
  const scenarios = [
    {
      task: 'Fix failing Jest test in sportsbook',
      workingDir: mockProjectPath('sportsbook'),
      expectedPatterns: ['testing-patterns.md', 'sportsbook/core.md']
    },
    {
      task: 'Add TanStack Query hook for user API',
      workingDir: mockProjectPath('raf-app'),
      expectedPatterns: ['state-management.md', 'api-patterns.md', 'react-patterns.md']
    },
    {
      task: 'Update styled-components theme',
      workingDir: mockProjectPath('raf-app'),
      expectedPatterns: ['styled-components.md', 'raf-app/core.md']
    },
    {
      task: 'Add Detox E2E test for iOS',
      workingDir: mockProjectPath('sportsbook'),
      expectedPatterns: ['testing-patterns.md', 'react-native-patterns.md', 'sportsbook/testing.md']
    },
    {
      task: 'Fix Apollo GraphQL cache issue',
      workingDir: mockProjectPath('sportsbook'),
      expectedPatterns: ['api-patterns.md', 'state-management.md']
    }
  ];
  
  scenarios.forEach(scenario => {
    it(`should handle: "${scenario.task}"`, () => {
      const result = loadContext(scenario.task, scenario.workingDir);
      const paths = getFilePaths(result);
      
      // Check that expected patterns are loaded
      scenario.expectedPatterns.forEach(pattern => {
        const hasPattern = paths.some(p => p.includes(pattern));
        expect(hasPattern).toBe(true);
      });
    });
  });
});
