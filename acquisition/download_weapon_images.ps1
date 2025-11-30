# PowerShell script to download weapon images from Tarkov Wiki
# This script downloads images for weapons that have audio files

$ErrorActionPreference = "Stop"

# Create images directory
$imagesDir = "public\images\weapons"
if (-not (Test-Path $imagesDir)) {
    New-Item -ItemType Directory -Path $imagesDir -Force | Out-Null
    Write-Host "Created directory: $imagesDir"
}

# Map of weapon IDs to their actual wiki image URLs
# These URLs are found by visiting each weapon's wiki page and getting the main image
$weaponImageUrls = @{
    'ak-50' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/3/38/AK-50_View.png/revision/latest/scale-to-width-down/320?cb=20250716225603'
    'ak-103' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/e/e1/AK-103_7.62x39.png/revision/latest/scale-to-width-down/320?cb=20231017095145'
    'm4a1' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/2/29/M4a1.png/revision/latest/scale-to-width-down/320?cb=20231017102422'
    'glock-18c' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/8/81/Glock18CImage.png/revision/latest/scale-to-width-down/320?cb=20231025015040'
    'm700' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/2/26/M700Image.png/revision/latest/scale-to-width-down/320?cb=20240826190338'
    'mdr-308' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/3/33/DT_MDR_308.png/revision/latest/scale-to-width-down/320?cb=20240826170129'
    'mk47' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/6/68/Mk47_Mutant_View.png/revision/latest/scale-to-width-down/320?cb=20231017102438'
    'mosin' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/d/d4/MosinInfantryImage.png/revision/latest/scale-to-width-down/320?cb=20231025174305'
    'mp-153' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/3/3b/Mp153.png/revision/latest/scale-to-width-down/320?cb=20231025194415'
    'p90' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/6/6c/P90Image.png/revision/latest/scale-to-width-down/320?cb=20240826192501'
    'fn57' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/1/13/FN57Image.png/revision/latest/scale-to-width-down/320?cb=20231017095739'
    'rsh12' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/c/cb/RSh-12_Image.png/revision/latest/scale-to-width-down/320?cb=20240826165042'
    'ash-12' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/f/f1/ASh_12.png/revision/latest/scale-to-width-down/320?cb=20231025175418'
    'sv-98' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/7/7d/Sv98.png/revision/latest/scale-to-width-down/320?cb=20231025174330'
    'svd' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/8/8f/SVD-S.png/revision/latest/scale-to-width-down/320?cb=20231025180009'
    't-5000' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/e/ea/T-5000_View.png/revision/latest/scale-to-width-down/320?cb=20240826190557'
    'sr-25' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/6/69/SR-25_View.png/revision/latest/scale-to-width-down/320?cb=20231025180001'
    'rsass' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/9/9b/Rsass.png/revision/latest/scale-to-width-down/320?cb=20231025175418'
    'saiga-12k' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/c/cd/Saiga12.png/revision/latest/scale-to-width-down/320?cb=20231025194441'
    'tt' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/1/1b/Tt.png/revision/latest/scale-to-width-down/320?cb=20231025022625'
    'dvl-10' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/6/6c/Dvl10.png/revision/latest/scale-to-width-down/320?cb=20231025174246'
    'scar-h' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/a/a8/ScarH_Image.gif/revision/latest/scale-to-width-down/320?cb=20231017091930'
    'rfb' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/6/68/KT_RFB.png/revision/latest/scale-to-width-down/320?cb=20231017104710'
    'vpo-209' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/b/b0/Vpo209.png/revision/latest/scale-to-width-down/320?cb=20231017104859'
    # Newly found URLs
    '9a-91' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/6/64/Kbp_9a91_car.png/revision/latest/scale-to-width-down/320?cb=20240101214721'
    'as-val-mod4' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/0/08/VAL_MOD_4_Image.png/revision/latest/scale-to-width-down/320?cb=20251125152525'
    'avt-40' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/3/3b/AVT-40_STD_Image.png/revision/latest/scale-to-width-down/320?cb=20231017104644'
    'op-sks' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/0/08/Opsks.png/revision/latest/scale-to-width-down/320?cb=20240121193821'
    'sag-ak' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/1/19/SAG.545.png/revision/latest/scale-to-width-down/320?cb=20231017104753'
    'sks' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/7/72/Sks.png/revision/latest/scale-to-width-down/320?cb=20240101215301'
    'sr-3m' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/2/23/SR-3M_Image.png/revision/latest/scale-to-width-down/320?cb=20240825190337'
}

Write-Host "Downloading weapon images from Tarkov Wiki..." -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$failCount = 0

foreach ($weaponId in $weaponImageUrls.Keys) {
    $url = $weaponImageUrls[$weaponId]
    # Handle .gif files (like scar-h)
    $extension = if ($url -match '\.gif') { '.gif' } else { '.png' }
    $outputFile = Join-Path $imagesDir "$weaponId$extension"
    
    try {
        Write-Host "Downloading $weaponId..." -NoNewline
        
        # Download the image
        Invoke-WebRequest -Uri $url -OutFile $outputFile -UseBasicParsing -ErrorAction Stop
        
        if (Test-Path $outputFile) {
            $fileSize = (Get-Item $outputFile).Length
            if ($fileSize -gt 0) {
                $sizeKB = [math]::Round($fileSize/1KB, 1)
                Write-Host " [OK] ($sizeKB KB)" -ForegroundColor Green
                $successCount++
            } else {
                Write-Host " [FAIL] (empty file)" -ForegroundColor Red
                Remove-Item $outputFile -Force
                $failCount++
            }
        } else {
            Write-Host " [FAIL] (file not created)" -ForegroundColor Red
            $failCount++
        }
    } catch {
        Write-Host " [FAIL] (error: $($_.Exception.Message))" -ForegroundColor Red
        $failCount++
    }
}

Write-Host ""
Write-Host "Download complete!" -ForegroundColor Cyan
Write-Host "  Success: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })

