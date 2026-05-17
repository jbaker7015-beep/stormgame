# Save System Design

# Philosophy

The save system should be:
- reliable
- modular
- expandable
- version-safe

Player progression should remain stable across updates.

---

# Saved Data Categories

## Player Progression
Includes:
- player level
- unlocked storms
- agency upgrades
- cosmetics

---

## Settings
Includes:
- graphics
- controls
- audio
- accessibility

---

## Statistics
Includes:
- storms created
- destruction caused
- lives saved
- matches played

---

# Match Persistence

Future systems may support:
- persistent worlds
- reconnect systems
- long-running simulations

---

# Save Design Rules

- avoid storing unnecessary temporary data
- separate profile saves from match saves
- support future expansion cleanly

---

# Cloud Save Goals

Potential future support:
- cross-platform progression
- cloud backups
- account synchronization

---

# Failure Protection

The save system should:
- prevent corruption
- support backups
- handle partial failures gracefully

---

# Technical Goals

Save data should:
- remain lightweight
- be version-compatible
- support future content additions