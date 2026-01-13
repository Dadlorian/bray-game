# Sniper Elite - Brayden's No-to-Pro Journey

> A dad & son project where I'm learning to code games in Roblox from scratch!

---

## Who Am I?

**Name:** Brayden
**Started:** January 2026
**Goal:** Go from knowing NOTHING about coding to making a PRO sniper game!

---

## My Journey So Far

### Level 1: The Beginning
*"What's a script?"*

- [x] Learned what Roblox Studio is
- [x] Set up my development environment
- [x] Connected Rojo (pro developer workflow!)
- [x] Made my first script run
- [x] Created basic red square targets

**Skills Unlocked:** Basic Lua, Roblox Studio, Git

---

### Level 2: Making Things Shoot
*"How do bullets work in games?"*

- [x] Learned about Raycasting (invisible laser beams!)
- [x] Made bullets hit targets
- [x] Targets explode when shot
- [x] Targets respawn after being destroyed

**Skills Unlocked:** Raycasting, Events, Server-Client communication

---

### Level 3: Pro Sniper Features
*"I want it to feel like a REAL sniper game!"*

- [x] **Scope Zoom** - Right-click to aim down sights
- [x] **Scope Sway** - Breathing makes the scope move
- [x] **Hold Breath** - Press Shift to steady aim (8 seconds!)
- [x] **Breath Meter** - Shows how long I can hold breath
- [x] **Crosshairs** - Clean scope overlay with red dot

**Skills Unlocked:** Camera manipulation, User input, UI design

---

### Level 4: Game Juice (Making It Feel GOOD)
*"Pro devs call these effects 'game juice'!"*

- [x] **Visible Sniper Rifle** - Built a 3D gun model from code!
  - Body, Barrel, Stock, Scope, Trigger Guard
- [x] **Bullet Tracers** - See the bullet fly through the air
- [x] **Muzzle Flash** - Bright flash + light when shooting
- [x] **Screen Shake** - Camera shakes on every shot (recoil!)
- [x] **Hit Markers** - Visual feedback when you hit something

**Skills Unlocked:** 3D modeling with code, Visual effects, Lerp (smooth movement)

**New Concept Learned - LERP:**
```lua
-- Lerp smoothly moves from A to B
-- t=0 means A, t=1 means B, t=0.5 means halfway!
local function lerp(a, b, t)
    return a + (b - a) * t
end
```

---

### Level 5: Brayden's Custom Bullet Cam
*"I designed this myself!"*

When you hit a target from 100+ studs away, the camera follows the bullet in SLOW MOTION!

**My Design Choices:**
- **Camera Style:** Chase cam (behind the bullet)
- **Speed:** Super slow for drama
- **Trails:** Fire + Smoke + Glow (triple trails!)
- **Impact:** Time freezes, sparks fly out, BIG explosion

This is the coolest feature in the game and I designed every part of it!

**Skills Unlocked:** Game design, Creative decision-making, Cinematic cameras

---

### Level 6: Points & Scoring
*"Gotta track those kills!"*

- [x] **Kill Counter** - Shows total kills
- [x] **Points System** - More distance = more points!
- [x] **Kill Popup** - Shows distance + points earned
- [x] **Score Display** - Always visible at top of screen

**Skills Unlocked:** UI creation, Math (distance calculations), Data tracking

---

### Level 7: Real NPCs (Current!)
*"No more boring red squares!"*

- [x] **Humanoid NPCs** - Real character models with heads, arms, legs
- [x] **Faces** - They have the classic Roblox smile!
- [x] **Walking AI** - NPCs patrol around using PathfindingService
- [x] **Ragdoll Deaths** - Bodies fly apart when killed
- [x] **Health Bars** - Green/Yellow/Red bar above their heads
- [x] **Damage Numbers** - Floating numbers show how much damage you did
- [x] **Headshot System** - 100 damage for headshots, less for body/limbs!

**Damage Values I Set:**
| Body Part | Damage |
|-----------|--------|
| Head | 100 (instant kill!) |
| Torso | 50 |
| Arms | 30 |
| Legs | 25 |

**Skills Unlocked:** NPC creation, AI pathfinding, Humanoid system, Damage systems

---

## Cool Concepts I've Learned

### 1. Lerp (Linear Interpolation)
Smoothly transition between two values. Used EVERYWHERE in game dev!

### 2. Raycasting
Shooting invisible beams to detect what you're pointing at.

### 3. Client vs Server
- **Client** = What YOU see (your computer)
- **Server** = The truth (Roblox's computers)
- Always validate on server to prevent cheating!

### 4. TweenService
Animate anything smoothly - positions, colors, sizes, transparency.

### 5. PathfindingService
Makes NPCs walk around obstacles intelligently.

### 6. Game Juice
The little effects that make games FEEL good - screen shake, particles, sounds, flashes.

---

## What's Next?

- [ ] Add real 3D target models from Toolbox
- [ ] Build an environment (trees, rocks, buildings)
- [ ] Add a sniper tower to shoot from
- [ ] Ambient sounds and atmosphere
- [ ] Maybe multiplayer?

---

## Play My Game!

*Coming soon to Roblox!*

---

## Tech Stack

- **Engine:** Roblox Studio
- **Language:** Luau (Roblox's Lua)
- **Workflow:** Rojo (syncs code from VS Code)
- **Version Control:** Git + GitHub

---

## Special Thanks

**Dad** - For teaching me and building this with me!

---

*"From no code to pro code, one feature at a time!"*

**- Brayden, 2026**
