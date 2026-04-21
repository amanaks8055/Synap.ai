$ErrorActionPreference = 'Stop'

function Check-ImageSize {
    param(
        [string]$Path,
        [int]$ExpectedWidth,
        [int]$ExpectedHeight,
        [switch]$AllowLarger,
        [string]$Label
    )

    if (!(Test-Path $Path)) {
        Write-Output "MISSING: $Label -> $Path"
        return
    }

    Add-Type -AssemblyName System.Drawing
    $img = [System.Drawing.Image]::FromFile((Resolve-Path $Path))
    try {
        $w = $img.Width
        $h = $img.Height
        if ($AllowLarger) {
            if ($w -ge $ExpectedWidth -and $h -ge $ExpectedHeight) {
                Write-Output "OK: $Label -> ${w}x${h}"
            } else {
                Write-Output "FAIL: $Label -> ${w}x${h} (need at least ${ExpectedWidth}x${ExpectedHeight})"
            }
        } else {
            if ($w -eq $ExpectedWidth -and $h -eq $ExpectedHeight) {
                Write-Output "OK: $Label -> ${w}x${h}"
            } else {
                Write-Output "FAIL: $Label -> ${w}x${h} (need exact ${ExpectedWidth}x${ExpectedHeight})"
            }
        }
    } finally {
        $img.Dispose()
    }
}

Write-Output "=== Synap Play Store Asset QC ==="

$aab = "build/app/outputs/bundle/release/app-release.aab"
if (Test-Path $aab) {
    $sizeMb = [Math]::Round((Get-Item $aab).Length / 1MB, 2)
    Write-Output "OK: AAB -> $aab (${sizeMb} MB)"
} else {
    Write-Output "MISSING: AAB -> $aab"
}

Check-ImageSize -Path "web/icons/Icon-512.png" -ExpectedWidth 512 -ExpectedHeight 512 -Label "Play Icon"
Check-ImageSize -Path "assets/store/feature-graphic-1024x500.png" -ExpectedWidth 1024 -ExpectedHeight 500 -Label "Feature Graphic"

$screenshotDir = "assets/store/screenshots"
if (!(Test-Path $screenshotDir)) {
    Write-Output "MISSING: Screenshot folder -> $screenshotDir"
} else {
    $shots = Get-ChildItem $screenshotDir -File | Where-Object { $_.Extension -match "(?i)\.(png|jpg|jpeg)$" }
    if ($shots.Count -lt 2) {
        Write-Output "FAIL: Screenshots -> found $($shots.Count), need at least 2"
    } else {
        Write-Output "OK: Screenshots count -> $($shots.Count)"
    }

    foreach ($s in $shots) {
        Check-ImageSize -Path $s.FullName -ExpectedWidth 1080 -ExpectedHeight 1920 -AllowLarger -Label "Screenshot $($s.Name)"
    }
}

Write-Output "=== QC Complete ==="
