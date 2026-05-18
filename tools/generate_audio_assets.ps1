# Generate louder storm audio WAV files for StormGame.
$ErrorActionPreference = "Stop"
$SampleRate = 22050
$OutDir = Join-Path $PSScriptRoot "..\Audio"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

function Write-WavFile {
    param([string]$Path, [float[]]$Samples)
    $path = [System.IO.Path]::GetFullPath($Path)
    $count = $Samples.Length
    $byteCount = 44 + ($count * 2)
    $bytes = New-Object byte[] $byteCount
    $encoding = [System.Text.Encoding]::ASCII
    [void]$encoding.GetBytes("RIFF").CopyTo($bytes, 0)
    [BitConverter]::GetBytes([int]($byteCount - 8)).CopyTo($bytes, 4)
    [void]$encoding.GetBytes("WAVEfmt ").CopyTo($bytes, 8)
    [BitConverter]::GetBytes([int]16).CopyTo($bytes, 16)
    [BitConverter]::GetBytes([Int16]1).CopyTo($bytes, 20)
    [BitConverter]::GetBytes([Int16]1).CopyTo($bytes, 22)
    [BitConverter]::GetBytes([int]$SampleRate).CopyTo($bytes, 24)
    [BitConverter]::GetBytes([int]($SampleRate * 2)).CopyTo($bytes, 28)
    [BitConverter]::GetBytes([Int16]2).CopyTo($bytes, 32)
    [BitConverter]::GetBytes([Int16]16).CopyTo($bytes, 34)
    [void]$encoding.GetBytes("data").CopyTo($bytes, 36)
    [BitConverter]::GetBytes([int]($count * 2)).CopyTo($bytes, 40)
    for ($i = 0; $i -lt $count; $i++) {
        $clamped = [Math]::Max(-1.0, [Math]::Min(1.0, $Samples[$i]))
        $sample = [int]($clamped * 30000)
        [BitConverter]::GetBytes([Int16]$sample).CopyTo($bytes, 44 + ($i * 2))
    }
    [System.IO.File]::WriteAllBytes($path, $bytes)
    Write-Host "Wrote $([System.IO.Path]::GetFileName($path))"
}

function Get-PinkNoise {
    param([int]$Length, [int]$Seed = 7)
    $rng = [System.Random]::new($Seed)
    $rows = @(0.0) * 7
    $out = New-Object float[] $Length
    for ($i = 0; $i -lt $Length; $i++) {
        $white = ($rng.NextDouble() * 2.0) - 1.0
        $rows[0] = 0.99886 * $rows[0] + $white * 0.0555179
        $rows[1] = 0.99332 * $rows[1] + $white * 0.0750759
        $rows[2] = 0.96900 * $rows[2] + $white * 0.1538520
        $rows[3] = 0.86650 * $rows[3] + $white * 0.3104856
        $rows[4] = 0.55000 * $rows[4] + $white * 0.5329522
        $rows[5] = -0.7616 * $rows[5] - $white * 0.0168980
        $pink = $rows[0] + $rows[1] + $rows[2] + $rows[3] + $rows[4] + $rows[5] + $rows[6] + $white * 0.5362
        $rows[6] = $white * 0.115926
        $out[$i] = $pink * 0.28
    }
    return $out
}

function New-Rain {
    $len = [int]($SampleRate * 2.4)
    $base = Get-PinkNoise -Length $len -Seed 11
    for ($i = 0; $i -lt $len; $i++) {
        $t = $i / $SampleRate
        $base[$i] *= (0.65 + 0.35 * [Math]::Sin($t * 14.0)) * (0.7 + 0.3 * [Math]::Sin($t * 3.0))
    }
    return $base
}

function New-Wind {
    $len = [int]($SampleRate * 3.0)
    $out = New-Object float[] $len
    for ($i = 0; $i -lt $len; $i++) {
        $t = $i / $SampleRate
        $gust = 0.5 + 0.5 * [Math]::Sin($t * 0.42 + [Math]::Sin($t * 0.09) * 2.0)
        $noise = (Get-PinkNoise -Length 1 -Seed ($i % 997))[0]
        $tone = [Math]::Sin($t * 28.0) * 0.06
        $out[$i] = ($noise * $gust + $tone) * 0.38
    }
    return $out
}

function New-Hum {
    $len = [int]($SampleRate * 2.8)
    $out = New-Object float[] $len
    for ($i = 0; $i -lt $len; $i++) {
        $t = $i / $SampleRate
        $tone = [Math]::Sin($t * 42.0) * 0.12 + [Math]::Sin($t * 84.0) * 0.05
        $noise = (Get-PinkNoise -Length 1 -Seed (($i * 3) % 991))[0] * 0.08
        $out[$i] = ($tone + $noise) * (0.75 + 0.25 * [Math]::Sin($t * 0.7))
    }
    return $out
}

function New-Thunder {
    $len = [int]($SampleRate * 1.1)
    $out = New-Object float[] $len
    $rng = [System.Random]::new(42)
    $duration = $len / $SampleRate
    for ($i = 0; $i -lt $len; $i++) {
        $t = $i / $SampleRate
        $crack = if ($t -lt 0.04) { [Math]::Exp(-$t * 120.0) } else { 0.0 }
        $rumble = [Math]::Exp(-$t * 3.2) * [Math]::Sin($t * 38.0) * 0.55
        $noise = (($rng.NextDouble() * 2.0) - 1.0) * [Math]::Exp(-$t * 5.0)
        $out[$i] = ($noise * 0.45 + $rumble + $crack * 0.9) * (1.0 - $t / $duration)
    }
    return $out
}

Write-WavFile (Join-Path $OutDir "rain_loop.wav") (New-Rain)
Write-WavFile (Join-Path $OutDir "wind_loop.wav") (New-Wind)
Write-WavFile (Join-Path $OutDir "storm_hum_loop.wav") (New-Hum)
Write-WavFile (Join-Path $OutDir "thunder_hit.wav") (New-Thunder)
Write-Host "Done. Reimport Audio folder in Godot."
