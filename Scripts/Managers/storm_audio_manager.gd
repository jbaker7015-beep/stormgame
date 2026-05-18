extends Node

## Procedural storm audio (polish pass) — wind, rain, thunder without external assets.

@onready var _wind_player: AudioStreamPlayer = $WindPlayer
@onready var _rain_player: AudioStreamPlayer = $RainPlayer
@onready var _hum_player: AudioStreamPlayer = $HumPlayer
@onready var _thunder_player: AudioStreamPlayer = $ThunderPlayer

var _wind_playback: AudioStreamGeneratorPlayback
var _rain_playback: AudioStreamGeneratorPlayback
var _hum_playback: AudioStreamGeneratorPlayback

var _wind_volume: float = 0.0
var _rain_volume: float = 0.0
var _hum_volume: float = 0.0
var _noise_state: float = 0.0


func _ready() -> void:
	_wind_playback = _start_generator(_wind_player)
	_rain_playback = _start_generator(_rain_player)
	_hum_playback = _start_generator(_hum_player)
	_wind_volume = 0.02


func _process(_delta: float) -> void:
	_fill_generator(_wind_playback, _wind_volume, 0.4)
	_fill_generator(_rain_playback, _rain_volume, 0.85)
	_fill_generator(_hum_playback, _hum_volume, 0.08, true)


func update_atmosphere(rain_intensity: float, storm_intensity: float, growth_stage: int) -> void:
	_rain_volume = lerpf(0.0, 0.11, rain_intensity)
	_wind_volume = lerpf(0.015, 0.09, storm_intensity)

	var stage_norm: float = clampf(float(growth_stage) / 4.0, 0.0, 1.0)
	_hum_volume = lerpf(0.008, 0.035, stage_norm)


func play_thunder(intensity: float = 1.0) -> void:
	_thunder_player.stream = _build_thunder_stream(intensity)
	_thunder_player.play()


func _start_generator(player: AudioStreamPlayer) -> AudioStreamGeneratorPlayback:
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = 22050
	stream.buffer_length = 0.12
	player.stream = stream
	player.play()
	return player.get_stream_playback() as AudioStreamGeneratorPlayback


func _fill_generator(
	playback: AudioStreamGeneratorPlayback,
	volume: float,
	noise_weight: float,
	use_tone: bool = false
) -> void:
	if playback == null or volume <= 0.0001:
		return

	var to_fill: int = playback.get_frames_available()
	for _i in to_fill:
		_noise_state = fmod(_noise_state + noise_weight, 1.0)
		var noise: float = (randf() * 2.0 - 1.0) * volume
		if use_tone:
			var tone: float = sin(_noise_state * TAU * 2.0) * volume * 0.35
			noise = noise * 0.65 + tone
		playback.push_frame(Vector2(noise, noise))


func _build_thunder_stream(intensity: float) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	stream.stereo = false

	var duration: float = lerpf(0.25, 0.5, intensity)
	var sample_count: int = int(22050.0 * duration)
	var data := PackedByteArray()
	data.resize(sample_count * 2)

	for i in sample_count:
		var t: float = float(i) / 22050.0
		var envelope: float = exp(-t * 7.5) * (1.0 - t / duration)
		var sample_f: float = randf_range(-1.0, 1.0) * envelope * lerpf(0.5, 1.0, intensity)
		var sample_i: int = int(clampf(sample_f * 30000.0, -32000.0, 32000.0))
		data[i * 2] = sample_i & 0xFF
		data[i * 2 + 1] = (sample_i >> 8) & 0xFF

	stream.data = data
	return stream
