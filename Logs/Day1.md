# 🛠 Development Log

## 📅 15 February 2026 – Project Foundation

### 🔹 Initial Setup

* Initial commit – Godot project setup
* Implemented basic player movement
* Added player sprite controller

### 🔹 Core NPC Systems

* Created a basic NPC navigation system
* Added basic NPC wander state
* Implemented NPC sprite controller
* Added basic NPC chase state
* Added basic NPC melee attack state

### 🔹 Player Systems

* Created a basic player health system

  * Includes hurt animation feedback

---

## 📅 16 February 2026 – Combat & AI Expansion

### 🔹 Ranged Combat

* Created a basic NPC throw projectile state
* Implemented base projectile class

### 🔹 AI & Visual Improvements

* Enabled avoidance on NPC NavAgent
* Reassigned NPC sprite direction before melee attacks for improved visual feedback

### 🔹 Disruption System (Core Feature Development)

#### Base Framework

* Created **DisruptiveProps + VFX base modules** for the Disruption system
* Implemented a `DisruptionManager` to store and manage disruption states
* Integrated a prototype `DisruptionProgressBar` for debug visual feedback
* Integrated `DisruptionManager` into the NPCInteractField

#### VFX System

* Created a disruptive animated sprite VFX system

  * Includes both **sequenced** and **non-sequenced** versions

---

## 📅 UI & Structural Improvements

* Added prototype main menu
* Implemented health progress bar
* Organised Scripts folder for improved project structure

---

## 🐛 Bug Fixes & Stability

* Fixed issue causing projectiles to deal double damage
* Added error handling for NPC logic to safely handle the Player being freed

---

# 📌 Summary of Progress

In roughly two days, the project evolved from:

* Basic player movement
  ➡
* Fully navigable NPCs with wander, chase, melee, and ranged attack states
  ➡
* A structured disruption mechanic system with VFX and debug UI
  ➡
* Core UI elements (main menu + health bar)
  ➡
* Improved AI behaviour and stability fixes

---
