# User Preferences - Index

**Last Updated:** 2026-02-05  
**Status:** This file has been split into focused files for better token efficiency

---

## 📋 Context Files Overview

This index points to the split context files. **GloomStalker** automatically loads relevant files based on keywords.

### ✅ Always Loaded (Priority 1)
- **`ai-working-style.md`** - Critical AI behavior rules (never auto-commit, ask before UI, etc.)
- **`code-style.md`** - Commenting rules and code quality guidelines

### 🔍 Loaded by Keywords (Priority 2+)

#### Git Operations
**File:** `git-workflow.md`  
**Keywords:** git, commit, branch, push, pull, merge, rebase, github, gh  
**Contains:** Git config, commit conventions, branch naming, GitHub CLI

#### Development Environment  
**File:** `dev-environment.md`  
**Keywords:** terminal, shell, editor, nvim, neovim, zsh, tmux, starship, mise, opencode  
**Contains:** Terminal setup, editor config, version management, package managers

#### CLI Tools
**File:** `cli-tools.md`  
**Keywords:** bat, eza, fd, ripgrep, rg, fzf, lazygit, yazi, btop, delta, zoxide, k9s, lazydocker  
**Contains:** Modern tool reference, usage examples, installation

#### Project Structure
**File:** `project-organization.md`  
**Keywords:** directory, structure, dotfiles, stow, organization, projects  
**Contains:** Directory layout, dotfiles management, window managers, context system

---

## 📊 Token Savings

**Before Split:**
- Single file: 277 lines (~8.7KB, ~2,500 tokens)
- Always loaded regardless of task

**After Split:**
- Always loaded: ~100 lines (~3KB, ~900 tokens) - **64% savings**
- Conditional files: Only loaded when keywords match
- Estimated average savings: **60-70% per task**

---

## 🎯 How It Works

1. **GloomStalker** analyzes your task for keywords
2. Loads **always-priority** files (`ai-working-style.md`, `code-style.md`)
3. Matches keywords to conditional files
4. Returns minimal necessary context
5. Typical load: 2-4 files instead of 1 giant file

**Example:**
```
Task: "Fix git commit message formatting"
↓
GloomStalker loads:
- ai-working-style.md (always)
- code-style.md (always)
- git-workflow.md (keyword: git, commit)

Result: 3 focused files (~150 lines) instead of 277 lines
Savings: ~46% tokens
```

---

## 📁 File Structure

```
context/general/
├── user-preferences.md        ← You are here (index)
├── ai-working-style.md        ← Always load
├── code-style.md              ← Always load
├── git-workflow.md            ← Load on git keywords
├── dev-environment.md         ← Load on dev keywords
├── cli-tools.md               ← Load on tool keywords
└── project-organization.md    ← Load on structure keywords
```

---

## 🔄 Migration Notes

**Old File:** `user-preferences.md` (277 lines)  
**New Files:** 6 focused files (varies by usage)

**Content Mapping:**
- Critical AI rules → `ai-working-style.md`
- Code quality, comments → `code-style.md`
- Git config, commits → `git-workflow.md`
- Terminal, editor, tools → `dev-environment.md`
- Modern CLI tools → `cli-tools.md`
- Directories, dotfiles → `project-organization.md`

**Benefits:**
- ✅ Better token efficiency (60-70% savings)
- ✅ Easier to maintain (smaller files)
- ✅ More precise context loading
- ✅ Clearer organization by topic

---

## 🚀 Quick Links

| Topic                  | File                       | Priority        |
| ---------------------- | -------------------------- | --------------- |
| AI Behavior (Critical) | `ai-working-style.md`      | Always Load     |
| Code Style             | `code-style.md`            | Always Load     |
| Git Workflow           | `git-workflow.md`          | Load on keywords |
| Dev Environment        | `dev-environment.md`       | Load on keywords |
| CLI Tools              | `cli-tools.md`             | Load on keywords |
| Project Organization   | `project-organization.md`  | Load on keywords |

---

**Last Migration:** 2026-02-05  
**Migrated by:** AI (Artificer)  
**Approved by:** User
