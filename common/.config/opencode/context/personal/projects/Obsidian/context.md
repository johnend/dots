# Obsidian Vault Context

**Project Path:** `/Users/john.enderby/Developer/personal/Obsidian`

## Overview

This is a personal Obsidian knowledge vault for managing notes, tasks, projects, and documentation. The vault is organized into two main sections: Personal and Work, containing various knowledge bases including development notes, learning materials, health tracking, project documentation, and work goals.

## Tech Stack

### Core
- **Application:** Obsidian.md (Knowledge Management & Note-Taking)
- **Format:** Markdown (.md files)
- **Editor Config:** EditorConfig (spaces, indent size 2)
- **Vim Mode:** Custom vim keybindings via .obsidian.vimrc
- **Version Control:** Git

### Key Plugins (Community)
- **obsidian-style-settings** - Custom styling and appearance
- **obsidian-icon-folder** - Folder and file icons
- **quickadd** - Quick note creation workflows
- **calendar** - Calendar view for daily notes
- **cm-editor-syntax-highlight-obsidian** - Code syntax highlighting
- **obsidian-kanban** - Kanban boards for project management
- **obsidian-importer** - Import from other note-taking apps
- **obsidian-relative-line-numbers** - Vim-style line numbers
- **advanced-canvas** - Enhanced canvas functionality
- **code-styler** - Code block styling
- **editor-width-slider** - Adjustable editor width
- **obsidian-advanced-new-file** - Advanced file creation
- **obsidian-tweaks** - Various UI tweaks
- **obsidian-projects** - Project management features
- **obsidian-vimrc-support** - Vim emulation
- **pane-relief** - Tab/pane navigation

### Dev Tools
- **Formatting:** EditorConfig (2-space indentation for .md)
- **Version Control:** Git
- **Vim Emulation:** Custom .obsidian.vimrc

## Project Structure

```
Obsidian/
├── Personal/                 # Personal knowledge base
│   ├── Development/          # Development-related notes
│   │   ├── Yearly-Reviews/   # Annual life reviews
│   │   └── CBT-Diary/        # Cognitive Behavioral Therapy diary
│   ├── Learning/             # Learning materials and courses
│   ├── Projects/             # Personal projects
│   │   ├── Archive/          # Archived projects (e.g., QuantumPanel)
│   │   ├── Ideas.md          # Project ideas
│   │   └── Plz/              # Current projects
│   ├── Health/               # Health and wellness tracking
│   ├── Knowledge/            # General knowledge base
│   ├── Linux/                # Linux notes and configs
│   ├── NeoVim/               # NeoVim configuration and notes
│   └── Writing/              # Writing and creative content
├── Work/                     # Work-related knowledge base
│   ├── Archive/              # Archived work notes
│   ├── Goals/                # Work goals and objectives
│   │   ├── Journal AGENTS.md # AI agent journal for work
│   │   └── 2025/             # 2025 goals and quarterly plans
│   ├── General/              # General work notes
│   ├── Raccoons/             # Team-specific notes
│   └── ToDo list.md          # Work task list
├── _templates/               # Note templates
│   ├── 🧠 CBT Thought Record.md
│   ├── Daily note.md
│   └── Goal Tracking Template.md
├── .obsidian/                # Obsidian configuration
│   ├── plugins/              # Installed plugins
│   ├── snippets/             # CSS snippets
│   ├── themes/               # Custom themes
│   └── *.json                # Various config files
└── .obsidian.vimrc           # Vim keybindings configuration
```

## Vim Configuration

### Key Features
- **Vim Mode:** Full vim emulation with custom keybindings
- **Navigation:** Visual line navigation (gj/gk), tab switching (gt/gT)
- **Folding:** Toggle folds (zo), fold all (zM), unfold all (zR)
- **Links:** Open links (go/gd), follow links (gf), link jump (<Space>f)
- **Surround:** Custom surround commands for wiki links, quotes, brackets
- **Focus:** Pane navigation with Ctrl+hjkl
- **File Operations:** Rename file (gr)
- **Clipboard:** System clipboard integration

### Notable Keybindings
- `<Space>f` - Link jump (fuzzy search links)
- `go` / `gd` - Open link in new leaf
- `gf` - Follow link under cursor
- `gr` - Rename file
- `gt` / `gT` - Next/previous tab
- `zo` - Toggle fold
- `zR` / `zM` - Unfold all / fold all
- `Ctrl+h/j/k/l` - Focus left/down/up/right pane

## Templates

### Available Templates
1. **CBT Thought Record** - Structured template for cognitive behavioral therapy thought tracking
2. **Daily Note** - Daily journal and task tracking template
3. **Goal Tracking Template** - Template for tracking goals and progress

## Development Setup

### Prerequisites
- Obsidian desktop app installed
- Git for version control
- Text editor supporting EditorConfig (optional)

### Setup Steps
1. Clone or sync the vault repository
2. Open vault in Obsidian app
3. Obsidian will automatically load plugins and configuration
4. Vim keybindings are automatically enabled via .obsidian.vimrc

## Organization Strategy

### Personal Section
- **Development**: Technical learning, yearly reviews, personal growth
- **Projects**: Active and archived personal projects
- **Health**: Wellness tracking, CBT diary
- **Knowledge**: General reference materials
- **Linux/NeoVim**: System and editor configuration notes
- **Writing**: Creative content and writing projects

### Work Section
- **Goals**: Annual and quarterly work objectives with detailed tracking
- **Archive**: Historical work documentation
- **General**: Day-to-day work notes
- **Raccoons**: Team-specific collaboration notes

## Version Control

- **Repository:** Git-tracked personal vault
- **Ignored Files:** .DS_Store only
- **Public Repository:** This vault is tracked in personal dotfiles (public)

## Note Structure & Conventions

### Front Matter Requirements

**CRITICAL:** All notes MUST include YAML front matter with appropriate metadata and tags for proper linking within the vault.

#### Standard Front Matter Pattern
```yaml
---
title: "Note Title"
date: YYYY-MM-DD
tags: [tag1, tag2, tag3]
---
```

#### Common Front Matter Fields

**Universal Fields:**
- `title` - Note title (always required)
- `date` or `created` - Creation date in YYYY-MM-DD format
- `tags` - Array of tags for categorization and linking

**Context-Specific Fields:**
- `type` - Note type (e.g., `kanban`, `journal`, `project`, `goal`)
- `status` - Status tracking (e.g., `Not Started`, `In Progress`, `Done`)
- `category` - Categorical grouping (e.g., `Skill Development`, `Work`, `Personal`)
- `priority` - Importance level (e.g., `High`, `Medium`, `Low`)
- `timeframe` - Time period (e.g., `Q1 2025`, `2025-01`)
- `day` - Day of week for daily notes

**Specialized Fields (by note type):**
- **CBT Notes:** `emotion`, `distortions`, `project_related`, `health_related`, `relationship_related`, `energy_level`
- **Goals:** `key_results`, `milestones`, `deadline`
- **Kanban:** `kanban-plugin: board`

### Tagging Strategy

Tags are essential for linking notes and enabling cross-vault discovery. Use hierarchical and descriptive tags.

#### Tag Categories

**Activity Tags:**
- `#ideas` - Brainstorming and ideation
- `#projects` - Project-related notes
- `#learning` - Educational content
- `#journal` - Journal entries
- `#daily` - Daily notes
- `#goal` - Goal tracking

**Domain Tags:**
- `#development` - Software development
- `#health` - Health and wellness
- `#work` - Work-related
- `#personal` - Personal content
- `#mental-health` - Mental health tracking
- `#cbt` - Cognitive behavioral therapy

**Context Tags:**
- `#brainstorming` - Ideation phase
- `#skill_development` - Skill building
- `#q1`, `#q2`, `#q3`, `#q4` - Quarterly organization

### Inter-Note Linking

**CRITICAL:** Use Obsidian wiki-link syntax for proper linking in both NeoVim and Obsidian GUI.

#### Wiki Link Syntax
```markdown
[[Note Title]]              # Link to note by title
[[Note Title|Display Text]] # Link with custom display text
[[folder/Note Title]]       # Link with path (if needed)
```

#### Link Best Practices
1. **Use wiki links, not markdown links** - `[[Note]]` not `[Note](note.md)`
2. **Link by title, not file path** - Obsidian resolves by note title
3. **Use aliases for clarity** - `[[Long Note Title|short reference]]`
4. **Create bidirectional links** - Link back to parent/related notes
5. **Tag AND link** - Tags for categorization, links for relationships

#### Example Note with Proper Linking
```markdown
---
title: "React Performance Optimization"
date: 2025-01-15
tags: [development, react, performance, learning]
type: learning
---

# React Performance Optimization

Related to [[JavaScript Fundamentals]] and [[Web Performance]].

See also: [[Personal/Projects/Ideas]] for potential applications.

## Concepts
- **Memoization** - See [[React.memo and useMemo]]
- **Virtual DOM** - Related to [[How React Works]]
```

### Editing Workflow

**Primary Editor:** NeoVim
- Most editing happens in NeoVim outside Obsidian GUI
- Wiki links must be valid for Obsidian GUI when opened
- Front matter is essential for both NeoVim and GUI workflows

**Secondary Editor:** Obsidian GUI
- Used for visual editing, canvas, and plugin features
- Requires properly formatted wiki links to function
- Front matter enables plugin features (calendar, kanban, projects)

### Note Creation Checklist

When creating or editing notes, ensure:
1. ✅ YAML front matter is present and complete
2. ✅ `title` field matches note content
3. ✅ `date` or `created` field is set (YYYY-MM-DD format)
4. ✅ Minimum 2-3 relevant tags included
5. ✅ Related notes are linked using `[[wiki links]]`
6. ✅ Links use note titles, not file paths
7. ✅ Context-specific metadata is included (status, priority, etc.)

## Key Patterns

- **Front matter is mandatory** - All notes require YAML metadata for proper vault integration
- **Wiki-style linking** - Use `[[Note Title]]` syntax for all inter-note references
- **Tag everything** - Minimum 2-3 tags per note for discoverability
- **2-space indentation** for all Markdown files (enforced by .editorconfig)
- **Hierarchical organization** with clear Personal/Work separation
- **Template-based note creation** for consistency (templates include proper front matter)
- **Vim-first workflow** with extensive custom keybindings
- **NeoVim primary, GUI secondary** - Most editing in NeoVim, GUI for visual/plugin features
- **Bidirectional linking** - Create connections between related notes
- **Plugin-enhanced experience** for project management, calendars, and kanban boards
- **Quarterly goal tracking** with detailed breakdown in Work section
- **CBT journaling** for mental health tracking in Personal section

## Important Notes

- **Front Matter is Mandatory:** All notes must include YAML front matter with title, date, and tags
- **Use Wiki Links:** Always use `[[Note Title]]` syntax, never markdown links `[text](path.md)`
- **NeoVim Primary, GUI Secondary:** Most editing in NeoVim, but links must work in Obsidian GUI
- **Vim Mode Required:** This vault is heavily optimized for Vim keybindings - new users should review .obsidian.vimrc
- **Plugin Dependencies:** Many workflows depend on community plugins being installed and enabled
- **Templates Location:** All templates stored in `_templates/` directory with proper front matter
- **Work Privacy:** While vault is public, sensitive work details should be kept minimal
- **Daily Notes:** Uses custom daily note template with date-based front matter
- **Pane Navigation:** Requires `pane-relief` plugin for gt/gT tab switching
- **Link Jumping:** Requires `mrj-jump-to-link` plugin for fuzzy link navigation
- **Tag Minimum:** Every note should have at least 2-3 relevant tags for discoverability

## AI Agent Usage

- **Journal AGENTS.md:** Work goals section includes specific file for tracking AI agent interactions
- **Context Awareness:** AI agents should respect the Personal/Work boundary
- **Template Usage:** AI can suggest using templates when creating new notes
- **Vim Commands:** AI should understand .obsidian.vimrc keybindings when discussing navigation
- **Front Matter Required:** When creating/editing notes, AI must always include proper YAML front matter
- **Wiki Link Syntax:** AI must use `[[Note Title]]` format for all inter-note links, never markdown links
- **Tagging:** AI should suggest minimum 2-3 relevant tags for any new note
- **NeoVim Compatibility:** All changes must work in both NeoVim and Obsidian GUI

## Future Enhancements

- Consider adding dataview queries for dynamic note aggregation
- Potential automation for daily note creation
- Archive old yearly reviews automatically
- Enhanced project tracking with obsidian-projects plugin
