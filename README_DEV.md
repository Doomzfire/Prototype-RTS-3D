# Prototype RTS 3D - Developer README

## Setup
1. Install **Godot 4.6**.
2. Open this repository folder as a Godot project.
3. Run `scenes/TestMap.tscn` (default main scene is configured).

## Controls
### Camera
- `WASD`: Camera pan
- Mouse to screen edge: Edge pan (toggle in `CameraManager.gd`)
- Mouse wheel: Smooth zoom
- **RMB drag**: Drag-pan camera (RMB click orders are suppressed while dragging)
- **Space**: Focus on selection (`cam_focus`)
- Middle mouse: Orbit (if enabled)

### Gameplay
- Left click: Single select
- `Shift + Left click`: Add/remove selection
- Left mouse drag: Box selection
- Right click ground: Move order
- Right click enemy: Attack order
- `Esc`: Toggle pause menu

## Architecture
- `CameraManager`: RTS camera movement and bounds
- `SelectionManager`: Single + box selection
- `OrderManager`: Move / attack command dispatch (RMB click vs drag gating)
- `CombatSystem`: Win/lose checks and combat lifecycle
- `AudioManager`: Routed one-shot SFX with cooldown
- `Unit`: Unit movement + targeting + attacking
- `HealthComponent`: Reusable health and death events

## Notes
- Movement uses simple steering for MVP; no navmesh is required.
- Some GLB imports may embed textures; keep PNG PBR maps for manual override when needed.
