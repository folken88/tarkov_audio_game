# Comprehensive script to download ALL weapon images from Tarkov Wiki
# Scrapes wiki pages to find and download weapon images
# Handles all weapons, grenades, and flares

$ErrorActionPreference = "Continue"

$weaponsDir = "public\weapons"
$wikiBase = "https://escapefromtarkov.fandom.com/wiki"

# Comprehensive mapping of weapon IDs to wiki page names
# Based on Tarkov Wiki structure
$weaponPages = @{
    # Assault Carbines
    '9a-91' = '9A-91_9x39_compact_assault_rifle'
    'adar-2-15' = 'ADAR_2-15'
    'as-val-mod4' = 'AS_VAL_MOD.4'
    'avt-40' = 'Tokarev_AVT-40_7.62x54R_automatic_rifle'
    'op-sks' = 'OP-SKS_7.62x39_carbine'
    'rfb' = 'RFB_7.62x51_carbine'
    'sag-ak' = 'SAG_AK-545_5.45x39_carbine'
    'sag-ak-short' = 'SAG_AK_Short'
    'sks' = 'TOZ_Simonov_SKS_7.62x39_carbine'
    'sr-3m' = 'SR-3M_9x39_compact_assault_rifle'
    
    # Assault Rifles
    'ak-74' = 'Kalashnikov_AK-74_5.45x39_assault_rifle'
    'ak-74n' = 'Kalashnikov_AK-74N_5.45x39_assault_rifle'
    'ak-74m' = 'Kalashnikov_AK-74M_5.45x39_assault_rifle'
    'ak-101' = 'Kalashnikov_AK-101_5.56x45_assault_rifle'
    'ak-102' = 'Kalashnikov_AK-102_5.56x45_assault_rifle'
    'ak-103' = 'Kalashnikov_AK-103_7.62x39_assault_rifle'
    'ak-104' = 'Kalashnikov_AK-104_7.62x39_assault_rifle'
    'ak-105' = 'Kalashnikov_AK-105_5.45x39_assault_rifle'
    'ak-12' = 'Kalashnikov_AK-12_5.45x39_assault_rifle'
    'ak-15' = 'Kalashnikov_AK-15_5.45x39_assault_rifle'
    'ak-50' = 'TheAKGuy_AK-50_.50_BMG_anti-materiel_rifle'
    'akm' = 'Kalashnikov_AKM_7.62x39_assault_rifle'
    'akmn' = 'Kalashnikov_AKMN_7.62x39_assault_rifle'
    'akms' = 'Kalashnikov_AKMS_7.62x39_assault_rifle'
    'akmsn' = 'Kalashnikov_AKMSN_7.62x39_assault_rifle'
    'm4a1' = 'Colt_M4A1_5.56x45_assault_rifle'
    'hk416a5' = 'HK_416A5'
    'sa-58' = 'DS_Arms_SA58_7.62x51_assault_rifle'
    'scar-l' = 'FN_SCAR-L_5.56x45_assault_rifle'
    'scar-h' = 'FN_SCAR-H_7.62x51_assault_rifle'
    'tx-15' = 'Lone_Star_TX-15_DML_5.56x45_carbine'
    'ash-12' = 'ASh-12_12.7x55_assault_rifle'
    'rd-704' = 'Rifle_Dynamics_RD-704_7.62x39_assault_rifle'
    'mk47' = 'MK47_Mutant_7.62x39_assault_rifle'
    'mdr-308' = 'Desert_Tech_MDR_.308_assault_rifle'
    'mdr-556' = 'Desert_Tech_MDR_5.56x45_assault_rifle'
    
    # Bolt-Action Rifles
    'mosin' = 'Mosin-Nagant_7.62x54R_bolt-action_rifle'
    'sv-98' = 'SV-98_7.62x54R_bolt-action_sniper_rifle'
    't-5000' = 'T-5000_.308_bolt-action_sniper_rifle'
    'dvl-10' = 'DVL-10_.308_bolt-action_sniper_rifle'
    'm700' = 'Remington_Model_700_7.62x51_bolt-action_sniper_rifle'
    'm700-tac' = 'Remington_Model_700_Tactical_7.62x51_bolt-action_sniper_rifle'
    'm700-sass' = 'Remington_Model_700_SASS_7.62x51_bolt-action_sniper_rifle'
    'm700-ultra' = 'Remington_Model_700_Ultra_Magnum_7.62x51_bolt-action_sniper_rifle'
    'axmc' = 'Accuracy_International_AXMC_.338_LM_bolt-action_sniper_rifle'
    
    # Designated Marksman Rifles
    'svd' = 'SVD_7.62x54R_sniper_rifle'
    'svds' = 'SVDS_7.62x54R_sniper_rifle'
    'vss' = 'VSS_Vintorez_9x39_special_sniper_rifle'
    'as-val' = 'AS_VAL_9x39_special_assault_rifle'
    'm1a' = 'Springfield_Armory_M1A_7.62x51_rifle'
    'm1a-sass' = 'Springfield_Armory_M1A_SASS_7.62x51_rifle'
    'sr-25' = 'Knight''s_Armament_SR-25_7.62x51_marksman_rifle'
    'rsass' = 'Remington_RSASS_7.62x51_marksman_rifle'
    
    # Light Machine Guns
    'rpk-16' = 'RPK-16_5.45x39_light_machine_gun'
    'pkp' = 'Kalashnikov_PKP_7.62x54R_infantry_machine_gun_Pecheneg'
    'pkm' = 'Kalashnikov_PKM_7.62x54R_machine_gun'
    'm249' = 'U.S._Ordnance_M249_7.62x51_light_machine_gun'
    'm240b' = 'U.S._Ordnance_M240B_7.62x51_light_machine_gun'
    
    # Shotguns
    'saiga-12k' = 'Saiga-12K_12ga_automatic_shotgun'
    'mp-153' = 'MP-153_12ga_pump-action_shotgun'
    'mp-133' = 'MP-133_12ga_pump-action_shotgun'
    'mp-155' = 'MP-155_12ga_semi-automatic_shotgun'
    'mp-18' = 'MP-18_7.62x54R_single-shot_rifle'
    'toz-106' = 'TOZ-106_20ga_bolt-action_shotgun'
    'remington-870' = 'Remington_Model_870_12ga_pump-action_shotgun'
    'm1014' = 'Benelli_M1014_12ga_semi-automatic_shotgun'
    'm590a1' = 'Mossberg_590A1_12ga_pump-action_shotgun'
    
    # Submachine Guns
    'mp5' = 'HK_MP5_9x19_submachine_gun_(Navy_3_Round_Burst)'
    'mp5k' = 'HK_MP5K_9x19_submachine_gun'
    'mp5sd' = 'HK_MP5SD_9x19_submachine_gun'
    'mp7' = 'HK_MP7A1_4.6x30_submachine_gun'
    'mp9' = 'B&T_MP9_9x19_submachine_gun'
    'pp-19-01' = 'PP-19-01_Vityaz_9x19_submachine_gun'
    'pp-91' = 'PP-91_Kedr_9x18PM_submachine_gun'
    'pp-91-01' = 'PP-91-01_Kedr-B_9x18PM_submachine_gun'
    'ppsh-41' = 'PPSh-41_7.62x25_submachine_gun'
    'p90' = 'FN_P90_5.7x28_submachine_gun'
    'ump45' = 'HK_UMP_.45_ACP_submachine_gun'
    'saiga-9' = 'Saiga-9_9x19_carbine'
    'stm-9' = 'Soyuz-TM_STM-9_Gen.2_9x19_carbine'
    'sr-2m' = 'SR-2M_Veresk_9x21_submachine_gun'
    
    # Pistols
    'pm' = 'Makarov_PM_9x18PM_pistol'
    'p226' = 'SIG_P226R_9x19_pistol'
    'glock-17' = 'Glock_17_9x19_pistol'
    'glock-18c' = 'Glock_18C_9x19_pistol'
    'm9a3' = 'Beretta_M9A3_9x19_pistol'
    'm1911a1' = 'Colt_M1911A1_.45_ACP_pistol'
    'tt' = 'Tokarev_TT-33_7.62x25_TT_pistol'
    'fn57' = 'FN_Five-seveN_5.7x28_pistol'
    'apb' = 'Stechkin_APB_9x18PM_silenced_machine_pistol'
    'aps' = 'Stechkin_APS_9x18PM_machine_pistol'
    'sr1mp' = 'Serdyukov_SR-1MP_Gyurza_9x21_pistol'
    
    # Revolvers
    'rsh12' = 'RSh-12_12.7x55_revolver'
    
    # Grenades
    'f-1' = 'F-1'
    'rgd-5' = 'RGD-5'
    'm67' = 'M67'
    'zarya' = 'Zarya'
    'flash-grenade' = 'Flash_grenade'
    'smoke-grenade' = 'Smoke_grenade'
    
    # Flares
    'flare' = 'Flare'
    'red-flare' = 'Red_flare'
    'green-flare' = 'Green_flare'
    'white-flare' = 'White_flare'
}

Write-Host "========================================"
Write-Host "Downloading ALL Weapon Images from Tarkov Wiki"
Write-Host "========================================"
Write-Host "Total weapons to process: $($weaponPages.Count)"
Write-Host ""

$successCount = 0
$failCount = 0
$skipCount = 0
$failedWeapons = @()

# Get weapon names from weapons.js for human-readable filenames
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

foreach ($weaponId in $weaponPages.Keys) {
    $weaponFolder = Join-Path $weaponsDir $weaponId
    
    # Get human-readable weapon name for filename
    $weaponName = if ($weaponNames.ContainsKey($weaponId)) { $weaponNames[$weaponId] } else { $weaponId }
    $outputFilePng = Join-Path $weaponFolder "$weaponName.png"
    $outputFileGif = Join-Path $weaponFolder "$weaponName.gif"
    
    # Check if image already exists (PNG or GIF) with new or old naming
    $oldImagePng = Join-Path $weaponFolder "image.png"
    $oldImageGif = Join-Path $weaponFolder "image.gif"
    if ((Test-Path $outputFilePng) -or (Test-Path $outputFileGif) -or (Test-Path $oldImagePng) -or (Test-Path $oldImageGif)) {
        Write-Host "[SKIP] $weaponId (image already exists)" -ForegroundColor Yellow
        $skipCount++
        continue
    }
    
    # Ensure folder exists
    if (-not (Test-Path $weaponFolder)) {
        New-Item -ItemType Directory -Path $weaponFolder -Force | Out-Null
    }
    
    $wikiPage = $weaponPages[$weaponId]
    $wikiUrl = "$wikiBase/$wikiPage"
    
    Write-Host "[$($successCount + $failCount + 1)/$($weaponPages.Count)] Processing $weaponId..." -NoNewline
    
    try {
        # Fetch the wiki page HTML
        $response = Invoke-WebRequest -Uri $wikiUrl -UseBasicParsing -TimeoutSec 20 -ErrorAction Stop
        $html = $response.Content
        
        # Extract image URL from HTML
        # Multiple patterns to catch different image formats
        $imageUrl = $null
        $imageExtension = "png"
        
        # Pattern 1: Look for infobox image (most common)
        # Format: escapefromtarkov_gamepedia/images/.../ImageName.png/revision/...
        if ($html -match 'escapefromtarkov_gamepedia/images/([^"]+\.(?:png|gif|jpg|jpeg))') {
            $imagePath = $matches[1]
            # Remove query parameters and revision info
            $imagePath = $imagePath -replace '/revision.*$', ''
            $imagePath = $imagePath -replace '\?.*$', ''
            
            # Determine extension
            if ($imagePath -match '\.gif') {
                $imageExtension = "gif"
            } elseif ($imagePath -match '\.(jpg|jpeg)') {
                $imageExtension = "png"  # Convert to PNG
            }
            
            # Construct full URL with scaling
            $imageUrl = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/$imagePath/revision/latest/scale-to-width-down/320"
        }
        
        # Pattern 2: Look for direct image src in infobox
        if (-not $imageUrl -and $html -match 'src="(https://static\.wikia\.nocookie\.net/escapefromtarkov_gamepedia/images/[^"]+\.(?:png|gif|jpg|jpeg))') {
            $fullUrl = $matches[1]
            # Extract path and reconstruct
            if ($fullUrl -match '/images/([^/]+/[^/]+/[^"]+\.(?:png|gif|jpg|jpeg))') {
                $imagePath = $matches[1]
                $imagePath = $imagePath -replace '/revision.*$', ''
                $imagePath = $imagePath -replace '\?.*$', ''
                
                if ($imagePath -match '\.gif') {
                    $imageExtension = "gif"
                } elseif ($imagePath -match '\.(jpg|jpeg)') {
                    $imageExtension = "png"
                }
                
                $imageUrl = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/$imagePath/revision/latest/scale-to-width-down/320"
            }
        }
        
        # Pattern 3: Look for data-src (lazy loading)
        if (-not $imageUrl -and $html -match 'data-src="(https://static\.wikia\.nocookie\.net/escapefromtarkov_gamepedia/images/[^"]+\.(?:png|gif|jpg|jpeg))') {
            $fullUrl = $matches[1]
            if ($fullUrl -match '/images/([^/]+/[^/]+/[^"]+\.(?:png|gif|jpg|jpeg))') {
                $imagePath = $matches[1]
                $imagePath = $imagePath -replace '/revision.*$', ''
                $imagePath = $imagePath -replace '\?.*$', ''
                
                if ($imagePath -match '\.gif') {
                    $imageExtension = "gif"
                } elseif ($imagePath -match '\.(jpg|jpeg)') {
                    $imageExtension = "png"
                }
                
                $imageUrl = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/$imagePath/revision/latest/scale-to-width-down/320"
            }
        }
        
        if ($imageUrl) {
            # Determine output file based on extension (use human-readable name)
            $outputFile = if ($imageExtension -eq "gif") { $outputFileGif } else { $outputFilePng }
            
            # Download the image
            Write-Host " [DL]..." -NoNewline
            Invoke-WebRequest -Uri $imageUrl -OutFile $outputFile -UseBasicParsing -TimeoutSec 15 -ErrorAction Stop
            
            if (Test-Path $outputFile) {
                $fileSize = (Get-Item $outputFile).Length
                if ($fileSize -gt 0) {
                    $sizeKB = [math]::Round($fileSize/1KB, 1)
                    $fileName = Split-Path $outputFile -Leaf
                    Write-Host " [OK] ($sizeKB KB, $fileName)" -ForegroundColor Green
                    $successCount++
                } else {
                    Remove-Item $outputFile -Force -ErrorAction SilentlyContinue
                    Write-Host " [FAIL] (empty file)" -ForegroundColor Red
                    $failCount++
                    $failedWeapons += $weaponId
                }
            } else {
                Write-Host " [FAIL] (file not created)" -ForegroundColor Red
                $failCount++
                $failedWeapons += $weaponId
            }
        } else {
            Write-Host " [FAIL] (no image found on page)" -ForegroundColor Red
            Write-Host "   Wiki URL: $wikiUrl" -ForegroundColor Cyan
            $failCount++
            $failedWeapons += $weaponId
        }
    } catch {
        Write-Host " [FAIL] ($($_.Exception.Message))" -ForegroundColor Red
        Write-Host "   Wiki URL: $wikiUrl" -ForegroundColor Cyan
        $failCount++
        $failedWeapons += $weaponId
    }
    
    # Small delay to avoid rate limiting
    Start-Sleep -Milliseconds 1000
}

Write-Host ""
Write-Host "========================================"
Write-Host "Download Summary"
Write-Host "========================================"
Write-Host "  Success: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })
Write-Host "  Skipped: $skipCount" -ForegroundColor Yellow
Write-Host ""

if ($failedWeapons.Count -gt 0) {
    Write-Host "Failed Weapons:" -ForegroundColor Red
    foreach ($weaponId in $failedWeapons) {
        $wikiPage = $weaponPages[$weaponId]
        Write-Host "  - $weaponId : https://escapefromtarkov.fandom.com/wiki/$wikiPage" -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "For failed weapons, you may need to:"
    Write-Host "1. Visit the wiki page manually"
    Write-Host "2. Right-click the main weapon image"
    Write-Host "3. Copy image address"
    Write-Host "4. Download manually or update the script with direct URLs"
}

Write-Host ""
Write-Host "Script completed!" -ForegroundColor Cyan

