# Patch Notes — v0.1.3 (Hotfix)
**Release date:** 2026-02-18  
**Engine:** Godot 4.6

## Added
- (Animation) Gameplay animation controller for **GoldKeeper** (Idle/Walk/Attack/Death).
- (Animation) Randomised attack selection (Attack_01/02/03).

## Changed
- (Idle) Randomised idle selection with auto-chaining while stationary (Idle_01/02/03).
- (Death) Death plays **Death_01** (single merged death animation).

## Fixed
- (Orientation) Corrected model forward axis using a **Visual** wrapper rotated **Y = 180°**:
  - Units no longer walk backwards.
  - Attacks face the correct direction.
- (Godot) Fixed `AnimationPlayer` discovery so animations reliably play at runtime.
- (Godot) Fixed `loop_mode` assignment to use the proper enum (removes INT_AS_ENUM_WITHOUT_CAST warning).

## Known Issues
- Final animation naming/mapping may still require manual tuning depending on export naming.
- Some GLB imports may embed textures; manual PBR map reassignment may be required in Godot.
