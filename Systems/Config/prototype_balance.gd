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

# Visual scale driven by energy + a touch of instability
const MIN_VISUAL_SCALE: float = 0.45
const MAX_VISUAL_SCALE: float = 1.85
const HALO_SCALE_MULTIPLIER: float = 1.35

# Camera
const CAMERA_ZOOM_MIN: float = 0.55
const CAMERA_ZOOM_MAX: float = 1.35
const CAMERA_ZOOM_STEP: float = 0.08
