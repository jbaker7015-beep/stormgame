# Coding Standards

# Core Philosophy

Code should prioritize:
- readability
- modularity
- scalability
- maintainability

Readable code is more important than clever code.

---

# Naming Conventions

## Classes
Use PascalCase.

Examples:
- StormManager
- MoisturePocket
- WeatherSystem

---

## Variables
Use snake_case.

Examples:
- storm_energy
- humidity_level
- wind_speed

---

## Constants
Use ALL_CAPS.

Examples:
- MAX_STORM_SIZE
- BASE_HUMIDITY_GAIN

---

# File Organization

Scripts should remain organized by gameplay purpose.

Avoid dumping unrelated scripts into shared folders.

---

# Scene Organization

Scenes should:
- remain modular
- avoid excessive nesting
- support reusability

---

# Comment Philosophy

Comments should explain:
- why systems exist
- gameplay purpose
- complex calculations

Avoid obvious comments.

---

# Reusability

Systems should be reusable whenever possible.

Avoid:
- duplicated logic
- hardcoded references
- tightly coupled systems

---

# Data Philosophy

Gameplay values should eventually become:
- configurable
- data-driven
- easily balanceable

Avoid hardcoded gameplay tuning values.

---

# Performance Philosophy

Optimization matters.

Avoid:
- unnecessary physics calculations
- excessive particle spawning
- inefficient loops

---

# Signal Usage

Prefer:
- signals
- event-driven communication

Avoid excessive direct references between systems.

---

# AI Philosophy

AI systems should:
- follow the same gameplay rules as players
- avoid unfair cheating
- prioritize believable behavior

---

# Multiplayer Readiness

Even before multiplayer implementation:
- avoid local-only assumptions
- separate authority logic cleanly
- keep systems network-friendly

---

# Git Philosophy

Commit frequently.

Good commits:
- small
- focused
- descriptive

Examples:
- added moisture absorption system
- implemented instability calculations
- created cloud evolution prototype

---

# Cursor Workflow

Before major code generation:
- read relevant design docs
- follow existing architecture
- maintain naming consistency
- avoid overengineering

Gameplay feel is more important than technical perfection.