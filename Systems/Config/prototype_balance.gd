extends Node

## Autoload singleton: tuning values for StormGame prototypes.

# Movement (CharacterBody2D — acceleration model for smooth feel)
const MOVE_SPEED: float = 280.0
const MOVE_ACCELERATION: float = 1200.0
const MOVE_FRICTION: float = 900.0

# Resource caps shown on the HUD
const MAX_HUMIDITY: float = 100.0
const MAX_HEAT: float = 100.0
const MAX_STORM_ENERGY: float = 100.0
const MAX_INSTABILITY: float = 100.0

# Fallback collection when no biome zone overlap (should stay low)
const HUMIDITY_GAIN_PER_SECOND: float = 0.0
const HEAT_GAIN_PER_SECOND: float = 0.0

# Passive storm energy growth when humidity and heat coexist
const ENERGY_SYNTHESIS_RATE: float = 5.0
const ENERGY_INSTABILITY_BOOST: float = 0.65

# Instability — rises with resource synergy, falls when atmosphere is calm
const INSTABILITY_SYNERGY_RATE: float = 10.0
const INSTABILITY_IMBALANCE_PENALTY: float = 4.0
const INSTABILITY_HIGH_RESOURCE_BONUS: float = 4.0
const INSTABILITY_HIGH_RESOURCE_THRESHOLD: float = 35.0
const INSTABILITY_DECAY_RATE: float = 5.0
const INSTABILITY_SYNERGY_MIN: float = 0.12

# Growth stage thresholds (aligned with StormEvolutionTree.md)
const UNSTABLE_AIR_INSTABILITY: float = 28.0
const UPDRAFT_ENERGY: float = 45.0
const UPDRAFT_INSTABILITY: float = 40.0
const CUMULUS_ENERGY: float = 58.0
const CUMULUS_INSTABILITY: float = 48.0
const CUMULUS_HUMIDITY: float = 35.0
const THUNDERSTORM_ENERGY: float = 75.0
const THUNDERSTORM_INSTABILITY: float = 65.0
const THUNDERSTORM_HUMIDITY: float = 42.0
const MATURE_ENERGY: float = 90.0
const MATURE_INSTABILITY: float = 82.0
const MATURE_HUMIDITY: float = 48.0

# Stage transition feedback
const EVOLUTION_PULSE_DURATION: float = 0.5
const EVOLUTION_PULSE_SCALE: float = 2.4

# Slow decay when not collecting from biome zones
const HUMIDITY_DECAY_RATE: float = 4.0
const HEAT_DECAY_RATE: float = 3.0
const STORM_ENERGY_DECAY_RATE: float = 2.5

# Visual scale driven by energy + a touch of instability
const MIN_VISUAL_SCALE: float = 0.45
const MAX_VISUAL_SCALE: float = 1.85
const HALO_SCALE_MULTIPLIER: float = 1.35

# Camera
const CAMERA_ZOOM_MIN: float = 0.55
const CAMERA_ZOOM_MAX: float = 1.35
const CAMERA_ZOOM_STEP: float = 0.08

# --- Prototype Phase 3: weather effects ---

# Rain — needs storm energy plus humidity OR instability (charged storm)
const RAIN_MIN_HUMIDITY: float = 8.0
const RAIN_MIN_ENERGY: float = 8.0
const RAIN_MIN_INSTABILITY: float = 16.0
const RAIN_PARTICLES_MIN: int = 24
const RAIN_PARTICLES_MAX: int = 110

# Wind drift (pixels / second) — applied as steady push, noticeable when charged
const WIND_STRENGTH_MIN: float = 35.0
const WIND_STRENGTH_MAX: float = 110.0
const WIND_DIRECTION_SPEED: float = 0.55
const WIND_PUSH_ACCEL: float = 180.0

# Lightning flashes when the storm is charged
const LIGHTNING_MIN_INSTABILITY: float = 32.0
const LIGHTNING_MIN_ENERGY: float = 25.0
const LIGHTNING_COOLDOWN_MAX: float = 3.2
const LIGHTNING_COOLDOWN_MIN: float = 0.9
const LIGHTNING_FLASH_DURATION: float = 0.18
const LIGHTNING_FLASH_ALPHA: float = 0.55

# --- Prototype Phase 4: evolution bonuses (per stage) ---
const UNSTABLE_INSTABILITY_MULT: float = 1.08
const UPDRAFT_ENERGY_MULT: float = 1.12
const CUMULUS_HUMIDITY_MULT: float = 1.22
const CUMULUS_ENERGY_MULT: float = 1.15
const THUNDERSTORM_ENERGY_MULT: float = 1.2
const THUNDERSTORM_INSTABILITY_MULT: float = 1.1
const MATURE_ENERGY_MULT: float = 1.28
const MATURE_INSTABILITY_MULT: float = 1.18
const MATURE_HUMIDITY_MULT: float = 1.12

# --- Prototype Phase 5: AI ecosystem ---
const STORM_PLAYER_COLLISION_LAYER: int = 1
const STORM_AI_COLLISION_LAYER: int = 2
const STORM_BODY_COLLISION_MASK: int = 3

const AI_MOVE_SPEED: float = 250.0
const AI_THINK_INTERVAL: float = 0.45
const AI_PLAYER_COMPETE_RADIUS: float = 50.0
const AI_PLAYER_COMPETE_PENALTY: float = 28.0
const AI_STORM_COMPETE_PENALTY: float = 14.0
const AI_WEATHER_DROP_RADIUS: float = 130.0
const AI_WEATHER_RAIN_MULT: float = 0.92
const AI_WEATHER_WIND_MULT: float = 0.88

# --- Storm audio (player progression) ---
const AUDIO_WIND_IDLE: float = 0.018
const AUDIO_WIND_MAX: float = 0.11
const AUDIO_RAIN_MAX: float = 0.14
const AUDIO_HUM_IDLE: float = 0.006
const AUDIO_HUM_MAX: float = 0.048
const AUDIO_HUM_COMBINED_BOOST: float = 0.022
const AUDIO_THUNDER_MIN_DB: float = -2.0
const AUDIO_THUNDER_MAX_DB: float = 4.0

# --- Rival storm audio (distance + strength) ---
const AUDIO_AI_MAX_HEAR_DISTANCE: float = 640.0
const AUDIO_AI_FULL_HEAR_DISTANCE: float = 110.0
const AUDIO_AI_PAN_RANGE: float = 280.0
const AUDIO_AI_MIX_CAP: float = 0.9
const AUDIO_AI_RAIN_MAX: float = 0.085
const AUDIO_AI_WIND_MAX: float = 0.07
const AUDIO_AI_HUM_MAX: float = 0.03
const AUDIO_AI_THUNDER_MIN_DB: float = -20.0
const AUDIO_AI_THUNDER_MAX_DB: float = -5.0
