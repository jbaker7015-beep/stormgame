#!/usr/bin/env python3
"""Generate lightweight loopable storm audio WAV files for StormGame."""

from __future__ import annotations

import math
import random
import struct
import wave
from pathlib import Path

SAMPLE_RATE = 22050
OUTPUT_DIR = Path(__file__).resolve().parents[1] / "Audio"


def write_wav(path: Path, samples: list[float], loop: bool = True) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(path), "w") as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(SAMPLE_RATE)
        frames = bytearray()
        for sample in samples:
            value = int(max(-1.0, min(1.0, sample)) * 32000)
            frames.extend(struct.pack("<h", value))
        wav_file.writeframes(frames)
    print(f"Wrote {path.name} ({len(samples) / SAMPLE_RATE:.2f}s, loop={loop})")


def pink_noise(length: int, seed: int = 7) -> list[float]:
    rng = random.Random(seed)
    rows = [0.0] * 7
    out: list[float] = []
    for _ in range(length):
        white = rng.uniform(-1.0, 1.0)
        rows[0] = 0.99886 * rows[0] + white * 0.0555179
        rows[1] = 0.99332 * rows[1] + white * 0.0750759
        rows[2] = 0.96900 * rows[2] + white * 0.1538520
        rows[3] = 0.86650 * rows[3] + white * 0.3104856
        rows[4] = 0.55000 * rows[4] + white * 0.5329522
        rows[5] = -0.7616 * rows[5] - white * 0.0168980
        pink = rows[0] + rows[1] + rows[2] + rows[3] + rows[4] + rows[5] + rows[6] + white * 0.5362
        rows[6] = white * 0.115926
        out.append(pink * 0.11)
    return out


def make_loop(seconds: float, generator) -> list[float]:
    length = int(SAMPLE_RATE * seconds)
    return generator(length)


def gen_rain(length: int) -> list[float]:
    base = pink_noise(length, seed=11)
    return [s * (0.55 + 0.45 * math.sin(i * 0.017)) for i, s in enumerate(base)]


def gen_wind(length: int) -> list[float]:
    samples: list[float] = []
    for i in range(length):
        t = i / SAMPLE_RATE
        gust = 0.45 + 0.55 * math.sin(t * 0.55 + math.sin(t * 0.13) * 1.8)
        noise = pink_noise(1, seed=i % 997)[0]
        tone = math.sin(t * 42.0) * 0.04
        samples.append((noise * gust + tone) * 0.14)
    return samples


def gen_hum(length: int) -> list[float]:
    samples: list[float] = []
    for i in range(length):
        t = i / SAMPLE_RATE
        tone = math.sin(t * 58.0) * 0.05 + math.sin(t * 116.0) * 0.025
        noise = pink_noise(1, seed=(i * 3) % 991)[0] * 0.04
        samples.append((tone + noise) * (0.7 + 0.3 * math.sin(t * 0.9)))
    return samples


def gen_thunder(length: int) -> list[float]:
    samples: list[float] = []
    duration = length / SAMPLE_RATE
    for i in range(length):
        t = i / SAMPLE_RATE
        envelope = math.exp(-t * 7.0) * max(0.0, 1.0 - t / duration)
        noise = random.uniform(-1.0, 1.0)
        rumble = math.sin(t * 48.0) * 0.25
        samples.append((noise * 0.75 + rumble) * envelope * 0.9)
    return samples


def main() -> None:
    write_wav(OUTPUT_DIR / "rain_loop.wav", make_loop(2.4, gen_rain))
    write_wav(OUTPUT_DIR / "wind_loop.wav", make_loop(3.0, gen_wind))
    write_wav(OUTPUT_DIR / "storm_hum_loop.wav", make_loop(2.8, gen_hum))
    write_wav(OUTPUT_DIR / "thunder_hit.wav", make_loop(0.55, gen_thunder), loop=False)
    print("Done.")


if __name__ == "__main__":
    main()
