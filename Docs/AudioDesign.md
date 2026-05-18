# Audio Design

# Audio Philosophy

Audio is critical to StormGame.

**Target:** **Recorded** field audio (wind, rain, hail, thunder) — not procedural buzz.  
**Plan:** [StormFeaturesImplementationPlan.md](StormFeaturesImplementationPlan.md) — **S7**  
**Lightning sync:** IC forks + occasional CG — **S6**

Storms should sound:
- alive
- evolving
- dangerous
- atmospheric

Players should be able to hear storm intensity increasing even without looking directly at the storm.

The audio experience should feel **documentary-real**, not synthetic arcade.

**Prototype note:** Procedural synth in `storm_audio_synth.gd` is a **dev fallback** until S7 ships.

---

# Core Audio Categories

## Ambient Environment
Examples:
- wind
- distant thunder
- rainfall
- ocean waves
- city ambience
- forest ambience

Ambient audio should dynamically react to weather conditions.

---

## Storm Evolution Audio

Each storm stage should have distinct audio layers.

Examples:

### Moisture Pocket
- light wind
- soft atmospheric hum

### Updraft
- rising wind
- subtle air suction

### Cumulus Cloud
- soft rainfall
- distant thunder

### Thunderstorm
- heavier rain
- louder thunder
- electrical crackling

### Severe Storm
- violent wind
- hail impacts
- tornado roar

Storm audio should layer naturally as intensity increases.

---

# Positional Audio

Audio should support:
- directional thunder
- moving storms
- distance falloff
- environmental reflections

Players should be able to locate storms through sound.

---

# Dynamic Weather Audio

Weather systems should dynamically modify:
- wind intensity
- rainfall volume
- lightning frequency
- environmental ambience

The atmosphere should never feel static.

---

# Warning Audio

Weather alerts should feel:
- urgent
- professional
- realistic

Examples:
- tornado sirens
- emergency broadcasts
- weather radio alerts
- evacuation announcements

---

# Music Philosophy

Music should:
- remain atmospheric
- avoid overpowering gameplay
- escalate naturally with storm intensity

Early gameplay:
- calmer ambient tones

Late gameplay:
- intense cinematic atmosphere

---

# Agency Audio Design — DEFERRED

Weather agency audio (radar, alerts, dispatch) ships with **Weather Service gameplay** — far future.  
Storms-first: see [StormSimulationVision.md](StormSimulationVision.md).

---

# Technical Audio Goals

Audio systems should support:
- dynamic layering
- intensity scaling
- environmental transitions
- adaptive music systems

---

# Long-Term Audio Goals

The world should sound:
- alive
- reactive
- dangerous
- immersive

Players should emotionally feel storm escalation through sound alone.