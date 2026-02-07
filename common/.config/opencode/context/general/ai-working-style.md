# AI Working Style & Critical Rules

**Last Updated:** 2026-02-05  
**Priority:** ALWAYS LOAD - Core behavioral guidelines

---

## 🚨 CRITICAL RULES - NEVER VIOLATE

### 1. Git Commit Behavior

**Preference:** ⚠️ **Manual git operations ONLY**

**AI Behavior:**
- ✅ DO: Make code changes
- ✅ DO: Run tests
- ✅ DO: Show `git status` and `git diff`
- ❌ DON'T: Auto-commit
- ❌ DON'T: Auto-push
- ❌ DON'T: Create PRs automatically
- ❌ DON'T: Amend commits without explicit request

**Reasoning:** User wants to review and control all git operations

**Workflow:** Post git status + git diff (preferably via delta), then wait for approval

### 2. UI/Frontend Work

**Preference:** ⚠️ **Prefers doing frontend work himself**

**AI Behavior:**
- ❌ NEVER implement UI without asking first
- ✅ ALWAYS ask: "Would you like me to implement this UI, create basic structure, or just provide guidance?"

**Reasoning:** User values control over visual/UX decisions

### 3. Code Quality Philosophy

- 🎯 **Readability over cleverness**
- 📝 **Comments:** Explain WHY, not WHAT (see `code-style.md` for details)
- 🧪 **Testing:** Run validation scripts; prefer script-provided validation

---

## Communication Style

### Interaction Preferences

- **Verbosity:** Concise but complete
- **Detail Level:** Technical depth appreciated
- **Mode Support:**
  - `plan-first:` - Show detailed plan, wait for approval
  - `pause:` - Interactive step-by-step
  - `ultrawork:` or `ulw:` - Maximum automation, minimal interruption

### Decision Making

**Autonomy:** Appreciates AI taking initiative on non-critical tasks in ultrawork mode

**Critical Decisions - ALWAYS Consult:**
- UI implementation
- Git operations (commit, push, PR)
- Deployment
- Dependency changes
- System-wide changes

---

## Testing Philosophy

- Execute validation scripts with `--dry-run` before touching live systems
- Rerun validation after modifying configs
- Test shell configs in subshell: `env ZDOTDIR=$(pwd)/common zsh -f`
- Manual test steps should be documented when automation is impossible
- Run `shellcheck` locally before committing complex scripts

---

## Quick Reference - ALWAYS Remember

1. ⚠️ **Ask before implementing UI/frontend**
2. ⚠️ **Never auto-commit or auto-push**
3. 🎯 **Prefer readability over cleverness**
4. 📦 **User works with legacy code and monorepos**
5. 📝 **Use conventional commit format (fix:, feat:, etc.)**
6. 🔍 **Show git status + diff before committing**
7. 🧪 **Run tests and validation before declaring success**

---

## Preferred Workflows

- Use git aliases for commits: `git fix "message"`, `git feat "message"`
- Use delta for readable diffs
- Use lazygit for complex git operations
- Use tmux-sessionizer for project switching
- Use mise for version management (not asdf/nvm/pyenv)
- Prefer modern CLI tools: `rg` over `grep`, `fd` over `find`, `bat` over `cat`, `eza` over `ls`

---

**Related Files:**
- `code-style.md` - Detailed commenting and style guidelines
- `git-workflow.md` - Git configuration and commit conventions
- `dev-environment.md` - Development environment setup
