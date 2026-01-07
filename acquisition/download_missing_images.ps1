# PowerShell script to download missing weapon images from Tarkov Wiki
# Downloads static PNG images (no animated GIFs) for weapons we have but are missing images

$ErrorActionPreference = "Continue"

# Base URL for Tarkov Wiki images
$wikiBase = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images"

# Map of weapon IDs to their wiki image URLs
# Format: weapon-id = "image-path/filename.png"
# These URLs are extracted from the wiki pages
$weaponImageUrls = @{
    # Found from browser inspection
    'ak-74n' = '8/84/Akn.png'
    'akm' = '0/0f/Akm.png'
    'mp5' = '5/54/Mp5.png'
    
    # From existing download script (need to verify these work)
    'fn57' = '1/13/FN57Image.png'
    'mp-133' = '3/3b/Mp133.png'
    
    # Need to find these manually - placeholder pattern
    # Most follow pattern: {hash}/{WeaponName}.png or {hash}/{WeaponName}_Image.png
}

Write-Host "========================================"
Write-Host "Downloading Missing Weapon Images"
Write-Host "========================================"
Write-Host ""

$weaponsDir = "public\weapons"
$successCount = 0
$failCount = 0
$skipCount = 0

# List of weapons missing images (from MISSING_IMAGES_LIST.md)
$missingWeapons = @(
    'adar-2-15', 'sag-ak-short', 'ak-74n', 'ak-74m', 'ak-101', 'ak-102', 'ak-104', 'ak-105',
    'ak-12', 'ak-15', 'akm', 'akmn', 'akms', 'akmsn', 'hk416a5', 'sa-58', 'scar-l', 'scar-h',
    'tx-15', 'rd-704', 'mdr-556', 'm700-tac', 'm700-sass', 'm700-ultra', 'axmc', 'svds', 'vss',
    'as-val', 'm1a', 'm1a-sass', 'rpk-16', 'pkp', 'pkm', 'm249', 'm240b', 'mp-133', 'mp-155',
    'mp-18', 'toz-106', 'remington-870', 'm1014', 'm590a1', 'mp5', 'mp5k', 'mp5sd', 'mp7', 'mp9',
    'pp-19-01', 'pp-91', 'pp-91-01', 'ppsh-41', 'ump45', 'saiga-9', 'stm-9', 'sr-2m', 'pm',
    'p226', 'glock-17', 'm9a3', 'm1911a1', 'fn57', 'apb', 'aps', 'sr1mp'
)

foreach ($weaponId in $missingWeapons) {
    $weaponFolder = Join-Path $weaponsDir $weaponId
    $outputFile = Join-Path $weaponFolder "image.png"
    
    # Check if image already exists
    if (Test-Path $outputFile) {
        Write-Host "Skipping $weaponId (image already exists)" -ForegroundColor Yellow
        $skipCount++
        continue
    }
    
    # Ensure weapon folder exists
    if (-not (Test-Path $weaponFolder)) {
        New-Item -ItemType Directory -Path $weaponFolder -Force | Out-Null
    }
    
    # Get image URL
    $url = $null
    if ($weaponImageUrls.ContainsKey($weaponId)) {
        $imagePath = $weaponImageUrls[$weaponId]
        $url = "$wikiBase/$imagePath/revision/latest/scale-to-width-down/320?cb=20240101"
    } else {
        Write-Host "⚠️  $weaponId - Image URL not found in map" -ForegroundColor Yellow
        Write-Host "   Visit: https://escapefromtarkov.fandom.com/wiki/$($weaponId -replace '-', '_')" -ForegroundColor Cyan
        Write-Host "   Right-click image > Copy image address, then add to weaponImageUrls hashtable" -ForegroundColor Cyan
        $failCount++
        continue
    }
    
    # Download the image
    try {
        Write-Host "Downloading $weaponId..." -NoNewline
        
        Invoke-WebRequest -Uri $url -OutFile $outputFile -UseBasicParsing -ErrorAction Stop -TimeoutSec 30
        
        if (Test-Path $outputFile) {
            $fileSize = (Get-Item $outputFile).Length
            if ($fileSize -gt 0) {
                $sizeKB = [math]::Round($fileSize/1KB, 1)
                Write-Host " [OK] ($sizeKB KB)" -ForegroundColor Green
                $successCount++
            } else {
                Remove-Item $outputFile -Force
                Write-Host " [FAIL] (empty file)" -ForegroundColor Red
                $failCount++
            }
        } else {
            Write-Host " [FAIL] (file not created)" -ForegroundColor Red
            $failCount++
        }
    } catch {
        Write-Host " [FAIL] ($($_.Exception.Message))" -ForegroundColor Red
        if (Test-Path $outputFile) {
            Remove-Item $outputFile -Force -ErrorAction SilentlyContinue
        }
        $failCount++
    }
    
    # Small delay to avoid rate limiting
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "========================================"
Write-Host "Download Summary"
Write-Host "========================================"
Write-Host "  Success: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })
Write-Host "  Skipped: $skipCount" -ForegroundColor Yellow
Write-Host ""
Write-Host "For weapons that failed, you need to:"
Write-Host "1. Visit the weapon's wiki page"
Write-Host "2. Right-click the main weapon image"
Write-Host "3. Select 'Copy image address'"
Write-Host "4. Extract the path (e.g., '8/84/Akn.png' from the full URL)"
Write-Host "5. Add it to the weaponImageUrls hashtable in this script"
Write-Host "6. Re-run the script"
Write-Host ""


