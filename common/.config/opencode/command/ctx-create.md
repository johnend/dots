---
description: Create comprehensive project context
agent: artificer
---

# Create Project Context

Analyze the current project and create a comprehensive context file in `~/.config/opencode/context/projects/{project-name}/`.

## Required Files

1. **context.md** - Full project documentation including:
   - Overview (what is this project?)
   - Tech Stack (framework, language, build tool, versions)
   - Dependencies (key libraries with versions)
   - Scripts (all package.json/gradle scripts with descriptions)
   - Project Structure (directory layout)
   - Environment Setup (prerequisites, setup steps)
   - Testing Strategy (frameworks, commands)
   - CI/CD (pipeline links if available)
   - Team & Support (Slack channels, ownership)
   - Key Patterns (conventions, best practices)
   - Important Notes (gotchas, workarounds)

2. **metadata.json** - Path matching configuration:
   ```json
   {
     "projectPath": "/full/path/to/project",
     "projectName": "project-name",
     "lastUpdated": "YYYY-MM-DD",
     "contextVersion": "1.0.0",
     "projectType": "node|java|python|etc",
     "primaryLanguage": "typescript|java|python|etc",
     "framework": "react|spring-boot|django|etc",
     "matchPatterns": [
       "**/project-name/**"
     ],
     "keywords": ["relevant", "keywords"]
   }
   ```

## Analysis Steps

1. Read `package.json` / `build.gradle` / `requirements.txt` / etc.
2. Read `README.md` and `AGENTS.md` (if exists)
3. List root directory structure
4. Check for testing configuration
5. Look for CI/CD files (.github/workflows, .buildkite, etc.)
6. Identify key patterns in source code

## Output

After creating the files, provide:
- Path to created files
- Summary of what was documented
- Any gaps or questions needing clarification
