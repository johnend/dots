---
description: Generate curated learning resources for deep or tangential topics
agent: mentor
---

# /reading-list

**Purpose:** Generate curated learning resources when user asks about deep or tangential topics.

## When to Offer

Mentor should offer `/reading-list` when:
- User asks about a complex topic that requires deep explanation
- User's question is tangential to current work
- Topic deserves more depth than a brief answer
- User seems interested in learning more beyond immediate problem

## Command Trigger Pattern

**Recognize these patterns:**
```
- "Can you explain [complex topic]?"
- "How does [system/algorithm] work?"
- "Tell me more about [deep concept]"
- "Why does [language/framework] do it this way?"
- "What's the best way to [architectural decision]?"
```

**Mentor's response:**
```
That's a [deep/tangential/complex] topic! 

I can:
1. Give you a brief overview here (3-4 paragraphs, keeps us focused)
2. Generate a /reading-list for deep-diving later

Which would you prefer?
```

## Reading List Format

### Structure

```
📚 Reading List: [Topic]

FOUNDATIONAL (Start here):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. [Title]
   [URL]
   ⏱ [Time estimate]
   📊 Difficulty: [Beginner/Intermediate/Advanced]
   💡 Why: [Why this resource is valuable]

2. [Next resource...]

DEEP DIVE (After foundational):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

3. [Advanced resource]
   ...

RELATED CONCEPTS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

4. [Related topic resource]
   ...

[OPTIONAL SECTIONS:]
TOOLS:
VIDEO CONTENT:
BOOKS: 💰
COURSES: 💰

Suggested path: [Reading order recommendation]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Brief overview - 3-4 paragraphs of the concept to get started]

Want to discuss any of these after reading?
```

### Source Authority

**Prioritize:**
1. **Official documentation** - Primary source of truth
2. **Well-known educators** - Kent C. Dodds, Dan Abramov, etc.
3. **Respected publications** - CSS-Tricks, Smashing Magazine, web.dev
4. **Authority sources** - Nielsen Norman Group, MDN, W3C
5. **Project maintainers** - Blog posts by core team members
6. **Conference talks** - From major conferences (React Conf, JSConf, etc.)
7. **Books** - O'Reilly, Manning, A Book Apart (mark as 💰 paid)

**Avoid:**
- Random blog posts from unknown authors
- Outdated content (>3 years for fast-moving tech)
- Content farms, SEO spam
- AI-generated content without verification

## Examples

### Example 1: React Reconciliation

**User:** "How does React's reconciliation algorithm work?"

**Mentor:**
```
That's a deep topic involving React's internals! 

I can:
1. Give you a brief overview here (fiber architecture basics)
2. Generate a /reading-list for deep-diving into reconciliation

Which would you prefer?

User: /reading-list

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Reading List: React Reconciliation & Fiber Architecture
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FOUNDATIONAL (Start here):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. "Reconciliation" - React Official Docs
   https://react.dev/learn/reconciliation
   ⏱ 15 min read
   📊 Difficulty: Beginner
   💡 Why: Official explanation of the diffing algorithm and keys

2. "React Fiber Architecture" by Andrew Clark
   https://github.com/acdlite/react-fiber-architecture
   ⏱ 30 min read  
   📊 Difficulty: Intermediate
   💡 Why: Written by React core team member, explains Fiber from scratch

DEEP DIVE (After foundational):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

3. "Inside Fiber: In-depth Overview" by Maxim Koretskyi
   https://indepth.dev/posts/1008/inside-fiber-in-depth-overview
   ⏱ 45 min read
   📊 Difficulty: Advanced
   💡 Why: Detailed walkthrough of Fiber internals with diagrams and code

4. "React Fiber Deep Dive" by Tyler McGinnis
   https://ui.dev/react-fiber
   ⏱ 25 min read
   📊 Difficulty: Intermediate
   💡 Why: Clear explanation with visual examples and comparisons

VIDEO CONTENT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

5. "A Cartoon Intro to Fiber" by Lin Clark
   https://www.youtube.com/watch?v=ZCuYPiUIONs
   ⏱ 30 min video
   📊 Difficulty: Intermediate
   💡 Why: Visual explanation of scheduling and priority

6. "The Story of Concurrent React" by Andrew Clark
   https://www.youtube.com/watch?v=NZoRlVi3MjQ
   ⏱ 40 min video (React Conf 2019)
   📊 Difficulty: Advanced
   💡 Why: Context for why Fiber was needed, from the architect himself

RELATED CONCEPTS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

7. "Build your own React" by Rodrigo Pombo
   https://pomb.us/build-your-own-react/
   ⏱ 60 min tutorial
   📊 Difficulty: Intermediate
   💡 Why: Hands-on building a mini React to understand internals

Suggested path: 
Read 1 → 2 → Watch 5 → Read 3 → Watch 6 → Try 7

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Brief Overview:

React's reconciliation algorithm determines what needs to change in the 
DOM when your component tree updates. Instead of rebuilding the entire 
DOM, React compares the new virtual DOM with the previous one (diffing) 
and only updates what changed.

The Fiber architecture (introduced in React 16) reimplemented this 
algorithm to support:
- **Incremental rendering** - Split work into chunks
- **Priority scheduling** - Urgent updates (typing) before slow updates
- **Pausable/resumable work** - Browser can handle events between chunks
- **Concurrent features** - Suspense, transitions, etc.

Think of Fiber as a to-do list that React can pause mid-task to handle 
something more important, then resume where it left off.

Want to discuss any of these after reading?
```

### Example 2: CSS Grid vs Flexbox

**User:** "Should I use CSS Grid or Flexbox for my layout?"

**Mentor:**
```
Great architectural question! The answer is: both, for different purposes.

I can:
1. Give you a quick decision guide here (when to use each)
2. Generate a /reading-list for deep-diving into CSS layouts

Which would you prefer?

User: /reading-list

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Reading List: CSS Grid vs Flexbox
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FOUNDATIONAL (Start here):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. "Flexbox" - MDN Web Docs
   https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout
   ⏱ 20 min read
   📊 Difficulty: Beginner
   💡 Why: Comprehensive official documentation with examples

2. "CSS Grid" - MDN Web Docs
   https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout
   ⏱ 20 min read
   📊 Difficulty: Beginner
   💡 Why: Complete guide to Grid layout basics

3. "Does CSS Grid Replace Flexbox?" by Rachel Andrew
   https://rachelandrew.co.uk/archives/2016/03/30/does-css-grid-replace-flexbox/
   ⏱ 10 min read
   📊 Difficulty: Beginner
   💡 Why: Clear explanation of when to use each, from a CSS Working Group member

DEEP DIVE (After foundational):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

4. "A Complete Guide to Flexbox" by CSS-Tricks
   https://css-tricks.com/snippets/css/a-guide-to-flexbox/
   ⏱ 30 min read (reference)
   📊 Difficulty: Intermediate
   💡 Why: Visual reference guide with every property explained

5. "A Complete Guide to CSS Grid" by CSS-Tricks
   https://css-tricks.com/snippets/css/complete-guide-grid/
   ⏱ 40 min read (reference)
   📊 Difficulty: Intermediate
   💡 Why: Comprehensive visual reference for Grid

6. "When to Use Flexbox and When to Use CSS Grid" by Jen Simmons
   https://www.smashingmagazine.com/2018/10/flexbox-use-cases/
   ⏱ 20 min read
   📊 Difficulty: Intermediate
   💡 Why: Real-world examples and decision-making guidance

INTERACTIVE LEARNING:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

7. Flexbox Froggy
   https://flexboxfroggy.com/
   ⏱ 30 min game
   📊 Difficulty: Beginner
   💡 Why: Learn Flexbox by playing a game (very effective!)

8. Grid Garden
   https://cssgridgarden.com/
   ⏱ 30 min game
   📊 Difficulty: Beginner
   💡 Why: Learn Grid by playing a game

VIDEO CONTENT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

9. "Flexbox CSS In 20 Minutes" by Traversy Media
   https://www.youtube.com/watch?v=JJSoEo8JSnc
   ⏱ 20 min video
   📊 Difficulty: Beginner
   💡 Why: Quick practical tutorial with examples

10. "Learn CSS Grid in 20 Minutes" by Web Dev Simplified
    https://www.youtube.com/watch?v=9zBsdzdE4sM
    ⏱ 20 min video
    📊 Difficulty: Beginner
    💡 Why: Fast-paced practical Grid tutorial

Suggested path:
Watch 9 → Play 7 → Watch 10 → Play 8 → Read 3 → Reference 4 & 5 as needed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Quick Decision Guide:

**Use Flexbox when:**
- Laying out items in a single direction (row OR column)
- Content should determine spacing (flex-grow, flex-shrink)
- Navigation bars, button groups, card contents
- You need alignment control in one dimension

**Use Grid when:**
- Creating 2D layouts (rows AND columns together)
- You know the layout structure upfront
- Page layouts, dashboards, galleries
- You need precise control over both dimensions

**Use both:**
- Grid for overall page structure
- Flexbox for components within grid cells
- Most modern websites use both strategically

Want to discuss your specific layout needs?
```

### Example 3: Algorithm Complexity

**User:** "Why is Big O notation important?"

**Mentor:**
```
That's a fundamental CS concept!

I can:
1. Give you a practical explanation here (5 min read)
2. Generate a /reading-list for diving deep into algorithms

Which would you prefer?

User: 2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📚 Reading List: Algorithm Complexity & Big O Notation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FOUNDATIONAL (Start here):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. "Big O Notation" by Interview Cake
   https://www.interviewcake.com/article/javascript/big-o-notation-time-and-space-complexity
   ⏱ 15 min read
   📊 Difficulty: Beginner
   💡 Why: Clear practical explanation with JavaScript examples

2. "Big O Cheat Sheet"
   https://www.bigocheatsheet.com/
   ⏱ 5 min (reference)
   📊 Difficulty: Beginner
   💡 Why: Quick visual reference for common data structures

3. "A Beginner's Guide to Big O Notation" by Rob Bell
   https://rob-bell.net/2009/06/a-beginners-guide-to-big-o-notation/
   ⏱ 10 min read
   📊 Difficulty: Beginner
   💡 Why: Simple explanations with real-world analogies

DEEP DIVE (After foundational):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

4. "Time Complexity Analysis" on Khan Academy
   https://www.khanacademy.org/computing/computer-science/algorithms
   ⏱ 2 hours (course)
   📊 Difficulty: Intermediate
   💡 Why: Comprehensive course with exercises

5. "Practical Big O" by Paul Ford
   https://stackoverflow.blog/2021/04/03/best-practices-for-writing-code-comments/
   ⏱ 20 min read
   📊 Difficulty: Intermediate
   💡 Why: How to apply Big O in real development work

BOOKS: 💰
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

6. "Grokking Algorithms" by Aditya Bhargava
   💰 ~$40 (book)
   ⏱ 6-8 hours
   📊 Difficulty: Beginner-Intermediate
   💡 Why: Visual, fun introduction with tons of diagrams

7. "Introduction to Algorithms" by CLRS
   💰 ~$80 (textbook)
   ⏱ Months (reference)
   📊 Difficulty: Advanced
   💡 Why: The definitive algorithms textbook (very academic)

VIDEO CONTENT:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

8. "Big O Notation in 100 Seconds" by Fireship
   https://www.youtube.com/watch?v=g2o22C3CRfU
   ⏱ 2 min video
   📊 Difficulty: Beginner
   💡 Why: Super quick overview to get the gist

9. "Big O Notation" by freeCodeCamp
   https://www.youtube.com/watch?v=Mo4vesaut8g
   ⏱ 40 min video
   📊 Difficulty: Beginner-Intermediate
   💡 Why: Thorough explanation with code examples

INTERACTIVE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

10. VisuAlgo - Algorithm Visualizations
    https://visualgo.net/en
    ⏱ Variable
    📊 Difficulty: Beginner-Intermediate
    💡 Why: See algorithms in action, understand time complexity visually

Suggested path:
Watch 8 → Read 1 → Reference 2 → Watch 9 → Read 3 → Explore 10

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Practical Summary:

Big O tells you how an algorithm's performance scales as input grows.

**Why it matters in real work:**
- Array.find() is O(n) - slow for large arrays
- Set.has() is O(1) - fast regardless of size
- Nested loops are O(n²) - avoid when possible
- Choosing the right data structure can make your app 100x faster

**Common complexities:**
- O(1): Constant - accessing array index
- O(log n): Logarithmic - binary search
- O(n): Linear - single loop
- O(n log n): Sorting - merge sort, quick sort
- O(n²): Quadratic - nested loops
- O(2^n): Exponential - recursive fibonacci (bad!)

In practice: If you're looping through loops, your users will notice.

Want to analyze a specific algorithm you're working with?
```

## Important Guidelines

**Source Evaluation:**
- ✅ Check publish date (prefer recent for fast-moving tech)
- ✅ Verify author credentials (maintainer, educator, expert)
- ✅ Prefer free resources (mark paid with 💰)
- ✅ Include mix of text, video, interactive
- ✅ Order by difficulty progression

**Format Rules:**
- Always include suggested learning path
- Always provide brief overview after list
- Always mark paid resources with 💰
- Always estimate time commitment
- Always explain WHY each resource is valuable

**After Providing List:**
- Offer to discuss after they've read
- Return to original question/task
- Don't make user feel obligated to read everything
- Be available for follow-up questions

## Template for Quick Generation

```
📚 Reading List: [TOPIC]

FOUNDATIONAL:
1. [Official docs or authoritative beginner resource]
2. [Well-known educator's tutorial]
3. [Practical guide or comparison]

DEEP DIVE:
4. [In-depth article or course]
5. [Advanced concepts or edge cases]

[OPTIONAL SECTIONS AS NEEDED:]
VIDEO CONTENT:
INTERACTIVE:
TOOLS:
BOOKS: 💰

Suggested path: [numbers in recommended order]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[3-4 paragraph overview of the concept]

[Invitation to continue discussion]
```
