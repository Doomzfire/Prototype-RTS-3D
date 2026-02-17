# MVP Checklist

## PR #1 — Project scaffolding
- [x] Folder structure created
- [x] `.gitignore` added for Godot 4
- [x] `README_DEV.md` created
- [x] Initial minimal `Main.tscn`

## PR #2 — RTS Camera
- [x] RTS camera node hierarchy in `Main.tscn`
- [x] WASD camera pan
- [x] Edge pan option
- [x] Smooth mouse wheel zoom
- [x] Camera bounds clamp
- [x] Optional Q/E rotation toggle

## PR #3 — Ground targeting
- [x] Ground collision for click targeting
- [x] Camera raycast to detect ground point
- [x] 1s destination marker feedback

## PR #4 — Unit scene + click selection
- [x] `Unit.tscn` with placeholder mesh
- [x] Selection indicator mesh
- [x] Health component script
- [x] Single/shift-click selection logic

## PR #5 — Box Selection
- [x] Drag rectangle UI
- [x] Multi-select inside rectangle

## PR #6 — Move orders + basic formation
- [x] Right-click move command
- [x] Formation offsets to avoid stacking

## PR #7 — Basic Combat
- [x] Right-click enemy attack command
- [x] Range/damage/cooldown/health/death
- [x] Placeholder attack/hit/death feedback
- [x] Win/lose condition handling

## PR #8 — UI + Audio
- [x] Selected units count UI
- [x] Unit health labels above units
- [x] Pause menu
- [x] Audio buses + routed SFX
- [x] Anti-spam SFX cooldown
