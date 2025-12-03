/**
 * Gallery page - Diagnostic view of all weapons, images, and audio
 */

import { WEAPONS, getWeaponImageUrl } from './weapons.js';

// Audio file mapping (same as in game.js)
// All files are now in weapons/{weaponId}/{range}/ folders
function getAvailableAudioFiles(weaponId) {
  const weaponAudioMap = {
    'aa-12': ['weapons/aa-12/medium/tarkov_mps_auto_assault-12_gen1_aa12_burst.mp3', 'weapons/aa-12/medium/tarkov_mps_auto_assault-12_gen1_aa12_single_shot.mp3'],
    'ak-103': ['weapons/ak-103/medium/ak103_fullauto.mp3', 'weapons/ak-103/medium/ak103_singleshotmp3.mp3'],
    'ak-50': ['weapons/ak-50/medium/ak50_burst_reload.mp3', 'weapons/ak-50/medium/ak50_single_shot.mp3', 'weapons/ak-50/medium/ak50_single_shot_glass_break.mp3'],
    'm4a1': ['weapons/m4a1/medium/m4_fullauto.mp3', 'weapons/m4a1/medium/m4_loud_1shot.mp3', 'weapons/m4a1/medium/m4_silenced_burst.mp3'],
    'glock-18c': ['weapons/glock-18c/medium/glock18_burst_fullauto.mp3', 'weapons/glock-18c/medium/glock18_burst_semiauto.mp3', 'weapons/glock-18c/medium/glock18_singleshot.mp3'],
    'm700': ['weapons/m700/medium/m700_bolt.mp3', 'weapons/m700/medium/rifle_m700_loud.mp3', 'weapons/m700/medium/rifle_m700_shot_reload.mp3'],
    'mdr-308': ['weapons/mdr-308/medium/mdr762_loud_burst.mp3', 'weapons/mdr-308/medium/mdr762_loud_single.mp3'],
    'mk47': ['weapons/mk47/medium/mutant_mk47_burst_loud.mp3', 'weapons/mk47/medium/mutant_mk47_single_loud.mp3'],
    'mosin': ['weapons/mosin/medium/mosin_sniper.mp3'],
    'mp-153': ['weapons/mp-153/medium/mp153_shotgun.mp3'],
    'p90': ['weapons/p90/medium/p90_silenced_burst.mp3'],
    'fn57': ['weapons/fn57/medium/pistol_fn57_burst.mp3'],
    'rsh12': ['weapons/rsh12/medium/pistol_revolver_burst4.mp3', 'weapons/rsh12/medium/pistol_rsh12_empty_reload.mp3', 'weapons/rsh12/medium/pistol_rsh12_empty_reload2.mp3'],
    'ash-12': ['weapons/ash-12/medium/rifle_ash12_loud_burst4.mp3', 'weapons/ash-12/medium/rifle_ash12_silenced_burst_casings.mp3'],
    'sv-98': ['weapons/sv-98/medium/rifle_sv98_shot_only.mp3', 'weapons/sv-98/medium/rifle_sv98_shot_reload.mp3', 'weapons/sv-98/medium/sv98.mp3'],
    'svd': ['weapons/svd/medium/rifle_svd_burst4.mp3', 'weapons/svd/medium/svd_loud_1shot.mp3', 'weapons/svd/medium/svd_silenced_1hsot.mp3', 'weapons/svd/far/svd_rsass_distance.mp3'],
    't-5000': ['weapons/t-5000/medium/rifle_t5000_shot_reload.mp3'],
    'axmc': ['weapons/axmc/medium/rifle_axmc_lapua_338_magnum.mp3'],
    'sr-25': ['weapons/sr-25/medium/sr25_silenced_1shot.mp3', 'weapons/sr-25/medium/sr25_silenced_3shot_burst.mp3'],
    'rsass': ['weapons/rsass/medium/rsass_suppressed_burst.mp3', 'weapons/rsass/medium/rsass_suppressed_single.mp3'],
    'mk-18': ['weapons/mk-18/medium/tarkov_sword_international_mk-18_338_lm_marksman_rifle_burst.mp3', 'weapons/mk-18/medium/tarkov_sword_international_mk-18_338_lm_marksman_rifle_single_shot.mp3'],
    'saiga-12k': ['weapons/saiga-12k/medium/saiga_1shot_.mp3', 'weapons/saiga-12k/medium/saiga_4shot_burst.mp3'],
    'tt': ['weapons/tt/medium/tt_pistol_1shot.mp3', 'weapons/tt/medium/tt_pistol_3shot_burst.mp3'],
    'dvl-10': ['weapons/dvl-10/medium/dvl_silenced.mp3'],
    'fn40gl': ['weapons/fn40gl/medium/tarkov_fn40gl_mk2_40mm_grenade_launcher_single_shot.mp3'],
    'ks-23m': ['weapons/ks-23m/medium/tarkov_toz_ks-23m_pump_action_shotgun_single_shot.mp3'],
    'm1a': ['weapons/m1a/medium/tarkov_springfield_armory_m1a_rifle_sass_burst.mp3', 'weapons/m1a/medium/tarkov_springfield_armory_m1a_rifle_sass_burst_suppressed.mp3', 'weapons/m1a/medium/tarkov_springfield_armory_m1a_rifle_sass_single_shot.mp3', 'weapons/m1a/medium/tarkov_springfield_armory_m1a_rifle_sass_single_shot_suppressed.mp3'],
    'pkm': ['weapons/pkm/medium/tarkov_kalashnikov_pkm_machine_gun_burst.mp3', 'weapons/pkm/medium/tarkov_kalashnikov_pkm_machine_gun_single_shot.mp3'],
    'rpd': ['weapons/rpd/medium/tarkov_degtyarev_rpd_machine_gun_burst.mp3', 'weapons/rpd/medium/tarkov_degtyarev_rpd_machine_gun_single_shot.mp3'],
    'sa-58': ['weapons/sa-58/medium/tarkov_ds_arms_sa58_fal_rifle_burst.mp3', 'weapons/sa-58/medium/tarkov_ds_arms_sa58_fal_rifle_single_shot.mp3'],
    'scar-l': ['weapons/scar-l/medium/rifle_scar-l_burst.mp3', 'weapons/scar-l/medium/rifle_scar-l_suppressed_burst.mp3', 'weapons/scar-l/medium/rifle_mk17_burst4.mp3'],
    'sks': ['weapons/sks/medium/rifle_sks_burst.mp3', 'weapons/sks/medium/rifle_sks_single_shot.mp3'],
    'sr-2m': ['weapons/sr-2m/medium/tarkov_sr2_submachine_gun_loud_burst.mp3', 'weapons/sr-2m/medium/tarkov_sr2_submachine_gun_single_shot_loud.mp3'],
    'vpo-209': ['weapons/vpo-209/medium/rifle_gornostay_366_shot_reload.mp3', 'weapons/vpo-209/medium/rifle_vpo366_burst4.mp3'],
    'rfb': ['weapons/rfb/medium/rfb_burst.mp3'],
    'nl545-gp': ['weapons/nl545-gp/medium/rifle_nl545_gp_burst.mp3', 'weapons/nl545-gp/medium/rifle_nl545_gp_burst_short.mp3', 'weapons/nl545-gp/medium/rifle_nl545_gp_single_shot.mp3'],
    'marlin-mxlr': ['weapons/marlin-mxlr/medium/rifle_marlin_mxlr_single.mp3', 'weapons/marlin-mxlr/medium/rifle_marlin_mxlr_triple.mp3'],
    'hk416a5': ['weapons/hk416a5/medium/rifle_hk416_loud_burst.mp3', 'weapons/hk416a5/medium/rifle_hk416_suppressed_burst.mp3', 'weapons/hk416a5/medium/rifle_hk416_suppressed_single_shot.mp3', 'weapons/hk416a5/close/rifle_hk416_loud_single_shot.mp3'],
    'vpo-101': ['weapons/vpo-101/close/rifle_vpo101_burst.mp3', 'weapons/vpo-101/close/rifle_vpo101_single_shot.mp3'],
    'sako-trg-m10': ['weapons/sako-trg-m10/close/rifle_sako_trg_m10_shot_reload.mp3'],
    'mcx-spear': ['weapons/mcx-spear/close/rifle_mcx_spear_burst.mp3', 'weapons/mcx-spear/close/rifle_mcx_spear_single_shot.mp3'],
    'm60e6': ['weapons/m60e6/close/rifle_m60e6_burst_long.mp3', 'weapons/m60e6/close/rifle_m60e6_single_shot.mp3'],
    'pm': ['weapons/pm/medium/pistol_pm_burst.mp3', 'weapons/pm/medium/pistol_pm_single_shot.mp3', 'weapons/pm/close/pistol_pm_burst_alt.mp3', 'weapons/pm/close/pistol_pm_single_shot_alt.mp3'],
    'as-val': ['weapons/as-val/medium/tarkov_as_val_special_assault_rifle_burst.mp3', 'weapons/as-val/medium/tarkov_as_val_special_assault_rifle_single_shot.mp3'],
    'aks-74u': ['weapons/aks-74u/medium/tarkov_kalashnikov_aks-74u_assault_rifle_burst_loud.mp3', 'weapons/aks-74u/medium/tarkov_kalashnikov_aks-74u_assault_rifle_burst_suppressed.mp3', 'weapons/aks-74u/medium/tarkov_kalashnikov_aks-74u_assault_rifle_single_loud.mp3', 'weapons/aks-74u/medium/tarkov_kalashnikov_aks-74u_assault_rifle_single_suppressed.mp3'],
    'g36': ['weapons/g36/medium/tarkov_g36_burst_loud.mp3', 'weapons/g36/medium/tarkov_g36_single_shot_loud.mp3'],
    'aug-a3': ['weapons/aug-a3/medium/tarkov_steyr_aug_a3_rifle_loud_burst.mp3', 'weapons/aug-a3/medium/tarkov_steyr_aug_a3_rifle_loud_single_shot.mp3'],
    'mp5': ['weapons/mp5/medium/tarkov_hk_mp5_submachine_gun_loud_burst.mp3', 'weapons/mp5/medium/tarkov_hk_mp5_submachine_gun_loud_single_shot.mp3'],
    'mpx': ['weapons/mpx/medium/tarkov_sig_mpx_submachine_gun_suppressed_burst.mp3', 'weapons/mpx/medium/tarkov_sig_mpx_submachine_gun_suppressed_single_shot.mp3'],
    'rhino-50ds': ['weapons/rhino-50ds/medium/tarkov_chiappa_rhino_50ds_357_revolver_burst.mp3', 'weapons/rhino-50ds/medium/tarkov_chiappa_rhino_50ds_357_revolver_single_shot.mp3']
  };
  return weaponAudioMap[weaponId] || [];
}

// Check if image exists (tries all fallback paths)
async function checkImageExists(weaponId, weaponName) {
  const safeName = weaponName
    .replace(/\s+/g, '-')
    .replace(/\./g, '')
    .replace(/[^a-zA-Z0-9-]/g, '')
    .replace(/-+/g, '-')
    .replace(/^-|-$/g, '');
  
  const fallbackPaths = [
    `weapons/${weaponId}/${safeName}.png`,
    `weapons/${weaponId}/${safeName}.gif`,
    `weapons/${weaponId}/image.png`,
    `weapons/${weaponId}/image.gif`
  ];
  
  for (const url of fallbackPaths) {
    const exists = await new Promise((resolve) => {
      const img = new Image();
      img.onload = () => resolve(true);
      img.onerror = () => resolve(false);
      img.src = url;
    });
    if (exists) return url; // Return the first path that works
  }
  return null; // No image found
}

// Create weapon card
async function createWeaponCard(weapon) {
  const imageUrl = await checkImageExists(weapon.id, weapon.name);
  const audioFiles = getAvailableAudioFiles(weapon.id);
  
  const imageExists = imageUrl !== null;
  const audioExists = audioFiles.length > 0;

  const card = document.createElement('div');
  card.className = 'weapon-card';
  
  if (!imageExists) card.classList.add('no-image');
  if (!audioExists) card.classList.add('no-audio');
  if (imageExists && audioExists) card.classList.add('complete');

  // Header with image and name
  const header = document.createElement('div');
  header.className = 'weapon-card-header';
  
  const imageContainer = document.createElement('div');
  imageContainer.className = 'weapon-card-image';
  if (imageExists) {
    const img = document.createElement('img');
    img.src = imageUrl; // This is the first working path from checkImageExists
    img.alt = weapon.name;
    // Don't add className to img - the container div already has the styling
    imageContainer.appendChild(img);
  } else {
    imageContainer.classList.add('missing');
    imageContainer.textContent = 'No Image';
  }
  
  const titleContainer = document.createElement('div');
  const title = document.createElement('div');
  title.className = 'weapon-card-title';
  title.textContent = weapon.name;
  const id = document.createElement('div');
  id.className = 'weapon-card-id';
  id.textContent = weapon.id;
  titleContainer.appendChild(title);
  titleContainer.appendChild(id);
  
  header.appendChild(imageContainer);
  header.appendChild(titleContainer);
  
  // Audio section
  const audioSection = document.createElement('div');
  audioSection.className = 'weapon-card-audio';
  
  const audioTitle = document.createElement('h3');
  audioTitle.textContent = `Audio Files (${audioFiles.length})`;
  audioSection.appendChild(audioTitle);
  
  const audioList = document.createElement('div');
  audioList.className = 'audio-files-list';
  
  if (audioFiles.length === 0) {
    const noAudio = document.createElement('div');
    noAudio.className = 'audio-file-item missing';
    noAudio.textContent = 'No audio files available';
    audioList.appendChild(noAudio);
  } else {
    for (const audioFile of audioFiles) {
      const audioItem = document.createElement('div');
      audioItem.className = 'audio-file-item';
      
      const audioName = document.createElement('div');
      audioName.className = 'audio-file-name';
      audioName.textContent = audioFile.split('/').pop();
      
      const audioPlayer = document.createElement('audio');
      audioPlayer.controls = true;
      audioPlayer.preload = 'metadata';
      audioPlayer.src = audioFile;
      
      audioItem.appendChild(audioName);
      audioItem.appendChild(audioPlayer);
      audioList.appendChild(audioItem);
    }
  }
  
  audioSection.appendChild(audioList);
  
  card.appendChild(header);
  card.appendChild(audioSection);
  
  return { card, imageExists, audioExists };
}

// Initialize gallery
async function initGallery() {
  const galleryGrid = document.getElementById('gallery-grid');
  const totalWeaponsEl = document.getElementById('total-weapons');
  const withImagesEl = document.getElementById('with-images');
  const withAudioEl = document.getElementById('with-audio');
  const completeEl = document.getElementById('complete');
  
  let withImages = 0;
  let withAudio = 0;
  let complete = 0;
  
  totalWeaponsEl.textContent = WEAPONS.length;
  
  // Process weapons
  for (const weapon of WEAPONS) {
    const { card, imageExists, audioExists } = await createWeaponCard(weapon);
    galleryGrid.appendChild(card);
    
    if (imageExists) withImages++;
    if (audioExists) withAudio++;
    if (imageExists && audioExists) complete++;
    
    // Update stats
    withImagesEl.textContent = withImages;
    withAudioEl.textContent = withAudio;
    completeEl.textContent = complete;
  }
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initGallery);
} else {
  initGallery();
}

