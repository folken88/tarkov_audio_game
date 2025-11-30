# PowerShell script to download weapon images from Tarkov Wiki
# Uses wiki page names to find and download the main weapon image
# Downloads as PNG (static images only, no animated GIFs)

$ErrorActionPreference = "Continue"

# Map weapon IDs to their wiki page names
$weaponWikiPages = @{
    # Assault Carbines
    'adar-2-15' = 'ADAR_2-15'
    'sag-ak-short' = 'SAG_AK_Short'
    
    # Assault Rifles  
    'ak-74n' = 'AK-74N'
    'ak-74m' = 'AK-74M'
    'ak-101' = 'AK-101'
    'ak-102' = 'AK-102'
    'ak-104' = 'AK-104'
    'ak-105' = 'AK-105'
    'ak-12' = 'AK-12'
    'ak-15' = 'AK-15'
    'akm' = 'AKM'
    'akmn' = 'AKMN'
    'akms' = 'AKMS'
    'akmsn' = 'AKMSN'
    'hk416a5' = 'HK_416A5'
    'sa-58' = 'SA-58'
    'scar-l' = 'SCAR-L'
    'scar-h' = 'SCAR-H'
    'tx-15' = 'TX-15_DML'
    'rd-704' = 'RD-704'
    'mdr-556' = 'MDR_5.56x45'
    
    # Bolt-Action Rifles
    'm700-tac' = 'M700_Tactical'
    'm700-sass' = 'M700_SASS'
    'm700-ultra' = 'M700_Ultra'
    'axmc' = 'AXMC'
    
    # Designated Marksman Rifles
    'svds' = 'SVDS'
    'vss' = 'VSS_Vintorez'
    'as-val' = 'AS_VAL'
    'm1a' = 'M1A'
    'm1a-sass' = 'M1A_SASS'
    
    # Light Machine Guns
    'rpk-16' = 'RPK-16'
    'pkp' = 'PKP'
    'pkm' = 'PKM'
    'm249' = 'M249'
    'm240b' = 'M240B'
    
    # Shotguns
    'mp-133' = 'MP-133'
    'mp-155' = 'MP-155'
    'mp-18' = 'MP-18'
    'toz-106' = 'TOZ-106'
    'remington-870' = 'Remington_870'
    'm1014' = 'M1014'
    'm590a1' = 'M590A1'
    
    # Submachine Guns
    'mp5' = 'MP5'
    'mp5k' = 'MP5K'
    'mp5sd' = 'MP5SD'
    'mp7' = 'MP7'
    'mp9' = 'MP9'
    'pp-19-01' = 'PP-19-01_Vityaz'
    'pp-91' = 'PP-91_Kedr'
    'pp-91-01' = 'PP-91-01_Kedr-B'
    'ppsh-41' = 'PPSh-41'
    'ump45' = 'UMP-45'
    'saiga-9' = 'Saiga-9'
    'stm-9' = 'STM-9'
    'sr-2m' = 'SR-2M_Veresk'
    
    # Pistols
    'pm' = 'PM'
    'p226' = 'P226'
    'glock-17' = 'Glock_17'
    'm9a3' = 'M9A3'
    'm1911a1' = 'M1911A1'
    'fn57' = 'FN_Five-seveN'
    'apb' = 'APB'
    'aps' = 'APS'
    'sr1mp' = 'SR1MP'
    
    # Grenades (may not have standard images)
    'f-1' = 'F-1'
    'rgd-5' = 'RGD-5'
    'm67' = 'M67'
    'zarya' = 'Zarya'
}

Write-Host "========================================"
Write-Host "Downloading Weapon Images from Tarkov Wiki"
Write-Host "========================================"
Write-Host "This script will download static PNG images (no animated GIFs)"
Write-Host ""

$weaponsDir = "public\weapons"
$successCount = 0
$failCount = 0
$skipCount = 0

# Known working image URLs from existing script (for reference)
$knownUrls = @{
    'fn57' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/1/13/FN57Image.png/revision/latest/scale-to-width-down/320?cb=20231017095739'
    'scar-h' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/a/a8/ScarH_Image.png/revision/latest/scale-to-width-down/320?cb=20231017091930'
    'mp-133' = 'https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/3/3b/Mp133.png/revision/latest/scale-to-width-down/320?cb=20231025194415'
}

foreach ($weaponId in $weaponWikiPages.Keys) {
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
    
    # Try known URL first
    $url = $null
    if ($knownUrls.ContainsKey($weaponId)) {
        $url = $knownUrls[$weaponId]
        # Convert .gif to .png if needed
        if ($url -match '\.gif') {
            $url = $url -replace '\.gif', '.png'
        }
    } else {
        # Construct URL from wiki page name
        $wikiPage = $weaponWikiPages[$weaponId]
        Write-Host "⚠️  $weaponId - Need to find image URL manually" -ForegroundColor Yellow
        Write-Host "   Wiki page: https://escapefromtarkov.fandom.com/wiki/$wikiPage" -ForegroundColor Cyan
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
Write-Host "For weapons that failed, visit their wiki pages and:"
Write-Host "1. Right-click the main weapon image"
Write-Host "2. Select 'Copy image address'"
Write-Host "3. Add the URL to the 'knownUrls' hashtable in this script"
Write-Host "4. Re-run the script"
Write-Host ""


