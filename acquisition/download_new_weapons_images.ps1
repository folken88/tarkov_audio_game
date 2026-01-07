# Download images for new weapons: NL545 GP and Marlin MXLR
# These are new weapons from the latest Tarkov patch

$ErrorActionPreference = "Stop"

$weaponsDir = "public\weapons"
$wikiBase = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images"

# Image URLs for new weapons
# Format: 'weapon-id' = 'path/filename.png'
# You'll need to visit the wiki pages and get the actual image paths
$imageUrls = @{
    'nl545-gp' = ''  # TODO: Get from https://escapefromtarkov.fandom.com/wiki/NL545_(GP)
    'marlin-mxlr' = ''  # TODO: Get from https://escapefromtarkov.fandom.com/wiki/Marlin_MXLR
}

Write-Host "Downloading images for new weapons..." -ForegroundColor Cyan
Write-Host ""
Write-Host "NOTE: You need to visit the wiki pages and get the image URLs first!" -ForegroundColor Yellow
Write-Host "  - NL545 GP: https://escapefromtarkov.fandom.com/wiki/NL545_(GP)" -ForegroundColor Yellow
Write-Host "  - Marlin MXLR: https://escapefromtarkov.fandom.com/wiki/Marlin_MXLR" -ForegroundColor Yellow
Write-Host ""

foreach ($weaponId in $imageUrls.Keys) {
    $imagePath = $imageUrls[$weaponId]
    
    if ([string]::IsNullOrEmpty($imagePath)) {
        Write-Host "[SKIP] $weaponId - No image URL provided" -ForegroundColor Yellow
        continue
    }
    
    $folder = Join-Path $weaponsDir $weaponId
    $output = Join-Path $folder "image.png"
    
    if (Test-Path $output) {
        Write-Host "✓ $weaponId (exists)" -ForegroundColor Green
        continue
    }
    
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    
    $url = "$wikiBase/$imagePath/revision/latest/scale-to-width-down/320?cb=20240101"
    
    try {
        Write-Host "Downloading $weaponId..." -NoNewline
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing -TimeoutSec 10
        Write-Host " ✓" -ForegroundColor Green
    } catch {
        Write-Host " ✗ ($($_.Exception.Message))" -ForegroundColor Red
    }
}

Write-Host "`nDone!" -ForegroundColor Cyan
Write-Host ""
Write-Host "To get image URLs:" -ForegroundColor Cyan
Write-Host "1. Visit the weapon's wiki page" -ForegroundColor White
Write-Host "2. Right-click the main weapon image" -ForegroundColor White
Write-Host "3. Copy image address" -ForegroundColor White
Write-Host "4. Extract the path part (between /images/ and /revision/)" -ForegroundColor White
Write-Host "5. Add it to the `$imageUrls hashtable above" -ForegroundColor White










