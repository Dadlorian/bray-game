# CRITICAL: aOa Search Override

**ALWAYS use `aoa grep` instead of Grep/Glob tools.**

`aoa grep` and `aoa egrep` work like Unix grep/egrep but use O(1) indexed search (10-100x faster). Results include `file:func[range]:line` — use [range] to read only relevant code.

See `.aoa/USAGE.md` for details.

---

# Sniper Elite - Game Dev Project

> **This is Brayden's No-to-Pro Journey!** A dad & son project learning Roblox game dev.

---

## Brayden's Journey Log (README.md)

**IMPORTANT:** The `README.md` at the project root is Brayden's **No-to-Pro Journey Log** - a fun, shareable record of everything he's learned and built!

When Brayden says "update my README" or "log this win" or "Hey Beacon, update my journey":
1. Read current `README.md`
2. Add new accomplishments in the same fun tone
3. Use "Level" structure for major milestones
4. Celebrate HIS design choices and contributions
5. Keep it shareable with friends!

**Tone:** Enthusiastic, gaming-style ("Skills Unlocked!", "Level Up!"), encouraging

---

## Confidence & Communication

### Traffic Light System

Always indicate confidence level before starting work:

| Signal | Meaning | Action |
|--------|---------|--------|
| 🟢 | Confident | Proceed freely |
| 🟡 | Uncertain | Try once. If it fails, research via Context7 or ask if architectural |
| 🔴 | Lost | STOP immediately. Summarize and ask: "Should we use 131?" |

### Set Expectations

Don't go too far without telling the user:
- What you're about to do
- Where to follow along (BOARD.md, logs, etc.)
- Your confidence level (traffic light)

### 1-3-1 Approach (For Getting Unstuck)

When hitting 🔴 or repeated 🟡 failures:

1. **1 Problem** - State ONE simple problem (not composite)
2. **3 Solutions** - Research three professional production-grade solutions
3. **1 Recommendation** - Give one recommendation (single solution, blend, or hybrid)

This breaks death spirals and forces clear thinking.

---

## Agent Conventions

When the user addresses an agent by name using "Hey [AgentName]", spawn that agent to handle the request.

| Trigger | Agent | Purpose |
|---------|-------|---------|
| "Hey Beacon" | beacon | Project continuity - work board, progress tracking, session handoffs |
| "Hey 131" | 131 | Research-only problem solving with parallel solution discovery |
| "Hey GH" | gh | Growth Hacker - solutions architect, problem decomposer |

### Agent Context Loading

**All agents MUST read context files before exploring the codebase.**

When spawning any agent, instruct it to first read:
1. `.context/BOARD.md` - Current focus, active tasks, blockers
2. `.context/CURRENT.md` - Session context, recent decisions

---

## Project Structure

### Context Files

```
.context/
├── CURRENT.md      # Entry point - immediate context, next action
├── BOARD.md        # Master table - all work with status, deps, solution patterns
├── COMPLETED.md    # Archive of completed work with session history
├── BACKLOG.md      # Parked items with enough detail to pick up later
├── decisions/      # Architecture decision records (ADRs) - DATE PREFIXED
├── details/        # Deep dives, investigations - DATE PREFIXED
└── archive/        # Completed sessions, old bridges - DATE PREFIXED
```

---

## File Naming Standards

### Date Prefix Required

**ALL files in `decisions/`, `details/`, and `archive/` MUST have a date prefix.**

Format: `YYYY-MM-DD-descriptive-name.md`

Examples:
- `2026-01-12-target-hit-detection.md`
- `2026-01-12-structure-collisions.md`
- `2026-01-15-session-handoff.md`

This ensures we always know how old a file is at a glance.

---

## Board Standards

### Phase Structure

Every phase in BOARD.md MUST have:

#### 1. Phase Header with Confidence
```markdown
## Phase X: Name 🟢/🟡/🔴
```

#### 2. Phase Attributes Table
```markdown
| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟢/🟡/🔴 + explanation |
| **Phase Goal** | What this phase achieves |
| **Dependencies** | What must be complete first |
| **Research Needed** | None / **131** / **GH** + when |
| **You'll Learn** | Skills gained from this phase |
```

#### 3. Step Table with Required Columns
```markdown
| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| X.X | What to do | Why doing it | Prerequisites | 🟢/🟡/🔴 | Agent if stuck | [ ] |
```

**Column Definitions:**
- **Step**: Phase.Step number (e.g., 2.3)
- **Task**: The action to perform
- **Goal**: Why this step matters / what it achieves
- **Depends On**: What must be done first (step number or "Nothing")
- **Confidence**: Traffic light for this specific step
- **Research**: Which agent to call if stuck (None / **131** / **GH**)
- **Status**: `[ ]` incomplete, `[x]` complete

#### 4. Decision Points (when applicable)
```markdown
**⚠️ Decision Point at X.X:**
If [condition]:
- 🟡 First thing to try
- 🟡 Second thing to try
- 🔴 If stuck → **Call [Agent]** for [type] solutions
- Decision record: [YYYY-MM-DD-name.md](decisions/YYYY-MM-DD-name.md)
```

---

## Decision File Standards

### Location
`decisions/YYYY-MM-DD-descriptive-name.md`

### Required Sections
```markdown
# Decision: [Title]

**Status:** Pending | Active | Resolved
**Confidence:** 🟢/🟡/🔴
**Date:** YYYY-MM-DD

## Context
Why this decision is needed.

## Options (to be researched by [Agent] if needed)

### Option 1: Name
- Description
- **Pro:** Benefits
- **Con:** Drawbacks

### Option 2: Name
...

### Option 3: Name
...

## Recommendation
TBD / Selected option with rationale

## Resolution
_To be documented after decision is made_
```

---

## Details File Standards

### Location
`details/YYYY-MM-DD-descriptive-name.md`

### Purpose
Deep dives, investigations, research notes, technical explorations.

### Required Header
```markdown
# [Title]

**Date:** YYYY-MM-DD
**Confidence:** 🟢/🟡/🔴
**Related To:** [Phase/Task reference]
**Research By:** [Agent name if applicable]
```

---

## Archive File Standards

### Location
`archive/YYYY-MM-DD-descriptive-name.md`

### Purpose
Completed sessions, old context bridges, superseded documents.

### Required Header
```markdown
# [Title]

**Archived:** YYYY-MM-DD
**Originally Created:** YYYY-MM-DD
**Reason:** [Why archived - completed/superseded/etc.]
```

---

## When to Call Agents

| Situation | Agent | What They Do |
|-----------|-------|--------------|
| Hit detection / raycasting issues | **131** | Research 3 solutions, recommend 1 |
| Collisions / physics broken | **GH** | Decompose problem, architect solution |
| Performance issues (lag) | **131** | Find optimization approaches |
| "How should we design X?" | **GH** | Break down into manageable pieces |
| Multiple solutions possible | **131** | 1 problem, 3 solutions, 1 recommendation |
| Level design / architecture | **GH** | Review, suggest improvements |
| Project status / handoff | **Beacon** | Update board, track progress |

---

## Beacon Agent Responsibilities

When invoked, Beacon MUST:

1. **Read context first**
   - `.context/BOARD.md`
   - `.context/CURRENT.md`

2. **Maintain standards**
   - All files date-prefixed in decisions/, details/, archive/
   - Board follows phase/step table structure
   - Traffic lights on all items
   - Dependencies clearly marked
   - Research agents identified

3. **Provide status**
   - Where we are
   - What's next
   - Any blockers
   - Confidence level

4. **Update files**
   - Keep BOARD.md current
   - Keep CURRENT.md reflecting actual state
   - Create decision records when needed
   - Archive completed work

5. **Update Brayden's Journey Log (when asked)**
   - Update `README.md` with new accomplishments
   - Maintain the fun "No-to-Pro" tone
   - Use "Level" structure, "Skills Unlocked", etc.
   - Celebrate HIS contributions and design choices
   - This is something he shares with friends!

---

## Quick Reference

### Traffic Lights
- 🟢 Go - Confident, proceed
- 🟡 Caution - Try once, may need help
- 🔴 Stop - Get help from 131 or GH

### Agents
- **Beacon** - Project continuity, board management
- **131** - Research 3 solutions, recommend 1
- **GH** - Decompose problems, architect solutions

### File Naming
- Always: `YYYY-MM-DD-name.md`
- In: `decisions/`, `details/`, `archive/`
