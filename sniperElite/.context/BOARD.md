# Sniper Elite - Development Board

## Traffic Light Legend
| Signal | Meaning | Action |
|--------|---------|--------|
| 🟢 | Confident | Proceed freely |
| 🟡 | Uncertain | Try once. If fails, research or ask |
| 🔴 | Lost | STOP. Use 131 or GH for help |

---

## Current Status: Phase 1 Ready
**Game State:** Working mini sniper game with basic Part targets
**Next Step:** Learn the Toolbox to get professional 3D models

---

## Phase 1: Master the Toolbox 🟢

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟢 High - Standard Roblox Studio workflow |
| **Phase Goal** | Learn how to find, add, and manage 3D models from Roblox's Creator Store |
| **Dependencies** | None - can start immediately |
| **Research Needed** | None |
| **You'll Learn** | Browsing, filtering, adding, and managing models |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| 1.1 | Open Toolbox (View > Toolbox) | Access the model library | Nothing | 🟢 | None | [ ] |
| 1.2 | Search for "target" or "bullseye" | Learn to search | 1.1 | 🟢 | None | [ ] |
| 1.3 | Filter by "Endorsed Models" | Find safe, verified models | 1.2 | 🟢 | None | [ ] |
| 1.4 | Click model to add to game | Insert model into Workspace | 1.3 | 🟢 | None | [ ] |
| 1.5 | Move/rotate with Studio tools | Learn positioning controls | 1.4 | 🟢 | None | [ ] |
| 1.6 | Delete it (select + Delete) | Learn to remove objects | 1.5 | 🟢 | None | [ ] |

**Escalation:** None expected - if Toolbox won't open, check Studio installation

---

## Phase 2: Upgrade the Targets 🟡

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟡 Medium - Hit detection may need adjustment |
| **Phase Goal** | Replace basic red Part targets with professional 3D shooting targets that work with existing code |
| **Dependencies** | Phase 1 complete |
| **Research Needed** | 🟡 Possibly **131** if hit detection breaks |
| **You'll Learn** | Asset replacement, testing compatibility, debugging |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| 2.1 | Search for "shooting target" | Find professional target models | Phase 1 | 🟢 | None | [ ] |
| 2.2 | Add ONE target to test | Test single model first | 2.1 | 🟢 | None | [ ] |
| 2.3 | Play test - shoot the new target | Verify raycast hits new model | 2.2 | 🟡 | **131** if fails | [ ] |
| 2.4 | If works, add more targets | Scale up after confirming | 2.3 | 🟢 | None | [ ] |
| 2.5 | Position at interesting distances | Create gameplay variety | 2.4 | 🟢 | None | [ ] |
| 2.6 | Remove old Part targets | Clean up placeholder assets | 2.5 | 🟢 | None | [ ] |

**⚠️ Decision Point at 2.3:**
If fancy targets don't register hits:
- 🟡 Try a simpler model (fewer parts)
- 🟡 Check if model has CanCollide = true
- 🔴 If stuck → **Call 131** for hit detection solutions
- Decision record: [2026-01-12-target-hit-detection.md](decisions/2026-01-12-target-hit-detection.md)

---

## Phase 3: Natural Environment 🟢

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟢 High - Decorative, no code changes needed |
| **Phase Goal** | Add trees, rocks, and natural elements to create an immersive outdoor sniper environment |
| **Dependencies** | Phase 1 complete (Phase 2 optional) |
| **Research Needed** | None |
| **You'll Learn** | Environment composition, performance considerations ("low poly") |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| 3.1 | Search "low poly tree" | Find performance-friendly trees | Phase 1 | 🟢 | None | [ ] |
| 3.2 | Add 3-5 trees, spread around | Create natural landscape | 3.1 | 🟢 | None | [ ] |
| 3.3 | Search "rock" or "boulder" | Find natural terrain objects | 3.2 | 🟢 | None | [ ] |
| 3.4 | Add rocks for cover/decoration | Add visual interest + cover | 3.3 | 🟢 | None | [ ] |
| 3.5 | Play test - walk around | Verify environment feels real | 3.4 | 🟢 | None | [ ] |
| 3.6 | Adjust for sniping sightlines | Balance visibility vs cover | 3.5 | 🟡 | **GH** for level design tips | [ ] |

**Search Terms:**
- "low poly tree" - fast, simple
- "realistic rock" - natural boulders
- "nature pack" - bundled items

---

## Phase 4: Structures & Buildings 🟡

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟡 Medium - Collisions and climbing may need work |
| **Phase Goal** | Add buildings, sniper towers, and tactical cover to create interesting gameplay spaces |
| **Dependencies** | Phase 1 complete |
| **Research Needed** | 🟡 Possibly **GH** for collision/physics issues |
| **You'll Learn** | Level design basics, collision handling, gameplay spaces |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| 4.1 | Search "sniper tower" or "watchtower" | Find elevated sniper position | Phase 1 | 🟢 | None | [ ] |
| 4.2 | Add tower as sniper nest | Create main player vantage point | 4.1 | 🟡 | **GH** if can't climb | [ ] |
| 4.3 | Search "house" or "low poly building" | Find structures for layout | 4.2 | 🟢 | None | [ ] |
| 4.4 | Add 2-3 buildings for layout | Create village/compound feel | 4.3 | 🟢 | None | [ ] |
| 4.5 | Search "wall" "barrier" "sandbags" | Find tactical cover objects | 4.4 | 🟢 | None | [ ] |
| 4.6 | Add cover objects | Give targets places to hide | 4.5 | 🟢 | None | [ ] |
| 4.7 | Play test full layout | Verify fun factor | 4.6 | 🟡 | **GH** for design feedback | [ ] |

**⚠️ Decision Point at 4.2:**
If player can't climb tower or falls through:
- 🟡 Check CanCollide on all parts
- 🟡 Try different tower model
- 🔴 If complex → **Call GH** for collision/climbing solutions
- Decision record: [2026-01-12-structure-collisions.md](decisions/2026-01-12-structure-collisions.md)

---

## Phase 5: Polish & Game Feel 🟢

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟢 High - Settings tweaks, no complex code |
| **Phase Goal** | Add atmosphere, audio, and finishing touches to make the game feel professional |
| **Dependencies** | Phases 1-4 substantially complete |
| **Research Needed** | 🟡 Possibly **131** for audio scripting |
| **You'll Learn** | Atmosphere, audio, player experience, game feel |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| 5.1 | Adjust Lighting properties | Set mood/atmosphere | Phases 1-4 | 🟢 | None | [ ] |
| 5.2 | Add skybox from Toolbox | Create immersive sky | 5.1 | 🟢 | None | [ ] |
| 5.3 | Add ambient sounds | Create audio atmosphere | 5.2 | 🟡 | **131** if scripting needed | [ ] |
| 5.4 | Set spawn point location | Control player start position | 5.3 | 🟢 | None | [ ] |
| 5.5 | Full game test | Verify complete experience | 5.4 | 🟢 | None | [ ] |

**Note on 5.3:** Sound setup might need script work
- 🟡 If sounds don't play → check SoundService settings
- 🔴 If complex audio needed → **Call 131** for audio solutions

---

## Dependency Map

```
Phase 1 (Toolbox) ──┬──> Phase 2 (Targets)
                    │
                    ├──> Phase 3 (Environment)
                    │
                    └──> Phase 4 (Structures)
                              │
                              v
                         Phase 5 (Polish)
```

**Key:** Phase 1 unlocks everything. Phases 2-4 can be done in any order. Phase 5 is the finale.

---

## When to Call for Help

| Situation | Agent | Trigger | What They Do |
|-----------|-------|---------|--------------|
| Hit detection not working | **131** | 🔴 after 2 attempts | Research 3 solutions, recommend 1 |
| Collisions/physics broken | **GH** | 🔴 after 2 attempts | Decompose problem, architect solution |
| Performance issues (lag) | **131** | 🟡 research needed | Find optimization approaches |
| "How should we design X?" | **GH** | Architecture decision | Break down into manageable pieces |
| Multiple solutions possible | **131** | Need options | 1 problem, 3 solutions, 1 recommendation |
| Level design feedback | **GH** | 🟡 want expert input | Review layout, suggest improvements |

---

## Resources

### Where to Get Models

| Source | Type | Confidence | Research If Issues |
|--------|------|------------|-------------------|
| [Creator Store](https://create.roblox.com/store/models) | Built-in | 🟢 | None |
| Endorsed Models (filter) | Verified safe | 🟢 | None |
| [Buzzy.gg](https://buzzy.gg/toolbox/models/) | External verified | 🟡 | **131** for vetting |
| [Meshy AI](https://www.meshy.ai/tags/roblox) | AI Generated | 🟡 | **131** for import help |

### Importing External Models
1. Download .obj or .fbx file
2. Studio: View > Asset Manager
3. Right-click > Bulk Import
4. Select file

**Confidence:** 🟡 - May need troubleshooting
**Research:** **131** if import fails

---

## Decisions Log

| Decision | Status | Date | Link |
|----------|--------|------|------|
| Target hit detection approach | Pending | 2026-01-12 | [2026-01-12-target-hit-detection.md](decisions/2026-01-12-target-hit-detection.md) |
| Structure collision handling | Pending | 2026-01-12 | [2026-01-12-structure-collisions.md](decisions/2026-01-12-structure-collisions.md) |

---

## Completed

- [x] Environment setup (aliases working)
- [x] Rojo workflow connected
- [x] Basic sniper game functional
- [x] Targets shootable (Part-based)
- [x] Development board created with phases

---

## Notes

**Dad & Son Learning Project**
- One phase at a time
- Test after EVERY step
- 🟢 = go for it, 🟡 = be ready to troubleshoot, 🔴 = ask for help
- If something breaks, undo and try again
- Have fun!
