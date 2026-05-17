# Storm Data Structures

# Philosophy

Storms should be highly data-driven.

Storm behavior, growth, evolution, and damage should primarily be controlled through configurable values rather than hardcoded logic.

This allows:
- easier balancing
- easier expansion
- AI tuning
- future mod support
- scalable storm creation

---

# Core Storm Attributes

Every storm contains the following base attributes.

---

## Storm Identity

- storm_name
- storm_type
- evolution_stage
- specialization_path

---

## Atmospheric Resources

- humidity
- heat_energy
- instability
- wind_shear
- electrical_charge

---

## Physical Characteristics

- storm_size
- wind_speed
- rotation_speed
- rainfall_intensity
- pressure_level

---

## Lifecycle Values

- growth_rate
- energy_decay
- dissipation_rate
- evolution_progress

---

## Combat/Impact Values

- destruction_power
- debris_generation
- lightning_damage
- flood_generation
- hail_intensity

---

# Storm Categories

## Basic Atmospheric Forms
- moisture pocket
- updraft
- cumulus cloud

---

## Standard Storms
- thunderstorm
- severe thunderstorm

---

## Specialized Storms
- tornado
- hurricane
- blizzard
- lightning storm

---

# Evolution Requirements

Each evolution stage requires:
- minimum humidity
- minimum heat
- instability threshold
- environmental conditions

---

# Environmental Interaction Variables

Storms interact with:
- terrain type
- temperature
- nearby storms
- population density
- water sources

---

# AI Variables

AI-controlled storms include:
- aggression_rating
- resource_priority
- evolution_preference
- target_preference

---

# Future Expandability

Future storm types should be creatable using primarily:
- data values
- modular abilities
- reusable systems

Avoid creating fully custom code for every storm type whenever possible.