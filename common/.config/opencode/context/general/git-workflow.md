# Git Workflow & Configuration

**Last Updated:** 2026-02-05  
**Keywords:** git, commit, branch, push, pull, merge, rebase, github, gh

---

## Git Configuration

### Core Settings
- **Editor:** nvim
- **Pager:** delta (side-by-side, catppuccin-mocha theme)
- **Default branch:** main
- **Merge conflict style:** diff3
- **Force Push:** Uses `--force-with-lease` (safer than `--force`)
- **GitHub:** Authenticated via gh CLI
- **LFS:** Enabled

---

## Commit Style

### Conventional Commits via Git Aliases

```bash
git fix "message"      # → fix: message
git feat "message"     # → feat: message
git chore "message"    # → chore: message
git docs "message"     # → docs: message
git style "message"    # → style: message
git refactor "message" # → refactor: message
git test "message"     # → test: message
```

### Commit Template
- **Location:** `~/.gitsettings/.gitmessage.txt`
- **Style:** Conventional Commits format

### Commit Guidelines

**Format:**
- Imperative tense ("add feature" not "added feature")
- Under 72 characters for first line
- Group related edits into single commit
- **CRITICAL:** Never commit without owner sign-off
- Post `git status` and `git diff --stat` for inspection first

**Example Good Commits:**
```
fix: resolve null pointer in user validation
feat: add password reset flow
chore: update dependencies to latest versions
docs: clarify API authentication requirements
```

---

## Branch Naming Convention

**Pattern:** `<area>: <scope> - <summary>`

**Examples:**
```
feat: auth - add password reset
fix: payment - handle stripe webhook errors
chore: deps - upgrade react to v19
docs: api - document rate limiting
refactor: user-service - extract validation logic
```

---

## Git Operations - AI Behavior

### ✅ ALLOWED Operations (Read-Only)
- `git status` - Check repo state
- `git log` - View history
- `git diff` - View changes
- `git show` - Show commits/objects
- `git branch` - List branches (read-only)
- `git remote -v` - View remotes

### ⚠️ REQUIRES APPROVAL (State Changes)
- `git add` - Stage files
- `git commit` - Create commits
- `git push` - Push to remote
- `git pull` - Pull from remote
- `git fetch` - Fetch from remote
- `git checkout` / `git switch` - Change branches
- `git merge` - Merge branches
- `git rebase` - Rebase commits
- `git reset` - Reset state
- `git stash` - Stash changes
- `git branch -d/-D` - Delete branches

### 🚫 FORBIDDEN (Destructive)
- `git push --force` - Use `--force-with-lease` instead
- `git reset --hard` without confirmation
- Force pushing to main/master
- Rewriting public history without discussion

---

## GitHub CLI Usage

### Read-Only Operations (Allowed)
```bash
gh repo view
gh pr view <number>
gh pr list
gh issue view <number>
gh issue list
gh run view <id>
gh run list
gh api <endpoint>
```

### State-Changing Operations (Requires Approval)
```bash
gh pr create
gh pr merge
gh pr close
gh issue create
gh issue close
gh run cancel
gh run rerun
```

---

## Workflow Best Practices

### Before Committing
1. Run `git status` to see all changes
2. Run `git diff` (preferably with delta) to review changes
3. Stage related files: `git add <files>`
4. Write clear commit message following conventions
5. Wait for user approval before committing

### Branch Workflow
1. Create feature branch from main: `git switch -c "feat: description"`
2. Make changes and commit regularly
3. Keep commits atomic and focused
4. Rebase on main before merging (if needed)
5. Use `--force-with-lease` if rebase required

### Pull Request Workflow
1. Push branch to remote
2. Create PR via `gh pr create` (after user approval)
3. Reference related issues in PR description
4. Wait for review before merging

---

## Delta Configuration

**Theme:** catppuccin-mocha  
**Style:** side-by-side diffs  
**Features:**
- Syntax highlighting
- Line numbers
- Git blame integration
- Better merge conflict visualization

**Usage:**
```bash
git diff           # Automatically uses delta
git log -p         # Commit diffs with delta
git show <commit>  # Show commit with delta
```

---

## Common Git Aliases (Available)

```bash
git fix "msg"      # Quick fix commit
git feat "msg"     # Quick feature commit
git chore "msg"    # Quick chore commit
git docs "msg"     # Quick docs commit
git style "msg"    # Quick style commit
git refactor "msg" # Quick refactor commit
git test "msg"     # Quick test commit
```

---

**Related Files:**
- `ai-working-style.md` - Critical rules for AI behavior
- `dev-environment.md` - Development environment setup
- `cli-tools.md` - Modern CLI tools (includes delta, gh, lazygit)
