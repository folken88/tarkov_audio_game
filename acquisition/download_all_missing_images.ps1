# PowerShell script to download ALL missing weapon images from Tarkov Wiki
# Downloads static PNG images (no animated GIFs) and saves to weapon folders

$ErrorActionPreference = "Continue"

# Base URL pattern for Tarkov Wiki images
$wikiBaseUrl = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images"

# Map of weapon IDs to their wiki image file names and paths
# Format: weapon-id = @{filename="ImageName.png", path="path/to/image"}
# These are based on the Tarkov Wiki structure
$weaponImageMap = @{
    # Assault Carbines
    'adar-2-15' = @{filename="ADAR2-15Image.png"; path="a/a8"}
    'sag-ak-short' = @{filename="SAG.545_Short.png"; path="path/to"}
    
    # Assault Rifles
    'ak-74n' = @{filename="AK-74N_Image.png"; path="path/to"}
    'ak-74m' = @{filename="AK-74M_Image.png"; path="path/to"}
    'ak-101' = @{filename="AK-101_Image.png"; path="path/to"}
    'ak-102' = @{filename="AK-102_Image.png"; path="path/to"}
    'ak-104' = @{filename="AK-104_Image.png"; path="path/to"}
    'ak-105' = @{filename="AK-105_Image.png"; path="path/to"}
    'ak-12' = @{filename="AK-12_Image.png"; path="path/to"}
    'ak-15' = @{filename="AK-15_Image.png"; path="path/to"}
    'akm' = @{filename="AKM_Image.png"; path="path/to"}
    'akmn' = @{filename="AKMN_Image.png"; path="path/to"}
    'akms' = @{filename="AKMS_Image.png"; path="path/to"}
    'akmsn' = @{filename="AKMSN_Image.png"; path="path/to"}
    'hk416a5' = @{filename="HK416A5_Image.png"; path="path/to"}
    'sa-58' = @{filename="SA-58_Image.png"; path="path/to"}
    'scar-l' = @{filename="SCAR-L_Image.png"; path="path/to"}
    'scar-h' = @{filename="ScarH_Image.png"; path="a/a8"}  # Convert .gif to .png
    'tx-15' = @{filename="TX-15_Image.png"; path="path/to"}
    'rd-704' = @{filename="RD-704_Image.png"; path="path/to"}
    'mdr-556' = @{filename="MDR_556_Image.png"; path="path/to"}
    
    # Bolt-Action Rifles
    'm700-tac' = @{filename="M700_Tactical_Image.png"; path="path/to"}
    'm700-sass' = @{filename="M700_SASS_Image.png"; path="path/to"}
    'm700-ultra' = @{filename="M700_Ultra_Image.png"; path="path/to"}
    'axmc' = @{filename="AXMC_Image.png"; path="path/to"}
    
    # Designated Marksman Rifles
    'svds' = @{filename="SVDS_Image.png"; path="path/to"}
    'vss' = @{filename="VSS_Image.png"; path="path/to"}
    'as-val' = @{filename="AS_VAL_Image.png"; path="path/to"}
    'm1a' = @{filename="M1A_Image.png"; path="path/to"}
    'm1a-sass' = @{filename="M1A_SASS_Image.png"; path="path/to"}
    
    # Light Machine Guns
    'rpk-16' = @{filename="RPK-16_Image.png"; path="path/to"}
    'pkp' = @{filename="PKP_Image.png"; path="path/to"}
    'pkm' = @{filename="PKM_Image.png"; path="path/to"}
    'm249' = @{filename="M249_Image.png"; path="path/to"}
    'm240b' = @{filename="M240B_Image.png"; path="path/to"}
    
    # Shotguns
    'mp-133' = @{filename="Mp133.png"; path="3/3b"}
    'mp-155' = @{filename="MP-155_Image.png"; path="path/to"}
    'mp-18' = @{filename="MP-18_Image.png"; path="path/to"}
    'toz-106' = @{filename="TOZ-106_Image.png"; path="path/to"}
    'remington-870' = @{filename="Remington_870_Image.png"; path="path/to"}
    'm1014' = @{filename="M1014_Image.png"; path="path/to"}
    'm590a1' = @{filename="M590A1_Image.png"; path="path/to"}
    
    # Submachine Guns
    'mp5' = @{filename="MP5_Image.png"; path="path/to"}
    'mp5k' = @{filename="MP5K_Image.png"; path="path/to"}
    'mp5sd' = @{filename="MP5SD_Image.png"; path="path/to"}
    'mp7' = @{filename="MP7_Image.png"; path="path/to"}
    'mp9' = @{filename="MP9_Image.png"; path="path/to"}
    'pp-19-01' = @{filename="PP-19-01_Image.png"; path="path/to"}
    'pp-91' = @{filename="PP-91_Image.png"; path="path/to"}
    'pp-91-01' = @{filename="PP-91-01_Image.png"; path="path/to"}
    'ppsh-41' = @{filename="PPSh-41_Image.png"; path="path/to"}
    'ump45' = @{filename="UMP-45_Image.png"; path="path/to"}
    'saiga-9' = @{filename="Saiga-9_Image.png"; path="path/to"}
    'stm-9' = @{filename="STM-9_Image.png"; path="path/to"}
    'sr-2m' = @{filename="SR-2M_Image.png"; path="path/to"}
    
    # Pistols
    'pm' = @{filename="PM_Image.png"; path="path/to"}
    'p226' = @{filename="P226_Image.png"; path="path/to"}
    'glock-17' = @{filename="Glock17_Image.png"; path="path/to"}
    'm9a3' = @{filename="M9A3_Image.png"; path="path/to"}
    'm1911a1' = @{filename="M1911A1_Image.png"; path="path/to"}
    'fn57' = @{filename="FN57Image.png"; path="1/13"}
    'apb' = @{filename="APB_Image.png"; path="path/to"}
    'aps' = @{filename="APS_Image.png"; path="path/to"}
    'sr1mp' = @{filename="SR1MP_Image.png"; path="path/to"}
    
    # Grenades & Flares (these may not have standard images on wiki)
    'f-1' = @{filename="F-1_Image.png"; path="path/to"}
    'rgd-5' = @{filename="RGD-5_Image.png"; path="path/to"}
    'm67' = @{filename="M67_Image.png"; path="path/to"}
    'zarya' = @{filename="Zarya_Image.png"; path="path/to"}
    'flash-grenade' = @{filename="Flash_Grenade_Image.png"; path="path/to"}
    'smoke-grenade' = @{filename="Smoke_Grenade_Image.png"; path="path/to"}
}

Write-Host "========================================"
Write-Host "Downloading Missing Weapon Images"
Write-Host "========================================"
Write-Host "This script will attempt to download images from Tarkov Wiki"
Write-Host "Images will be saved as PNG (static, no animations)"
Write-Host ""

$weaponsDir = "public\weapons"
$successCount = 0
$failCount = 0
$skipCount = 0

# Read missing images list
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
    
    # Try to get image URL from map, or construct from wiki page
    $url = $null
    
    if ($weaponImageMap.ContainsKey($weaponId)) {
        $imageInfo = $weaponImageMap[$weaponId]
        if ($imageInfo.path -ne "path/to") {
            # Use provided path
            $url = "$wikiBaseUrl/$($imageInfo.path)/$($imageInfo.filename)/revision/latest/scale-to-width-down/320?cb=20240101"
        }
    }
    
    # If no URL in map, try to construct from weapon name
    if (-not $url) {
        # Convert weapon ID to wiki page name format
        $wikiName = $weaponId -replace '-', '_' -replace '\.', ''
        $wikiName = $wikiName -creplace '([a-z])([A-Z])', '$1_$2'  # Add underscores before capitals
        $wikiName = $wikiName.ToUpper()
        
        # Try common image filename patterns
        $possibleNames = @(
            "$wikiName.png",
            "${wikiName}_Image.png",
            "${wikiName}_View.png",
            "$($weaponId -replace '-', '_').png"
        )
        
        # For now, we'll need to manually find these or use a different approach
        Write-Host "⚠️  $weaponId - Manual URL needed" -ForegroundColor Yellow
        $failCount++
        continue
    }
    
    # Download the image
    try {
        Write-Host "Downloading $weaponId..." -NoNewline
        
        # Download with retry
        $maxRetries = 3
        $retryCount = 0
        $downloaded = $false
        
        while ($retryCount -lt $maxRetries -and -not $downloaded) {
            try {
                Invoke-WebRequest -Uri $url -OutFile $outputFile -UseBasicParsing -ErrorAction Stop -TimeoutSec 30
                
                if (Test-Path $outputFile) {
                    $fileSize = (Get-Item $outputFile).Length
                    if ($fileSize -gt 0) {
                        $sizeKB = [math]::Round($fileSize/1KB, 1)
                        Write-Host " [OK] ($sizeKB KB)" -ForegroundColor Green
                        $successCount++
                        $downloaded = $true
                    } else {
                        Remove-Item $outputFile -Force -ErrorAction SilentlyContinue
                        throw "Empty file"
                    }
                } else {
                    throw "File not created"
                }
            } catch {
                $retryCount++
                if ($retryCount -lt $maxRetries) {
                    Start-Sleep -Seconds 2
                } else {
                    throw
                }
            }
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
Write-Host "Note: Many weapons need manual URL lookup from the wiki."
Write-Host "Visit https://escapefromtarkov.fandom.com/wiki/Weapons for each weapon"
Write-Host "and find the image URL, then add it to the weaponImageMap in this script."
Write-Host ""


