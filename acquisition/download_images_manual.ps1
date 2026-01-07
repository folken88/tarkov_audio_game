# Manual image download script
# Add image URLs to the hashtable below, then run this script

$ErrorActionPreference = "Stop"

$weaponsDir = "public\weapons"
$wikiBase = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images"

# Add image URLs here as you find them
# Format: 'weapon-id' = 'path/filename.png'
$imageUrls = @{
    'ak-74n' = '8/84/Akn.png'
    'akm' = '0/0f/Akm.png'
    'mp5' = '5/54/Mp5.png'
    # Add more here...
}

Write-Host "Downloading $($imageUrls.Count) images..." -ForegroundColor Cyan

foreach ($weaponId in $imageUrls.Keys) {
    $folder = Join-Path $weaponsDir $weaponId
    $output = Join-Path $folder "image.png"
    
    if (Test-Path $output) {
        Write-Host "✓ $weaponId (exists)" -ForegroundColor Green
        continue
    }
    
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    
    $url = "$wikiBase/$($imageUrls[$weaponId])/revision/latest/scale-to-width-down/320?cb=20240101"
    
    try {
        Write-Host "Downloading $weaponId..." -NoNewline
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing -TimeoutSec 10
        Write-Host " ✓" -ForegroundColor Green
    } catch {
        Write-Host " ✗ ($($_.Exception.Message))" -ForegroundColor Red
    }
}

Write-Host "`nDone!" -ForegroundColor Cyan


