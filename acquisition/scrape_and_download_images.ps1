# Automated script to scrape weapon images from Tarkov Wiki
# Visits each wiki page, extracts image URL, and downloads it

$ErrorActionPreference = "Continue"

$weaponsDir = "public\weapons"
$wikiBase = "https://escapefromtarkov.fandom.com/wiki"

# Map weapon IDs to their wiki page names
$weaponPages = @{
    'adar-2-15' = 'ADAR_2-15'
    'sag-ak-short' = 'SAG_AK_Short'
    'ak-74n' = 'Kalashnikov_AK-74N_5.45x39_assault_rifle'
    'ak-74m' = 'Kalashnikov_AK-74M_5.45x39_assault_rifle'
    'ak-101' = 'Kalashnikov_AK-101_5.56x45_assault_rifle'
    'ak-102' = 'Kalashnikov_AK-102_5.56x45_assault_rifle'
    'ak-104' = 'Kalashnikov_AK-104_7.62x39_assault_rifle'
    'ak-105' = 'Kalashnikov_AK-105_5.45x39_assault_rifle'
    'ak-12' = 'Kalashnikov_AK-12_5.45x39_assault_rifle'
    'ak-15' = 'Kalashnikov_AK-15_5.45x39_assault_rifle'
    'akm' = 'Kalashnikov_AKM_7.62x39_assault_rifle'
    'akmn' = 'Kalashnikov_AKMN_7.62x39_assault_rifle'
    'akms' = 'Kalashnikov_AKMS_7.62x39_assault_rifle'
    'akmsn' = 'Kalashnikov_AKMSN_7.62x39_assault_rifle'
    'hk416a5' = 'HK_416A5'
    'sa-58' = 'DS_Arms_SA58_7.62x51_assault_rifle'
    'scar-l' = 'FN_SCAR-L_5.56x45_assault_rifle'
    'scar-h' = 'FN_SCAR-H_7.62x51_assault_rifle'
    'tx-15' = 'Lone_Star_TX-15_DML_5.56x45_carbine'
    'rd-704' = 'Rifle_Dynamics_RD-704_7.62x39_assault_rifle'
    'mdr-556' = 'Desert_Tech_MDR_5.56x45_assault_rifle'
    'm700-tac' = 'Remington_Model_700_Tactical_7.62x51_bolt-action_sniper_rifle'
    'm700-sass' = 'Remington_Model_700_SASS_7.62x51_bolt-action_sniper_rifle'
    'm700-ultra' = 'Remington_Model_700_Ultra_7.62x51_bolt-action_sniper_rifle'
    'axmc' = 'Accuracy_International_AXMC_.338_LM_bolt-action_sniper_rifle'
    'svds' = 'SVDS_7.62x54R_sniper_rifle'
    'vss' = 'VSS_Vintorez_9x39_special_sniper_rifle'
    'as-val' = 'AS_VAL_9x39_special_assault_rifle'
    'm1a' = 'Springfield_Armory_M1A_7.62x51_rifle'
    'm1a-sass' = 'Springfield_Armory_M1A_SASS_7.62x51_rifle'
    'rpk-16' = 'RPK-16_5.45x39_light_machine_gun'
    'pkp' = 'Kalashnikov_PKP_7.62x54R_infantry_machine_gun_Pecheneg'
    'pkm' = 'Kalashnikov_PKM_7.62x54R_machine_gun'
    'm249' = 'U.S._Ordnance_M249_7.62x51_light_machine_gun'
    'm240b' = 'U.S._Ordnance_M240B_7.62x51_light_machine_gun'
    'mp-133' = 'MP-133_12ga_pump-action_shotgun'
    'mp-155' = 'MP-155_12ga_semi-automatic_shotgun'
    'mp-18' = 'MP-18_7.62x54R_single-shot_rifle'
    'toz-106' = 'TOZ-106_20ga_bolt-action_shotgun'
    'remington-870' = 'Remington_Model_870_12ga_pump-action_shotgun'
    'm1014' = 'Benelli_M1014_12ga_semi-automatic_shotgun'
    'm590a1' = 'Mossberg_590A1_12ga_pump-action_shotgun'
    'mp5' = 'HK_MP5_9x19_submachine_gun_(Navy_3_Round_Burst)'
    'mp5k' = 'HK_MP5K_9x19_submachine_gun'
    'mp5sd' = 'HK_MP5SD_9x19_submachine_gun'
    'mp7' = 'HK_MP7A1_4.6x30_submachine_gun'
    'mp9' = 'B&T_MP9_9x19_submachine_gun'
    'pp-19-01' = 'PP-19-01_Vityaz_9x19_submachine_gun'
    'pp-91' = 'PP-91_Kedr_9x18PM_submachine_gun'
    'pp-91-01' = 'PP-91-01_Kedr-B_9x18PM_submachine_gun'
    'ppsh-41' = 'PPSh-41_7.62x25_submachine_gun'
    'ump45' = 'HK_UMP_.45_ACP_submachine_gun'
    'saiga-9' = 'Saiga-9_9x19_carbine'
    'stm-9' = 'Soyuz-TM_STM-9_Gen.2_9x19_carbine'
    'sr-2m' = 'SR-2M_Veresk_9x21_submachine_gun'
    'pm' = 'Makarov_PM_9x18PM_pistol'
    'p226' = 'SIG_P226R_9x19_pistol'
    'glock-17' = 'Glock_17_9x19_pistol'
    'm9a3' = 'Beretta_M9A3_9x19_pistol'
    'm1911a1' = 'Colt_M1911A1_.45_ACP_pistol'
    'fn57' = 'FN_Five-seveN_5.7x28_pistol'
    'apb' = 'Stechkin_APB_9x18PM_silenced_machine_pistol'
    'aps' = 'Stechkin_APS_9x18PM_machine_pistol'
    'sr1mp' = 'Serdyukov_SR-1MP_Gyurza_9x21_pistol'
}

Write-Host "========================================"
Write-Host "Scraping and Downloading Weapon Images"
Write-Host "========================================"
Write-Host ""

$successCount = 0
$failCount = 0
$skipCount = 0

foreach ($weaponId in $weaponPages.Keys) {
    $weaponFolder = Join-Path $weaponsDir $weaponId
    $outputFile = Join-Path $weaponFolder "image.png"
    
    # Skip if already exists
    if (Test-Path $outputFile) {
        Write-Host "[SKIP] $weaponId" -ForegroundColor Yellow
        $skipCount++
        continue
    }
    
    # Ensure folder exists
    if (-not (Test-Path $weaponFolder)) {
        New-Item -ItemType Directory -Path $weaponFolder -Force | Out-Null
    }
    
    $wikiPage = $weaponPages[$weaponId]
    $wikiUrl = "$wikiBase/$wikiPage"
    
    Write-Host "[SCRAPE] $weaponId..." -NoNewline
    
    try {
        # Fetch the wiki page HTML
        $response = Invoke-WebRequest -Uri $wikiUrl -UseBasicParsing -TimeoutSec 15 -ErrorAction Stop
        $html = $response.Content
        
        # Extract image URL from HTML
        # Look for the main weapon image in the infobox or first image
        $imageUrl = $null
        
        # Pattern 1: Look for infobox image
        if ($html -match 'escapefromtarkov_gamepedia/images/([^"]+\.(?:png|gif|jpg))') {
            $imagePath = $matches[1]
            # Remove query parameters and get clean path
            $imagePath = $imagePath -replace '/revision.*$', ''
            $imageUrl = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/$imagePath/revision/latest/scale-to-width-down/320?cb=20240101"
        }
        
        # Pattern 2: Look for table image (weapon icon)
        if (-not $imageUrl -and $html -match 'src="(https://static\.wikia\.nocookie\.net/escapefromtarkov_gamepedia/images/[^"]+\.(?:png|gif|jpg))') {
            $fullUrl = $matches[1]
            # Convert to scaled version
            if ($fullUrl -match '/images/([^/]+/[^/]+/[^"]+\.(?:png|gif|jpg))') {
                $imagePath = $matches[1]
                $imageUrl = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/$imagePath/revision/latest/scale-to-width-down/320?cb=20240101"
            }
        }
        
        if ($imageUrl) {
            # Download the image
            Write-Host " [DL]..." -NoNewline
            Invoke-WebRequest -Uri $imageUrl -OutFile $outputFile -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
            
            if ((Get-Item $outputFile).Length -gt 0) {
                Write-Host " ✓" -ForegroundColor Green
                $successCount++
            } else {
                Remove-Item $outputFile -Force
                Write-Host " ✗ (empty)" -ForegroundColor Red
                $failCount++
            }
        } else {
            Write-Host " ✗ (no image found)" -ForegroundColor Red
            $failCount++
        }
    } catch {
        Write-Host " ✗ ($($_.Exception.Message))" -ForegroundColor Red
        $failCount++
    }
    
    # Small delay to avoid rate limiting
    Start-Sleep -Milliseconds 800
}

Write-Host ""
Write-Host "========================================"
Write-Host "Summary: $successCount success, $failCount failed, $skipCount skipped" -ForegroundColor Cyan
Write-Host "========================================"


