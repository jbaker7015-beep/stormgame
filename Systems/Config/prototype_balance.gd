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

# Growth stage thresholds (aligned with early StormEvolutionTree stages)
const UNSTABLE_AIR_INSTABILITY: float = 28.0
const UPDRAFT_ENERGY: float = 45.0
const UPDRAFT_INSTABILITY: float = 40.0

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

# Rain intensity scales with humidity and storm energy
const RAIN_MIN_HUMIDITY: float = 20.0
const RAIN_MIN_ENERGY: float = 15.0
const RAIN_PARTICLES_MIN: int = 0
const RAIN_PARTICLES_MAX: int = 72

# Wind drift applied to the moisture pocket (pixels / second)
const WIND_STRENGTH_MIN: float = 12.0
const WIND_STRENGTH_MAX: float = 52.0
const WIND_DIRECTION_SPEED: float = 0.55

# Lightning flashes when the storm is charged
const LIGHTNING_MIN_INSTABILITY: float = 32.0
const LIGHTNING_MIN_ENERGY: float = 25.0
const LIGHTNING_COOLDOWN_MAX: float = 3.2
const LIGHTNING_COOLDOWN_MIN: float = 0.9
const LIGHTNING_FLASH_DURATION: float = 0.18
const LIGHTNING_FLASH_ALPHA: float = 0.55
