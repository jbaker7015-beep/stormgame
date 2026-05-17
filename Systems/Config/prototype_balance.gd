extends Node

## Autoload singleton: tuning values for Prototype Phase 1.

## Central tuning values for Prototype Phase 1.
## Keeping numbers here makes balancing easier without hunting through scripts.

# Movement (CharacterBody2D — acceleration model for smooth feel)
const MOVE_SPEED: float = 280.0
const MOVE_ACCELERATION: float = 1200.0
const MOVE_FRICTION: float = 900.0

# Resource caps shown on the HUD
const MAX_HUMIDITY: float = 100.0
const MAX_HEAT: float = 100.0
const MAX_STORM_ENERGY: float = 100.0

# How quickly zones refill resources while the player overlaps them
const HUMIDITY_GAIN_PER_SECOND: float = 18.0
const HEAT_GAIN_PER_SECOND: float = 14.0

# Passive energy growth when both humidity and heat are present
const ENERGY_SYNTHESIS_RATE: float = 6.0

# Slow decay when not collecting (keeps meters readable during testing)
const HUMIDITY_DECAY_RATE: float = 4.0
const HEAT_DECAY_RATE: float = 3.0

# Visual scale: 1.0 at zero energy → MAX_VISUAL_SCALE at full energy
const MIN_VISUAL_SCALE: float = 0.45
const MAX_VISUAL_SCALE: float = 1.65

# Camera
const CAMERA_ZOOM_MIN: float = 0.55
const CAMERA_ZOOM_MAX: float = 1.35
const CAMERA_ZOOM_STEP: float = 0.08
const CAMERA_FOLLOW_SPEED: float = 8.0
