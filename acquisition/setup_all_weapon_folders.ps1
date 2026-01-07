# Tarkov Weapon Folder Setup
# Creates weapon folders for ALL weapons in weapons.js
# Each folder will have: image, close/, medium/, far/

$weaponsDir = "public\weapons"

# Ensure base directory exists
if (-not (Test-Path $weaponsDir)) {
    New-Item -ItemType Directory -Path $weaponsDir | Out-Null
}

Write-Host "========================================"
Write-Host "Tarkov Weapon Folder Setup"
Write-Host "========================================"
Write-Host "Creating weapon folders with close/medium/far structure..."
Write-Host ""

# Read weapons.js and extract weapon IDs
$weaponsJsPath = "public\js\weapons.js"
$content = Get-Content $weaponsJsPath -Raw

# Extract all weapon IDs using regex (pattern: { id: 'weapon-id', name: 'Name' })
$pattern = "id:\s*['""]([^'""]+)['""]"
$matches = [regex]::Matches($content, $pattern)

$createdCount = 0
$renamedCount = 0

foreach ($match in $matches) {
    $weaponId = $match.Groups[1].Value
    
    if ($weaponId) {
        $weaponPath = Join-Path $weaponsDir $weaponId
        
        # Create weapon folder
        if (-not (Test-Path $weaponPath)) {
            New-Item -ItemType Directory -Path $weaponPath | Out-Null
        }
        
        # Create audio subfolders (close, medium, far)
        $closePath = Join-Path $weaponPath "close"
        $mediumPath = Join-Path $weaponPath "medium"
        $farPath = Join-Path $weaponPath "far"
        
        if (-not (Test-Path $closePath)) {
            New-Item -ItemType Directory -Path $closePath | Out-Null
        }
        if (-not (Test-Path $mediumPath)) {
            New-Item -ItemType Directory -Path $mediumPath | Out-Null
        }
        if (-not (Test-Path $farPath)) {
            New-Item -ItemType Directory -Path $farPath | Out-Null
        }
        
        # If long folder exists, rename it to far
        $longPath = Join-Path $weaponPath "long"
        if (Test-Path $longPath) {
            if (Test-Path $farPath) {
                # Merge contents from long to far
                $longFiles = Get-ChildItem -Path $longPath -File
                foreach ($file in $longFiles) {
                    Move-Item -Path $file.FullName -Destination $farPath -Force
                }
                Remove-Item -Path $longPath -Force
                Write-Host "Merged long into far: $weaponId"
                $renamedCount++
            } else {
                Move-Item -Path $longPath -Destination $farPath -Force
                Write-Host "Renamed long to far: $weaponId"
                $renamedCount++
            }
        }
        
        $createdCount++
        Write-Host "Created: $weaponId"
    }
}

Write-Host ""
Write-Host "========================================"
Write-Host "Setup Complete!"
Write-Host "========================================"
Write-Host "Created/updated $createdCount weapon folders"
if ($renamedCount -gt 0) {
    Write-Host "Renamed $renamedCount 'long' folders to 'far'"
}
Write-Host ""
Write-Host "Weapon structure: public\weapons\{weapon-id}\"
Write-Host "  - image.png or image.gif (add your images here)"
Write-Host "  - close\ (add close range sounds here)"
Write-Host "  - medium\ (add medium range sounds here)"
Write-Host "  - far\ (add far range sounds here)"
Write-Host ""

