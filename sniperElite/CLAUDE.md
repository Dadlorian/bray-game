# Sniper Elite - Game Dev Project

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
├── decisions/      # Architecture decision records (ADRs)
├── details/        # Deep dives, investigations (date-prefixed)
└── archive/        # Completed sessions, old bridges (date-prefixed)
```

