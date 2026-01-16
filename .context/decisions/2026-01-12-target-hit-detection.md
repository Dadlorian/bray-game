# Decision: Target Hit Detection Approach

**Status:** Pending
**Confidence:** 🟡
**Date:** 2026-01-12

## Context

When replacing basic Part targets with 3D models from the Toolbox, the existing raycast hit detection may not work because:
- Models may have multiple parts (raycast might hit wrong part)
- Model parts might have CanCollide = false
- Model hierarchy might not match what the script expects

**Related To:** Phase 2, Step 2.3
**Research By:** **131** (if needed)

## Options (to be researched by 131 if needed)

### Option 1: Simple Part Check
Check if hit part is descendant of Targets folder.
- **Pro:** Simple, works with any model
- **Con:** May need folder reorganization

### Option 2: CollectionService Tags
Tag all target models with "Target" tag, check tag on raycast hit.
- **Pro:** Clean, flexible, Roblox-standard approach
- **Con:** Requires learning CollectionService

### Option 3: Name-based Detection
Check if hit part or ancestor contains "Target" in name.
- **Pro:** Very simple to implement
- **Con:** Relies on naming convention, fragile

## Recommendation

TBD - will be filled when issue is encountered

## Resolution

_To be documented after decision is made_
