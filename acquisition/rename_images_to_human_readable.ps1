# Rename existing image.png/gif files to human-readable names
# This standardizes all images to use the new naming convention

$ErrorActionPreference = "Continue"

$weaponsDir = "public\weapons"

# Human-readable weapon names (matches download script)
$weaponNames = @{
    '9a-91' = '9A-91'
    'adar-2-15' = 'ADAR-2-15'
    'as-val-mod4' = 'AS-VAL-MOD4'
    'avt-40' = 'AVT-40'
    'op-sks' = 'OP-SKS'
    'rfb' = 'RFB'
    'sag-ak' = 'SAG-AK'
    'sag-ak-short' = 'SAG-AK-Short'
    'sks' = 'SKS'
    'sr-3m' = 'SR-3M'
    'ak-74' = 'AK-74'
    'ak-74n' = 'AK-74N'
    'ak-74m' = 'AK-74M'
    'ak-101' = 'AK-101'
    'ak-102' = 'AK-102'
    'ak-103' = 'AK-103'
    'ak-104' = 'AK-104'
    'ak-105' = 'AK-105'
    'ak-12' = 'AK-12'
    'ak-15' = 'AK-15'
    'ak-50' = 'AK-50'
    'akm' = 'AKM'
    'akmn' = 'AKMN'
    'akms' = 'AKMS'
    'akmsn' = 'AKMSN'
    'm4a1' = 'M4A1'
    'hk416a5' = 'HK-416A5'
    'sa-58' = 'SA-58'
    'scar-l' = 'SCAR-L'
    'scar-h' = 'SCAR-H'
    'tx-15' = 'TX-15-DML'
    'ash-12' = 'ASh-12'
    'rd-704' = 'RD-704'
    'mk47' = 'MK47-Mutant'
    'mdr-308' = 'MDR-308'
    'mdr-556' = 'MDR-556'
    'mosin' = 'Mosin-Nagant'
    'sv-98' = 'SV-98'
    't-5000' = 'T-5000'
    'dvl-10' = 'DVL-10'
    'm700' = 'M700'
    'm700-tac' = 'M700-Tactical'
    'm700-sass' = 'M700-SASS'
    'm700-ultra' = 'M700-Ultra'
    'axmc' = 'AXMC'
    'svd' = 'SVD'
    'svds' = 'SVDS'
    'vss' = 'VSS-Vintorez'
    'as-val' = 'AS-VAL'
    'm1a' = 'M1A'
    'm1a-sass' = 'M1A-SASS'
    'sr-25' = 'SR-25'
    'rsass' = 'RSASS'
    'rpk-16' = 'RPK-16'
    'pkp' = 'PKP'
    'pkm' = 'PKM'
    'm249' = 'M249'
    'm240b' = 'M240B'
    'saiga-12k' = 'Saiga-12K'
    'mp-153' = 'MP-153'
    'mp-133' = 'MP-133'
    'mp-155' = 'MP-155'
    'mp-18' = 'MP-18'
    'toz-106' = 'TOZ-106'
    'remington-870' = 'Remington-870'
    'm1014' = 'M1014'
    'm590a1' = 'M590A1'
    'mp5' = 'MP5'
    'mp5k' = 'MP5K'
    'mp5sd' = 'MP5SD'
    'mp7' = 'MP7'
    'mp9' = 'MP9'
    'pp-19-01' = 'PP-19-01-Vityaz'
    'pp-91' = 'PP-91-Kedr'
    'pp-91-01' = 'PP-91-01-Kedr-B'
    'ppsh-41' = 'PPSh-41'
    'p90' = 'P90'
    'ump45' = 'UMP-45'
    'saiga-9' = 'Saiga-9'
    'stm-9' = 'STM-9'
    'sr-2m' = 'SR-2M-Veresk'
    'pm' = 'PM'
    'p226' = 'P226'
    'glock-17' = 'Glock-17'
    'glock-18c' = 'Glock-18C'
    'm9a3' = 'M9A3'
    'm1911a1' = 'M1911A1'
    'tt' = 'TT'
    'fn57' = 'FN-Five-seveN'
    'apb' = 'APB'
    'aps' = 'APS'
    'sr1mp' = 'SR1MP'
    'rsh12' = 'RSh-12'
    'f-1' = 'F-1-Grenade'
    'rgd-5' = 'RGD-5-Grenade'
    'm67' = 'M67-Grenade'
    'zarya' = 'Zarya-Flashbang'
    'flash-grenade' = 'Flash-Grenade'
    'smoke-grenade' = 'Smoke-Grenade'
    'flare' = 'Flare'
    'red-flare' = 'Red-Flare'
    'green-flare' = 'Green-Flare'
    'white-flare' = 'White-Flare'
}

Write-Host "========================================"
Write-Host "Renaming Images to Human-Readable Names"
Write-Host "========================================"
Write-Host ""

$renamedCount = 0
$skippedCount = 0
$errorCount = 0

foreach ($weaponId in $weaponNames.Keys) {
    $weaponFolder = Join-Path $weaponsDir $weaponId
    
    if (-not (Test-Path $weaponFolder)) {
        continue
    }
    
    $weaponName = $weaponNames[$weaponId]
    $oldImagePng = Join-Path $weaponFolder "image.png"
    $oldImageGif = Join-Path $weaponFolder "image.gif"
    $newImagePng = Join-Path $weaponFolder "$weaponName.png"
    $newImageGif = Join-Path $weaponFolder "$weaponName.gif"
    
    # Check if new name already exists
    if ((Test-Path $newImagePng) -or (Test-Path $newImageGif)) {
        Write-Host "[SKIP] $weaponId - already has human-readable name" -ForegroundColor Yellow
        $skippedCount++
        continue
    }
    
    # Rename PNG if exists
    if (Test-Path $oldImagePng) {
        try {
            Rename-Item -Path $oldImagePng -NewName "$weaponName.png" -Force
            Write-Host "[RENAME] $weaponId - image.png -> $weaponName.png" -ForegroundColor Green
            $renamedCount++
        } catch {
            Write-Host "[ERROR] $weaponId - Failed to rename: $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }
    
    # Rename GIF if exists
    if (Test-Path $oldImageGif) {
        try {
            Rename-Item -Path $oldImageGif -NewName "$weaponName.gif" -Force
            Write-Host "[RENAME] $weaponId - image.gif -> $weaponName.gif" -ForegroundColor Green
            $renamedCount++
        } catch {
            Write-Host "[ERROR] $weaponId - Failed to rename: $($_.Exception.Message)" -ForegroundColor Red
            $errorCount++
        }
    }
}

Write-Host ""
Write-Host "========================================"
Write-Host "Rename Summary"
Write-Host "========================================"
Write-Host "  Renamed: $renamedCount" -ForegroundColor Green
Write-Host "  Skipped: $skippedCount" -ForegroundColor Yellow
Write-Host "  Errors: $errorCount" -ForegroundColor $(if ($errorCount -gt 0) { "Red" } else { "Green" })
Write-Host ""


