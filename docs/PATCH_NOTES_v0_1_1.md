# Patch Notes — v0.1.1 (Prototype)
**Release date:** 2026-02-16  
**Engine:** Godot 4.6

## Added
- End-to-end playable loop in TestMap (victory achievable).
- Contextual right-click behaviour (move on ground / attack on enemy).
- Selection feedback (indicator + HUD dependency restored).

## Fixed
- Godot 4.x compile failures caused by calling `get_world_3d()` from non-Node3D scripts.
  - Raycasts now use `get_viewport().get_world_3d().direct_space_state` for robust world access.
- GDScript type inference errors on raycast results.
  - Raycast results are treated as `Dictionary` and accessed via safe keys (e.g., `result.get("collider")`).
- `hud.gd` failing to load due to dependent script compilation errors.
- Integer division warning in `order_manager.gd` (line ~41).
  - Updated arithmetic to float math where fractional results are required.

## Known Issues
- Formation spread is basic; may stack in tight spaces depending on navigation/avoidance.
- No economy/buildings/multiplayer (intentionally out of scope for prototype).
