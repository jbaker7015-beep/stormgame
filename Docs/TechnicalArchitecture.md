# Technical Architecture

## Engine

- Godot 4
- GDScript
- GitHub version control
- Cursor IDE assisted development

---

# Core Philosophy

The architecture should prioritize:
- modular systems
- scalability
- multiplayer readiness
- maintainability
- readability
- reusable components

Systems should remain loosely coupled whenever possible.

---

# Primary Architecture Style

StormGame uses:
- scene-based architecture
- singleton manager systems
- component-driven gameplay systems
- data-driven storm configuration

---

# Core Singleton Managers

These managers should eventually exist as AutoLoads.

## GameManager
Handles:
- match state
- game flow
- pause states
- global settings

---

## StormManager
Handles:
- storm spawning
- storm tracking
- evolution management
- atmospheric systems

---

## WeatherManager
Handles:
- humidity
- heat
- wind
- instability
- environmental simulation

---

## AIManager
Handles:
- bot behavior
- difficulty scaling
- ecosystem AI systems

---

## PopulationManager
Handles:
- civilians
- evacuation systems
- city population states

---

## AudioManager
Handles:
- dynamic weather audio
- ambient sound
- storm intensity scaling

---

## SaveManager
Handles:
- player progression
- unlocks
- settings
- persistent data

---

# Scene Philosophy

Scenes should remain:
- small
- modular
- reusable

Avoid giant all-in-one scenes.

---

# Recommended Scene Structure

## MainMenu
Main navigation and game setup.

---

## Gameplay
Primary gameplay container scene.

---

## Storm Scenes
Individual storm entities.

Examples:
- MoisturePocket
- Thunderstorm
- Tornado
- Hurricane

---

## UI Scenes
Reusable UI components.

---

# Data Philosophy

Gameplay values should eventually become data-driven.

Examples:
- storm stats
- evolution thresholds
- AI values
- damage values

Avoid hardcoding gameplay numbers whenever possible.

---

# Event Communication

Prefer:
- signals
- event-driven communication

Avoid direct cross-system dependencies when possible.

---

# Multiplayer Philosophy

The game should be built multiplayer-aware from the start, even if multiplayer is implemented later.

Systems should avoid assumptions about:
- single-player ownership
- local-only logic
- hardcoded player references

---

# Performance Goals

The game should support:
- many simultaneous storms
- particle-heavy visuals
- large maps
- AI ecosystems

Optimization should remain a long-term priority.

---

# Long-Term Technical Goals

- scalable atmospheric simulation
- dynamic weather ecosystems
- procedural storm evolution
- AI-driven ecosystem behavior
- expandable storm classes