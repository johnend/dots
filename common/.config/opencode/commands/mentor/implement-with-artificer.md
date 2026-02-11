---
description: Hand off implementation to Artificer with full session context
agent: mentor
---

# /implement-with-artificer

**Purpose:** Hand off implementation to Artificer with full session context from Mentor conversation.

## When to Use

Mentor should offer this command when:
- User asks "can you implement this?"
- Discussion has reached implementation-ready stage
- User expresses time pressure or frustration with exploration
- Concept is understood, just needs code written

## Command Format

```
/implement-with-artificer "Brief description of what to implement"
```

## Mentor's Workflow

### 1. Capture Session Context

**Information to gather:**
- **Topic** - What was being discussed
- **Discussion summary** - Key points and decisions made
- **Files discussed** - Code locations mentioned in conversation
- **User's understanding level** - What they know vs. don't know
- **Implementation requirements** - Specific needs identified
- **Constraints** - Things to avoid or consider
- **Approach discussed** - Any specific patterns or strategies agreed upon

### 2. Check Git Status

Before handoff, run git status checker:
```bash
node ~/.config/opencode/hooks/git-status-checker/dist/cli.js
```

Include relevant changes in context:
- Files user was working on
- Any attempts they made
- Current state of implementation

### 3. Format Handoff Message

```
@Artificer - Implementation request from Mentor session:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXT FROM MENTOR SESSION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Topic: [What was being discussed]

Discussion Summary:
- [Key point 1]
- [Key point 2]
- [Key decision made]

Files Discussed:
- [file path] - [what was discussed about it]
- [file path] - [user's WIP attempt]

User's Understanding Level: [Beginner/Intermediate/Advanced]
- Knows: [What they understand]
- Learning: [What they're still figuring out]

Implementation Requirements:
1. [Specific requirement 1]
2. [Specific requirement 2]
3. [Follow existing patterns in codebase]

Constraints/Considerations:
- [Technical constraint]
- [Business requirement]
- [Security concern]

Git Status:
[Relevant changes from git-status-checker]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Please implement this solution following established patterns.

---

Mentor session ended. Good luck! Call me back if you need more guidance.
```

### 4. End Mentor Session

After handoff:
- Mentor signs off with encouragement
- Artificer takes over completely
- User can call Mentor back anytime if needed

## Examples

### Example 1: Redux Middleware Implementation

**User:** "I think I understand how middleware works now. Can you just build it for me? I'm running out of time."

**Mentor:**
```
✓ Preparing handoff to @Artificer...
✓ Checking git status...
✓ Capturing session context...

@Artificer - Implementation request from Mentor session:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXT FROM MENTOR SESSION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Topic: Redux middleware for action logging

Discussion Summary:
- User wants to log all actions for debugging production issues
- Discussed middleware intercepts actions before reducers
- Decided on format: { type, payload, timestamp, prevState, nextState }
- User understands the middleware chain concept
- Exclude AUTH_* actions for security

Files Discussed:
- src/store/middleware.ts - User's WIP attempt (incomplete)
- src/store/index.ts - Store configuration location
- src/store/middleware/logging.example.ts - Similar example in codebase

User's Understanding Level: Intermediate
- Knows: Redux basics, why middleware is needed
- Learning: How to implement custom middleware, how to access state

Implementation Requirements:
1. Create logging middleware in src/store/middleware/logging.ts
2. Log format: { type, payload, timestamp, prevState, nextState }
3. Exclude AUTH_LOGIN, AUTH_LOGOUT, AUTH_REFRESH from logs
4. Add to store configuration in src/store/index.ts
5. Only active in development mode (check process.env.NODE_ENV)
6. Follow existing middleware patterns (see logging.example.ts)

Constraints/Considerations:
- Security: Never log AUTH actions or tokens
- Performance: Only in development, not production
- Format: Console.log with clear formatting for readability

Git Status:
📝 Modified:
  🔴 src/store/middleware.ts (unstaged)
     +15 -0 lines
     [User started implementation but got stuck]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Please implement this logging middleware following the existing patterns.

---

Great learning session! Artificer will take it from here. Call me back if you want to understand what he implements!
```

### Example 2: API Endpoint Implementation

**User:** "/implement-with-artificer Add the password reset endpoint we designed"

**Mentor:**
```
✓ Preparing handoff to @Artificer...
✓ Checking git status...

@Artificer - Implementation request from Mentor session:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXT FROM MENTOR SESSION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Topic: Password reset API endpoint design

Discussion Summary:
- User needs password reset functionality for production bug
- Discussed flow: request reset → email token → verify token → update password
- Token should expire in 1 hour
- Use bcrypt for password hashing (already in use)
- Send email via existing EmailService

Files Discussed:
- backend/src/routes/auth.ts - Existing auth routes
- backend/src/services/EmailService.ts - Email sending service
- backend/src/models/User.ts - User model with password field

User's Understanding Level: Intermediate
- Knows: Express routing, async/await, basic security
- Learning: Token generation, expiration handling

Implementation Requirements:
1. POST /api/auth/password-reset-request
   - Body: { email }
   - Generate token, save to user record with expiry
   - Send email with token link
   
2. POST /api/auth/password-reset-confirm
   - Body: { token, newPassword }
   - Verify token not expired
   - Hash password with bcrypt
   - Update user password
   - Invalidate token

3. Use existing patterns from auth.ts for:
   - Error handling
   - Validation (express-validator)
   - Response format

Constraints/Considerations:
- Security: Token must be cryptographically secure (crypto.randomBytes)
- UX: Clear error messages (token expired vs. invalid)
- Email: Use EmailService.sendPasswordReset() method
- Validation: Password must meet existing requirements (min 8 chars, etc.)

Git Status:
[No uncommitted changes - clean working tree]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Please implement these two endpoints following existing auth patterns.

---

Nicely designed! Artificer will implement this now. Let me know if you want to review it together afterwards!
```

### Example 3: Quick Handoff

**User:** "Just make it work, I'll figure it out later"

**Mentor:**
```
I understand you're pressed for time! Before I hand off to Artificer, let me make sure I capture what you need:

From our discussion:
- You need the form validation for the login page
- Email and password fields, both required
- Email must be valid format
- Password min 8 characters

Does that sound right? Any other requirements?

[User confirms]

Perfect! Handing off to @Artificer now:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CONTEXT FROM MENTOR SESSION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Topic: Login form validation

Discussion Summary:
- User is time-pressed, needs working validation ASAP
- Form has email and password fields
- Brief discussion, user knows React forms

Implementation Requirements:
1. Add validation to LoginForm component
2. Email field: required, valid email format
3. Password field: required, min 8 characters
4. Show error messages below each field
5. Disable submit button until valid

Git Status:
📝 Modified:
  🔴 src/components/LoginForm.tsx (unstaged)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

@Artificer - Please add form validation following React best practices.

---

@User - Artificer's got this! Come back if you want to understand the implementation.
```

## Important Notes

**Always capture:**
- ✅ What user understands (avoid over-explaining)
- ✅ What patterns to follow (consistency matters)
- ✅ Why decisions were made (context for Artificer)
- ✅ Current git state (what user tried)

**Never:**
- ❌ Hand off without checking user wants it
- ❌ Leave out constraints discussed
- ❌ Forget to mention existing patterns
- ❌ Skip git status check

**Session end:**
- Mentor ends cleanly with encouragement
- User knows they can call Mentor back
- Artificer has full context to implement properly
