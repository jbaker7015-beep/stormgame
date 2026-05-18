class_name StormAudioSynth
extends RefCounted

## Procedural storm audio — wind hiss, rainfall, and rolling thunder.

const SAMPLE_RATE: int = 22050


static func fill_wind_frame(
	volume: float,
	noise_state: float,
	time: float
) -> Dictionary:
	var gust: float = 0.55 + 0.45 * sin(time * 0.55 + sin(time * 0.13) * 1.6)
	var flutter: float = 0.85 + 0.15 * sin(time * 3.7)
	noise_state = fmod(noise_state + 0.37, 1.0)
	var noise: float = (randf() * 2.0 - 1.0) * 0.55 + (randf() * 2.0 - 1.0) * 0.45
	var whoosh: float = noise * gust * flutter * volume * 0.22
	return {"sample": whoosh, "noise_state": noise_state}


static func fill_rain_frame(
	volume: float,
	noise_state: float,
	time: float
) -> Dictionary:
	noise_state = fmod(noise_state + 0.92, 1.0)
	var hiss: float = (randf() * 2.0 - 1.0) * 0.7
	var sparkle: float = 0.0
	if randf() < 0.08:
		sparkle = randf_range(0.25, 0.65)
	var patter: float = 0.7 + 0.3 * sin(time * 24.0 + sin(time * 7.0))
	var sample: float = (hiss * patter + sparkle) * volume * 0.28
	return {"sample": sample, "noise_state": noise_state}


static func fill_hum_frame(
	volume: float,
	noise_state: float,
	time: float
) -> Dictionary:
	noise_state = fmod(noise_state + 0.11, 1.0)
	var sub: float = sin(time * 48.0) * 0.04 + sin(time * 72.0) * 0.025
	var air: float = (randf() * 2.0 - 1.0) * 0.015
	var sample: float = (sub + air) * volume * 0.35
	return {"sample": sample, "noise_state": noise_state}


static func build_rolling_thunder(intensity: float, stereo_pan: float = 0.0) -> AudioStreamWAV:
	var charge: float = clampf(intensity, 0.0, 1.0)
	var duration: float = lerpf(2.0, 3.6, charge)
	var sample_count: int = int(SAMPLE_RATE * duration)
	var data := PackedByteArray()
	data.resize(sample_count * 4)

	var pan: float = clampf(stereo_pan, -1.0, 1.0)
	var left_master: float = lerpf(1.0, 0.45, maxf(pan, 0.0))
	var right_master: float = lerpf(1.0, 0.45, maxf(-pan, 0.0))
	var rng := RandomNumberGenerator.new()
	rng.seed = int(Time.get_ticks_usec()) % 100000

	for i in sample_count:
		var t: float = float(i) / float(SAMPLE_RATE)
		var progress: float = t / duration

		# Sharp initial crack (zap).
		var crack: float = 0.0
		if t < 0.035:
			crack = rng.randf_range(-1.0, 1.0) * exp(-t * 95.0) * lerpf(0.7, 1.15, charge)

		# Main rolling rumble — low frequencies with slow decay.
		var rumble_envelope: float = exp(-t * 1.35) * (1.0 - progress * 0.35)
		var rumble_tone: float = (
			sin(t * TAU * 42.0) * 0.42
			+ sin(t * TAU * 67.0) * 0.22
			+ sin(t * TAU * 28.0 + sin(t * 2.1) * 2.0) * 0.18
		) * rumble_envelope

		# Noise body gives the "roll" texture.
		var roll_noise: float = rng.randf_range(-1.0, 1.0) * rumble_envelope * 0.38

		# Secondary distant roll echo.
		var echo_t: float = maxf(t - 0.18, 0.0)
		var echo: float = 0.0
		if echo_t > 0.0:
			var echo_env: float = exp(-echo_t * 1.1) * 0.45
			echo = (
				sin(echo_t * TAU * 35.0) * 0.25 + rng.randf_range(-1.0, 1.0) * 0.2
			) * echo_env

		var mono: float = (crack + rumble_tone + roll_noise + echo) * lerpf(0.65, 1.0, charge)
		var left_i: int = int(clampf(mono * 32000.0 * left_master, -32000.0, 32000.0))
		var right_i: int = int(clampf(mono * 32000.0 * right_master, -32000.0, 32000.0))
		data[i * 4] = left_i & 0xFF
		data[i * 4 + 1] = (left_i >> 8) & 0xFF
		data[i * 4 + 2] = right_i & 0xFF
		data[i * 4 + 3] = (right_i >> 8) & 0xFF

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = true
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = data
	return stream
