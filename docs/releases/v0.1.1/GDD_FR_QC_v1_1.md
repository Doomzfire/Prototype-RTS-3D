# Prototype RTS (3D) — GDD (FR-QC)
**Projet:** Prototype RTS 3D  
**Moteur:** Godot 4.6  
**Langage:** GDScript  
**Version du jeu:** v0.1.1 (Prototype jouable)  
**Dernière mise à jour:** 2026-02-16 (America/Montreal)

---

## 1) Résumé
Prototype RTS 3D jouable qui valide le **core loop** : caméra RTS, sélection d’unités (clic + box), ordres contextuels (move/attack), déplacement en groupe (formation simple), combat de base, UI minimal, audio minimal.

**Hors-scope (pour le prototype):** économie, bâtiments, tech tree, multijoueur, sauvegardes, minimap.

---

## 2) Équipe
### Samuel Latreille
- Implémentation Godot (gameplay, UI, intégration, perf)
- Audio (SFX + musique + mix/buses)
- Build et structure repo

### Gabriel Chevalier
- Render/animations/correctifs personnages
- Livraison assets (GLB + textures + anim sets)

---

## 3) Objectifs du Prototype (Definition of Done)
Le prototype est “DONE” quand, dans une scène **TestMap**, le joueur peut :
- Naviguer avec une caméra RTS (pan/zoom, limites)
- Sélectionner 1+ unités (clic + shift + box selection)
- Donner des ordres (clic droit sol = move, clic droit ennemi = attack)
- Voir du feedback clair (indicateurs, UI minimal)
- Entendre du feedback (SFX selection/ordre/hit/death)
- Compléter une condition **Victoire/Défaite** stable

---

## 4) Core Gameplay Loop
1. Start (TestMap)
2. Sélection unités
3. Ordre (move/attack)
4. Déplacement / engagement
5. Résolution combat
6. Victoire / Défaite

---

## 5) Contrôles (MVP)
- **WASD** : déplacement caméra (pan)
- **Molette** : zoom
- **Clic gauche** : sélectionner
- **Shift + clic gauche** : ajouter/enlever
- **Drag clic gauche** : box selection
- **Clic droit** : ordre contextuel (move/attack)

*(ESC pause: optionnel selon implémentation actuelle.)*

---

## 6) Systèmes (MVP)
### 6.1 Caméra RTS
- Pan WASD
- Zoom smooth
- Clamp limites map

### 6.2 Sélection
- Raycast sélection au clic
- Box selection (screen-space)
- Indicateur de sélection

### 6.3 Ordres
- Ordre de déplacement sol
- Ordre d’attaque sur cible ennemie
- Formation simple (spread offsets)

### 6.4 Déplacement
- Déplacement vers destination (avec offsets de formation)
- Option: NavigationAgent3D si NavMesh présent

### 6.5 Combat
- Portée, cooldown, damage fixe
- HP, mort, retrait après délai
- Victoire/Défaite

### 6.6 UI Minimal
- Compteur unités sélectionnées
- Option: HP bars

### 6.7 Audio Minimal
- Buses: Master / Music / SFX / UI / Ambience
- SFX: select, order, hit, death
- Anti-spam (cooldown/limiteur)

---

## 7) Data Design (Unit)
**Stats:** HP, MoveSpeed, AttackRange, AttackDamage, AttackCooldown  
**States:** Idle, Move, Attack, Dead

---

## 8) Pipeline Assets (Render → Godot)
- **Format recommandé:** GLB
- **Échelle:** 1 unité = 1 m
- **Noms anim:** Idle, Walk, Attack, Death
- Dossiers:
  - `assets/raw_for_blender/` (Gabriel)
  - `assets/processed/` (Godot ready)

---

## 9) Cibles de performance (prototype)
- 30–100 unités actives
- 60 FPS cible (PC)

---

## 10) Roadmap courte
### Sprint 1
- Caméra + targeting sol + move ordre

### Sprint 2
- Sélection avancée + formation + combat

### Sprint 3
- Polish UI/audio + intégration assets animés

---

## 11) Changelog GDD
- **v1.1:** Clarification MVP, DoD, et standardisation raycast + typage GDScript (Godot 4.6).
