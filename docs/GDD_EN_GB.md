# Prototype RTS (3D) — GDD (EN-GB)
**Project:** Prototype RTS 3D  
**Engine:** Godot 4.6  
**Language:** GDScript  
**Game Version:** v0.1.3 (Playable prototype)  
**Last Updated:** 2026-02-18 (America/Montreal)

---

## 1) Summary
Playable 3D RTS prototype validating the **core loop**: RTS camera, unit selection (click + box), contextual orders (move/attack), simple formation movement, basic combat, minimal UI, minimal audio.

**Out of scope (prototype):** economy, buildings, tech tree, multiplayer, saving, minimap.

## 2) Team
### Samuel Latreille
- Godot implementation (gameplay, UI, integration, performance)
- Audio (SFX + music + buses)
- Git repo + builds

### Gabriel Chevalier
- Render/animation/character fixes
- Asset delivery (FBX/GLB + textures + animation sets)

## 3) Definition of Done (Prototype)
In **TestMap**, the player can:
- RTS camera (pan/zoom + bounds)
- Selection (click + shift + box select)
- Orders (RMB ground = move, RMB enemy = attack)
- Clear feedback (indicators + minimal HUD)
- Minimal audio (select/order/hit/death)
- Stable Win/Lose conditions

## 4) Core Loop
Start → Select → Order → Move/Engage → Combat → Win/Lose

## 5) Controls (MVP)
- WASD: camera pan
- Mouse wheel: zoom
- LMB: select
- Shift + LMB: add/remove
- LMB drag: box selection
- RMB: contextual move/attack

## 6) Systems (MVP)
- RTS Camera: pan/zoom/clamp
- Selection: raycast + box select + indicator
- Orders: move/attack + simple formation (spread offsets)
- Movement: destination (+ NavAgent3D if NavMesh)
- Combat: range/cooldown/damage/HP/death
- UI: selected count (optional HP bars)
- Audio: buses + anti-spam

## 7) 3D Units + Animation (v0.1.3)
### Status (GoldKeeper)
- Animated 3D unit integrated: **GoldKeeper**
- Animations wired to gameplay:
  - **Idle** random (Idle_01/02/03) with auto-chaining while stationary
  - **Walk** (Walk_01) while moving
  - **Attack** random (Attack_01/02/03) when an attack is triggered
  - **Death**: Death_01 (single merged death animation)
- **Orientation fixed**: visuals wrapped under a `Visual` node rotated **Y = 180°** (forward-axis fix)

### Standard animation set (v0.2.0 target)
- Idle, Walk, Attack, Death (normalised naming) + reusable controller for all units

### Performance budgets (Total-War style RTS)
- Soldier: 1k–3k triangles
- Elite: 6k–10k triangles (LOD0) + LODs
- Boss: 10k–15k triangles (LOD0), rare

## 8) Asset Pipeline (Meshy → Render → Godot)
### Goal
Minimise risk (broken rig, scale issues, textures) with a simple exchange format.

### Recommended flow
- AI export staging: `assets/meshy_ai/`
1) **Meshy**: Image→3D → Remesh (per role) → export **FBX** (rig + skin + anim) or **GLB** if stable
2) **Render (Gabriel)**: rig/weights/animation fixes → export final (GLB preferred)
3) **Godot (Samuel)**: import into `assets/raw_for_blender/<UnitName>/` → create `scenes/units/<UnitName>/<UnitName>.tscn`

### Rules
- Never remesh after rig/animation.
- Avoid unnecessary FBX↔GLB conversions.
- Scale: aim for 1 unit = 1 metre; final scale (1,1,1) before export.
- Textures: GLB may embed textures; keep PNGs for manual override when needed.
- **Forward axis**: if a model is flipped, fix it by rotating the `Visual` wrapper (not the gameplay root).

## 9) Project structure (convention)
- Raw assets: `assets/raw_for_blender/`
- Unit scenes: `scenes/units/`
- Scripts: `scripts/`
- Docs: `docs/`

## 10) GDD Changelog
- v1.3: Added gameplay animation rules (Idle/Walk/Attack/Death) + forward-axis fix (Visual Y=180°).
- v1.2: Added 3D units/animation + Meshy→Render→Godot pipeline + performance budgets.
