# Extract and organize weapon images from site-download folder
# Maps webp files to weapon IDs and copies them with human-readable names

$ErrorActionPreference = "Continue"

$siteDownloadDir = "site-download"
$weaponsDir = "public\weapons"

# Map webp filenames to weapon IDs
# Based on the files I saw in site-download
$imageMappings = @{
    # Assault Carbines
    'ADAR2-15Image.webp' = 'adar-2-15'
    'AK-545Short_View.webp' = 'sag-ak-short'
    '9A-91.webp' = '9a-91'
    '9A-91_9x39.webp' = '9a-91'
    'AS_VAL_MOD4.webp' = 'as-val-mod4'
    'AVT-40_STD_Image.webp' = 'avt-40'
    'OP-SKS.webp' = 'op-sks'
    'RFB.webp' = 'rfb'
    'SAG_AK-545.webp' = 'sag-ak'
    'SKS.webp' = 'sks'
    'SR-3M.webp' = 'sr-3m'
    
    # Assault Rifles
    'AK-74Image.webp' = 'ak-74'
    'Akn.webp' = 'ak-74n'
    'AK-74M.webp' = 'ak-74m'
    'AK101_Image.webp' = 'ak-101'
    'Ak102image.webp' = 'ak-102'
    'AK-103_7.62x39.webp' = 'ak-103'
    'AK-104Image.webp' = 'ak-104'
    'AK-105_5.45x39.webp' = 'ak-105'
    'AK-12_Image.webp' = 'ak-12'
    'AK-15.webp' = 'ak-15'
    'AK-50_View.webp' = 'ak-50'
    'Akm.webp' = 'akm'
    'Akmn.webp' = 'akmn'
    'Akms.webp' = 'akms'
    'Akmsn.webp' = 'akmsn'
    'M4A1.webp' = 'm4a1'
    'HK_416A5.webp' = 'hk416a5'
    'DS_Arms_SA-58_OSW_Para_7.62x51.webp' = 'sa-58'
    'SCAR-L.webp' = 'scar-l'
    'ScarH_Image.webp' = 'scar-h'
    'TX-15_DML.webp' = 'tx-15'
    'ASh_12.webp' = 'ash-12'
    'RD-704.webp' = 'rd-704'
    'DT_MDR_308.webp' = 'mdr-308'
    'DT_MDR_5.56x45_Assault_Rifle.webp' = 'mdr-556'
    'MK47_Mutant.webp' = 'mk47'
    
    # Bolt-Action Rifles
    'Mosin-Nagant.webp' = 'mosin'
    'SV-98.webp' = 'sv-98'
    'T-5000.webp' = 't-5000'
    'Dvl10.webp' = 'dvl-10'
    'M700.webp' = 'm700'
    'M700_Tactical.webp' = 'm700-tac'
    'M700_SASS.webp' = 'm700-sass'
    'M700_Ultra.webp' = 'm700-ultra'
    'AXMC_.338_LM.webp' = 'axmc'
    
    # Designated Marksman Rifles
    'SVD.webp' = 'svd'
    'SVDS.webp' = 'svds'
    'VSS_Vintorez.webp' = 'vss'
    'Asval.webp' = 'as-val'
    'M1A.webp' = 'm1a'
    'M1A_SASS.webp' = 'm1a-sass'
    'SR-25.webp' = 'sr-25'
    'RSASS.webp' = 'rsass'
    
    # Light Machine Guns
    'RPK-16.webp' = 'rpk-16'
    'PKP.webp' = 'pkp'
    'PKM.webp' = 'pkm'
    'M249.webp' = 'm249'
    'M240B.webp' = 'm240b'
    
    # Shotguns
    'Saiga-12K.webp' = 'saiga-12k'
    'MP-153.webp' = 'mp-153'
    'Mp133.png' = 'mp-133'
    'MP-133.webp' = 'mp-133'
    'MP-155.webp' = 'mp-155'
    'MP-18.webp' = 'mp-18'
    'TOZ-106.webp' = 'toz-106'
    'Remington_870.webp' = 'remington-870'
    'M1014.webp' = 'm1014'
    'M590A1.webp' = 'm590a1'
    
    # Submachine Guns
    'MP5.webp' = 'mp5'
    'MP5K.webp' = 'mp5k'
    'MP5SD.webp' = 'mp5sd'
    'MP7.webp' = 'mp7'
    'B&T_MP9-N_9x19_Submachinegun.webp' = 'mp9'
    'PP-19-01_Vityaz.webp' = 'pp-19-01'
    'PP-91_Kedr.webp' = 'pp-91'
    'PP-91-01_Kedr-B.webp' = 'pp-91-01'
    'PPSh-41.webp' = 'ppsh-41'
    'P90.webp' = 'p90'
    'UMP-45.webp' = 'ump45'
    'Saiga-9.webp' = 'saiga-9'
    'STM-9.webp' = 'stm-9'
    'SR-2M_Veresk.webp' = 'sr-2m'
    
    # Pistols
    'PM.webp' = 'pm'
    'P226.webp' = 'p226'
    'Glock_17.webp' = 'glock-17'
    'Glock_18C.webp' = 'glock-18c'
    'Beretta_M9A3_9x19_pistol_Image.webp' = 'm9a3'
    'M1911A1.webp' = 'm1911a1'
    'TT.webp' = 'tt'
    'Five-seveN.webp' = 'fn57'
    'APBImage.webp' = 'apb'
    'APS.webp' = 'aps'
    'SR1MP.webp' = 'sr1mp'
    
    # Revolvers
    'RSh-12.webp' = 'rsh12'
    
    # Grenades
    'F-1.webp' = 'f-1'
    'RGD-5.webp' = 'rgd-5'
    'M67.webp' = 'm67'
    'Zarya.webp' = 'zarya'
    'Flash_grenade.webp' = 'flash-grenade'
    'Smoke_grenade.webp' = 'smoke-grenade'
    
    # Flares
    'Flare.webp' = 'flare'
    'Red_flare.webp' = 'red-flare'
    'Green_flare.webp' = 'green-flare'
    'White_flare.webp' = 'white-flare'
    'Blue_Flare_Image.webp' = 'flare'  # Fallback
}

# Human-readable weapon names for filenames
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
Write-Host "Extracting Weapon Images from site-download"
Write-Host "========================================"
Write-Host ""

if (-not (Test-Path $siteDownloadDir)) {
    Write-Host "ERROR: site-download directory not found!" -ForegroundColor Red
    exit 1
}

$successCount = 0
$skipCount = 0
$notFoundCount = 0
$notFoundFiles = @()

# Get all image files from site-download
$imageFiles = Get-ChildItem -Path $siteDownloadDir -File | Where-Object { 
    $_.Extension -match '\.(webp|png|gif|jpg|jpeg)$' 
}

Write-Host "Found $($imageFiles.Count) image files in site-download"
Write-Host ""

foreach ($imageFile in $imageFiles) {
    $fileName = $imageFile.Name
    $weaponId = $null
    
    # Try exact match first
    if ($imageMappings.ContainsKey($fileName)) {
        $weaponId = $imageMappings[$fileName]
    } else {
        # Try case-insensitive match
        $lowerFileName = $fileName.ToLower()
        foreach ($key in $imageMappings.Keys) {
            if ($key.ToLower() -eq $lowerFileName) {
                $weaponId = $imageMappings[$key]
                break
            }
        }
    }
    
    if (-not $weaponId) {
        $notFoundCount++
        $notFoundFiles += $fileName
        continue
    }
    
    $weaponFolder = Join-Path $weaponsDir $weaponId
    $weaponName = if ($weaponNames.ContainsKey($weaponId)) { $weaponNames[$weaponId] } else { $weaponId }
    
    # Determine output extension (convert webp to png)
    $outputExt = if ($imageFile.Extension -eq '.webp') { '.png' } else { $imageFile.Extension }
    $outputFile = Join-Path $weaponFolder "$weaponName$outputExt"
    
    # Check if already exists
    if (Test-Path $outputFile) {
        Write-Host "[SKIP] $weaponId - $weaponName$outputExt (already exists)" -ForegroundColor Yellow
        $skipCount++
        continue
    }
    
    # Check for old naming convention
    $oldImagePng = Join-Path $weaponFolder "image.png"
    $oldImageGif = Join-Path $weaponFolder "image.gif"
    if ((Test-Path $oldImagePng) -or (Test-Path $oldImageGif)) {
        Write-Host "[SKIP] $weaponId - has old image.png/gif (will need manual rename)" -ForegroundColor Yellow
        $skipCount++
        continue
    }
    
    # Ensure folder exists
    if (-not (Test-Path $weaponFolder)) {
        New-Item -ItemType Directory -Path $weaponFolder -Force | Out-Null
    }
    
    # Copy and convert if needed
    try {
        if ($imageFile.Extension -eq '.webp') {
            # For webp, we'll need to convert it (or just copy and rename)
            # PowerShell doesn't have built-in webp conversion, so we'll copy as-is for now
            # User can convert manually if needed, or we can use ImageMagick if available
            Copy-Item -Path $imageFile.FullName -Destination $outputFile -Force
            Write-Host "[COPY] $weaponId -> $weaponName$outputExt" -ForegroundColor Green
        } else {
            Copy-Item -Path $imageFile.FullName -Destination $outputFile -Force
            Write-Host "[COPY] $weaponId -> $weaponName$outputExt" -ForegroundColor Green
        }
        $successCount++
    } catch {
        Write-Host "[FAIL] $weaponId - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================"
Write-Host "Extraction Summary"
Write-Host "========================================"
Write-Host "  Copied: $successCount" -ForegroundColor Green
Write-Host "  Skipped: $skipCount" -ForegroundColor Yellow
Write-Host "  Not Mapped: $notFoundCount" -ForegroundColor $(if ($notFoundCount -gt 0) { "Yellow" } else { "Green" })
Write-Host ""

if ($notFoundFiles.Count -gt 0) {
    Write-Host "Unmapped image files (may be useful):" -ForegroundColor Cyan
    $notFoundFiles | ForEach-Object { Write-Host "  - $_" -ForegroundColor Gray }
    Write-Host ""
}

Write-Host "Script completed!" -ForegroundColor Cyan

