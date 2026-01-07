# Organize grenade sounds from mp3_deposit to weapon folders
# Creates grenade folders and moves/copies grenade sounds

$mp3Deposit = "mp3_deposit"
$weaponsDir = "public\weapons"

Write-Host "========================================"
Write-Host "Organizing Grenade and Flare Sounds"
Write-Host "========================================"
Write-Host ""

# Grenade types and their sound mappings
$grenades = @(
    @{ id = 'f-1'; name = 'F-1 Grenade'; sounds = @('tarkov_grenade_frag_*.mp3', 'tarkov_grenade_landing_boom.mp3', 'tarkov_grenade_impact_landing.mp3') },
    @{ id = 'rgd-5'; name = 'RGD-5 Grenade'; sounds = @('tarkov_grenade_frag_*.mp3', 'tarkov_grenade_landing_boom.mp3') },
    @{ id = 'm67'; name = 'M67 Grenade'; sounds = @('tarkov_grenade_frag_*.mp3', 'tarkov_grenade_landing_boom.mp3') },
    @{ id = 'zarya'; name = 'Zarya Flashbang'; sounds = @('tarkov_grenade_flash_.mp3') },
    @{ id = 'flash-grenade'; name = 'Flash Grenade'; sounds = @('tarkov_grenade_flash_.mp3') },
    @{ id = 'smoke-grenade'; name = 'Smoke Grenade'; sounds = @('tarkov_grenade_smoke.mp3') },
    @{ id = 'flare'; name = 'Flare'; sounds = @() },
    @{ id = 'red-flare'; name = 'Red Flare'; sounds = @() },
    @{ id = 'green-flare'; name = 'Green Flare'; sounds = @() },
    @{ id = 'white-flare'; name = 'White Flare'; sounds = @() }
)

foreach ($grenade in $grenades) {
    $grenadeId = $grenade.id
    $grenadeFolder = Join-Path $weaponsDir $grenadeId
    
    # Create grenade folder structure
    if (-not (Test-Path $grenadeFolder)) {
        New-Item -ItemType Directory -Path $grenadeFolder | Out-Null
    }
    
    $closeFolder = Join-Path $grenadeFolder "close"
    $mediumFolder = Join-Path $grenadeFolder "medium"
    $farFolder = Join-Path $grenadeFolder "far"
    
    if (-not (Test-Path $closeFolder)) {
        New-Item -ItemType Directory -Path $closeFolder | Out-Null
    }
    if (-not (Test-Path $mediumFolder)) {
        New-Item -ItemType Directory -Path $mediumFolder | Out-Null
    }
    if (-not (Test-Path $farFolder)) {
        New-Item -ItemType Directory -Path $farFolder | Out-Null
    }
    
    Write-Host "Created folder structure for: $($grenade.name)"
    
    # Copy matching sounds to medium folder (default location)
    if ($grenade.sounds.Count -gt 0) {
        foreach ($soundPattern in $grenade.sounds) {
            $soundFiles = Get-ChildItem -Path $mp3Deposit -Filter $soundPattern -ErrorAction SilentlyContinue
            foreach ($soundFile in $soundFiles) {
                $destPath = Join-Path $mediumFolder $soundFile.Name
                if (-not (Test-Path $destPath)) {
                    Copy-Item -Path $soundFile.FullName -Destination $destPath
                    Write-Host "  Copied: $($soundFile.Name) -> $grenadeId/medium/"
                }
            }
        }
    }
}

# Also copy general grenade sounds that can be used for multiple types
$generalGrenadeSounds = @(
    'tarkov_grenade_pin_pull.mp3',
    'tarkov_grenade_pin_pull_only.mp3',
    'tarkov_grenade_pull_drop.mp3',
    'tarkov_grenade_landing_clunk.mp3',
    'tarkov_grenade_landing_only.mp3'
)

Write-Host ""
Write-Host "Copying general grenade sounds..."
foreach ($soundName in $generalGrenadeSounds) {
    $sourceFile = Join-Path $mp3Deposit $soundName
    if (Test-Path $sourceFile) {
        # Copy to f-1, rgd-5, and m67 medium folders
        foreach ($grenadeId in @('f-1', 'rgd-5', 'm67')) {
            $destFolder = Join-Path (Join-Path $weaponsDir $grenadeId) "medium"
            $destPath = Join-Path $destFolder $soundName
            if (-not (Test-Path $destPath)) {
                Copy-Item -Path $sourceFile -Destination $destPath
                Write-Host "  Copied: $soundName -> $grenadeId/medium/"
            }
        }
    }
}

Write-Host ""
Write-Host "========================================"
Write-Host "Organization Complete!"
Write-Host "========================================"
Write-Host ""


