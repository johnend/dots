# Mentor Commands

Custom commands that enhance Mentor's teaching and collaboration capabilities.

## Overview

These commands extend Mentor's default behavior with specialized workflows:

1. **`/implement-with-artificer`** - Hand off implementation to Artificer with full context
2. **`/debug-with-me`** - Structured collaborative debugging
3. **`/reading-list`** - Curated learning resources for deep topics

## Command Philosophy

**Mentor's core role:**
- Guide, don't solve
- Teach process, not just answers
- Build user's skills and confidence
- Know when to hand off vs. when to dig deeper

**Commands support:**
- Efficient workflows (hand off when appropriate)
- Structured learning (debugging process, resource curation)
- User autonomy (choose their path forward)

## Usage

### For AI Agents

When Mentor detects appropriate triggers, offer the relevant command:

```
User: "How does React reconciliation work?"

Mentor: That's a deep topic!

I can:
1. Give you a brief overview here (3-4 paragraphs)
2. Generate a /reading-list for deep-diving later

Which would you prefer?
```

### For Users

Users can invoke commands explicitly:

```
/implement-with-artificer "Build the logging middleware we discussed"
/debug-with-me "Login form not submitting"
/reading-list
```

## Command Specifications

### /implement-with-artificer

**Purpose:** Clean handoff from learning to building

**When to offer:**
- User asks "can you implement this?"
- Discussion reached implementation-ready stage
- User expresses time pressure
- Concept is understood, just needs code

**Workflow:**
1. Capture session context (topic, discussion, requirements)
2. Check git status (what user tried)
3. Format comprehensive handoff message
4. End Mentor session cleanly
5. Artificer takes over with full context

**Key feature:** Artificer receives not just requirements, but user's understanding level and constraints discussed.

[See full specification →](./implement-with-artificer.md)

### /debug-with-me

**Purpose:** Teach systematic debugging process

**When to offer:**
- User says "it's not working"
- User is stuck debugging
- Problem requires investigation

**Framework:**
1. **Understand symptom** - What exactly happens?
2. **Form hypothesis** - What might cause this?
3. **Design investigation** - Which tools to use?
4. **Execute & observe** - Walk through debugging
5. **Iterate or solve** - Found it? Fix or dig deeper?

**Key feature:** Teaches tool usage (DevTools, debugger, Postman) not just bug fixes.

[See full specification →](./debug-with-me.md)

### /reading-list

**Purpose:** Provide curated learning resources without derailing conversation

**When to offer:**
- User asks about complex/deep topic
- Question is tangential to current work
- Topic deserves more depth than brief answer

**Format:**
- **Foundational** - Start here (official docs, beginner tutorials)
- **Deep Dive** - After foundational (advanced articles, courses)
- **Related** - Optional connections (tools, videos, books)
- **Suggested path** - Reading order recommendation
- **Brief overview** - 3-4 paragraphs to get started

**Key feature:** Prioritizes authoritative sources (MDN, official docs, respected educators), marks paid resources (💰).

[See full specification →](./reading-list.md)

## Integration with Git Status Checker

All commands benefit from git status awareness:

**Before /implement-with-artificer:**
```bash
node ~/.config/opencode/hooks/git-status-checker/dist/cli.js
```

**Shows Artificer:**
- What files user was working on
- Any WIP attempts they made
- Current state of implementation

**Enables Mentor to:**
- See what user tried ("I see you attempted...")
- Tailor guidance to their approach
- Recognize progress or struggles

## Command Interactions

**Commands can chain:**
```
/debug-with-me → (found issue) → /implement-with-artificer
/reading-list → (user reads) → (returns with questions)
/implement-with-artificer → (user has questions) → (call Mentor back)
```

**Mentor always available:**
- Commands don't "lock" the user
- Can call Mentor back after handoff
- Can switch between learning and building modes

## Examples in Context

### Example: Time Pressure

```
User: "I need to add form validation but I don't have time to learn it right now"

Mentor: I understand you're pressed for time!

Quick question so I can hand off to Artificer:
- Email and password fields?
- What validations? (required, format, length?)

User: "Email format, password min 8 chars, both required"

Mentor: Perfect! Handing off to @Artificer now:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXT FROM MENTOR SESSION
...
[/implement-with-artificer workflow]
```

### Example: Learning Journey

```
User: "Why is my component re-rendering so much?"

Mentor: Let's debug this together!

/debug-with-me workflow:
- Profile with React DevTools
- Find unnecessary re-renders
- Identify function reference issue

User: "This is fascinating! How does React decide what to re-render?"

Mentor: That's the reconciliation algorithm!

I can:
1. Give you overview here (3-4 paragraphs)
2. Generate /reading-list for deep dive

User: "/reading-list"

[Generates curated list of React reconciliation resources]
```

### Example: Stuck Debugging

```
User: "API works in dev but fails in production"

Mentor: Classic environment issue!

/debug-with-me workflow:
- Check browser console (CORS error)
- Inspect Network tab (Access-Control headers)
- Find CORS config in code
- Identify localhost-only configuration

Mentor: Found it! Your CORS only allows localhost.

Want to:
1. Fix it yourself (I'll guide you)
2. /implement-with-artificer to fix quickly
3. Discuss CORS security more

User: "2 - deadline approaching"

[Hands off to Artificer with full context]
```

## Design Principles

**1. User autonomy**
- Always offer choices
- Never force a path
- Respect their learning style

**2. Context preservation**
- Git status awareness
- Session memory
- Handoff continuity

**3. Skill building**
- Teach process, not just answers
- Introduce tools systematically
- Build debugging confidence

**4. Efficiency**
- Hand off when appropriate
- Provide resources for deep dives
- Don't block on tangents

**5. Encouragement**
- Celebrate discoveries
- Support learning journey
- Maintain positive tone

## Future Enhancements

**Potential additions:**
- `/explain-code` - Deep dive into specific code snippet
- `/architecture-review` - Discuss design decisions
- `/pair-program` - Step-by-step collaborative coding
- `/test-with-me` - Write tests together

**Data-driven improvements:**
- Track which commands are most useful
- Identify when users struggle with handoffs
- Optimize reading list based on feedback

## Development

To add a new command:

1. Create `commands/mentor/[command-name].md`
2. Follow existing format:
   - Purpose
   - When to use
   - Workflow
   - Examples
   - Important notes
3. Update this README
4. Update `agents/mentor.md` with command
5. Test in real scenarios

## Notes

- Commands are **specifications**, not code
- Agents read these files for guidance
- Format optimized for AI comprehension
- Examples teach expected behavior
- User-facing documentation in `docs/`
