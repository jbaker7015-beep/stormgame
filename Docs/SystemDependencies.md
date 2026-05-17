# System Dependencies

# Philosophy

Systems should remain modular and loosely coupled.

Avoid circular dependencies whenever possible.

Systems should communicate primarily through:
- signals
- events
- managers

---

# Core Dependency Order

## Foundation Layer
Base systems required for everything else.

Includes:
- GameManager
- Input systems
- Save systems
- Settings systems

---

## Atmospheric Layer
Controls environmental simulation.

Includes:
- humidity systems
- heat systems
- instability systems
- wind systems

Depends on:
- Foundation Layer

---

## Storm Layer
Controls storm behavior and evolution.

Includes:
- storm entities
- evolution systems
- storm abilities

Depends on:
- Atmospheric Layer

---

## AI Layer
Controls storm and agency AI.

Depends on:
- Atmospheric Layer
- Storm Layer

---

## Destruction Layer
Controls damage and environmental impact.

Depends on:
- Storm Layer

---

## Population Layer
Controls civilians and cities.

Depends on:
- Destruction Layer

---

## Weather Agency Layer
Controls forecasting and mitigation gameplay.

Depends on:
- Atmospheric Layer
- Population Layer

---

## Multiplayer Layer
Synchronizes gameplay systems.

Depends on:
- all major gameplay systems

---

# Dependency Rules

Higher-level systems should not directly modify lower-level systems unnecessarily.

Systems should expose clean APIs and signals.

---

# Long-Term Goal

The architecture should support:
- future storm types
- multiplayer scaling
- new gameplay systems
- modular expansion