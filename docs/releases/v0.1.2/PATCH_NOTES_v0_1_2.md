# Patch Notes — v0.1.2 (Prototype)
**Release date:** 2026-02-17  
**Engine:** Godot 4.6

## Added
- Integrated first animated 3D unit (**GoldKeeper**) imported from Meshy export.
- Replaced placeholder unit visuals with GoldKeeper model + prototype animation driving (Idle/Walk).

## Changed
- Standardised raw asset placement under `assets/raw_from_render/<UnitName>/`.
- Created a clean unit scene wrapper under `scenes/units/<UnitName>/` (do not place raw GLB/FBX directly in maps).

## Fixed
- None reported (project runs without script errors after integration).

## Known Issues
- Animation names may require manual mapping (Idle/Walk/Attack/Death) depending on import/export naming.
- Textures may be embedded in GLB; manual reassignment may be required if PBR maps are not auto-bound.
