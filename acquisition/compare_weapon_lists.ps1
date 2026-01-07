# Compare our weapons list with the official Tarkov Wiki list
# Identifies missing weapons and naming differences

# Our current weapon IDs (from weapons.js)
$ourWeapons = @(
    '9a-91', 'adar-2-15', 'as-val-mod4', 'avt-40', 'op-sks', 'rfb', 'sag-ak', 'sag-ak-short', 'sks', 'sr-3m',
    'ak-74', 'ak-74n', 'ak-74m', 'ak-101', 'ak-102', 'ak-103', 'ak-104', 'ak-105', 'ak-12', 'ak-15', 'ak-50',
    'akm', 'akmn', 'akms', 'akmsn', 'm4a1', 'hk416a5', 'sa-58', 'scar-l', 'scar-h', 'tx-15', 'ash-12', 'rd-704',
    'mk47', 'mdr-308', 'mdr-556',
    'mosin', 'sv-98', 't-5000', 'dvl-10', 'm700', 'm700-tac', 'm700-sass', 'm700-ultra', 'axmc',
    'svd', 'svds', 'vss', 'as-val', 'm1a', 'm1a-sass', 'sr-25', 'rsass',
    'rpk-16', 'pkp', 'pkm', 'm249', 'm240b',
    'saiga-12k', 'mp-153', 'mp-133', 'mp-155', 'mp-18', 'toz-106', 'remington-870', 'm1014', 'm590a1',
    'mp5', 'mp5k', 'mp5sd', 'mp7', 'mp9', 'pp-19-01', 'pp-91', 'pp-91-01', 'ppsh-41', 'p90', 'ump45',
    'saiga-9', 'stm-9', 'sr-2m',
    'pm', 'p226', 'glock-17', 'glock-18c', 'm9a3', 'm1911a1', 'tt', 'fn57', 'apb', 'aps', 'sr1mp',
    'rsh12',
    'f-1', 'rgd-5', 'm67', 'zarya', 'flash-grenade', 'smoke-grenade', 'flare', 'red-flare', 'green-flare', 'white-flare'
)

# Official wiki weapon names (normalized for comparison)
$wikiWeapons = @(
    'Accuracy International AXMC .338 LM bolt-action sniper rifle',
    'ADAR 2-15 5.56x45 carbine',
    'Aklys Defense Velociraptor .300 Blackout assault rifle',
    'AS VAL 9x39 special assault rifle',
    'AS VAL MOD.4 9x39 special assault rifle',
    'ASh-12 12.7x55 assault rifle',
    'B&T MP9 9x19 submachine gun',
    'B&T MP9-N 9x19 submachine gun',
    'Benelli M3 Super 90 12ga dual-mode shotgun',
    'Beretta M9A3 9x19 pistol',
    'Chiappa Rhino 200DS 9x19 revolver',
    'Chiappa Rhino 50DS .357 revolver',
    'CMMG Mk47 Mutant 7.62x39 assault rifle',
    'Colt M16A1 5.56x45 assault rifle M16A1E1',
    'Colt M16A2 5.56x45 assault rifle',
    'Colt M1911A1 .45 ACP pistol',
    'Colt M45A1 .45 ACP pistol',
    'Colt M4A1 5.56x45 assault rifle Carbine',
    'Custom Guns NL545 (DI) 5.45x39 assault rifle',
    'Custom Guns NL545 (GP) 5.45x39 assault rifle',
    'Degtyarev RPD 7.62x39 machine gun',
    'Degtyarev RPDN 7.62x39 machine gun',
    'Desert Tech MDR 5.56x45 assault rifle',
    'Desert Tech MDR 7.62x51 assault rifle',
    'DS Arms SA58 7.62x51 assault rifle',
    'FN Five-seveN MK2 5.7x28 pistol',
    'FN Five-seveN MK2 5.7x28 pistol (FDE)',
    'FN P90 5.7x28 submachine gun',
    'FN SCAR-H 7.62x51 assault rifle (FDE)',
    'FN SCAR-H 7.62x51 assault rifle LB',
    'FN SCAR-H X-17 7.62x51 assault rifle',
    'FN SCAR-L 5.56x45 assault rifle (FDE)',
    'FN SCAR-L 5.56x45 assault rifle LB',
    'FN40GL Mk2 40mm grenade launcher',
    'FN40GL Mk2 grenade launcher',
    'Glock 17 9x19 pistol',
    'Glock 18C 9x19 machine pistol',
    'Glock 19X 9x19 pistol',
    'HK 416A5 5.56x45 assault rifle',
    'HK G28 7.62x51 marksman rifle',
    'HK G36 5.56x45 assault rifle',
    'HK MP5 9x19 submachine gun (Navy 3 Round Burst)',
    'HK MP5K 9x19 submachine gun',
    'HK MP7A1 4.6x30 submachine gun',
    'HK MP7A2 4.6x30 submachine gun',
    'HK UMP .45 ACP submachine gun',
    'HK USP .45 ACP pistol',
    'IWI UZI 9x19 submachine gun',
    'IWI UZI PRO Pistol 9x19 submachine gun',
    'IWI UZI PRO SMG 9x19 submachine gun',
    'Kalashnikov AK-101 5.56x45 assault rifle',
    'Kalashnikov AK-102 5.56x45 assault rifle',
    'Kalashnikov AK-103 7.62x39 assault rifle',
    'Kalashnikov AK-104 7.62x39 assault rifle',
    'Kalashnikov AK-105 5.45x39 assault rifle',
    'Kalashnikov AK-12 5.45x39 assault rifle',
    'Kalashnikov AK-308 7.62x51 assault rifle',
    'Kalashnikov AK-74 5.45x39 assault rifle',
    'Kalashnikov AK-74M 5.45x39 assault rifle',
    'Kalashnikov AK-74N 5.45x39 assault rifle',
    'Kalashnikov AKM 7.62x39 assault rifle',
    'Kalashnikov AKMN 7.62x39 assault rifle',
    'Kalashnikov AKMS 7.62x39 assault rifle',
    'Kalashnikov AKMSN 7.62x39 assault rifle',
    'Kalashnikov AKS-74 5.45x39 assault rifle',
    'Kalashnikov AKS-74N 5.45x39 assault rifle',
    'Kalashnikov AKS-74U 5.45x39 assault rifle',
    'Kalashnikov AKS-74UB 5.45x39 assault rifle',
    'Kalashnikov AKS-74UN 5.45x39 assault rifle',
    'Kalashnikov PKM 7.62x54R machine gun',
    'Kalashnikov PKP 7.62x54R infantry machine gun Pecheneg',
    'KBP 9A-91 9x39 compact assault rifle',
    'KBP VSK-94 9x39 rifle',
    'Kel-Tec RFB 7.62x51 rifle',
    'Knight''s Armament Company SR-25 7.62x51 marksman rifle',
    'Lebedev PL-15 9x19 pistol',
    'Lobaev Arms DVL-10 7.62x51 bolt-action sniper rifle Urbana',
    'Lone Star TX-15 DML 5.56x45 carbine',
    'Magnum Research Desert Eagle L5 .357 pistol',
    'Magnum Research Desert Eagle L5 .50 AE pistol',
    'Magnum Research Desert Eagle L6 .50 AE pistol',
    'Magnum Research Desert Eagle L6 .50 AE pistol (WTS)',
    'Magnum Research Desert Eagle Mk XIX .50 AE pistol',
    'Makarov PM (t) 9x18PM pistol',
    'Makarov PM 9x18PM pistol',
    'Marlin MXLR .308 ME lever-action rifle',
    'Milkor M32A1 MSGL 40mm grenade launcher',
    'Molot Arms Simonov OP-SKS 7.62x39 carbine',
    'Molot Arms VPO-101 Vepr-Hunter 7.62x51 carbine',
    'Molot Arms VPO-136 Vepr-KM 7.62x39 carbine',
    'Molot Arms VPO-209 .366 TKM carbine',
    'Molot Arms VPO-215 Gornostay .366 TKM bolt-action rifle',
    'Mosin 7.62x54R bolt-action rifle (Infantry)',
    'Mosin 7.62x54R bolt-action rifle (Sniper)',
    'Mossberg 590A1 12ga pump-action shotgun',
    'MP-133 12ga pump-action shotgun',
    'MP-153 12ga semi-automatic shotgun',
    'MP-155 12ga semi-automatic shotgun',
    'MP-18 7.62x54R single-shot rifle',
    'MP-43 12ga sawed-off double-barrel shotgun',
    'MP-43-1C 12ga double-barrel shotgun',
    'MPS Auto Assault-12 Gen 1 12ga automatic shotgun',
    'MPS Auto Assault-12 Gen 2 12ga automatic shotgun',
    'MTs-255-12 12ga shotgun',
    'ORSIS T-5000M 7.62x51 bolt-action sniper rifle',
    'PB 9x18PM silenced pistol',
    'PP-19-01 Vityaz 9x19 submachine gun',
    'PP-9 Klin 9x18PMM submachine gun',
    'PP-91 Kedr 9x18PM submachine gun',
    'PP-91-01 Kedr-B 9x18PM submachine gun',
    'PPSh-41 7.62x25 submachine gun',
    'Radian Weapons Model 1 FA 5.56x45 assault rifle',
    'Remington Model 700 7.62x51 bolt-action sniper rifle',
    'Remington Model 870 12ga pump-action shotgun',
    'Remington R11 RSASS 7.62x51 marksman rifle',
    'Rifle Dynamics RD-704 7.62x39 assault rifle',
    'RPK-16 5.45x39 light machine gun',
    'RSh-12 12.7x55 revolver',
    'RShG-2 72.5mm rocket launcher',
    'Sako TRG M10 .338 LM bolt-action sniper rifle',
    'SAG AK-545 5.45x39 carbine',
    'SAG AK-545 Short 5.45x39 carbine',
    'Saiga-12K 12ga automatic shotgun',
    'Saiga-12K ver.10 12ga semi-automatic shotgun',
    'Saiga-9 9x19 carbine',
    'Serdyukov SR-1MP Gyurza 9x21 pistol',
    'SIG MCX .300 Blackout assault rifle',
    'SIG MCX-SPEAR 6.8x51 assault rifle',
    'SIG MPX 9x19 submachine gun',
    'SIG P226R 9x19 pistol',
    'Soyuz-TM STM-9 Gen.2 9x19 carbine',
    'Springfield Armory M1A 7.62x51 rifle',
    'SR-2M Veresk 9x21 submachine gun',
    'SR-3M 9x39 compact assault rifle',
    'Stechkin APB 9x18PM silenced machine pistol',
    'Stechkin APS 9x18PM machine pistol',
    'Steyr AUG A1 5.56x45 assault rifle',
    'Steyr AUG A3 5.56x45 assault rifle',
    'Steyr AUG A3 5.56x56 assault rifle (Black)',
    'SV-98 7.62x54R bolt-action sniper rifle',
    'SVDS 7.62x54R sniper rifle',
    'SWORD International Mk-18 .338 LM marksman rifle',
    'TDI KRISS Vector Gen.2 .45 ACP submachine gun',
    'TDI KRISS Vector Gen.2 9x19 submachine gun',
    'TheAKGuy AK-50 .50 BMG anti-materiel rifle',
    'TKPD 9.3x64 carbine',
    'Tokarev AVT-40 7.62x54R automatic rifle',
    'Tokarev SVT-40 7.62x54R rifle',
    'Tokarev TT-33 7.62x25 TT pistol',
    'Tokarev TT-33 7.62x25 TT pistol (Golden)',
    'TOZ KS-23M 23x75mm pump-action shotgun',
    'TOZ Simonov SKS 7.62x39 carbine',
    'TOZ-106 20ga bolt-action shotgun',
    'U.S. Ordnance M60E4 7.62x51 light machine gun',
    'U.S. Ordnance M60E6 7.62x51 light machine gun',
    'U.S. Ordnance M60E6 7.62x51 light machine gun (FDE)',
    'VSS Vintorez 9x39 special sniper rifle',
    'Yarygin MP-443 Grach 9x19 pistol',
    'ZiD SP-81 26x75 signal pistol'
)

Write-Host "========================================"
Write-Host "Weapon List Comparison"
Write-Host "========================================"
Write-Host ""
Write-Host "Our weapons: $($ourWeapons.Count)"
Write-Host "Wiki weapons: $($wikiWeapons.Count)"
Write-Host ""

# Function to normalize weapon names for comparison
function Convert-ToWeaponId($name) {
    # Remove common prefixes and suffixes
    $id = $name -replace '^.*?(\w+.*?)(\s+\d+.*?)?$', '$1'  # Get main weapon name
    $id = $id -replace '\s*\(.*?\)', ''  # Remove parentheses
    $id = $id -replace '\d+x\d+.*', ''  # Remove calibers
    $id = $id -replace '\s+(rifle|pistol|shotgun|carbine|submachine gun|machine gun|assault rifle|sniper rifle|marksman rifle|grenade launcher|revolver|launcher)', ''
    $id = $id -replace '[^a-z0-9\s-]', ''  # Remove special chars
    $id = $id -replace '\s+', '-'  # Replace spaces with hyphens
    $id = $id.ToLower()
    $id = $id.Trim('-')
    return $id
}

# Create mapping of wiki weapons to IDs
$wikiWeaponIds = @()
foreach ($weapon in $wikiWeapons) {
    $id = Convert-ToWeaponId $weapon
    $wikiWeaponIds += $id
}

# Find weapons in wiki but not in our list
$missingFromOurs = @()
foreach ($wikiId in $wikiWeaponIds) {
    if ($wikiId -and $wikiId -notin $ourWeapons) {
        $missingFromOurs += $wikiId
    }
}

# Find weapons in our list but not in wiki (or named differently)
$extraInOurs = @()
foreach ($ourId in $ourWeapons) {
    if ($ourId -notin $wikiWeaponIds) {
        $extraInOurs += $ourId
    }
}

Write-Host "========================================"
Write-Host "Missing from Our List"
Write-Host "========================================"
Write-Host "Count: $($missingFromOurs.Count)"
Write-Host ""
$missingFromOurs | Sort-Object | ForEach-Object { Write-Host "  - $_" }

Write-Host ""
Write-Host "========================================"
Write-Host "In Our List But Not in Wiki (or different name)"
Write-Host "========================================"
Write-Host "Count: $($extraInOurs.Count)"
Write-Host ""
$extraInOurs | Sort-Object | ForEach-Object { Write-Host "  - $_" }

Write-Host ""


