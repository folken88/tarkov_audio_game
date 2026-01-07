# Simple script to download weapon images - runs quickly and shows progress
# Add image URLs to the $imageUrls hashtable as you find them

$ErrorActionPreference = "Continue"

$weaponsDir = "public\weapons"
$wikiBase = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images"

# Known image URLs (add more as you find them)
# Format: weapon-id = "path/filename.png"
$imageUrls = @{
    'ak-74n' = '8/84/Akn.png'
    'akm' = '0/0f/Akm.png'
    'mp5' = '5/54/Mp5.png'
    'fn57' = '1/13/FN57Image.png'
    'mp-133' = '3/3b/Mp133.png'
}

Write-Host "Downloading weapon images..." -ForegroundColor Cyan
Write-Host ""

$success = 0
$failed = 0
$skipped = 0

foreach ($weaponId in $imageUrls.Keys) {
    $folder = Join-Path $weaponsDir $weaponId
    $output = Join-Path $folder "image.png"
    
    if (Test-Path $output) {
        Write-Host "[SKIP] $weaponId" -ForegroundColor Yellow
        $skipped++
        continue
    }
    
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
    
    $imagePath = $imageUrls[$weaponId]
    $url = "$wikiBase/$imagePath/revision/latest/scale-to-width-down/320?cb=20240101"
    
    try {
        Write-Host "[DL] $weaponId..." -NoNewline
        Invoke-WebRequest -Uri $url -OutFile $output -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop | Out-Null
        
        if ((Get-Item $output).Length -gt 0) {
            Write-Host " OK" -ForegroundColor Green
            $success++
        } else {
            Remove-Item $output -Force
            Write-Host " FAIL (empty)" -ForegroundColor Red
            $failed++
        }
    } catch {
        Write-Host " FAIL" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "Done: $success success, $failed failed, $skipped skipped" -ForegroundColor Cyan


