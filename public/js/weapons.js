/**
 * Tarkov Weapon Data
 * List of all weapons that make noise in Escape from Tarkov
 * 
 * Weapon data and categorization based on:
 * https://escapefromtarkov.fandom.com/wiki/Weapons
 */

export const WEAPONS = [
  // Assault Carbines (based on Tarkov Wiki)
  { id: '9a-91', name: '9A-91' },
  { id: 'adar-2-15', name: 'ADAR 2-15' },
  { id: 'as-val-mod4', name: 'AS VAL MOD.4' },
  { id: 'avt-40', name: 'AVT-40' },
  { id: 'op-sks', name: 'OP-SKS' },
  { id: 'rfb', name: 'RFB' },
  { id: 'sag-ak', name: 'SAG AK' },
  { id: 'sag-ak-short', name: 'SAG AK Short' },
  { id: 'sks', name: 'SKS' },
  { id: 'sr-3m', name: 'SR-3M' },
  { id: 'vpo-101', name: 'VPO-101 Vepr-Hunter' },
  
  // Assault Rifles (based on Tarkov Wiki)
  { id: 'ak-74', name: 'AK-74' },
  { id: 'ak-74n', name: 'AK-74N' },
  { id: 'ak-74m', name: 'AK-74M' },
  { id: 'aks-74u', name: 'AKS-74U' },
  { id: 'ak-101', name: 'AK-101' },
  { id: 'ak-102', name: 'AK-102' },
  { id: 'ak-103', name: 'AK-103' },
  { id: 'ak-104', name: 'AK-104' },
  { id: 'ak-105', name: 'AK-105' },
  { id: 'ak-12', name: 'AK-12' },
  { id: 'ak-15', name: 'AK-15' },
  { id: 'ak-50', name: 'AK-50' },
  { id: 'akm', name: 'AKM' },
  { id: 'akmn', name: 'AKMN' },
  { id: 'akms', name: 'AKMS' },
  { id: 'akmsn', name: 'AKMSN' },
  { id: 'm4a1', name: 'M4A1' },
  { id: 'hk416a5', name: 'HK 416A5' },
  { id: 'sa-58', name: 'SA-58' },
  { id: 'scar-l', name: 'SCAR-L' },
  { id: 'tx-15', name: 'TX-15 DML' },
  { id: 'ash-12', name: 'ASh-12' },
  { id: 'rd-704', name: 'RD-704' },
  { id: 'mk47', name: 'MK47 Mutant' },
  { id: 'mdr-308', name: 'MDR .308' },
  { id: 'mdr-556', name: 'MDR 5.56x45' },
  { id: 'mcx-spear', name: 'SIG MCX-SPEAR' },
  { id: 'nl545-gp', name: 'NL545 GP' },
  { id: 'g36', name: 'G36' },
  { id: 'aug-a3', name: 'Steyr AUG A3' },
  
  // Bolt-Action Rifles (based on Tarkov Wiki)
  { id: 'mosin', name: 'Mosin-Nagant' },
  { id: 'sv-98', name: 'SV-98' },
  { id: 't-5000', name: 'T-5000' },
  { id: 'dvl-10', name: 'DVL-10' },
  { id: 'm700', name: 'M700' },
  { id: 'm700-tac', name: 'M700 Tactical' },
  { id: 'm700-sass', name: 'M700 SASS' },
  { id: 'm700-ultra', name: 'M700 Ultra' },
  { id: 'axmc', name: 'AXMC' },
  { id: 'marlin-mxlr', name: 'Marlin MXLR' },
  { id: 'sako-trg-m10', name: 'Sako TRG M10' },
  
  // Designated Marksman Rifles (based on Tarkov Wiki)
  { id: 'svd', name: 'SVD' },
  { id: 'svds', name: 'SVDS' },
  { id: 'vss', name: 'VSS Vintorez' },
  { id: 'as-val', name: 'AS VAL' },
  { id: 'm1a', name: 'M1A' },
  { id: 'm1a-sass', name: 'M1A SASS' },
  { id: 'sr-25', name: 'SR-25' },
  { id: 'rsass', name: 'RSASS' },
  { id: 'mk-18', name: 'MK-18 .338 LM' },
  
  // Light Machine Guns (based on Tarkov Wiki)
  { id: 'rpk-16', name: 'RPK-16' },
  { id: 'rpd', name: 'RPD' },
  { id: 'pkp', name: 'PKP' },
  { id: 'pkm', name: 'PKM' },
  { id: 'm249', name: 'M249' },
  { id: 'm240b', name: 'M240B' },
  { id: 'm60e6', name: 'M60E6' },
  
  // Shotguns (based on Tarkov Wiki)
  { id: 'saiga-12k', name: 'Saiga-12K' },
  { id: 'aa-12', name: 'AA-12' },
  { id: 'mp-153', name: 'MP-153' },
  { id: 'mp-133', name: 'MP-133' },
  { id: 'mp-155', name: 'MP-155' },
  { id: 'mp-18', name: 'MP-18' },
  { id: 'toz-106', name: 'TOZ-106' },
  { id: 'ks-23m', name: 'KS-23M' },
  { id: 'remington-870', name: 'Remington 870' },
  { id: 'm1014', name: 'M1014' },
  { id: 'm590a1', name: 'M590A1' },
  
  // Submachine Guns (based on Tarkov Wiki)
  { id: 'mp5', name: 'MP5' },
  { id: 'mp5k', name: 'MP5K' },
  { id: 'mp5sd', name: 'MP5SD' },
  { id: 'mp7', name: 'MP7' },
  { id: 'mp9', name: 'MP9' },
  { id: 'mpx', name: 'SIG MPX' },
  { id: 'pp-19-01', name: 'PP-19-01 Vityaz' },
  { id: 'pp-91', name: 'PP-91 Kedr' },
  { id: 'pp-91-01', name: 'PP-91-01 Kedr-B' },
  { id: 'ppsh-41', name: 'PPSh-41' },
  { id: 'p90', name: 'P90' },
  { id: 'ump45', name: 'UMP-45' },
  { id: 'saiga-9', name: 'Saiga-9' },
  { id: 'stm-9', name: 'STM-9' },
  { id: 'sr-2m', name: 'SR-2M Veresk' },
  
  // Pistols (based on Tarkov Wiki)
  { id: 'pm', name: 'PM' },
  { id: 'p226', name: 'P226' },
  { id: 'glock-17', name: 'Glock 17' },
  { id: 'glock-18c', name: 'Glock 18C' },
  { id: 'm9a3', name: 'M9A3' },
  { id: 'm1911a1', name: 'M1911A1' },
  { id: 'tt', name: 'TT' },
  { id: 'fn57', name: 'FN Five-seveN' },
  { id: 'apb', name: 'APB' },
  { id: 'aps', name: 'APS' },
  { id: 'sr1mp', name: 'SR1MP' },
  
  // Revolvers (based on Tarkov Wiki)
  { id: 'rsh12', name: 'RSh-12' },
  { id: 'rhino-50ds', name: 'Chiappa Rhino 50DS' },
  
  // Grenade Launchers (based on Tarkov Wiki)
  { id: 'fn40gl', name: 'FN40GL Mk2' },
  
  // Grenades (based on Tarkov Wiki)
  { id: 'f-1', name: 'F-1 Grenade' },
  { id: 'rgd-5', name: 'RGD-5 Grenade' },
  { id: 'm67', name: 'M67 Grenade' },
  { id: 'zarya', name: 'Zarya Flashbang' },
  { id: 'flash-grenade', name: 'Flash Grenade' },
  { id: 'smoke-grenade', name: 'Smoke Grenade' },
  
  // Flares (based on Tarkov Wiki)
  { id: 'flare', name: 'Flare' },
  { id: 'red-flare', name: 'Red Flare' },
  { id: 'green-flare', name: 'Green Flare' },
  { id: 'white-flare', name: 'White Flare' },
];

/**
 * Get local image URL for a weapon
 * Images are stored in public/weapons/{weaponId}/{weaponName}.png or .gif
 * Human-readable naming: {weaponName}.png (with fallback to .gif and old image.png)
 * 
 * Naming convention:
 * - Primary: {weaponName}.png (e.g., "AK-74.png", "SCAR-H.png")
 * - Fallback: {weaponName}.gif (for animated images)
 * - Legacy: image.png or image.gif (old naming convention)
 */
export function getWeaponImageUrl(weaponId, weaponName) {
  // Convert weapon name to filesystem-safe format (matches download script naming)
  // This matches the human-readable names used in the download script
  const safeName = weaponName
    .replace(/\s+/g, '-')           // Replace spaces with hyphens
    .replace(/\./g, '')             // Remove periods (e.g., "MOD.4" -> "MOD4")
    .replace(/[^a-zA-Z0-9-]/g, '')  // Remove special characters except hyphens
    .replace(/-+/g, '-')           // Collapse multiple hyphens
    .replace(/^-|-$/g, '');         // Remove leading/trailing hyphens
  
  // Return primary path - browser will handle fallback via onerror handler
  // The actual fallback logic should be in the HTML/img tag's onerror handler
  return `weapons/${weaponId}/${safeName}.png`;
}

/**
 * Get a random weapon
 */
export function getRandomWeapon() {
  return WEAPONS[Math.floor(Math.random() * WEAPONS.length)];
}

/**
 * Get multiple random weapons (excluding specified ones)
 */
export function getRandomWeapons(count, excludeIds = []) {
  const available = WEAPONS.filter(w => !excludeIds.includes(w.id));
  const shuffled = [...available].sort(() => 0.5 - Math.random());
  return shuffled.slice(0, count);
}

/**
 * Get weapon image URL based on audio file variant
 * Some weapons have different images for suppressed vs loud variants
 */
export function getWeaponImageUrlForAudio(weaponId, weaponName, audioFile = '') {
  // Special case: M4A1 has different image for suppressed variant
  if (weaponId === 'm4a1' && audioFile.includes('silenced')) {
    return 'weapons/m4a1/M4A1-Suppressed.png';
  }
  
  // Default to standard image
  return getWeaponImageUrl(weaponId, weaponName);
}

