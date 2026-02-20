# Patch Notes — v0.1.4 (Camera Upgrade) Prototype build
**Release date:** 2026-02-19  
**Engine:** Godot 4.6

## Added
- (Camera) RMB drag-pan with click-vs-drag gating to preserve RMB click-to-order.
- (Camera) Focus on current selection via **Space** (`cam_focus`).
- (Assets) Added **Cinderghast** asset bundle (model + textures + animation set) to staging (not yet wired to gameplay).

## Changed
- (Camera) Fixed edge-pan vertical direction (top = forward, bottom = backward).
- (Camera) Added smoothing target flow with optional map bounds clamp support.
- (Camera) Removed Q/E keyboard rotate path; middle-mouse orbit remains.

## Fixed
- (Camera) Fixed RMB drag-pan vertical inversion.
- (Camera) Fixed RMB drag-pan horizontal inversion.

---

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

---

# Patch Notes — v0.1.2 (Prototype)
**Release date:** 2026-02-17  
**Engine:** Godot 4.6

## Added
- Integrated first animated 3D unit (**GoldKeeper**) imported from Meshy export.
- Replaced placeholder unit visuals with GoldKeeper model + prototype animation driving (Idle/Walk).

## Changed
- Standardised staging placement under `assets/meshy_ai/<UnitName>/` and `assets/raw_from_render/<UnitName>-Render/`.
- Created a clean unit scene wrapper under `scenes/units/<UnitName>/` (do not place raw GLB/FBX directly in maps).

## Fixed
- None reported (project runs without script errors after integration).

## Known Issues
- Animation names may require manual mapping (Idle/Walk/Attack/Death) depending on import/export naming.
- Textures may be embedded in GLB; manual reassignment may be required if PBR maps are not auto-bound.
