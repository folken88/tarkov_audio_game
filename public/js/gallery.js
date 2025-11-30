/**
 * Gallery page - Diagnostic view of all weapons, images, and audio
 */

import { WEAPONS, getWeaponImageUrl } from './weapons.js';

// Audio file mapping (same as in game.js)
// All files are now in weapons/{weaponId}/{range}/ folders
function getAvailableAudioFiles(weaponId) {
  const weaponAudioMap = {
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
    'sv-98': ['weapons/sv-98/medium/rifle_sv98_shot_only.mp3', 'weapons/sv-98/medium/rifle_sv98_shot_reload.mp3', 'weapons/sv-98/medium/rifle_sv98_shot_reload_unholy.mp3', 'weapons/sv-98/medium/sv98.mp3'],
    'svd': ['weapons/svd/medium/rifle_svd_burst4.mp3', 'weapons/svd/medium/svd_loud_1shot.mp3', 'weapons/svd/medium/svd_silenced_1hsot.mp3', 'weapons/svd/far/svd_rsass_distance.mp3'],
    't-5000': ['weapons/t-5000/medium/rifle_t5000_MAGUS-FRIGID-BLAST.mp3', 'weapons/t-5000/medium/rifle_t5000_shot_reload.mp3'],
    'axmc': ['weapons/axmc/medium/lapua_338_magnum.mp3'],
    'sr-25': ['weapons/sr-25/medium/sr25_silenced_1shot.mp3', 'weapons/sr-25/medium/sr25_silenced_3shot_burst.mp3'],
    'rsass': ['weapons/rsass/medium/rsass_suppressed_burst.mp3', 'weapons/rsass/medium/rsass_suppressed_single.mp3'],
    'saiga-12k': ['weapons/saiga-12k/medium/saiga_1shot_.mp3', 'weapons/saiga-12k/medium/saiga_4shot_burst.mp3'],
    'tt': ['weapons/tt/medium/tt_pistol_1shot.mp3', 'weapons/tt/medium/tt_pistol_3shot_burst.mp3'],
    'dvl-10': ['weapons/dvl-10/medium/dvl_silenced.mp3'],
    'scar-h': ['weapons/scar-h/medium/rifle_mk17_burst4.mp3'],
    'vpo-209': ['weapons/vpo-209/medium/rifle_gornostay_366_shot_reload.mp3', 'weapons/vpo-209/medium/rifle_vpo366_burst4.mp3'],
    'rfb': ['weapons/rfb/medium/rfb_burst.mp3']
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
    img.className = 'weapon-card-image';
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

