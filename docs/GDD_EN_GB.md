# Prototype RTS (3D) — GDD (EN-GB)
**Project:** Prototype RTS 3D  
**Engine:** Godot 4.6  
**Language:** GDScript  
**Game Version:** v0.1.4 (Playable prototype)  
**Last Updated:** 2026-02-19 (America/Montreal)

---

## 1) Summary
Playable 3D RTS prototype validating the **core loop**: RTS camera, unit selection (click + box), contextual orders (move/attack), simple formation movement, basic combat, minimal UI, minimal audio.

**Out of scope (prototype):** economy, buildings, tech tree, multiplayer, saving, minimap.

## 2) Team
### Samuel Latreille
- Godot implementation (gameplay, UI, integration, performance)
- Audio (SFX + music + buses)
- Git repo + builds/releases

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
### Camera
- `WASD`: camera pan
- Screen-edge pan: camera pan
- Mouse wheel: smooth zoom
- **RMB drag: camera pan** (suppresses orders while dragging)
- **Space: focus on selection** (`cam_focus`)
- Middle mouse: orbit (if enabled in script)

### Gameplay
- LMB: select
- `Shift + LMB`: add/remove selection
- LMB drag: box selection
- RMB: contextual order (ground = move, enemy = attack)

## 6) Systems (MVP)
- **RTS Camera**: pan/zoom + smoothing + bounds clamp + RMB drag-pan (click/drag gating)
- **Selection**: raycast + box select + indicator
- **Orders**: move/attack + simple formation offsets
- **Movement**: destination (+ NavAgent3D later if using NavMesh)
- **Combat**: range/cooldown/damage/HP/death
- **UI**: selected count (optional HP bars)
- **Audio**: buses + anti-spam

## 7) 3D Units + Animation
### 7.1 Status (GoldKeeper) — integrated
- Animated 3D unit integrated: **GoldKeeper**
- Animations wired to gameplay:
  - **Idle** random (Idle_01/02/03) with auto-chaining while stationary
  - **Walk** (Walk_01) while moving
  - **Attack** random (Attack_01/02/03) when an attack is triggered
  - **Death**: Death_01 (single merged death animation)
- **Orientation fixed**: visuals wrapped under `Visual` rotated **Y = 180°** (forward-axis fix)

### 7.2 Status (Cinderghast) — assets added (staging)
- **Assets present**: 3D model + textures + animation set (staging only)
- **To do (integration)**:
  - Validate final `GLB` + PBR texture binding
  - Create `scenes/units/Cinderghast/CinderghastUnit.tscn`
  - Wire animations to the controller (Idle/Walk/Attack/Death)
  - Verify forward axis (apply Visual Y=180° if needed)
  - Add a test spawn/prefab in `TestMap`

### Standard animation set (v0.2.0 target)
- Idle, Walk, Attack, Death (normalised naming) + reusable controller for all units

### Performance budgets (Total-War style RTS)
- Soldier: 1k–3k triangles
- Elite: 6k–10k triangles (LOD0) + LODs
- Boss: 10k–15k triangles (LOD0), rare

## 8) Asset Pipeline (Meshy → Render → Godot)
### Goal
Minimise risk (broken rig, scale, textures) with a simple exchange format.

### Recommended folders (staging → runtime)
- `assets/meshy_ai/<UnitName>/`: raw AI exports (zip/FBX/GLB + textures)
- `assets/raw_from_render/<UnitName>-Render/`: Render outputs (Gabriel)
- `assets/processed/<UnitName>/`: **runtime assets** (final GLB + textures)
- `scenes/units/<UnitName>/`: unit wrapper scene (collisions + scripts)

### Recommended flow
1) **Meshy (Image→3D)**: remesh per role → export **FBX** (rig+skin+anim) if Render prefers FBX, otherwise a stable GLB
2) **Render (Gabriel)**: rig/weights/animation fixes → export final (GLB preferred)
3) **Godot (Samuel)**: import into `assets/processed/<UnitName>/` → create `scenes/units/<UnitName>/<UnitName>Unit.tscn`

### Rules
- Never remesh after rig/animation.
- Avoid unnecessary FBX↔GLB conversions.
- Scale: aim 1 unit = 1 metre; final scale (1,1,1) before export.
- Textures: GLB may embed; keep PNG PBR maps for manual override.
- Forward axis: fix via a `Visual` wrapper (not the gameplay root).

## 9) Project structure (convention)
- Runtime assets: `assets/processed/`
- Staging assets: `assets/meshy_ai/`, `assets/raw_from_render/`
- Unit scenes: `scenes/units/`
- Scripts: `scripts/`
- Docs: `docs/`

## 10) GDD Changelog
- v0.1.4: RTS camera upgrade (RMB drag-pan + Space focus + smoothing/clamp).
- v0.1.3: GoldKeeper animation wiring + forward-axis fix (Visual Y=180°).
- v0.1.2: Meshy→Render→Godot pipeline + performance budgets.
