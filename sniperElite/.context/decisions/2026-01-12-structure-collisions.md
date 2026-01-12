# Decision: Structure Collision Handling

**Status:** Pending
**Confidence:** 🟡
**Date:** 2026-01-12

## Context

When adding buildings, towers, and structures from Toolbox, players may:
- Fall through floors/stairs
- Get stuck in walls
- Be unable to climb ladders/stairs
- Clip through objects

**Related To:** Phase 4, Step 4.2
**Research By:** **GH** (if needed)

## Options (to be researched by GH if needed)

### Option 1: CanCollide Audit
Check all parts in model have CanCollide = true. Use Studio's property window to bulk-edit.
- **Pro:** Quick fix, no code needed
- **Con:** May affect performance with many parts

### Option 2: Collision Groups
Set up collision groups for player vs structure.
- **Pro:** Fine-grained control
- **Con:** More complex setup, requires scripting

### Option 3: Invisible Collision Parts
Add simple invisible parts for collision. Keep visual model separate from physics.
- **Pro:** Best performance, clean collisions
- **Con:** More work to set up manually

### Option 4: Find Better Model
Search for a different model that works out of the box.
- **Pro:** No code/config changes needed
- **Con:** May not find exactly what you want

## Recommendation

TBD - will be filled when issue is encountered

## Resolution

_To be documented after decision is made_
