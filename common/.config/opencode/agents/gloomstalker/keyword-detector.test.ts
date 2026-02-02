/**
 * GloomStalker - Keyword Detection Tests
 * 
 * Unit tests for keyword detection and matching logic.
 * Run with: npx jest keyword-detector.test.ts
 */

import {
  detectKeywords,
  extractKeywords,
  matchesKeyword,
  normalizeText,
  getTopMatches,
  filterByScore,
  type DetectionResult,
  type KeywordMatch
} from './keyword-detector';

describe('GloomStalker Keyword Detector', () => {
  
  // ==========================================================================
  // Text Normalization
  // ==========================================================================
  
  describe('normalizeText', () => {
    it('should convert to lowercase', () => {
      expect(normalizeText('Test Case')).toBe('test case');
    });

    it('should remove punctuation', () => {
      expect(normalizeText('Hello, world!')).toBe('hello world');
    });

    it('should collapse whitespace', () => {
      expect(normalizeText('too   many    spaces')).toBe('too many spaces');
    });

    it('should preserve hyphens', () => {
      expect(normalizeText('react-native')).toBe('react native');
    });

    it('should trim edges', () => {
      expect(normalizeText('  spaces  ')).toBe('spaces');
    });
  });

  // ==========================================================================
  // Keyword Extraction
  // ==========================================================================
  
  describe('extractKeywords', () => {
    it('should extract single words', () => {
      const result = extractKeywords('Add a test');
      expect(result).toContain('add');
      expect(result).toContain('test');
    });

    it('should extract bigrams', () => {
      const result = extractKeywords('react native component');
      expect(result).toContain('react native');
      expect(result).toContain('native component');
    });

    it('should extract trigrams', () => {
      const result = extractKeywords('react native testing library');
      expect(result).toContain('react native testing');
      expect(result).toContain('native testing library');
    });

    it('should skip very short words', () => {
      const result = extractKeywords('a b c test');
      expect(result).not.toContain('a');
      expect(result).not.toContain('b');
      expect(result).toContain('test');
    });
  });

  // ==========================================================================
  // Keyword Matching
  // ==========================================================================
  
  describe('matchesKeyword', () => {
    it('should match exact keyword', () => {
      expect(matchesKeyword('test', 'test')).toBe(true);
    });

    it('should match partial keyword (extracted contains pattern)', () => {
      expect(matchesKeyword('testing', 'test')).toBe(true);
    });

    it('should match fuzzy keyword (pattern contains extracted)', () => {
      expect(matchesKeyword('auth', 'authentication')).toBe(true);
    });

    it('should not match unrelated keywords', () => {
      expect(matchesKeyword('component', 'test')).toBe(false);
    });

    it('should be case insensitive', () => {
      expect(matchesKeyword('TEST', 'test')).toBe(true);
      expect(matchesKeyword('test', 'TEST')).toBe(true);
    });
  });

  // ==========================================================================
  // Detection - Testing Keywords
  // ==========================================================================
  
  describe('detectKeywords - Testing', () => {
    it('should detect test keywords', () => {
      const result = detectKeywords('Add a test for login');
      
      const testingMatch = result.matches.find(m => 
        m.file === 'core/testing-patterns.md'
      );
      
      expect(testingMatch).toBeDefined();
      expect(testingMatch!.matchedKeywords).toContain('test');
      expect(testingMatch!.score).toBeGreaterThan(0);
    });

    it('should detect jest keywords', () => {
      const result = detectKeywords('Write Jest unit tests');
      
      const testingMatch = result.matches.find(m => 
        m.file === 'core/testing-patterns.md'
      );
      
      expect(testingMatch).toBeDefined();
      expect(testingMatch!.matchedKeywords).toContain('jest');
      expect(testingMatch!.matchedKeywords).toContain('unit test');
    });

    it('should detect cypress keywords', () => {
      const result = detectKeywords('Add Cypress E2E tests');
      
      const testingMatch = result.matches.find(m => 
        m.file === 'core/testing-patterns.md'
      );
      
      expect(testingMatch).toBeDefined();
      expect(testingMatch!.matchedKeywords).toContain('cypress');
      expect(testingMatch!.matchedKeywords).toContain('e2e');
    });
  });

  // ==========================================================================
  // Detection - State Management Keywords
  // ==========================================================================
  
  describe('detectKeywords - State Management', () => {
    it('should detect redux keywords', () => {
      const result = detectKeywords('Add Redux state for auth');
      
      const stateMatch = result.matches.find(m => 
        m.file === 'core/state-management.md'
      );
      
      expect(stateMatch).toBeDefined();
      expect(stateMatch!.matchedKeywords).toContain('redux');
      expect(stateMatch!.matchedKeywords).toContain('state');
    });

    it('should detect zustand keywords', () => {
      const result = detectKeywords('Use Zustand store');
      
      const stateMatch = result.matches.find(m => 
        m.file === 'core/state-management.md'
      );
      
      expect(stateMatch).toBeDefined();
      expect(stateMatch!.matchedKeywords).toContain('zustand');
      expect(stateMatch!.matchedKeywords).toContain('store');
    });

    it('should detect TanStack Query keywords', () => {
      const result = detectKeywords('Fetch data with TanStack Query');
      
      const stateMatch = result.matches.find(m => 
        m.file === 'core/state-management.md'
      );
      
      expect(stateMatch).toBeDefined();
      expect(stateMatch!.matchedKeywords).toContain('tanstack query');
      expect(stateMatch!.matchedKeywords).toContain('query');
    });
  });

  // ==========================================================================
  // Detection - API Keywords
  // ==========================================================================
  
  describe('detectKeywords - API', () => {
    it('should detect api keywords', () => {
      const result = detectKeywords('Call the API endpoint');
      
      const apiMatch = result.matches.find(m => 
        m.file === 'core/api-patterns.md'
      );
      
      expect(apiMatch).toBeDefined();
      expect(apiMatch!.matchedKeywords).toContain('api');
      expect(apiMatch!.matchedKeywords).toContain('endpoint');
    });

    it('should detect authentication keywords', () => {
      const result = detectKeywords('Add JWT authentication');
      
      const apiMatch = result.matches.find(m => 
        m.file === 'core/api-patterns.md'
      );
      
      expect(apiMatch).toBeDefined();
      expect(apiMatch!.matchedKeywords).toContain('jwt');
      expect(apiMatch!.matchedKeywords).toContain('authentication');
    });

    it('should detect GraphQL keywords', () => {
      const result = detectKeywords('Create GraphQL query with Apollo');
      
      const apiMatch = result.matches.find(m => 
        m.file === 'core/api-patterns.md'
      );
      
      expect(apiMatch).toBeDefined();
      expect(apiMatch!.matchedKeywords).toContain('graphql');
      expect(apiMatch!.matchedKeywords).toContain('apollo');
      expect(apiMatch!.matchedKeywords).toContain('query');
    });
  });

  // ==========================================================================
  // Detection - React Keywords
  // ==========================================================================
  
  describe('detectKeywords - React', () => {
    it('should detect react component keywords', () => {
      const result = detectKeywords('Create React component');
      
      const reactMatch = result.matches.find(m => 
        m.file === 'ui/web/react-patterns.md'
      );
      
      expect(reactMatch).toBeDefined();
      expect(reactMatch!.matchedKeywords).toContain('react');
      expect(reactMatch!.matchedKeywords).toContain('component');
    });

    it('should detect hook keywords', () => {
      const result = detectKeywords('Add useEffect hook');
      
      const reactMatch = result.matches.find(m => 
        m.file === 'ui/web/react-patterns.md'
      );
      
      expect(reactMatch).toBeDefined();
      expect(reactMatch!.matchedKeywords).toContain('hook');
      expect(reactMatch!.matchedKeywords).toContain('useeffect');
    });
  });

  // ==========================================================================
  // Detection - Multiple Matches
  // ==========================================================================
  
  describe('detectKeywords - Multiple Matches', () => {
    it('should match multiple files for complex tasks', () => {
      const result = detectKeywords(
        'Add Redux state for API auth with tests'
      );
      
      // Should match state-management, api-patterns, and testing-patterns
      expect(result.matches.length).toBeGreaterThanOrEqual(3);
      
      const files = result.matches.map(m => m.file);
      expect(files).toContain('core/state-management.md');
      expect(files).toContain('core/api-patterns.md');
      expect(files).toContain('core/testing-patterns.md');
    });

    it('should sort matches by score', () => {
      const result = detectKeywords(
        'Write comprehensive Jest unit tests with React Testing Library'
      );
      
      // First match should be testing (most keywords)
      expect(result.matches[0].file).toBe('core/testing-patterns.md');
      expect(result.matches[0].score).toBeGreaterThan(0);
    });

    it('should handle tasks with no matches', () => {
      const result = detectKeywords('Refactor the codebase');
      
      // Might have no matches or very low scores
      // Should not throw error
      expect(result.matches).toBeDefined();
      expect(Array.isArray(result.matches)).toBe(true);
    });
  });

  // ==========================================================================
  // Utility Functions
  // ==========================================================================
  
  describe('Utility Functions', () => {
    const mockResult: DetectionResult = {
      task: 'Test task',
      extractedKeywords: ['test', 'task'],
      matches: [
        { file: 'file1.md', matchedKeywords: ['test'], score: 5, domain: 'core' },
        { file: 'file2.md', matchedKeywords: ['test', 'task'], score: 3, domain: 'core' },
        { file: 'file3.md', matchedKeywords: ['test'], score: 1, domain: 'ui' },
      ]
    };

    describe('getTopMatches', () => {
      it('should return top N matches', () => {
        const top2 = getTopMatches(mockResult, 2);
        expect(top2).toHaveLength(2);
        expect(top2[0].file).toBe('file1.md');
        expect(top2[1].file).toBe('file2.md');
      });

      it('should default to top 5', () => {
        const top = getTopMatches(mockResult);
        expect(top.length).toBeLessThanOrEqual(5);
      });
    });

    describe('filterByScore', () => {
      it('should filter by minimum score', () => {
        const filtered = filterByScore(mockResult, 3);
        expect(filtered).toHaveLength(2);
        expect(filtered.every(m => m.score >= 3)).toBe(true);
      });

      it('should default to score 1', () => {
        const filtered = filterByScore(mockResult);
        expect(filtered).toHaveLength(3);
      });
    });
  });

  // ==========================================================================
  // Integration Tests
  // ==========================================================================
  
  describe('Integration Tests', () => {
    it('should handle realistic task: Add test for login form', () => {
      const result = detectKeywords('Add a test for the login form in sportsbook');
      
      // Should detect testing and react
      const files = result.matches.map(m => m.file);
      expect(files).toContain('core/testing-patterns.md');
      expect(files).toContain('ui/web/react-patterns.md');
      
      // Testing should have higher score (more specific)
      const testingMatch = result.matches.find(m => 
        m.file === 'core/testing-patterns.md'
      );
      expect(testingMatch!.score).toBeGreaterThan(0);
    });

    it('should handle realistic task: Redux API auth', () => {
      const result = detectKeywords(
        'Implement Redux state management for API authentication'
      );
      
      // Should detect state-management and api-patterns
      const files = result.matches.map(m => m.file);
      expect(files).toContain('core/state-management.md');
      expect(files).toContain('core/api-patterns.md');
    });

    it('should handle realistic task: React Native component', () => {
      const result = detectKeywords(
        'Create React Native component with navigation'
      );
      
      // Should detect react-native-patterns and possibly react-patterns
      const files = result.matches.map(m => m.file);
      expect(files).toContain('core/react-native-patterns.md');
    });

    it('should handle realistic task: Cypress E2E', () => {
      const result = detectKeywords(
        'Write Cypress E2E tests for the checkout flow'
      );
      
      // Should detect testing-patterns
      const files = result.matches.map(m => m.file);
      expect(files).toContain('core/testing-patterns.md');
      
      const testingMatch = result.matches.find(m => 
        m.file === 'core/testing-patterns.md'
      );
      expect(testingMatch!.matchedKeywords).toContain('cypress');
      expect(testingMatch!.matchedKeywords).toContain('e2e');
    });
  });
});
