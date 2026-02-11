# AI Working Style & Critical Rules

**Last Updated:** 2026-02-05  
**Priority:** ALWAYS LOAD - Core behavioral guidelines

---

## 🚨 CRITICAL RULES - NEVER VIOLATE

### ⚠️ RULE APPLICATION: EVERY REQUEST

**IMPORTANT:** These rules apply to **EVERY REQUEST** in a session, not just the initial one.

- ✅ Run context loading (GloomStalker) for **each new request**
- ✅ Check documentation for **each library usage**
- ✅ Verify git safety for **each git operation**
- ✅ Assess risk for **each destructive operation**
- ❌ DON'T assume context from initial request applies to follow-up requests
- ❌ DON'T skip safety checks because session already started

**Reasoning:** Each request may have different requirements, even in the same session. Session continuation should NOT bypass safety protocols.

### 1. Git Commit Behavior

**Preference:** ⚠️ **Manual git operations ONLY**

**AI Behavior:**
- ✅ DO: Make code changes
- ✅ DO: Run tests
- ✅ DO: Show `git status` and `git diff`
- ❌ DON'T: Auto-commit (applies to EVERY request, not just first one)
- ❌ DON'T: Auto-push
- ❌ DON'T: Create PRs automatically
- ❌ DON'T: Amend commits without explicit request

**Reasoning:** User wants to review and control all git operations

**Workflow:** Post git status + git diff (preferably via delta), then wait for approval

### 2. UI/Frontend Work

**Preference:** ⚠️ **Prefers doing frontend work himself**

**AI Behavior:**
- ❌ NEVER implement UI without asking first (applies to EVERY UI request)
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
- ✅ DO: Check documentation when the first approach fails (applies to EVERY failure, not just first)
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

**When to Check Docs (ON EVERY RELEVANT REQUEST):**
1. **Before implementing** with unfamiliar libraries
2. **After first failure** - Don't iterate blindly
3. **When creating wrappers** - Check if built-in config options exist first
4. **User suggests checking docs** - Do it immediately

**Reasoning:** Libraries often have simpler built-in solutions than custom implementations. Checking docs saves time and reduces complexity. Local docs are often installed with libraries and match the exact version being used.

### 5. Documentation & Knowledge Base

**Obsidian Vault Location:** `~/Developer/personal/Obsidian`

**AI Behavior:**
- ✅ DO: Ask @Scribe to document in Obsidian when creating/explaining complex features
- ✅ DO: Use Scribe's `/chronicle` command for rich documentation
- ✅ DO: Include technical detail that's also easy to consume
- ✅ DO: Reference Obsidian vault when user asks for documentation
- ❌ DON'T: Create documentation outside Obsidian vault unless user specifies
- ❌ DON'T: Write generic documentation—make it technically detailed AND readable

**Obsidian Structure:**
- **Work projects:** `Work/Domains/{Project-Name}/`
- **Personal learning:** `Personal/Learning/Notes/`
- **Tool guides:** `Personal/Knowledge/Tools/`
- **Project-specific:** `Personal/Projects/{Project-Name}/`

**When to Document:**
1. Complex features or workflows implemented
2. Non-obvious patterns or architectural decisions
3. User explicitly requests documentation
4. Knowledge worth preserving for future reference

**Reasoning:** Centralized knowledge base in Obsidian makes information discoverable and reusable. Technical detail ensures accuracy; readability ensures utility.

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

**🔄 ON EVERY REQUEST (not just initial):**
1. ⚠️ **Load appropriate context via GloomStalker for the CURRENT request**
2. ⚠️ **Check docs for third-party libraries before implementing**
3. ⚠️ **Never auto-commit or auto-push** (even in continued sessions)
4. ⚠️ **Ask before implementing UI/frontend** (each time)
5. ⚠️ **Assess risk before destructive operations**

**General Principles:**
6. 🎯 **Prefer readability over cleverness**
7. 📦 **User works with legacy code and monorepos**
8. 📝 **Use conventional commit format (fix:, feat:, etc.)**
9. 🔍 **Show git status + diff before committing**
10. 🧪 **Run tests and validation before declaring success**
11. 📚 **Document in Obsidian vault** (`~/Developer/personal/Obsidian`) via @Scribe

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
