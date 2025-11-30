/**
 * Tarkov Weapon Sound Trainer Game Logic
 */

import { WEAPONS, getRandomWeapon, getRandomWeapons, getWeaponImageUrl } from './weapons.js';
import { 
  initAudioContext, 
  playAudioWithEffects, 
  stopAudio,
  isSupported as isAudioEffectsSupported 
} from './audio-effects.js';

// List of weapons that have audio files available
const WEAPONS_WITH_AUDIO = [
  'ak-103',
  'ak-50',
  'ash-12',
  'axmc',
  'dvl-10',
  'fn57',
  'glock-18c',
  'hk416a5',
  'm4a1',
  'm700',
  'mdr-308',
  'mk47',
  'mosin',
  'mp-153',
  'p90',
  'pm',
  'rfb',
  'rsass',
  'rsh12',
  'saiga-12k',
  'scar-h',
  'scar-l',
  'sks',
  'sr-25',
  'sv-98',
  'svd',
  't-5000',
  'tt',
  'vpo-209'
];

// Weapons that still need audio files (for reference)
// This list will be updated as files are added
const WEAPONS_NEEDING_AUDIO = [
  // Assault Carbines
  '9a-91', 'adar-2-15', 'as-val-mod4', 'avt-40', 'op-sks', 'sag-ak', 'sag-ak-short', 'sr-3m',
  // Assault Rifles (missing)
  'ak-74n', 'ak-74m', 'ak-101', 'ak-102', 'ak-104', 'ak-105', 'akm', 'akmn', 'akms', 'akmsn',
  'sa-58', 'tx-15', 'rd-704', 'ak-12', 'ak-15', 'mdr-556',
  // Bolt-Action Rifles (missing)
  'm700-tac', 'm700-sass', 'm700-ultra',
  // DMRs (missing)
  'svds', 'vss', 'as-val', 'm1a', 'm1a-sass',
  // Light Machine Guns
  'rpk-16', 'pkp', 'pkm', 'm249', 'm240b',
  // Shotguns (missing)
  'mp-133', 'mp-155', 'mp-18', 'toz-106', 'remington-870', 'm1014', 'm590a1',
  // SMGs (missing)
  'mp5', 'mp5k', 'mp5sd', 'mp7', 'mp9', 'pp-19-01', 'pp-91', 'pp-91-01', 'ppsh-41', 'ump45',
  'saiga-9', 'stm-9', 'sr-2m',
  // Pistols (missing)
  'p226', 'glock-17', 'm9a3', 'm1911a1', 'apb', 'aps', 'sr1mp'
];

// Game state
let currentRound = 1;
let score = 0;
let streak = 0;
let correctWeapon = null;
let selectedWeapon = null;
let roundComplete = false;
let audioFiles = {}; // Will be populated with available audio files
let currentAudioFile = null; // Track which audio file is currently playing
let audioEffectsEnabled = false; // Whether to use audio effects
let currentEffects = { pan: 0, distance: 0, muffled: 0, throughWall: 0 }; // Current effect configuration

// DOM elements
const roundNumberEl = document.getElementById('round-number');
const scoreEl = document.getElementById('score');
const streakEl = document.getElementById('streak');
const btnPlay = document.getElementById('btn-play');
const btnNextRound = document.getElementById('btn-next-round');
const btnNewGame = document.getElementById('btn-new-game');
const audioPlayer = document.getElementById('audio-player');
const audioInfoText = document.getElementById('audio-info-text');
const choicesGrid = document.getElementById('choices-grid');
const resultMessage = document.getElementById('result-message');

/**
 * Initialize the game
 */
function initGame() {
  // Load available audio files (will be populated when you add audio files)
  // For now, we'll use placeholder logic
  loadAudioFiles();
  
  // Verify we have weapons with audio
  const availableCount = WEAPONS.filter(w => WEAPONS_WITH_AUDIO.includes(w.id)).length;
  if (availableCount === 0) {
    audioInfoText.textContent = 'No weapons with audio files available. Please add audio files.';
    console.error('[Game] No weapons with audio files!');
    return;
  }
  
  console.info(`[Game] Initialized with ${availableCount} weapons that have audio files`);
  startNewRound();
}

/**
 * Load available audio files
 * This will scan the weapon directory structure
 * Format: weapons/{weapon-id}/{range}/{filename}.mp3
 */
async function loadAudioFiles() {
  audioFiles = {};
  
  // Fetch the audio directory structure
  try {
    // We'll build the file list from the known weapon structure
    // Since we can't easily scan server-side, we'll use a manifest approach
    // For now, we'll try to load files and see what's available
    
    // Get list of weapons that might have audio
    const weaponsWithAudio = [
      'ak-103', 'ak-50', 'm4a1', 'glock-18c', 'm700', 'mdr-308', 'mk47',
      'mosin', 'mp-153', 'p90', 'fn57', 'rsh12', 'ash-12', 'sv-98', 'svd',
      't-5000', 'sr-25', 'rsass', 'saiga-12k', 'tt', 'dvl-10', 'scar-h',
      'vpo-209', 'rfb'
    ];
    
    // For each weapon, try to discover available files
    // We'll use a simple approach: try common filenames
    for (const weaponId of weaponsWithAudio) {
      audioFiles[weaponId] = [];
      
      // Try different ranges
      const ranges = ['close', 'medium', 'far'];
      for (const range of ranges) {
        // We'll discover files by attempting to load them
        // The actual file discovery will happen when we try to play
        // For now, we'll use a pattern-based approach
      }
    }
    
    console.info('[Game] Audio file structure initialized');
  } catch (error) {
    console.error('[Game] Error loading audio files:', error);
  }
}

/**
 * Get available audio files for a weapon
 * Returns array of file paths based on organized structure
 */
function getAvailableAudioFiles(weaponId) {
  // Map of weapon IDs to their actual file names based on organized structure
  // All files are now in weapons/{weaponId}/{range}/ folders
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
    'pm': ['weapons/pm/medium/pistol_pm_burst.mp3', 'weapons/pm/medium/pistol_pm_single_shot.mp3'],
    // RSh-12: Revolver pistol (12.7x55mm)
    'rsh12': ['weapons/rsh12/medium/pistol_revolver_burst4.mp3', 'weapons/rsh12/medium/pistol_rsh12_empty_reload.mp3', 'weapons/rsh12/medium/pistol_rsh12_empty_reload2.mp3'],
    // ASh-12: Assault rifle (12.7x55mm) - DIFFERENT WEAPON from RSh-12
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
    'sks': ['weapons/sks/medium/rifle_sks_burst.mp3', 'weapons/sks/medium/rifle_sks_single_shot.mp3'],
    'vpo-209': ['weapons/vpo-209/medium/rifle_gornostay_366_shot_reload.mp3', 'weapons/vpo-209/medium/rifle_vpo366_burst4.mp3'],
    'rfb': ['weapons/rfb/medium/rfb_burst.mp3']
  };
  
  return weaponAudioMap[weaponId] || [];
}

/**
 * Get a random weapon that has audio files available
 */
function getRandomWeaponWithAudio() {
  const availableWeapons = WEAPONS.filter(w => WEAPONS_WITH_AUDIO.includes(w.id));
  if (availableWeapons.length === 0) {
    console.error('[Game] No weapons with audio files available!');
    return null;
  }
  return availableWeapons[Math.floor(Math.random() * availableWeapons.length)];
}

/**
 * Get multiple random weapons with audio (excluding specified ones)
 */
function getRandomWeaponsWithAudio(count, excludeIds = []) {
  const available = WEAPONS.filter(w => 
    WEAPONS_WITH_AUDIO.includes(w.id) && !excludeIds.includes(w.id)
  );
  const shuffled = [...available].sort(() => 0.5 - Math.random());
  return shuffled.slice(0, count);
}

/**
 * Start a new round
 */
function startNewRound() {
  roundComplete = false;
  selectedWeapon = null;
  
  // Hide result message without affecting layout
  resultMessage.style.opacity = '0';
  resultMessage.style.visibility = 'hidden';
  resultMessage.style.transition = 'opacity 0.3s ease, visibility 0s linear 0.3s';
  
  // Remove result background colors from game section
  const gameSection = document.querySelector('.game-section');
  gameSection.classList.remove('result-correct', 'result-incorrect');
  
  // Select correct weapon (only from those with audio)
  correctWeapon = getRandomWeaponWithAudio();
  
  if (!correctWeapon) {
    audioInfoText.textContent = 'No weapons with audio files available. Please add audio files.';
    return;
  }
  
  // Get 7 random incorrect weapons (also only from those with audio)
  const incorrectWeapons = getRandomWeaponsWithAudio(7, [correctWeapon.id]);
  
  // Ensure we have enough weapons - if not, we'll use what we have
  const availableCount = WEAPONS.filter(w => WEAPONS_WITH_AUDIO.includes(w.id)).length;
  if (availableCount < 8) {
    console.warn(`[Game] Only ${availableCount} weapons with audio available. Game will use ${availableCount} choices.`);
  }
  
  // Combine and shuffle - correct weapon is always included
  const allChoices = [correctWeapon, ...incorrectWeapons].sort(() => 0.5 - Math.random());
  
  // Safety check: ensure correct weapon is in choices (should always be true, but verify)
  if (!allChoices.find(w => w.id === correctWeapon.id)) {
    console.error('[Game] CRITICAL: Correct weapon not in choices! Adding it now.');
    allChoices[0] = correctWeapon; // Force it to be first
  }
  
  console.log(`[Game] Round ${currentRound}: Correct weapon is ${correctWeapon.name} (${correctWeapon.id}). Total choices: ${allChoices.length}`);
  
  // Render choices
  renderChoices(allChoices);
  
  // Set up audio - get a random file from available files for this weapon
  const availableAudio = getAvailableAudioFiles(correctWeapon.id);
  if (availableAudio.length > 0) {
    const randomFile = availableAudio[Math.floor(Math.random() * availableAudio.length)];
    currentAudioFile = randomFile; // Store the current audio file for debugging
    
    // Reset effects for new round (will be updated by checkboxes)
    currentEffects = { pan: 0, distance: 0, muffled: 0, throughWall: 0 };
    
    // Set up HTML5 audio as fallback
    audioPlayer.src = randomFile;
    audioPlayer.onerror = () => {
      audioInfoText.textContent = 'Error loading audio file.';
      console.warn('[Game] Audio file error:', randomFile);
    };
    audioInfoText.textContent = 'Click "Play Sound" to hear the weapon';
    btnPlay.disabled = false;
  } else {
    // This shouldn't happen if we're filtering correctly, but handle it gracefully
    audioInfoText.textContent = `No audio files found for ${correctWeapon.name}. Restarting round...`;
    console.error('[Game] No audio files found for weapon:', correctWeapon.id);
    setTimeout(() => startNewRound(), 1000);
    return;
  }
  
  // Reset UI
  btnNextRound.disabled = true;
  
  // Stop all audio when starting new round (clean slate)
  stopAudio();
  // Clean up HTML5 audio clones
  html5AudioClones.forEach(clone => {
    try {
      clone.pause();
      clone.remove();
    } catch (e) {
      // Already removed
    }
  });
  html5AudioClones = [];
  if (audioPlayer) {
    audioPlayer.pause();
    audioPlayer.currentTime = 0;
  }
  
  // Enable all choice buttons
  document.querySelectorAll('.choice-button').forEach(btn => {
    btn.disabled = false;
    btn.classList.remove('correct', 'incorrect');
  });
}

/**
 * Render choice buttons
 */
function renderChoices(weapons) {
  choicesGrid.innerHTML = '';
  
  weapons.forEach(weapon => {
    const button = document.createElement('button');
    button.className = 'choice-button';
    button.dataset.weaponId = weapon.id;
    
    // Create image element
    const img = document.createElement('img');
    img.alt = weapon.name;
    img.className = 'choice-button__image';
    
    // Try loading image with fallback chain
    const safeName = weapon.name
      .replace(/\s+/g, '-')
      .replace(/\./g, '')
      .replace(/[^a-zA-Z0-9-]/g, '')
      .replace(/-+/g, '-')
      .replace(/^-|-$/g, '');
    
    let attemptCount = 0;
    const fallbackPaths = [
      `weapons/${weapon.id}/${safeName}.png`,
      `weapons/${weapon.id}/${safeName}.gif`,
      `weapons/${weapon.id}/image.png`,
      `weapons/${weapon.id}/image.gif`
    ];
    
    img.onerror = function() {
      attemptCount++;
      if (attemptCount < fallbackPaths.length) {
        // Try next fallback path
        this.src = fallbackPaths[attemptCount];
      } else {
        // All fallbacks failed, hide image and show text only
        this.style.display = 'none';
        button.classList.add('choice-button--no-image');
      }
    };
    
    img.src = fallbackPaths[0]; // Start with primary path
    
    // Create text element
    const text = document.createElement('span');
    text.className = 'choice-button__text';
    text.textContent = weapon.name;
    
    button.appendChild(img);
    button.appendChild(text);
    button.addEventListener('click', () => selectWeapon(weapon.id));
    choicesGrid.appendChild(button);
  });
}

/**
 * Handle weapon selection
 */
function selectWeapon(weaponId) {
  if (roundComplete) return;
  
  selectedWeapon = weaponId;
  roundComplete = true;
  
  const isCorrect = weaponId === correctWeapon.id;
  
  // Update score and streak
  const audioFileName = currentAudioFile ? currentAudioFile.split('/').pop() : 'unknown';
  
  // Get the game section for background color
  const gameSection = document.querySelector('.game-section');
  
  if (isCorrect) {
    score += 10;
    streak += 1;
    resultMessage.innerHTML = `Correct! It was a ${correctWeapon.name}<br><small style="opacity: 0.7; font-size: 0.75em;">Sound: ${audioFileName}</small>`;
    resultMessage.className = 'result-message correct';
    // Light up background panel green
    gameSection.classList.remove('result-incorrect');
    gameSection.classList.add('result-correct');
  } else {
    streak = 0;
    const correctName = correctWeapon.name;
    resultMessage.innerHTML = `Incorrect! It was a ${correctName}<br><small style="opacity: 0.7; font-size: 0.75em;">Sound: ${audioFileName}</small>`;
    resultMessage.className = 'result-message incorrect';
    // Light up background panel red
    gameSection.classList.remove('result-correct');
    gameSection.classList.add('result-incorrect');
  }
  
  // Show result message without affecting layout
  resultMessage.style.opacity = '1';
  resultMessage.style.visibility = 'visible';
  resultMessage.style.transition = 'opacity 0.3s ease';
  
  // Update UI
  document.querySelectorAll('.choice-button').forEach(btn => {
    btn.disabled = true;
    if (btn.dataset.weaponId === correctWeapon.id) {
      btn.classList.add('correct');
    } else if (btn.dataset.weaponId === weaponId && !isCorrect) {
      btn.classList.add('incorrect');
    }
  });
  
  // Update stats
  updateStats();
  
  // Enable next round button
  btnNextRound.disabled = false;
}

/**
 * Update game statistics
 */
function updateStats() {
  roundNumberEl.textContent = currentRound;
  scoreEl.textContent = score;
  streakEl.textContent = streak;
}

// Track HTML5 audio clones for overlapping playback
let html5AudioClones = [];

/**
 * Play the audio (allows overlapping playback for rapid fire simulation)
 */
async function playAudio() {
  if (!currentAudioFile) {
    audioInfoText.textContent = 'No audio file available for this weapon.';
    return;
  }

  // Don't stop previous audio - allow overlapping for rapid fire
  audioInfoText.textContent = 'Playing audio...';

  try {
    if (audioEffectsEnabled && isAudioEffectsSupported()) {
      // Use Web Audio API with effects
      // Initialize context on first user interaction if needed
      if (!initAudioContext()) {
        throw new Error('Failed to initialize audio context');
      }

      // Create new source (allows overlapping with previous plays)
      await playAudioWithEffects(currentAudioFile, currentEffects);
      // Don't change text immediately - let it play
    } else {
      // Use standard HTML5 audio (no effects)
      // Clone the audio element for overlapping playback
      const audioClone = audioPlayer.cloneNode();
      audioClone.src = currentAudioFile;
      audioClone.volume = audioPlayer.volume;
      
      // Clean up clone when finished
      audioClone.onended = () => {
        const index = html5AudioClones.indexOf(audioClone);
        if (index > -1) {
          html5AudioClones.splice(index, 1);
        }
        audioClone.remove();
      };
      
      // Track clone
      html5AudioClones.push(audioClone);
      
      // Play the clone
      await audioClone.play();
    }
  } catch (err) {
    console.error('[Game] Error playing audio:', err);
    audioInfoText.textContent = 'Error playing audio. Please check the file.';
  }
}

/**
 * Move to next round
 */
function nextRound() {
  currentRound += 1;
  startNewRound();
}

/**
 * Start a new game
 */
function newGame() {
  currentRound = 1;
  score = 0;
  streak = 0;
  updateStats();
  startNewRound();
}

// Audio effects controls
const audioEffectsToggle = document.getElementById('audio-effects-enabled');
const audioEffectsContainer = document.getElementById('audio-effects-container');
const distanceClose = document.getElementById('distance-close');
const distanceMedium = document.getElementById('distance-medium');
const distanceFar = document.getElementById('distance-far');
const helmetMuffled = document.getElementById('helmet-muffled');
const throughWall = document.getElementById('through-wall');

function updateEffects() {
  if (!audioEffectsEnabled) {
    currentEffects = { pan: 0, distance: 0, muffled: 0, throughWall: 0 };
    return;
  }

  // Distance effects (mutually exclusive)
  if (distanceFar?.checked) {
    currentEffects.distance = 0.7; // Far
  } else if (distanceMedium?.checked) {
    currentEffects.distance = 0.4; // Medium
  } else if (distanceClose?.checked) {
    currentEffects.distance = 0; // Close
  } else {
    currentEffects.distance = 0; // Default to close
  }

  // Muffled effects (can combine)
  currentEffects.muffled = 0;
  currentEffects.throughWall = 0;

  if (helmetMuffled?.checked) {
    currentEffects.muffled = 0.5; // Helmet muffling
  }

  if (throughWall?.checked) {
    currentEffects.throughWall = 0.8; // Through wall (stronger muffling)
    // Through wall also adds some distance effect
    if (currentEffects.distance < 0.3) {
      currentEffects.distance = 0.3;
    }
  }

  console.info('[Game] Effects updated:', currentEffects);
}

if (isAudioEffectsSupported()) {
  // Show controls if Web Audio API is supported
  if (audioEffectsContainer) {
    audioEffectsContainer.style.display = 'block';
  }

  // Load saved preferences
  const savedEnabled = localStorage.getItem('audioEffectsEnabled');
  if (savedEnabled !== null) {
    audioEffectsEnabled = savedEnabled === 'true';
    if (audioEffectsToggle) {
      audioEffectsToggle.checked = audioEffectsEnabled;
    }
  }

  // Load saved effect preferences
  const savedDistance = localStorage.getItem('audioDistance');
  const savedHelmet = localStorage.getItem('audioHelmet');
  const savedWall = localStorage.getItem('audioWall');

  if (savedDistance && distanceClose && distanceMedium && distanceFar) {
    if (savedDistance === 'close') distanceClose.checked = true;
    else if (savedDistance === 'medium') distanceMedium.checked = true;
    else if (savedDistance === 'far') distanceFar.checked = true;
  } else {
    // Default to medium
    if (distanceMedium) distanceMedium.checked = true;
  }

  if (savedHelmet === 'true' && helmetMuffled) {
    helmetMuffled.checked = true;
  }

  if (savedWall === 'true' && throughWall) {
    throughWall.checked = true;
  }

  // Set up event listeners
  const audioEffectsOptions = document.getElementById('audio-effects-options');
  
  if (audioEffectsToggle) {
    audioEffectsToggle.addEventListener('change', (e) => {
      audioEffectsEnabled = e.target.checked;
      localStorage.setItem('audioEffectsEnabled', audioEffectsEnabled);
      
      // Show/hide options
      if (audioEffectsOptions) {
        audioEffectsOptions.style.display = audioEffectsEnabled ? 'block' : 'none';
      }
      
      updateEffects();
      // Note: We don't stop audio here to allow overlapping
    });
    
    // Show options if already enabled
    if (audioEffectsEnabled && audioEffectsOptions) {
      audioEffectsOptions.style.display = 'block';
    }
  }

  // Distance radio buttons (mutually exclusive)
  [distanceClose, distanceMedium, distanceFar].forEach(radio => {
    if (radio) {
      radio.addEventListener('change', (e) => {
        if (e.target.checked) {
          localStorage.setItem('audioDistance', e.target.value);
          updateEffects();
        }
      });
    }
  });

  // Helmet checkbox
  if (helmetMuffled) {
    helmetMuffled.addEventListener('change', (e) => {
      localStorage.setItem('audioHelmet', e.target.checked);
      updateEffects();
    });
  }

  // Through wall checkbox
  if (throughWall) {
    throughWall.addEventListener('change', (e) => {
      localStorage.setItem('audioWall', e.target.checked);
      updateEffects();
    });
  }

  // Initialize effects
  updateEffects();
}

// Event listeners
btnPlay.addEventListener('click', playAudio);
btnNextRound.addEventListener('click', nextRound);
btnNewGame.addEventListener('click', newGame);

// Initialize game on load
document.addEventListener('DOMContentLoaded', () => {
  initGame();
});

