# Parse tarkov.dev weapon list and create comprehensive weapon ID list
# This will be used to generate folders and update weapons.js

$weaponNames = @(
    "ZiD SP-81 26x75 signal pistol",
    "Yarygin MP-443 Grach 9x19 pistol",
    "VSS Vintorez 9x39 special sniper rifle",
    "U.S. Ordnance M60E6 7.62x51 light machine gun",
    "U.S. Ordnance M60E6 7.62x51 light machine gun (FDE)",
    "U.S. Ordnance M60E4 7.62x51 light machine gun",
    "TOZ-106 20ga bolt-action shotgun",
    "TOZ Simonov SKS 7.62x39 carbine",
    "TOZ KS-23M 23x75mm pump-action shotgun",
    "Tokarev TT-33 7.62x25 TT pistol",
    "Tokarev TT-33 7.62x25 TT pistol (Golden)",
    "Tokarev SVT-40 7.62x54R rifle",
    "Tokarev AVT-40 7.62x54R automatic rifle",
    "TKPD 9.3x64 carbine",
    "TheAKGuy AK-50 .50 BMG anti-materiel rifle",
    "TDI KRISS Vector Gen.2 9x19 submachine gun",
    "TDI KRISS Vector Gen.2 .45 ACP submachine gun",
    "SWORD International Mk-18 .338 LM marksman rifle",
    "SVDS 7.62x54R sniper rifle",
    "SV-98 7.62x54R bolt-action sniper rifle",
    "Steyr AUG A3 5.56x45 assault rifle",
    "Steyr AUG A3 5.56x45 assault rifle (Black)",
    "Steyr AUG A1 5.56x45 assault rifle",
    "Stechkin APS 9x18PM machine pistol",
    "Stechkin APB 9x18PM silenced machine pistol",
    "SR-3M 9x39 compact assault rifle",
    "SR-2M Veresk 9x21 submachine gun",
    "Springfield Armory M1A 7.62x51 rifle",
    "Soyuz-TM STM-9 Gen.2 9x19 carbine",
    "SIG P226R 9x19 pistol",
    "SIG MPX 9x19 submachine gun",
    "SIG MCX-SPEAR 6.8x51 assault rifle",
    "SIG MCX .300 Blackout assault rifle",
    "Serdyukov SR-1MP Gyurza 9x21 pistol",
    "Sako TRG M10 .338 LM bolt-action sniper rifle",
    "Saiga-9 9x19 carbine",
    "Saiga-12K ver.10 12ga semi-automatic shotgun",
    "Saiga-12K 12ga automatic shotgun",
    "SAG AK-545 Short 5.45x39 carbine",
    "SAG AK-545 5.45x39 carbine",
    "RShG-2 72.5mm rocket launcher",
    "RSh-12 12.7x55 revolver",
    "RPK-16 5.45x39 light machine gun",
    "Rifle Dynamics RD-704 7.62x39 assault rifle",
    "Remington R11 RSASS 7.62x51 marksman rifle",
    "Remington Model 870 12ga pump-action shotgun",
    "Remington Model 700 7.62x51 bolt-action sniper rifle",
    "Radian Weapons Model 1 FA 5.56x45 assault rifle",
    "PPSh-41 7.62x25 submachine gun",
    "PP-91-01 Kedr-B 9x18PM submachine gun",
    "PP-91 Kedr 9x18PM submachine gun",
    "PP-9 Klin 9x18PMM submachine gun",
    "PP-19-01 Vityaz 9x19 submachine gun",
    "PB 9x18PM silenced pistol",
    "ORSIS T-5000M 7.62x51 bolt-action sniper rifle",
    "MTs-255-12 12ga shotgun",
    "MPS Auto Assault-12 Gen 2 12ga automatic shotgun",
    "MPS Auto Assault-12 Gen 1 12ga automatic shotgun",
    "MP-43-1C 12ga double-barrel shotgun",
    "MP-43 12ga sawed-off double-barrel shotgun",
    "MP-18 7.62x54R single-shot rifle",
    "MP-155 12ga semi-automatic shotgun",
    "MP-153 12ga semi-automatic shotgun",
    "MP-133 12ga pump-action shotgun",
    "Mossberg 590A1 12ga pump-action shotgun",
    "Mosin 7.62x54R bolt-action rifle (Sniper)",
    "Mosin 7.62x54R bolt-action rifle (Infantry)",
    "Molot Arms VPO-215 Gornostay .366 TKM bolt-action rifle",
    "Molot Arms VPO-209 .366 TKM carbine",
    "Molot Arms VPO-136 Vepr-KM 7.62x39 carbine",
    "Molot Arms VPO-101 Vepr-Hunter 7.62x51 carbine",
    "Molot Arms Simonov OP-SKS 7.62x39 carbine",
    "Milkor M32A1 MSGL 40mm grenade launcher",
    "Marlin MXLR .308 ME lever-action rifle",
    "Makarov PM 9x18PM pistol",
    "Makarov PM (t) 9x18PM pistol",
    "Magnum Research Desert Eagle Mk XIX .50 AE pistol",
    "Magnum Research Desert Eagle L6 .50 AE pistol",
    "Magnum Research Desert Eagle L6 .50 AE pistol (WTS)",
    "Magnum Research Desert Eagle L5 .50 AE pistol",
    "Magnum Research Desert Eagle L5 .357 pistol",
    "Lone Star TX-15 DML 5.56x45 carbine",
    "Lobaev Arms DVL-10 7.62x51 bolt-action sniper rifle",
    "Lebedev PL-15 9x19 pistol",
    "Knight's Armament Company SR-25 7.62x51 marksman rifle",
    "Kel-Tec RFB 7.62x51 rifle",
    "KBP VSK-94 9x39 rifle",
    "KBP 9A-91 9x39 compact assault rifle",
    "Kalashnikov PKP 7.62x54R infantry machine gun",
    "Kalashnikov PKM 7.62x54R machine gun",
    "Kalashnikov AKS-74UN 5.45x39 assault rifle",
    "Kalashnikov AKS-74UB 5.45x39 assault rifle",
    "Kalashnikov AKS-74U 5.45x39 assault rifle",
    "Kalashnikov AKS-74N 5.45x39 assault rifle",
    "Kalashnikov AKS-74 5.45x39 assault rifle",
    "Kalashnikov AKMSN 7.62x39 assault rifle",
    "Kalashnikov AKMS 7.62x39 assault rifle",
    "Kalashnikov AKMN 7.62x39 assault rifle",
    "Kalashnikov AKM 7.62x39 assault rifle",
    "Kalashnikov AK-74N 5.45x39 assault rifle",
    "Kalashnikov AK-74M 5.45x39 assault rifle",
    "Kalashnikov AK-74 5.45x39 assault rifle",
    "Kalashnikov AK-308 7.62x51 assault rifle",
    "Kalashnikov AK-12 5.45x39 assault rifle",
    "Kalashnikov AK-105 5.45x39 assault rifle",
    "Kalashnikov AK-104 7.62x39 assault rifle",
    "Kalashnikov AK-103 7.62x39 assault rifle",
    "Kalashnikov AK-102 5.56x45 assault rifle",
    "Kalashnikov AK-101 5.56x45 assault rifle",
    "IWI UZI PRO SMG 9x19 submachine gun",
    "IWI UZI PRO Pistol 9x19 submachine gun",
    "IWI UZI 9x19 submachine gun",
    "HK USP .45 ACP pistol",
    "HK UMP .45 ACP submachine gun",
    "HK MP7A2 4.6x30 submachine gun",
    "HK MP7A1 4.6x30 submachine gun",
    "HK MP5K 9x19 submachine gun",
    "HK MP5 9x19 submachine gun (Navy 3 Round Burst)",
    "HK G36 5.56x45 assault rifle",
    "HK G28 7.62x51 marksman rifle",
    "HK 416A5 5.56x45 assault rifle",
    "Glock 19X 9x19 pistol",
    "Glock 18C 9x19 machine pistol",
    "Glock 17 9x19 pistol",
    "FN40GL Mk2 40mm grenade launcher",
    "FN SCAR-L 5.56x45 assault rifle",
    "FN SCAR-L 5.56x45 assault rifle (FDE)",
    "FN SCAR-H 7.62x51 assault rifle",
    "FN SCAR-H 7.62x51 assault rifle (FDE)",
    "FN P90 5.7x28 submachine gun",
    "FN Five-seveN MK2 5.7x28 pistol",
    "FN Five-seveN MK2 5.7x28 pistol (FDE)",
    "DS Arms SA58 7.62x51 assault rifle",
    "Desert Tech MDR 7.62x51 assault rifle",
    "Desert Tech MDR 5.56x45 assault rifle",
    "Degtyarev RPDN 7.62x39 machine gun",
    "Degtyarev RPD 7.62x39 machine gun",
    "Custom Guns NL545 (GP) 5.45x39 assault rifle",
    "Custom Guns NL545 (DI) 5.45x39 assault rifle",
    "Colt M4A1 5.56x45 assault rifle",
    "Colt M45A1 .45 ACP pistol",
    "Colt M1911A1 .45 ACP pistol",
    "Colt M16A2 5.56x45 assault rifle",
    "Colt M16A1 5.56x45 assault rifle",
    "CMMG Mk47 Mutant 7.62x39 assault rifle",
    "Chiappa Rhino 50DS .357 revolver",
    "Chiappa Rhino 200DS 9x19 revolver",
    "Beretta M9A3 9x19 pistol",
    "Benelli M3 Super 90 12ga dual-mode shotgun",
    "B&T MP9-N 9x19 submachine gun",
    "B&T MP9 9x19 submachine gun",
    "ASh-12 12.7x55 assault rifle",
    "AS VAL MOD.4 9x39 special assault rifle",
    "AS VAL 9x39 special assault rifle",
    "Aklys Defense Velociraptor .300 Blackout assault rifle",
    "ADAR 2-15 5.56x45 carbine",
    "Accuracy International AXMC .338 LM bolt-action sniper rifle",
    "20x1mm toy gun"
)

# Function to convert weapon name to ID
function Convert-ToWeaponId {
    param($name)
    
    $id = $name.ToLower()
    
    # Remove "Default", variant names in parentheses, and descriptors
    $id = $id -replace ' default$', ''
    $id = $id -replace ' \(.*?\)', ''
    $id = $id -replace ' \[.*?\]', ''
    
    # Specific mappings for common weapons
    $mappings = @{
        'mosin 7.62x54r bolt-action rifle' = 'mosin'
        'remington model 700 7.62x51 bolt-action sniper rifle' = 'm700'
        'springfield armory m1a 7.62x51 rifle' = 'm1a'
        'remington model 870 12ga pump-action shotgun' = 'remington-870'
        'mossberg 590a1 12ga pump-action shotgun' = 'm590a1'
        'colt m4a1 5.56x45 assault rifle' = 'm4a1'
        'colt m16a2 5.56x45 assault rifle' = 'm16a2'
        'colt m16a1 5.56x45 assault rifle' = 'm16a1'
        'hk 416a5 5.56x45 assault rifle' = 'hk416a5'
        'fn p90 5.7x28 submachine gun' = 'p90'
        'fn five-seven mk2 5.7x28 pistol' = 'fn57'
        'toz simonov sks 7.62x39 carbine' = 'sks'
        'molot arms simonov op-sks 7.62x39 carbine' = 'op-sks'
        'tokarev tt-33 7.62x25 tt pistol' = 'tt'
        'tokarev svt-40 7.62x54r rifle' = 'svt-40'
        'tokarev avt-40 7.62x54r automatic rifle' = 'avt-40'
        'theakguy ak-50 .50 bmg anti-materiel rifle' = 'ak-50'
        'kalashnikov ak-103 7.62x39 assault rifle' = 'ak-103'
        'kalashnikov ak-104 7.62x39 assault rifle' = 'ak-104'
        'kalashnikov ak-105 5.45x39 assault rifle' = 'ak-105'
        'kalashnikov ak-74m 5.45x39 assault rifle' = 'ak-74m'
        'kalashnikov ak-74n 5.45x39 assault rifle' = 'ak-74n'
        'kalashnikov ak-74 5.45x39 assault rifle' = 'ak-74'
        'kalashnikov akm 7.62x39 assault rifle' = 'akm'
        'kalashnikov akmn 7.62x39 assault rifle' = 'akmn'
        'kalashnikov akms 7.62x39 assault rifle' = 'akms'
        'kalashnikov akmsn 7.62x39 assault rifle' = 'akmsn'
        'kalashnikov aks-74u 5.45x39 assault rifle' = 'aks-74u'
        'glock 18c 9x19 machine pistol' = 'glock-18c'
        'glock 17 9x19 pistol' = 'glock-17'
        'kel-tec rfb 7.62x51 rifle' = 'rfb'
        'ash-12 12.7x55 assault rifle' = 'ash-12'
        'rsh-12 12.7x55 revolver' = 'rsh12'
        'molot arms vpo-209 .366 tkm carbine' = 'vpo-209'
        'fn scar-h 7.62x51 assault rifle' = 'scar-h'
        'fn scar-l 5.56x45 assault rifle' = 'scar-l'
        'desert tech mdr 7.62x51 assault rifle' = 'mdr-308'
        'desert tech mdr 5.56x45 assault rifle' = 'mdr-556'
        'cmmg mk47 mutant 7.62x39 assault rifle' = 'mk47'
        'knight''s armament company sr-25 7.62x51 marksman rifle' = 'sr-25'
        'remington r11 rsass 7.62x51 marksman rifle' = 'rsass'
        'sv-98 7.62x54r bolt-action sniper rifle' = 'sv-98'
        'svds 7.62x54r sniper rifle' = 'svds'
        'vss vintorez 9x39 special sniper rifle' = 'vss'
        'as val 9x39 special assault rifle' = 'as-val'
        'as val mod.4 9x39 special assault rifle' = 'as-val-mod4'
        'sr-3m 9x39 compact assault rifle' = 'sr-3m'
        'kbp 9a-91 9x39 compact assault rifle' = '9a-91'
        'mp-153 12ga semi-automatic shotgun' = 'mp-153'
        'mp-133 12ga pump-action shotgun' = 'mp-133'
        'mp-155 12ga semi-automatic shotgun' = 'mp-155'
        'mp-18 7.62x54r single-shot rifle' = 'mp-18'
        'saiga-12k 12ga automatic shotgun' = 'saiga-12k'
        'saiga-9 9x19 carbine' = 'saiga-9'
        'sag ak-545 5.45x39 carbine' = 'sag-ak'
        'sag ak-545 short 5.45x39 carbine' = 'sag-ak-short'
        'rpk-16 5.45x39 light machine gun' = 'rpk-16'
        'kalashnikov pkm 7.62x54r machine gun' = 'pkm'
        'kalashnikov pkp 7.62x54r infantry machine gun' = 'pkp'
        'u.s. ordnance m60e6 7.62x51 light machine gun' = 'm60e6'
        'u.s. ordnance m60e4 7.62x51 light machine gun' = 'm60e4'
        'orsis t-5000m 7.62x51 bolt-action sniper rifle' = 't-5000'
        'lobaev arms dvl-10 7.62x51 bolt-action sniper rifle' = 'dvl-10'
        'accuracy international axmc .338 lm bolt-action sniper rifle' = 'axmc'
        'sword international mk-18 .338 lm marksman rifle' = 'mk-18'
        'sako trg m10 .338 lm bolt-action sniper rifle' = 'trg-m10'
        'hk mp7a1 4.6x30 submachine gun' = 'mp7'
        'hk mp7a2 4.6x30 submachine gun' = 'mp7a2'
        'hk mp5 9x19 submachine gun' = 'mp5'
        'hk mp5k 9x19 submachine gun' = 'mp5k'
        'hk ump .45 acp submachine gun' = 'ump45'
        'pp-19-01 vityaz 9x19 submachine gun' = 'pp-19-01'
        'pp-91 kedr 9x18pm submachine gun' = 'pp-91'
        'pp-91-01 kedr-b 9x18pm submachine gun' = 'pp-91-01'
        'ppsh-41 7.62x25 submachine gun' = 'ppsh-41'
        'sr-2m veresk 9x21 submachine gun' = 'sr-2m'
        'soyuz-tm stm-9 gen.2 9x19 carbine' = 'stm-9'
        'tdi kriss vector gen.2 9x19 submachine gun' = 'vector-9'
        'tdi kriss vector gen.2 .45 acp submachine gun' = 'vector-45'
        'b&t mp9 9x19 submachine gun' = 'mp9'
        'b&t mp9-n 9x19 submachine gun' = 'mp9-n'
        'sig mpx 9x19 submachine gun' = 'mpx'
        'makarov pm 9x18pm pistol' = 'pm'
        'pb 9x18pm silenced pistol' = 'pb'
        'stechkin aps 9x18pm machine pistol' = 'aps'
        'stechkin apb 9x18pm silenced machine pistol' = 'apb'
        'serdyukov sr-1mp gyurza 9x21 pistol' = 'sr1mp'
        'sig p226r 9x19 pistol' = 'p226'
        'beretta m9a3 9x19 pistol' = 'm9a3'
        'colt m1911a1 .45 acp pistol' = 'm1911a1'
        'colt m45a1 .45 acp pistol' = 'm45a1'
        'lebedev pl-15 9x19 pistol' = 'pl-15'
        'yarygin mp-443 grach 9x19 pistol' = 'mp-443'
        'chiappa rhino 50ds .357 revolver' = 'rhino-50ds'
        'chiappa rhino 200ds 9x19 revolver' = 'rhino-200ds'
        'magnum research desert eagle mk xix .50 ae pistol' = 'deagle-mk19'
        'magnum research desert eagle l6 .50 ae pistol' = 'deagle-l6'
        'magnum research desert eagle l5 .50 ae pistol' = 'deagle-l5'
        'magnum research desert eagle l5 .357 pistol' = 'deagle-l5-357'
        'hk usp .45 acp pistol' = 'usp'
        'adar 2-15 5.56x45 carbine' = 'adar-2-15'
        'lone star tx-15 dml 5.56x45 carbine' = 'tx-15'
        'radian weapons model 1 fa 5.56x45 assault rifle' = 'radian-model-1'
        'ds arms sa58 7.62x51 assault rifle' = 'sa-58'
        'kalashnikov ak-101 5.56x45 assault rifle' = 'ak-101'
        'kalashnikov ak-102 5.56x45 assault rifle' = 'ak-102'
        'kalashnikov ak-12 5.45x39 assault rifle' = 'ak-12'
        'kalashnikov ak-15 7.62x39 assault rifle' = 'ak-15'
        'kalashnikov ak-308 7.62x51 assault rifle' = 'ak-308'
        'steyr aug a1 5.56x45 assault rifle' = 'aug-a1'
        'steyr aug a3 5.56x45 assault rifle' = 'aug-a3'
        'hk g36 5.56x45 assault rifle' = 'g36'
        'hk g28 7.62x51 marksman rifle' = 'g28'
        'sig mcx .300 blackout assault rifle' = 'mcx-300'
        'sig mcx-spear 6.8x51 assault rifle' = 'mcx-spear'
        'rifle dynamics rd-704 7.62x39 assault rifle' = 'rd-704'
        'custom guns nl545 5.45x39 assault rifle' = 'nl545'
        'aklys defense velociraptor .300 blackout assault rifle' = 'velociraptor'
        'degtyarev rpd 7.62x39 machine gun' = 'rpd'
        'degtyarev rpdn 7.62x39 machine gun' = 'rpdn'
        'benelli m3 super 90 12ga dual-mode shotgun' = 'm3-super-90'
        'toz-106 20ga bolt-action shotgun' = 'toz-106'
        'toz ks-23m 23x75mm pump-action shotgun' = 'ks-23m'
        'mp-43-1c 12ga double-barrel shotgun' = 'mp-43-1c'
        'mp-43 12ga sawed-off double-barrel shotgun' = 'mp-43'
        'mps auto assault-12 gen 1 12ga automatic shotgun' = 'aa-12-gen1'
        'mps auto assault-12 gen 2 12ga automatic shotgun' = 'aa-12-gen2'
        'mts-255-12 12ga shotgun' = 'mts-255'
        'molot arms vpo-101 vepr-hunter 7.62x51 carbine' = 'vpo-101'
        'molot arms vpo-136 vepr-km 7.62x39 carbine' = 'vpo-136'
        'molot arms vpo-215 gornostay .366 tkm bolt-action rifle' = 'vpo-215'
        'kbp vsk-94 9x39 rifle' = 'vsk-94'
        'iwi uzi 9x19 submachine gun' = 'uzi'
        'iwi uzi pro smg 9x19 submachine gun' = 'uzi-pro-smg'
        'iwi uzi pro pistol 9x19 submachine gun' = 'uzi-pro-pistol'
        'marlin mxlr .308 me lever-action rifle' = 'mxlr'
        'tkpd 9.3x64 carbine' = 'tkpd'
        'milkor m32a1 msgl 40mm grenade launcher' = 'm32a1'
        'fn40gl mk2 40mm grenade launcher' = 'fn40gl'
        'rshg-2 72.5mm rocket launcher' = 'rshg-2'
        'zid sp-81 26x75 signal pistol' = 'sp-81'
        '20x1mm toy gun' = 'toy-gun'
    }
    
    # Check if we have a specific mapping
    if ($mappings.ContainsKey($id)) {
        return $mappings[$id]
    }
    
    # Generic conversion: lowercase, remove caliber/descriptors, replace spaces with hyphens
    $id = $id -replace '\d+x\d+\.?\d*\s*', ''  # Remove calibers
    $id = $id -replace '\.?\d+\s*(mm|ga|ae)\s*', ''  # Remove mm, ga, etc.
    $id = $id -replace '\s+(rifle|pistol|shotgun|carbine|submachine gun|machine gun|assault rifle|sniper rifle|marksman rifle|grenade launcher|revolver|launcher)', ''
    $id = $id -replace '[^a-z0-9\s-]', ''  # Remove special chars except spaces and hyphens
    $id = $id -replace '\s+', '-'  # Replace spaces with hyphens
    $id = $id -replace '-+', '-'  # Remove duplicate hyphens
    $id = $id.Trim('-')  # Remove leading/trailing hyphens
    
    return $id
}

# Generate weapon IDs
$weapons = @()
foreach ($name in $weaponNames) {
    $id = Convert-ToWeaponId $name
    $weapons += [PSCustomObject]@{
        Name = $name
        ID = $id
    }
}

# Remove duplicates and sort
$uniqueWeapons = $weapons | Sort-Object -Property ID -Unique

Write-Host "Total unique weapons: $($uniqueWeapons.Count)"
Write-Host ""
Write-Host "Weapon IDs:"
$uniqueWeapons | ForEach-Object {
    Write-Host "  { id: '$($_.ID)', name: '$($_.Name)' },"
}

# Export to JSON for easy use
$uniqueWeapons | ConvertTo-Json | Out-File "all_tarkov_weapons.json" -Encoding UTF8

Write-Host ""
Write-Host "Exported to all_tarkov_weapons.json"


