# Sniper Elite - Development Board

## Traffic Light Legend
| Signal | Meaning | Action |
|--------|---------|--------|
| 🟢 | Confident | Proceed freely |
| 🟡 | Uncertain | Try once. If fails, research or ask |
| 🔴 | Lost | STOP. Use 131 or GH for help |

---

## Current Status: AUDIT COMPLETE - PATHS UNLOCKED! 🟢

**Game State:** Fully functional zombie defense with Great Wall, bullet cam, headshots, and more!
**Brayden's Level:** 8 - Level Design & Environmental Storytelling
**Next:** Choose an Improvement Path below!

---

## Codebase Audit Summary

### What Brayden Built (Amazing Work!)

| File | Lines | What It Does |
|------|-------|--------------|
| `init.server.luau` | 1,043 | Great Wall, zombies, damage system, AI patrol |
| `SniperRifle.client.luau` | 1,334 | Weapon, scope, bullet cam, UI, effects |
| `init.client.luau` | 1 | Hello world (starter file) |
| `Hello.luau` | 3 | Unused module |

### Skills Already Unlocked
- Lua basics, Raycasting, Camera manipulation
- UI design, 3D modeling with code
- TweenService, Lerp, Visual effects
- NPC creation, AI pathfinding
- Damage systems, Sound design
- Level design, Environmental storytelling

---

## How To Use This Board

**Pick a Path!** Each path teaches new skills while making the game better.

| Path | What You'll Build | What You'll Learn | Difficulty |
|------|-------------------|-------------------|------------|
| **A** | Organized code | Modules & require() | 🟡 Medium |
| **B** | Wave system | Game loops & state | 🟢 Easier |
| **C** | Zombie types | Tables & OOP | 🟢 Easier |
| **D** | Player danger | Combat systems | ✅ DONE! |
| **E** | Better sounds | Audio & atmosphere | ✅ DONE! |
| **F** | Faster game | Performance & pooling | 🟡 Medium |
| **G** | Save scores | DataStore | 🔴 Harder |
| **H** | Fix bugs | Debugging skills | 🟢 Easier |

**Recommendation:** Start with **Path B** (Waves) or **Path C** (Zombie Types) - they're fun and teach important concepts!

---

## Path A: Code Organization 🟡

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟡 Medium - New concept (modules) |
| **Goal** | Split 2,000+ lines into organized, reusable modules |
| **Dependencies** | None |
| **You'll Learn** | ModuleScripts, require(), code organization |
| **Why It Matters** | Pro developers NEVER put everything in one file! |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| A.1 | Create `shared/Config.luau` | Put all settings in one place | Nothing | 🟢 | None | [ ] |
| A.2 | Move WALL_HEIGHT, ZOMBIE_SPEED, etc. to Config | Learn to use shared modules | A.1 | 🟢 | None | [ ] |
| A.3 | Create `server/Map.luau` module | Separate map building code | A.2 | 🟡 | None | [ ] |
| A.4 | Create `server/ZombieSystem.luau` module | Separate zombie code | A.3 | 🟡 | None | [ ] |
| A.5 | Create `client/WeaponEffects.luau` module | Separate effects code | A.2 | 🟡 | None | [ ] |
| A.6 | Create `client/UI.luau` module | Separate UI code | A.5 | 🟡 | None | [ ] |

**New Concept - Modules:**
```lua
-- In shared/Config.luau
local Config = {
    WALL_HEIGHT = 80,
    ZOMBIE_SPEED = 6,
    HEADSHOT_DAMAGE = 100,
}
return Config

-- In another file
local Config = require(ReplicatedStorage.shared.Config)
print(Config.WALL_HEIGHT)  -- 80
```

---

## Path B: Wave System 🟢

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟢 High - Uses skills you already have |
| **Goal** | Zombies spawn in waves that get harder |
| **Dependencies** | None |
| **You'll Learn** | Game state, loops, difficulty scaling |
| **Why It Matters** | EVERY survival game has waves! |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| B.1 | Add `currentWave` variable on server | Track what wave we're on | Nothing | 🟢 | None | [ ] |
| B.2 | Create `WaveDisplay` UI on client | Show "WAVE 1" at top of screen | Nothing | 🟢 | None | [ ] |
| B.3 | Change zombie spawning to spawn X at once | Wave = batch of zombies | B.1 | 🟢 | None | [ ] |
| B.4 | Track when all zombies in wave are dead | Know when to start next wave | B.3 | 🟡 | None | [ ] |
| B.5 | Show "WAVE COMPLETE!" popup | Celebrate between waves | B.4 | 🟢 | None | [ ] |
| B.6 | Wait 5 seconds, then start next wave | Give player a breather | B.5 | 🟢 | None | [ ] |
| B.7 | Each wave has more zombies | Wave 1 = 5, Wave 2 = 8, etc. | B.6 | 🟢 | None | [ ] |
| B.8 | Each wave zombies are faster | Difficulty scaling | B.7 | 🟡 | None | [ ] |

**Wave Formula Ideas:**
```lua
local function getZombiesForWave(wave)
    return 3 + (wave * 2)  -- Wave 1 = 5, Wave 2 = 7, Wave 3 = 9...
end

local function getZombieSpeed(wave)
    return 6 + (wave * 0.5)  -- Gets 0.5 faster each wave
end
```

---

## Path C: Zombie Types 🟢

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟢 High - Just tables and colors |
| **Goal** | Multiple zombie types with different abilities |
| **Dependencies** | None |
| **You'll Learn** | Tables as data, variety systems |
| **Why It Matters** | Variety keeps games interesting! |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| C.1 | Create `ZOMBIE_TYPES` table | Define all zombie varieties | Nothing | 🟢 | None | [ ] |
| C.2 | Add "Walker" type (current zombie) | First entry in table | C.1 | 🟢 | None | [ ] |
| C.3 | Add "Runner" type (fast but weak) | Speed 12, Health 50 | C.2 | 🟢 | None | [ ] |
| C.4 | Add "Tank" type (slow but tough) | Speed 3, Health 300 | C.3 | 🟢 | None | [ ] |
| C.5 | Update `createZombieCharacter()` to accept type | Use type's settings | C.4 | 🟡 | None | [ ] |
| C.6 | Give each type different colors | Runners = pale, Tanks = dark | C.5 | 🟢 | None | [ ] |
| C.7 | Random type selection when spawning | Variety in each wave | C.6 | 🟢 | None | [ ] |
| C.8 | (Optional) Add "Crawler" - low and fast | Harder to headshot! | C.7 | 🟡 | **131** | [ ] |

**Zombie Types Table:**
```lua
local ZOMBIE_TYPES = {
    Walker = {
        speed = 6,
        health = 100,
        skinColor = Color3.fromRGB(85, 120, 85),
        points = 100,
    },
    Runner = {
        speed = 12,
        health = 50,
        skinColor = Color3.fromRGB(150, 170, 150),  -- Pale
        points = 150,  -- Harder to hit!
    },
    Tank = {
        speed = 3,
        health = 300,
        skinColor = Color3.fromRGB(50, 70, 50),  -- Dark
        points = 300,  -- Lots of points!
    },
}
```

---

## Path D: Player Danger ✅ COMPLETE!

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟢 Done! |
| **Goal** | Zombies can hurt you, game can end |
| **Dependencies** | None |
| **You Learned** | Combat systems, win/lose conditions, RemoteEvents |
| **Why It Matters** | No danger = no tension! |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| D.1 | Add player health variable | Track player's HP | Nothing | 🟢 | None | [x] |
| D.2 | Create player health bar UI | Show HP at bottom of screen | D.1 | 🟢 | None | [x] |
| D.3 | Zombies check distance to wall | Know when they "reach" you | D.1 | 🟢 | None | [x] |
| D.4 | When zombie reaches wall, deal damage | Player takes 10 damage | D.3 | 🟢 | None | [x] |
| D.5 | Flash screen red when hit | Feedback that you're hurt | D.4 | 🟢 | None | [x] |
| D.6 | When HP = 0, show "GAME OVER" | End state | D.5 | 🟢 | None | [x] |
| D.7 | Add "Play Again" button | Restart the game | D.6 | 🟢 | None | [x] |
| D.8 | Show final score on game over | How well did you do? | D.7 | 🟢 | None | [x] |

**Decision Made:** Used Z position check (simple approach) - zombie Z < wall threshold = breach!

---

## Path E: Audio & Atmosphere ✅ COMPLETE!

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟢 Done! |
| **Goal** | Game SOUNDS scary and intense |
| **Dependencies** | None |
| **You Learned** | SoundService, spatial audio, dynamic music, announcer systems |
| **Why It Matters** | Sound is 50% of the experience! |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| E.1 | Find ambient forest sounds | Wind, birds, rustling | Nothing | 🟢 | None | [x] |
| E.2 | Add looping forest ambient | Background atmosphere | E.1 | 🟢 | None | [x] |
| E.3 | Find distant zombie moans | Creepy background noise | E.1 | 🟢 | None | [x] |
| E.4 | Zombies moan randomly while walking | More scary! | E.3 | 🟢 | None | [x] |
| E.5 | Add tense background music | Low, building tension | E.2 | 🟢 | None | [x] |
| E.6 | Music gets more intense at low health | Dynamic audio | E.5 | 🟢 | None | [x] |
| E.7 | Add "Double Kill!" announcer | Kill 2 quickly | Nothing | 🟢 | None | [x] |
| E.8 | Add "Triple Kill!" and "UNSTOPPABLE!" | Epic multi-kills | E.7 | 🟢 | None | [x] |

**BONUS: Also fixed Japanese headshot voice → Now says "HEADSHOT!" in English!**

---

## Path F: Performance 🟡

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟡 Medium - Optimization concepts |
| **Goal** | Game runs smoothly even with lots of zombies |
| **Dependencies** | None |
| **You'll Learn** | Cloning, object pooling, efficient code |
| **Why It Matters** | Laggy games aren't fun! |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| F.1 | Create ONE tree template | Reference object to clone | Nothing | 🟢 | None | [ ] |
| F.2 | Use `Clone()` instead of `Instance.new()` for trees | 10x faster! | F.1 | 🟢 | None | [ ] |
| F.3 | Create damage number pool | Reuse objects instead of creating | Nothing | 🟡 | None | [ ] |
| F.4 | Return damage numbers to pool when done | Object pooling pattern | F.3 | 🟡 | None | [ ] |
| F.5 | Only update health bar when health changes | Not every frame | Nothing | 🟢 | None | [ ] |
| F.6 | Profile with MicroProfiler | Learn to find lag | F.5 | 🟡 | **131** | [ ] |

**Clone vs Instance.new:**
```lua
-- SLOW: Creating from scratch every time
for i = 1, 120 do
    local trunk = Instance.new("Part")
    trunk.Size = Vector3.new(3, 20, 3)
    -- ... lots of properties
end

-- FAST: Clone a template
local treeTemplate = createOneTree()  -- Make once
for i = 1, 120 do
    local tree = treeTemplate:Clone()  -- Super fast!
    tree.Position = Vector3.new(...)
    tree.Parent = workspace
end
```

---

## Path G: Save Scores (DataStore) 🔴

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🔴 Hard - New complex concept |
| **Goal** | High scores persist between play sessions |
| **Dependencies** | Path B recommended first |
| **Research Needed** | **131** for DataStore patterns |
| **You'll Learn** | DataStoreService, async/await, data persistence |
| **Why It Matters** | Players want their progress saved! |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| G.1 | Research DataStore basics | Understand the concept | Nothing | 🔴 | **131** | [ ] |
| G.2 | Create DataStore for high scores | Set up storage | G.1 | 🔴 | **131** | [ ] |
| G.3 | Save high score when game ends | Write to DataStore | G.2, Path D | 🔴 | None | [ ] |
| G.4 | Load high score when player joins | Read from DataStore | G.3 | 🔴 | None | [ ] |
| G.5 | Show "NEW HIGH SCORE!" popup | Celebrate achievement | G.4 | 🟢 | None | [ ] |
| G.6 | Create leaderboard UI | Show top scores | G.5 | 🟡 | None | [ ] |

**⚠️ Warning:** DataStore only works in published Roblox games, not in Studio testing!

---

## Path H: Bug Fixes 🟢

| Attribute | Value |
|-----------|-------|
| **Confidence** | 🟢 High - Small targeted fixes |
| **Goal** | Polish existing features |
| **Dependencies** | None |
| **You'll Learn** | Debugging, edge cases, code review |
| **Why It Matters** | Bugs make games feel unfinished |

| Step | Task | Goal | Depends On | Confidence | Research | Status |
|------|------|------|------------|------------|----------|--------|
| H.1 | Kill counter only increments on death | Not on every hit | Nothing | 🟢 | None | [ ] |
| H.2 | Unfreeze zombie parts after bullet cam | Clean up frozen targets | Nothing | 🟡 | None | [ ] |
| H.3 | Prevent shooting during bullet cam cooldown | No spam shots | Nothing | 🟢 | None | [ ] |
| H.4 | Fix damage info when zombie already dead | Edge case handling | Nothing | 🟡 | None | [ ] |
| H.5 | Add error handling to pathfinding | Graceful fallback | Nothing | 🟢 | None | [ ] |

**Bug H.1 Explanation:**
Currently in `SniperRifle.client.luau`, `updateKillCounter()` is called on every hit. Should only be called when zombie actually dies (when `damageInfo.killed == true`).

---

## Dependency Map

```
No Dependencies (Start Anywhere!)
├── Path B: Waves ────────────┐
├── Path C: Zombie Types      │
├── Path E: Audio             │
├── Path F: Performance       │
└── Path H: Bug Fixes         │
                              │
Builds On Other Paths         │
├── Path A: Code Org          │ (can do anytime, but easier after understanding code)
├── Path D: Player Danger ────┤ (better after Waves)
└── Path G: DataStore ────────┘ (needs Game Over from Path D)
```

---

## Quick Reference

### Recommended First Paths
1. **Path B: Waves** - Makes the game feel complete
2. **Path C: Zombie Types** - Easy wins, lots of variety
3. **Path E: Audio** - Low effort, high impact

### Files You'll Edit
| Path | Files |
|------|-------|
| A | New files + existing |
| B | `init.server.luau` + new UI |
| C | `init.server.luau` |
| D | Both server + client |
| E | Both server + client |
| F | `init.server.luau` |
| G | `init.server.luau` + new UI |
| H | `SniperRifle.client.luau` mostly |

### When to Call Agents

| Situation | Agent | What They Do |
|-----------|-------|--------------|
| "How do I structure modules?" | **131** | Research 3 patterns, recommend 1 |
| "My DataStore isn't working" | **131** | Debug with 3 solutions |
| "How should wave difficulty scale?" | **GH** | Game design advice |
| "Game feels laggy" | **131** | Performance investigation |
| "Need board update" | **Beacon** | Update this file |

---

## Completed Work Archive

### Session 2026-01-13 (All Day) - THE BIG BUILD

**Morning:**
- Scope sway + breathing system
- Visible sniper rifle model
- Bullet tracer + muzzle flash
- Screen shake, points system
- Brayden's custom bullet cam

**Afternoon:**
- Bullet cam improvements (timing, zoom, freeze)
- Humanoid NPCs replacing square targets
- Damage system (body parts, headshots)
- Floating damage numbers
- Health bars
- ZOMBIES! (green skin, scary faces, shambling)

**Evening:**
- Great Wall redesign (80 studs tall!)
- Destroyed towers (environmental storytelling)
- Sniper tower with roof + wooden ledge
- "HEADSHOT!" announcer voice
- README updated to Level 8

---

## Notes

**Brayden's Code Stats:**
- Total lines written: ~2,400
- Features implemented: 30+
- Skills unlocked: 15+

**Dad & Son Learning Project**
- Pick ONE path at a time
- Complete all steps before switching
- Test after EVERY step
- If stuck for 10+ minutes → call an agent
- HAVE FUN!
