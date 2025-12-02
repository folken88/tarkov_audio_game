/**
 * Tarkov Weapon Sound Trainer Game Logic
 */

import { WEAPONS, getRandomWeapon, getRandomWeapons, getWeaponImageUrl, getWeaponImageUrlForAudio, filterAudioBySuppressorStatus } from './weapons.js';
import { 
  initAudioContext, 
  playAudioWithEffects, 
  stopAudio,
  isSupported as isAudioEffectsSupported 
} from './audio-effects.js';

// List of weapons that have audio files available
const WEAPONS_WITH_AUDIO = [
  'aa-12',
  'ak-103',
  'ak-50',
  'aks-74u',
  'as-val',
  'ash-12',
  'aug-a3',
  'axmc',
  'dvl-10',
  'fn40gl',
  'fn57',
  'g36',
  'glock-18c',
  'hk416a5',
  'ks-23m',
  'm1a',
  'm4a1',
  'm60e6',
  'm700',
  'marlin-mxlr',
  'mdr-308',
  'mcx-spear',
  'mk-18',
  'mk47',
  'mosin',
  'mp-153',
  'mp5',
  'mpx',
  'nl545-gp',
  'p90',
  'pkm',
  'pm',
  'rfb',
  'rhino-50ds',
  'rpd',
  'rsass',
  'rsh12',
  'sa-58',
  'sako-trg-m10',
  'saiga-12k',
  'scar-l',
  'sks',
  'sr-2m',
  'sr-25',
  'sv-98',
  'svd',
  't-5000',
  'tt',
  'vpo-101',
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
  // Assault Rifles (missing) - new weapons
  'nl545-gp',
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
const MAX_ROUNDS = 50;
let currentRound = 1;
let score = 0;
let streak = 0;
let correctCount = 0;
let incorrectCount = 0;
let correctWeapon = null;
let selectedWeapon = null;
let roundComplete = false;
let audioFiles = {}; // Will be populated with available audio files
let currentAudioFile = null; // Track which audio file is currently playing
let audioEffectsEnabled = false; // Whether to use audio effects
let currentEffects = { pan: 0, distance: 0, muffled: 0, throughWall: 0 }; // Current effect configuration
let audioPlayCount = 0; // Track how many times audio has been played this round
let currentRoundPoints = 5; // Current points available for this round (starts at 5, decreases with each play)
let isSingleShotAudio = false; // Whether the current audio is a single-shot sound

// Seed system for competitive play
let gameSeed = null;
let seededRandom = null;

// Word lists for generating memorable seeds
const SEED_ADJECTIVES = ['swift', 'brave', 'quiet', 'sharp', 'quick', 'dark', 'bright', 'wild', 'calm', 'bold'];
const SEED_NOUNS = ['wolf', 'hawk', 'bear', 'fox', 'lion', 'tiger', 'eagle', 'shark', 'viper', 'raven'];

// DOM elements
const roundNumberEl = document.getElementById('round-number');
const scoreEl = document.getElementById('score');
const streakEl = document.getElementById('streak');
const rightWrongEl = document.getElementById('right-wrong');
const btnPlay = document.getElementById('btn-play');
const btnNextRound = document.getElementById('btn-next-round');
const btnNewGame = document.getElementById('btn-new-game');
const audioPlayer = document.getElementById('audio-player');
const audioInfoText = document.getElementById('audio-info-text');
const choicesGrid = document.getElementById('choices-grid');
const resultMessage = document.getElementById('result-message');
const pointsLog = document.getElementById('points-log');
const srAnnouncements = document.getElementById('sr-announcements');
const srAlerts = document.getElementById('sr-alerts');
const seedInput = document.getElementById('game-seed');
const btnCopySeed = document.getElementById('btn-copy-seed');
const btnNewSeed = document.getElementById('btn-new-seed');

/**
 * Seeded random number generator (Mulberry32)
 * @param {number} seed - Numeric seed
 * @returns {function} Random function that returns 0-1
 */
function createSeededRandom(seed) {
  return function() {
    let t = seed += 0x6D2B79F5;
    t = Math.imul(t ^ t >>> 15, t | 1);
    t ^= t + Math.imul(t ^ t >>> 7, t | 61);
    return ((t ^ t >>> 14) >>> 0) / 4294967296;
  };
}

/**
 * Convert string seed to numeric seed
 * @param {string} str - String seed
 * @returns {number} Numeric seed
 */
function stringToSeed(str) {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash = hash & hash; // Convert to 32bit integer
  }
  return Math.abs(hash);
}

/**
 * Generate a memorable word-based seed
 * @returns {string} Seed like "swift-wolf-42"
 */
function generateWordSeed() {
  const adj = SEED_ADJECTIVES[Math.floor(Math.random() * SEED_ADJECTIVES.length)];
  const noun = SEED_NOUNS[Math.floor(Math.random() * SEED_NOUNS.length)];
  const num = Math.floor(Math.random() * 100);
  return `${adj}-${noun}-${num}`;
}

/**
 * Initialize seed system
 * @param {string} seed - Optional seed string
 */
function initializeSeed(seed = null) {
  if (!seed || seed.trim() === '' || seed === 'auto') {
    // Generate new random seed
    gameSeed = generateWordSeed();
  } else {
    gameSeed = seed.trim().toLowerCase();
  }
  
  // Create seeded random function
  const numericSeed = stringToSeed(gameSeed);
  seededRandom = createSeededRandom(numericSeed);
  
  // Update input field
  seedInput.value = gameSeed;
  
  console.log(`[Seed] Initialized with seed: ${gameSeed}`);
  return gameSeed;
}

/**
 * Get a random number using the seeded generator
 * Falls back to Math.random() if no seed is set
 * @returns {number} Random number 0-1
 */
function getRandom() {
  return seededRandom ? seededRandom() : Math.random();
}

/**
 * Screen reader announcement utility
 * @param {string} message - Message to announce
 * @param {boolean} isAlert - Whether this is an alert (assertive) or polite announcement
 */
function announceToScreenReader(message, isAlert = false) {
  const target = isAlert ? srAlerts : srAnnouncements;
  if (target) {
    target.textContent = message;
    // Clear after announcement to allow same message to be announced again
    setTimeout(() => {
      target.textContent = '';
    }, 1000);
  }
  console.log(`[Screen Reader] ${isAlert ? 'ALERT' : 'Announce'}: ${message}`);
}

/**
 * Play a success sound using Web Audio API
 */
function playSuccessSound() {
  try {
    const audioContext = new (window.AudioContext || window.webkitAudioContext)();
    
    // Create a pleasant ascending tone
    const oscillator = audioContext.createOscillator();
    const gainNode = audioContext.createGain();
    
    oscillator.connect(gainNode);
    gainNode.connect(audioContext.destination);
    
    oscillator.frequency.setValueAtTime(523.25, audioContext.currentTime); // C5
    oscillator.frequency.setValueAtTime(659.25, audioContext.currentTime + 0.1); // E5
    oscillator.frequency.setValueAtTime(783.99, audioContext.currentTime + 0.2); // G5
    
    gainNode.gain.setValueAtTime(0.15, audioContext.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.3);
    
    oscillator.start(audioContext.currentTime);
    oscillator.stop(audioContext.currentTime + 0.3);
  } catch (e) {
    console.log('[Audio] Could not play success sound:', e);
  }
}

/**
 * Play a failure sound using Web Audio API
 */
function playFailureSound() {
  try {
    const audioContext = new (window.AudioContext || window.webkitAudioContext)();
    
    // Create a descending tone
    const oscillator = audioContext.createOscillator();
    const gainNode = audioContext.createGain();
    
    oscillator.connect(gainNode);
    gainNode.connect(audioContext.destination);
    
    oscillator.frequency.setValueAtTime(392.00, audioContext.currentTime); // G4
    oscillator.frequency.setValueAtTime(293.66, audioContext.currentTime + 0.15); // D4
    
    gainNode.gain.setValueAtTime(0.15, audioContext.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.3);
    
    oscillator.start(audioContext.currentTime);
    oscillator.stop(audioContext.currentTime + 0.3);
  } catch (e) {
    console.log('[Audio] Could not play failure sound:', e);
  }
}

/**
 * Initialize the game
 */
async function initGame() {
  // Load available audio files (will be populated when you add audio files)
  // For now, we'll use placeholder logic
  loadAudioFiles();
  
  // Load high scores
  await loadHighscores();
  
  // Verify we have weapons with audio
  const availableCount = WEAPONS.filter(w => WEAPONS_WITH_AUDIO.includes(w.id)).length;
  if (availableCount === 0) {
    audioInfoText.textContent = 'No weapons with audio files available. Please add audio files.';
    console.error('[Game] No weapons with audio files!');
    return;
  }
  
  console.info(`[Game] Initialized with ${availableCount} weapons that have audio files`);
  
  // Initialize seed system
  initializeSeed();
  
  // Set up seed control event listeners
  setupSeedControls();
  
  // Set up keyboard navigation
  setupKeyboardNavigation();
  
  // Announce game start to screen readers
  announceToScreenReader('Welcome to Tarkov Weapon Sound Trainer. Press P or Spacebar to play weapon sound, keys 1 through 8 to select weapons, N for new game, S to skip round. Navigate with Tab key.');
  
  startNewRound();
}

/**
 * Set up seed control event listeners
 */
function setupSeedControls() {
  // Handle seed input changes
  seedInput.addEventListener('change', () => {
    const newSeed = seedInput.value.trim();
    initializeSeed(newSeed);
    // Restart game with new seed
    newGame();
    announceToScreenReader(`Seed changed to ${gameSeed}. Starting new game.`);
  });
  
  // Copy seed to clipboard
  btnCopySeed.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(gameSeed);
      announceToScreenReader(`Seed ${gameSeed} copied to clipboard.`);
      
      // Visual feedback
      btnCopySeed.textContent = '✓';
      setTimeout(() => {
        btnCopySeed.textContent = '📋';
      }, 1000);
    } catch (err) {
      console.error('[Seed] Failed to copy:', err);
      announceToScreenReader('Failed to copy seed to clipboard.');
    }
  });
  
  // Generate new random seed
  btnNewSeed.addEventListener('click', () => {
    initializeSeed();
    newGame();
    announceToScreenReader(`New random seed generated: ${gameSeed}. Starting new game.`);
  });
  
  console.log('[Seed] Seed controls initialized');
}

/**
 * Set up keyboard navigation for accessibility
 */
let currentFocusIndex = 0;
let keyboardNavigationStarted = false; // Track if user has started keyboard navigation

function setupKeyboardNavigation() {
  document.addEventListener('keydown', (e) => {
    // Ignore if typing in an input field
    if (e.target.tagName === 'INPUT' && e.target.type === 'text') {
      return;
    }
    
    const key = e.key.toLowerCase();
    const buttons = Array.from(choicesGrid.querySelectorAll('.choice-button:not(:disabled)'));
    
    // Arrow key navigation
    if (key === 'arrowleft' || key === 'arrowright' || key === 'arrowup' || key === 'arrowdown') {
      e.preventDefault();
      
      if (buttons.length === 0) return;
      
      // If this is the first keyboard navigation, start at the first button
      if (!keyboardNavigationStarted) {
        keyboardNavigationStarted = true;
        currentFocusIndex = 0;
      } else {
        // Navigate from current position
        const gridColumns = 4; // 4 columns in grid
        
        if (key === 'arrowright') {
          currentFocusIndex = (currentFocusIndex + 1) % buttons.length;
        } else if (key === 'arrowleft') {
          currentFocusIndex = (currentFocusIndex - 1 + buttons.length) % buttons.length;
        } else if (key === 'arrowdown') {
          currentFocusIndex = (currentFocusIndex + gridColumns) % buttons.length;
        } else if (key === 'arrowup') {
          currentFocusIndex = (currentFocusIndex - gridColumns + buttons.length) % buttons.length;
        }
      }
      
      // Focus and announce the weapon
      const focusedButton = buttons[currentFocusIndex];
      focusedButton.focus();
      
      // Get weapon name from the button
      const weaponName = focusedButton.querySelector('.choice-button__text')?.textContent || 'Unknown';
      const position = `${currentFocusIndex + 1} of ${buttons.length}`;
      announceToScreenReader(`${weaponName}, ${position}`, false);
      
      return;
    }
    
    // Enter to select focused weapon
    if (key === 'enter' && buttons.includes(document.activeElement)) {
      e.preventDefault();
      document.activeElement.click();
      return;
    }
    
    // Number keys 1-8 for direct weapon selection
    if (key >= '1' && key <= '8') {
      e.preventDefault();
      const index = parseInt(key) - 1;
      if (buttons[index]) {
        currentFocusIndex = index;
        buttons[index].focus();
        const weaponName = buttons[index].querySelector('.choice-button__text')?.textContent || 'Unknown';
        announceToScreenReader(`${weaponName}, ${index + 1} of ${buttons.length}`, false);
        // Auto-select after a brief moment to allow quick selection
        setTimeout(() => {
          if (buttons[index] && !buttons[index].disabled) {
            buttons[index].click();
          }
        }, 300);
      }
      return;
    }
    
    // P or Spacebar for play sound (only if not focused on a weapon button)
    if ((key === 'p' || (key === ' ' && !buttons.includes(document.activeElement)))) {
      e.preventDefault();
      if (!btnPlay.disabled) {
        btnPlay.click();
      }
      return;
    }
    
    // N for new game
    if (key === 'n') {
      e.preventDefault();
      if (!btnNewGame.disabled) {
        btnNewGame.click();
      }
      return;
    }
    
    // S for skip round / next round
    if (key === 's') {
      e.preventDefault();
      if (!btnNextRound.disabled) {
        btnNextRound.click();
      }
      return;
    }
    
    // R to replay audio info
    if (key === 'r') {
      e.preventDefault();
      const message = audioInfoText.textContent;
      if (message) {
        announceToScreenReader(message);
      }
      return;
    }
    
    // H for help/keyboard shortcuts
    if (key === 'h' && (e.ctrlKey || e.metaKey)) {
      e.preventDefault();
      const helpMessage = 'Keyboard shortcuts: P or Space to play sound. Arrow keys to navigate weapons, Enter to select. Number keys 1 through 8 for quick select. N for new game, S to skip or next round, R to repeat current status.';
      announceToScreenReader(helpMessage, true);
      return;
    }
  });
  
  // Reset focus index when new choices are rendered
  choicesGrid.addEventListener('DOMSubtreeModified', () => {
    currentFocusIndex = 0;
  });
  
  console.log('[Game] Keyboard navigation with arrow keys initialized');
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
    'pm': ['weapons/pm/medium/pistol_pm_burst.mp3', 'weapons/pm/medium/pistol_pm_single_shot.mp3', 'weapons/pm/close/pistol_pm_burst_alt.mp3', 'weapons/pm/close/pistol_pm_single_shot_alt.mp3'],
    // RSh-12: Revolver pistol (12.7x55mm)
    'rsh12': ['weapons/rsh12/medium/pistol_revolver_burst4.mp3', 'weapons/rsh12/medium/pistol_rsh12_empty_reload.mp3', 'weapons/rsh12/medium/pistol_rsh12_empty_reload2.mp3'],
    // ASh-12: Assault rifle (12.7x55mm) - DIFFERENT WEAPON from RSh-12
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
    'as-val': ['weapons/as-val/medium/tarkov_as_val_special_assault_rifle_burst.mp3', 'weapons/as-val/medium/tarkov_as_val_special_assault_rifle_single_shot.mp3'],
    'aks-74u': ['weapons/aks-74u/medium/tarkov_kalashnikov_aks-74u_assault_rifle_burst_loud.mp3', 'weapons/aks-74u/medium/tarkov_kalashnikov_aks-74u_assault_rifle_burst_suppressed.mp3', 'weapons/aks-74u/medium/tarkov_kalashnikov_aks-74u_assault_rifle_single_loud.mp3', 'weapons/aks-74u/medium/tarkov_kalashnikov_aks-74u_assault_rifle_single_suppressed.mp3'],
    'g36': ['weapons/g36/medium/tarkov_g36_burst_loud.mp3', 'weapons/g36/medium/tarkov_g36_single_shot_loud.mp3'],
    'aug-a3': ['weapons/aug-a3/medium/tarkov_steyr_aug_a3_rifle_loud_burst.mp3', 'weapons/aug-a3/medium/tarkov_steyr_aug_a3_rifle_loud_single_shot.mp3'],
    'mp5': ['weapons/mp5/medium/tarkov_hk_mp5_submachine_gun_loud_burst.mp3', 'weapons/mp5/medium/tarkov_hk_mp5_submachine_gun_loud_single_shot.mp3'],
    'mpx': ['weapons/mpx/medium/tarkov_sig_mpx_submachine_gun_suppressed_burst.mp3', 'weapons/mpx/medium/tarkov_sig_mpx_submachine_gun_suppressed_single_shot.mp3'],
    'rhino-50ds': ['weapons/rhino-50ds/medium/tarkov_chiappa_rhino_50ds_357_revolver_burst.mp3', 'weapons/rhino-50ds/medium/tarkov_chiappa_rhino_50ds_357_revolver_single_shot.mp3']
  };
  
  // Get audio files for this weapon
  const audioFiles = weaponAudioMap[weaponId] || [];
  
  // Filter audio files based on weapon's suppressor status to ensure audio matches image
  return filterAudioBySuppressorStatus(weaponId, audioFiles);
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
  return availableWeapons[Math.floor(getRandom() * availableWeapons.length)];
}

/**
 * Get multiple random weapons with audio (excluding specified ones)
 */
function getRandomWeaponsWithAudio(count, excludeIds = []) {
  const available = WEAPONS.filter(w => 
    WEAPONS_WITH_AUDIO.includes(w.id) && !excludeIds.includes(w.id)
  );
  const shuffled = [...available].sort(() => 0.5 - getRandom());
  return shuffled.slice(0, count);
}

/**
 * Start a new round
 */
function startNewRound() {
  roundComplete = false;
  selectedWeapon = null;
  
  // Reset round-specific tracking
  audioPlayCount = 0;
  currentRoundPoints = 5; // Start with 5 points
  isSingleShotAudio = false;
  
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
    const randomFile = availableAudio[Math.floor(getRandom() * availableAudio.length)];
    currentAudioFile = randomFile; // Store the current audio file for debugging
    
    // Check if this is a single-shot audio file (for bonus points)
    const fileName = randomFile.toLowerCase();
    isSingleShotAudio = fileName.includes('single') || fileName.includes('1shot') || fileName.includes('shot1');
    
    // If single-shot, double the points
    if (isSingleShotAudio) {
      currentRoundPoints = 10; // Double points for single-shot
      console.log('[Game] Single-shot audio selected - 10 points available (double bonus)');
    }
    
    // Reset effects for new round (will be updated by checkboxes)
    currentEffects = { pan: 0, distance: 0, muffled: 0, throughWall: 0 };
    
    // Set up HTML5 audio as fallback
    audioPlayer.src = randomFile;
    audioPlayer.onerror = () => {
      audioInfoText.textContent = 'Error loading audio file.';
      console.warn('[Game] Audio file error:', randomFile);
    };
    const bonusText = isSingleShotAudio ? ' (Single-shot: 10 pts!)' : '';
    audioInfoText.textContent = `Click "Play Sound" to hear the weapon${bonusText}`;
    btnPlay.disabled = false;
  } else {
    // This shouldn't happen if we're filtering correctly, but handle it gracefully
    audioInfoText.textContent = `No audio files found for ${correctWeapon.name}. Restarting round...`;
    console.error('[Game] No audio files found for weapon:', correctWeapon.id);
    setTimeout(() => startNewRound(), 1000);
    return;
  }
  
  // Reset UI - enable Next Round button to allow skipping
  btnNextRound.disabled = false;
  btnNextRound.textContent = 'Skip Round (-1 pt)';
  
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
  
  weapons.forEach((weapon, index) => {
    const button = document.createElement('button');
    button.className = 'choice-button';
    button.dataset.weaponId = weapon.id;
    button.setAttribute('aria-label', `${weapon.name}. ${index + 1} of ${weapons.length}. Press Enter to select.`);
    button.setAttribute('data-key', index + 1);
    
    // Create image element
    const img = document.createElement('img');
    img.alt = weapon.name;
    img.className = 'choice-button__image';
    
    // Check if this is the correct weapon and use audio-aware image
    let fallbackPaths;
    if (weapon.id === correctWeapon.id) {
      // Use audio-aware image for correct weapon
      const audioAwareImage = getWeaponImageUrlForAudio(weapon.id, weapon.name, currentAudioFile);
      
      // Build fallback chain starting with audio-aware image
      const safeName = weapon.name
        .replace(/\s+/g, '-')
        .replace(/\./g, '')
        .replace(/[^a-zA-Z0-9-]/g, '')
        .replace(/-+/g, '-')
        .replace(/^-|-$/g, '');
      
      fallbackPaths = [
        audioAwareImage,
        `weapons/${weapon.id}/${safeName}.png`,
        `weapons/${weapon.id}/${safeName}.gif`,
        `weapons/${weapon.id}/image.png`,
        `weapons/${weapon.id}/image.gif`
      ];
    } else {
      // Standard fallback chain for incorrect choices
      const safeName = weapon.name
        .replace(/\s+/g, '-')
        .replace(/\./g, '')
        .replace(/[^a-zA-Z0-9-]/g, '')
        .replace(/-+/g, '-')
        .replace(/^-|-$/g, '');
      
      fallbackPaths = [
        `weapons/${weapon.id}/${safeName}.png`,
        `weapons/${weapon.id}/${safeName}.gif`,
        `weapons/${weapon.id}/image.png`,
        `weapons/${weapon.id}/image.gif`
      ];
    }
    
    let attemptCount = 0;
    
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
  
  // Reset focus index and keyboard navigation state for new round
  currentFocusIndex = 0;
  keyboardNavigationStarted = false;
  
  // Announce round start for screen readers without auto-focusing
  // Focus will only happen when user presses arrow keys or tab
  setTimeout(() => {
    const roundAnnouncement = `Round ${currentRound}. ${weapons.length} weapons to choose from. Use arrow keys to navigate, Enter to select, or click with mouse.`;
    announceToScreenReader(roundAnnouncement);
  }, 100);
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
  
  let pointsEarned = 0;
  
  if (isCorrect) {
    // Award points based on current round points (affected by replays)
    const basePoints = currentRoundPoints;
    
    // Add streak bonus (streak value added to base points)
    const streakBonus = streak; // Current streak before incrementing
    pointsEarned = basePoints + streakBonus;
    
    score += pointsEarned;
    streak += 1;
    correctCount += 1;
    
    // Build result message with points info
    let pointsInfo = `+${pointsEarned} point${pointsEarned !== 1 ? 's' : ''}`;
    
    // Add breakdown if there's a streak bonus
    if (streakBonus > 0) {
      pointsInfo += ` (${basePoints} base + ${streakBonus} streak)`;
    }
    
    if (isSingleShotAudio && audioPlayCount === 1) {
      pointsInfo += ' Single-shot!';
    } else if (audioPlayCount > 1) {
      pointsInfo += ` ${audioPlayCount} plays`;
    }
    
    resultMessage.innerHTML = `Correct! It was a ${correctWeapon.name} <span style="color: #4ade80;">${pointsInfo}</span><br><small style="opacity: 0.7; font-size: 0.75em;">Sound: ${audioFileName}</small>`;
    resultMessage.className = 'result-message correct';
    // Light up background panel green
    gameSection.classList.remove('result-incorrect');
    gameSection.classList.add('result-correct');
    
    // Announce success to screen reader with audio cue
    const successMessage = `Correct! ${correctWeapon.name}. ${pointsInfo}. Score is now ${score + pointsEarned}. Streak: ${streak + 1}.`;
    announceToScreenReader(successMessage, true);
    playSuccessSound();
    
    console.log(`[Game] Correct answer! Awarded ${pointsEarned} points (${basePoints} base + ${streakBonus} streak, ${audioPlayCount} plays, single-shot: ${isSingleShotAudio})`);
  } else {
    streak = 0;
    incorrectCount += 1;
    
    // Deduct 2 points for wrong answer
    score = Math.max(0, score - 2);
    pointsEarned = -2;
    
    const correctName = correctWeapon.name;
    resultMessage.innerHTML = `Incorrect! It was a ${correctName} <span style="color: #f87171;">-2 points</span><br><small style="opacity: 0.7; font-size: 0.75em;">Sound: ${audioFileName}</small>`;
    resultMessage.className = 'result-message incorrect';
    // Light up background panel red
    gameSection.classList.remove('result-correct');
    gameSection.classList.add('result-incorrect');
    
    // Announce failure to screen reader with audio cue
    const failureMessage = `Incorrect. The correct answer was ${correctName}. Minus 2 points. Score is now ${Math.max(0, score - 2)}. Streak reset.`;
    announceToScreenReader(failureMessage, true);
    playFailureSound();
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
  
  // Mark round as complete
  roundComplete = true;
  
  // Update stats
  updateStats();
  
  // Add to points log
  addPointsLogEntry(currentRound, correctWeapon.name, pointsEarned, isCorrect);
  
  // Change button text and enable
  btnNextRound.textContent = 'Next Round';
  btnNextRound.disabled = false;
}

/**
 * Update game statistics
 */
function updateStats(announce = false) {
  roundNumberEl.textContent = currentRound;
  scoreEl.textContent = score;
  streakEl.textContent = streak;
  rightWrongEl.textContent = `${correctCount}/${incorrectCount}`;
  
  // Announce stats to screen readers if requested
  if (announce) {
    const statsMessage = `Round ${currentRound}. Score: ${score}. Streak: ${streak}. ${correctCount} correct, ${incorrectCount} incorrect.`;
    announceToScreenReader(statsMessage);
  }
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

  // Increment play count and deduct points
  audioPlayCount++;
  
  // Deduct 1 point for each play after the first
  if (audioPlayCount > 1) {
    currentRoundPoints = Math.max(1, currentRoundPoints - 1); // Minimum 1 point
  }
  
  // Update info text to show current points
  const pointsText = currentRoundPoints > 1 ? `${currentRoundPoints} points` : `${currentRoundPoints} point`;
  audioInfoText.textContent = `Playing audio... (${pointsText} available)`;

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
 * Move to next round (or skip current round)
 */
async function nextRound() {
  // Check if round is complete (answer was given)
  if (roundComplete) {
    // Check if game is over (reached max rounds)
    if (currentRound >= MAX_ROUNDS) {
      await endGame();
      return;
    }
    
    // Normal progression to next round
    currentRound += 1;
    startNewRound();
  } else {
    // Player is skipping the round - apply 1 point penalty
    score = Math.max(0, score - 1);
    incorrectCount += 1;
    streak = 0;
    
    // Add to points log as skipped
    addPointsLogEntry(currentRound, correctWeapon.name, -1, false);
    
    // Show skip message
    const audioFileName = currentAudioFile ? currentAudioFile.split('/').pop() : 'unknown';
    resultMessage.innerHTML = `Round skipped! It was a ${correctWeapon.name}<br><small style="opacity: 0.7; font-size: 0.75em;">Sound: ${audioFileName}</small>`;
    resultMessage.className = 'result-message incorrect';
    resultMessage.style.opacity = '1';
    resultMessage.style.visibility = 'visible';
    
    // Light up background panel yellow/orange for skip
    const gameSection = document.querySelector('.game-section');
    gameSection.classList.remove('result-correct');
    gameSection.classList.add('result-incorrect');
    
    // Disable choices
    document.querySelectorAll('.choice-button').forEach(btn => {
      btn.disabled = true;
      if (btn.dataset.weaponId === correctWeapon.id) {
        btn.classList.add('correct');
      }
    });
    
    // Update stats
    updateStats();
    
    // Mark round as complete and change button text
    roundComplete = true;
    btnNextRound.textContent = 'Next Round';
  }
}

/**
 * Start a new game
 */
function newGame() {
  currentRound = 1;
  score = 0;
  streak = 0;
  correctCount = 0;
  incorrectCount = 0;
  
  // Reinitialize seeded random with current seed (resets the sequence)
  if (gameSeed) {
    const numericSeed = stringToSeed(gameSeed);
    seededRandom = createSeededRandom(numericSeed);
    console.log(`[Seed] Restarted game with seed: ${gameSeed}`);
  }
  
  // Clear points log
  if (pointsLog) {
    pointsLog.innerHTML = '';
  }
  
  updateStats();
  startNewRound();
}

/**
 * End the game and check for high score
 */
async function endGame() {
  // Check if score qualifies for top 10
  try {
    // Use relative URL to work with any server configuration
    const response = await fetch('/api/highscores/check', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ score })
    });
    
    const data = await response.json();
    
    if (data.qualifies) {
      // Prompt for name
      const playerName = prompt('🏆 Top 10! Sign your name:');
      
      if (playerName && playerName.trim()) {
        // Submit high score with seed
        await fetch('/api/highscores', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ name: playerName.trim(), score, seed: gameSeed })
        });
        
        // Refresh high scores display
        await loadHighscores();
      }
    }
  } catch (error) {
    console.error('Error checking/submitting high score:', error);
  }
  
  // Show game over message
  resultMessage.innerHTML = `Game Over! Final Score: ${score}<br><small>Completed ${MAX_ROUNDS} rounds</small>`;
  resultMessage.className = 'result-message';
  resultMessage.style.opacity = '1';
  resultMessage.style.visibility = 'visible';
  
  // Disable all buttons except New Game
  btnPlay.disabled = true;
  btnNextRound.disabled = true;
  document.querySelectorAll('.choice-button').forEach(btn => btn.disabled = true);
}

/**
 * Load and display high scores
 */
async function loadHighscores() {
  try {
    // Use relative URL to work with any server configuration
    const response = await fetch('/api/highscores');
    const highscores = await response.json();
    
    const highscoresList = document.getElementById('highscores-list');
    if (!highscoresList) return;
    
    if (highscores.length === 0) {
      highscoresList.innerHTML = '<div class="highscore-empty">No high scores yet. Be the first!</div>';
      return;
    }
    
    highscoresList.innerHTML = highscores.map((entry, index) => {
      const date = new Date(entry.date);
      const dateStr = date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
      const seed = entry.seed || 'unknown';
      
      return `
        <div class="highscore-entry ${index === 0 ? 'highscore-first' : ''}">
          <span class="highscore-rank">${index + 1}</span>
          <span class="highscore-name">${entry.name}</span>
          <span class="highscore-score">${entry.score}</span>
          <span class="highscore-seed" title="Game seed: ${seed}">${seed}</span>
          <span class="highscore-date">${dateStr}</span>
        </div>
      `;
    }).join('');
  } catch (error) {
    console.error('Error loading highscores:', error);
    const highscoresList = document.getElementById('highscores-list');
    if (highscoresList) {
      highscoresList.innerHTML = '<div class="highscore-empty">Failed to load high scores</div>';
    }
  }
}

/**
 * Add entry to points log
 */
function addPointsLogEntry(round, weaponName, pointsEarned, isCorrect) {
  if (!pointsLog) return;
  
  const entry = document.createElement('div');
  entry.className = `points-log-entry ${isCorrect ? 'correct' : 'incorrect'}`;
  
  const roundSpan = document.createElement('span');
  roundSpan.className = 'points-log-round';
  roundSpan.textContent = `R${round}`;
  
  const weaponSpan = document.createElement('span');
  weaponSpan.className = 'points-log-weapon';
  weaponSpan.textContent = weaponName;
  
  const pointsSpan = document.createElement('span');
  pointsSpan.className = 'points-log-points';
  
  // Format points display
  if (isCorrect) {
    pointsSpan.textContent = `+${pointsEarned}`;
  } else if (pointsEarned < 0) {
    pointsSpan.textContent = `${pointsEarned}`; // Already has minus sign
  } else {
    pointsSpan.textContent = '0';
  }
  
  entry.appendChild(roundSpan);
  entry.appendChild(weaponSpan);
  entry.appendChild(pointsSpan);
  
  pointsLog.appendChild(entry);
  
  // Auto-scroll to bottom
  pointsLog.scrollTop = pointsLog.scrollHeight;
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

