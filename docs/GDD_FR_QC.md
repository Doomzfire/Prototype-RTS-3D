# Prototype RTS (3D) — GDD (FR-QC)
**Projet:** Prototype RTS 3D  
**Moteur:** Godot 4.6  
**Langage:** GDScript  
**Version du jeu:** v0.1.3 (Prototype jouable)  
**Dernière mise à jour:** 2026-02-18 (America/Montreal)

---

## 1) Résumé
Prototype RTS 3D jouable qui valide le **core loop** : caméra RTS, sélection d’unités (clic + box), ordres contextuels (move/attack), déplacement en groupe (formation simple), combat de base, UI minimal, audio minimal.

**Hors-scope (prototype):** économie, bâtiments, tech tree, multijoueur, sauvegardes, minimap.

## 2) Équipe
### Samuel Latreille
- Implémentation Godot (gameplay, UI, intégration, performance)
- Audio (SFX + musique + mix/buses)
- Repo Git + builds

### Gabriel Chevalier
- Render/animations/correctifs personnages
- Livraison assets (FBX/GLB + textures + anim sets)

## 3) Definition of Done (Prototype)
Dans **TestMap**, le joueur peut :
- Caméra RTS (pan/zoom + limites)
- Sélection (clic + shift + box selection)
- Ordres (clic droit sol = move, clic droit ennemi = attack)
- Feedback clair (indicateurs + HUD minimal)
- Audio minimal (SFX select/ordre/hit/death)
- Conditions Victoire/Défaite stables

## 4) Core Loop
Start → Select → Order → Move/Engage → Combat → Win/Lose

## 5) Contrôles (MVP)
- WASD : pan caméra
- Molette : zoom
- Clic gauche : sélectionner
- Shift + clic : add/remove sélection
- Drag gauche : box selection
- Clic droit : move/attack contextuel

## 6) Systèmes (MVP)
- Caméra RTS : pan/zoom/clamp
- Sélection : raycast + box selection + indicator
- Ordres : move/attack + formation simple (spread offsets)
- Déplacement : destination (+ NavAgent3D si NavMesh)
- Combat : range/cooldown/damage/HP/death
- UI : compteur sélection (option HP bars)
- Audio : buses + anti-spam

## 7) Unités 3D + Animations (v0.1.3)
### Statut (GoldKeeper)
- Unité 3D animée intégrée : **GoldKeeper**
- Animations reliées aux mécaniques :
  - **Idle** aléatoire (Idle_01/02/03) + enchaînement automatique à l’arrêt
  - **Walk** (Walk_01) quand l’unité se déplace
  - **Attack** aléatoire (Attack_01/02/03) quand une attaque est déclenchée
  - **Death**: Death_01 puis Death_02 (séquence)
- **Orientation corrigée**: le visuel est wrapper dans un node `Visual` avec rotation **Y = 180°** (forward-axis fix)

### Standard animation (cible v0.2.0)
- Idle, Walk, Attack, Death (noms normalisés) + contrôleur réutilisable pour toutes les unités

### Budget perf (RTS “Total War”)
- Soldat: 1k–3k triangles
- Elite: 6k–10k triangles (LOD0), puis LODs
- Boss: 10k–15k triangles (LOD0), rare

## 8) Pipeline Assets (Meshy → Render → Godot)
### Objectif
Réduire les risques (rig cassé, scale, textures) et garder un flux simple.

### Flux recommandé
1) **Meshy**: Image→3D → Remesh (selon rôle) → export **FBX** (rig + peau + anim) ou **GLB** si stable
2) **Render (Gabriel)**: correctifs rig/weights/anim → export final (GLB idéal)
3) **Godot (Samuel)**: importer dans `assets/raw_from_render/<UnitName>/` → créer `scenes/units/<UnitName>/<UnitName>.tscn`

### Règles
- Ne jamais remesh après rig/anim (risque de tout casser).
- Éviter les conversions multiples FBX↔GLB.
- Échelle: viser 1 unité = 1 m, scale final (1,1,1) avant export.
- Textures: GLB peut être “embedded”; garder aussi les PNG si besoin d’override.
- **Forward axis**: si un modèle est inversé, corriger en mettant la rotation sur le node `Visual` (pas sur le root gameplay).

## 9) Arborescence projet (convention)
- Assets bruts: `assets/raw_from_render/`
- Scènes units: `scenes/units/`
- Scripts: `scripts/`
- Docs: `docs/`

## 10) Changelog GDD
- v1.3: Ajout règles d’animation gameplay (Idle/Walk/Attack/Death) + forward-axis fix (Visual Y=180°).
- v1.2: Ajout section Unités 3D/Animations + pipeline Meshy→Render→Godot + budgets perf.
