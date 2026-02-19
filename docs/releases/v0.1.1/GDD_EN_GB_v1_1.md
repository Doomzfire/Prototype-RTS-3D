# Prototype RTS (3D) — GDD (EN-GB)
**Project:** Prototype RTS 3D  
**Engine:** Godot 4.6  
**Language:** GDScript  
**Game Version:** v0.1.1 (Playable prototype)  
**Last Updated:** 2026-02-16 (America/Montreal)

---

## 1) Summary
A playable 3D RTS prototype validating the **core loop**: RTS camera, unit selection (click + box), contextual orders (move/attack), group movement (simple formation), basic combat, minimal UI, minimal audio.

**Out of scope (prototype):** economy, buildings, tech tree, multiplayer, saving, minimap.

---

## 2) Team
### Samuel Latreille
- Godot implementation (gameplay, UI, integration, performance)
- Audio (SFX + music + buses)
- Builds and repo structure

### Gabriel Chevalier
- Render/animation/character fixes
- Asset delivery (GLB + textures + animation sets)

---

## 3) Prototype Goals (Definition of Done)
In a **TestMap** scene, the player can:
- Navigate using RTS camera (pan/zoom, bounds)
- Select 1+ units (click + shift + box select)
- Issue contextual orders (RMB ground = move, RMB enemy = attack)
- Receive clear feedback (indicators, minimal HUD)
- Hear feedback (SFX select/order/hit/death)
- Reach stable **Win/Lose** conditions

---

## 4) Core Gameplay Loop
1. Start (TestMap)
2. Select units
3. Issue order (move/attack)
4. Move / engage
5. Combat resolution
6. Win / Lose

---

## 5) Controls (MVP)
- **WASD**: camera pan
- **Mouse wheel**: zoom
- **LMB**: select
- **Shift + LMB**: add/remove
- **LMB drag**: box selection
- **RMB**: contextual order (move/attack)

*(ESC pause: optional depending on current implementation.)*

---

## 6) Systems (MVP)
### 6.1 RTS Camera
- WASD pan
- Smooth zoom
- Map-bounds clamp

### 6.2 Selection
- Click raycast selection
- Box select (screen-space)
- Selection indicator

### 6.3 Orders
- Ground move orders
- Enemy attack orders
- Simple formation (spread offsets)

### 6.4 Movement
- Destination movement with formation offsets
- Optional: NavigationAgent3D when NavMesh is present

### 6.5 Combat
- Range, cooldown, fixed damage
- HP, death, timed cleanup
- Win/Lose conditions

### 6.6 Minimal UI
- Selected unit count
- Optional HP bars

### 6.7 Minimal Audio
- Buses: Master / Music / SFX / UI / Ambience
- SFX: select, order, hit, death
- Anti-spam limiter/cooldown

---

## 7) Data Design (Unit)
**Stats:** HP, MoveSpeed, AttackRange, AttackDamage, AttackCooldown  
**States:** Idle, Move, Attack, Dead

---

## 8) Asset Pipeline (Render → Godot)
- **Recommended format:** GLB
- **Scale:** 1 unit = 1 m
- **Animation names:** Idle, Walk, Attack, Death
- Folders:
  - `assets/raw_from_render/` (Gabriel)
  - `assets/processed/` (Godot ready)

---

## 9) Performance Targets (prototype)
- 30–100 active units
- 60 FPS target (PC)

---

## 10) Short Roadmap
### Sprint 1
- Camera + ground targeting + move orders

### Sprint 2
- Advanced selection + formation + combat

### Sprint 3
- UI/audio polish + animated asset integration

---

## 11) GDD Changelog
- **v1.1:** MVP/DoD clarification and standardised raycast + explicit typing for Godot 4.6.
