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

### 4. Third-Party Library Documentation

**Preference:** ⚠️ **ALWAYS check official documentation before implementing**

**AI Behavior:**
- ✅ DO: Check local docs first (if they exist alongside the library/plugin)
- ✅ DO: Use `webfetch` for online docs if local docs don't exist or are insufficient
- ✅ DO: Check documentation when the first approach fails
- ✅ DO: Suggest checking docs if unsure about API usage
- ❌ DON'T: Make assumptions about library APIs
- ❌ DON'T: Keep trying failed approaches without consulting docs
- ❌ DON'T: Create complex workarounds before checking if a simple built-in solution exists

**Documentation Priority (General):**
1. **Local library docs** - Check if docs are installed alongside the library
2. **Package README** - Often in the root of the library directory
3. **Online documentation** - Use `webfetch` for GitHub/official docs

**Examples of Local Documentation:**
- **Neovim plugins:** `~/.local/share/qvim/lazy/{plugin}/docs/` or `README.md` or `/doc/*.txt`
- **Node packages:** `node_modules/{package}/README.md` or `/docs/`
- **Python packages:** Virtual env site-packages or system packages
- **System libraries:** `/usr/share/doc/{package}/` on Linux

**When to Check Docs:**
1. **Before implementing** with unfamiliar libraries
2. **After first failure** - Don't iterate blindly
3. **When creating wrappers** - Check if built-in config options exist first
4. **User suggests checking docs** - Do it immediately

**Reasoning:** Libraries often have simpler built-in solutions than custom implementations. Checking docs saves time and reduces complexity. Local docs are often installed with libraries and match the exact version being used.

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
3. ⚠️ **Check docs for third-party libraries before implementing**
4. 🎯 **Prefer readability over cleverness**
5. 📦 **User works with legacy code and monorepos**
6. 📝 **Use conventional commit format (fix:, feat:, etc.)**
7. 🔍 **Show git status + diff before committing**
8. 🧪 **Run tests and validation before declaring success**

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
