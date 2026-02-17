# Milestone PR Plan and Acceptance

This repository now contains the complete MVP implementation in one branch. To split for GitHub review, create PRs in this order by commit range:

1. **Scaffolding**: folders, docs, minimal scenes.
2. **Camera + Ground targeting**: camera movement/zoom/bounds + destination marker.
3. **Selection**: unit scene, click select, box select.
4. **Orders + Combat**: movement formation, attack orders, combat loop, victory/defeat.
5. **UI + Audio polish**: HUD, pause, health labels, SFX routing.

## Universal test steps
1. Open project in Godot 4.6 and run `scenes/TestMap.tscn`.
2. Verify camera controls (WASD, edge pan, zoom, Q/E).
3. Select units by click and drag, including Shift behavior.
4. Right-click ground to move selected friendly units.
5. Right-click enemy to issue attack orders.
6. Confirm SFX and UI updates (selected count, status, health labels).
7. Eliminate one team to trigger win/lose status.
