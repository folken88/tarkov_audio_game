/**
 * Audio Effects Module
 * Provides panning, distance, and muffled sound effects using Web Audio API
 * Effects are optional and can be enabled per audio file
 * 
 * Effects:
 * - Panning: -1 (left ear) to 1 (right ear), 0 = center
 * - Distance: 0 (close) to 1 (far) - reduces volume and high frequencies
 * - Muffled: 0 (clear) to 1 (very muffled) - low-pass filter simulates wall/barrier
 */

let audioContext = null;
let activeSources = []; // Track all active audio sources for cleanup
let audioBufferCache = {}; // Cache decoded audio buffers

/**
 * Initialize Web Audio API context
 * Must be called from a user interaction (click, etc.)
 */
export function initAudioContext() {
  if (!audioContext) {
    try {
      audioContext = new (window.AudioContext || window.webkitAudioContext)();
      console.info('[AudioEffects] Audio context initialized');
    } catch (error) {
      console.error('[AudioEffects] Failed to initialize audio context:', error);
      return false;
    }
  }
  return true;
}

// Effect nodes are now created per-source to allow overlapping playback

/**
 * Get or load audio buffer (with caching)
 * @param {string} audioUrl - URL to the audio file
 * @returns {Promise<AudioBuffer>} - Decoded audio buffer
 */
async function getAudioBuffer(audioUrl) {
  // Check cache first
  if (audioBufferCache[audioUrl]) {
    return audioBufferCache[audioUrl];
  }

  // Fetch and decode
  const response = await fetch(audioUrl);
  const arrayBuffer = await response.arrayBuffer();
  const audioBuffer = await audioContext.decodeAudioData(arrayBuffer);
  
  // Cache it
  audioBufferCache[audioUrl] = audioBuffer;
  return audioBuffer;
}

/**
 * Create a new audio source with effects (allows overlapping playback)
 * @param {string} audioUrl - URL to the audio file
 * @param {Object} effects - Effect configuration
 * @param {number} effects.pan - Pan value (-1 = left, 0 = center, 1 = right)
 * @param {number} effects.distance - Distance (0 = close, 1 = far)
 * @param {number} effects.muffled - Muffled amount (0 = clear, 1 = very muffled)
 * @returns {Promise<AudioBufferSourceNode>} - New audio source node
 */
export async function createAudioSourceWithEffects(audioUrl, effects = {}) {
  if (!audioContext) {
    if (!initAudioContext()) {
      throw new Error('Failed to initialize audio context');
    }
  }

  // Resume context if suspended (required by some browsers)
  if (audioContext.state === 'suspended') {
    await audioContext.resume();
  }

  // Effect nodes are created per-source below

  try {
    // Get audio buffer (from cache if available)
    const audioBuffer = await getAudioBuffer(audioUrl);

    // Create a NEW buffer source for this playback instance
    const source = audioContext.createBufferSource();
    source.buffer = audioBuffer;

    // Create individual effect chain for this source
    // Each source needs its own effect nodes to allow different effects per instance
    const sourceFilter = audioContext.createBiquadFilter();
    sourceFilter.type = 'lowpass';
    
    const sourcePan = audioContext.createStereoPanner();
    const sourceGain = audioContext.createGain();

    // Apply effects to this source's nodes
    const {
      pan = 0,
      distance = 0,
      muffled = 0,
      throughWall = 0
    } = effects;

    // Panning
    sourcePan.pan.value = Math.max(-1, Math.min(1, pan));

    // Distance (volume)
    const distanceGain = 1 - (distance * 0.6);
    sourceGain.gain.value = distanceGain;

    // Muffled effect
    const totalMuffled = Math.min(1, muffled + (throughWall * 1.2));
    const baseFreq = 20000;
    const minFreq = 200;
    const filterFreq = baseFreq - (totalMuffled * (baseFreq - minFreq));
    sourceFilter.frequency.value = filterFreq;
    const qValue = 1 + (totalMuffled * 2) + (throughWall * 1);
    sourceFilter.Q.value = Math.min(5, qValue);

    // Connect: source -> filter -> pan -> gain -> destination
    source.connect(sourceFilter);
    sourceFilter.connect(sourcePan);
    sourcePan.connect(sourceGain);
    sourceGain.connect(audioContext.destination);

    // Track this source for cleanup
    activeSources.push(source);

    // Clean up when finished
    source.onended = () => {
      const index = activeSources.indexOf(source);
      if (index > -1) {
        activeSources.splice(index, 1);
      }
      try {
        source.disconnect();
        sourceFilter.disconnect();
        sourcePan.disconnect();
        sourceGain.disconnect();
      } catch (e) {
        // Already disconnected
      }
    };

    return source;
  } catch (error) {
    console.error('[AudioEffects] Error creating audio source:', error);
    throw error;
  }
}

// Note: applyEffects is no longer used since each source has its own effect nodes
// Keeping for potential future use or backwards compatibility

/**
 * Play audio with effects (allows overlapping playback)
 * @param {string} audioUrl - URL to the audio file
 * @param {Object} effects - Effect configuration
 * @returns {Promise} - Resolves when playback starts
 */
export async function playAudioWithEffects(audioUrl, effects = {}) {
  try {
    const source = await createAudioSourceWithEffects(audioUrl, effects);
    source.start(0);
    return source;
  } catch (error) {
    console.error('[AudioEffects] Error playing audio:', error);
    throw error;
  }
}

/**
 * Stop all currently playing audio
 */
export function stopAudio() {
  // Stop all active sources
  activeSources.forEach(source => {
    try {
      source.stop();
      source.disconnect();
    } catch (e) {
      // Source may already be stopped
    }
  });
  activeSources = [];
}

/**
 * Clear audio buffer cache (useful for memory management)
 */
export function clearAudioCache() {
  audioBufferCache = {};
}

/**
 * Get random effect configuration for variety
 * @param {string} effectType - Type of effect: 'pan', 'distance', 'muffled', or 'random'
 * @returns {Object} - Effect configuration
 */
export function getRandomEffects(effectType = 'random') {
  const effects = { pan: 0, distance: 0, muffled: 0 };

  switch (effectType) {
    case 'pan':
      // Pan slightly left or right
      effects.pan = (Math.random() - 0.5) * 0.6; // -0.3 to 0.3
      break;
    
    case 'distance':
      // Make sound distant
      effects.distance = 0.3 + (Math.random() * 0.4); // 0.3 to 0.7
      break;
    
    case 'muffled':
      // Make sound muffled (through wall)
      effects.muffled = 0.4 + (Math.random() * 0.4); // 0.4 to 0.8
      break;
    
    case 'random':
    default:
      // Random combination
      if (Math.random() > 0.5) {
        effects.pan = (Math.random() - 0.5) * 0.5;
      }
      if (Math.random() > 0.6) {
        effects.distance = Math.random() * 0.5;
      }
      if (Math.random() > 0.7) {
        effects.muffled = Math.random() * 0.6;
      }
      break;
  }

  return effects;
}

/**
 * Check if Web Audio API is supported
 */
export function isSupported() {
  return !!(window.AudioContext || window.webkitAudioContext);
}

