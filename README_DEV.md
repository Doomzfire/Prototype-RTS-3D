# Prototype RTS 3D - Developer README

## Setup
1. Install **Godot 4.6**.
2. Open this repository folder as a Godot project.
3. Run `scenes/TestMap.tscn` (default main scene is configured).

## Controls
- `WASD`: Camera pan
- Mouse to screen edge: Edge pan (toggle in `CameraManager.gd`)
- Mouse wheel: Smooth zoom
- `Q/E`: Rotate camera (toggle in `CameraManager.gd`)
- Left click: Single select
- `Shift + Left click`: Add/remove selection
- Left mouse drag: Box selection
- Right click ground: Move order
- Right click enemy: Attack order
- `Esc`: Toggle pause menu

## Architecture
- `CameraManager`: RTS camera movement and bounds
- `SelectionManager`: Single + box selection
- `OrderManager`: Move / attack command dispatch
- `CombatSystem`: Win/lose checks and combat lifecycle
- `AudioManager`: Routed one-shot SFX with cooldown
- `Unit`: Unit movement + targeting + attacking
- `HealthComponent`: Reusable health and death events

## Notes
- Movement uses simple steering for MVP; no navmesh is required.
- Audio uses generated placeholder beeps in code to avoid external dependencies.
