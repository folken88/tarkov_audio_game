# Audio Effects Feature

## Overview

The app now supports optional audio effects using the Web Audio API:
- **Panning**: Sounds can be panned left or right (simulating direction)
- **Distance**: Sounds can be made to sound distant (volume reduction + frequency filtering)
- **Muffled**: Sounds can be muffled as if heard through a wall (low-pass filter)

## How It Works

### Technical Implementation

The effects use the Web Audio API:
- `StereoPannerNode` for left/right panning
- `GainNode` for volume/distance control
- `BiquadFilterNode` (low-pass) for muffled sounds

### User Interface

- A checkbox appears below the audio info text (only if Web Audio API is supported)
- Check "Enable audio effects" to turn on effects
- Effects are randomized per round for variety
- Preference is saved in localStorage

### Effect Parameters

**Panning** (`-1` to `1`):
- `-1` = completely left ear
- `0` = center (both ears equally)
- `1` = completely right ear
- Random range: `-0.3` to `0.3` (subtle panning)

**Distance** (`0` to `1`):
- `0` = close/normal
- `1` = very far
- Reduces volume by up to 60%
- Reduces high frequencies
- Random range: `0.3` to `0.7` when enabled

**Muffled** (`0` to `1`):
- `0` = clear/normal
- `1` = very muffled (through thick wall)
- Uses low-pass filter (200 Hz to 20,000 Hz)
- Random range: `0.4` to `0.8` when enabled

## Customization

### Per-Weapon Effects

You can customize effects per weapon by modifying `startNewRound()` in `game.js`:

```javascript
// Example: Make sniper rifles sound distant
if (correctWeapon.id === 'sv-98' || correctWeapon.id === 'm700') {
  currentEffects = { pan: 0, distance: 0.6, muffled: 0 };
}
// Example: Make suppressed weapons sound muffled
else if (correctWeapon.id === 'mp5sd') {
  currentEffects = { pan: 0, distance: 0, muffled: 0.7 };
}
```

### Effect Types

The `getRandomEffects()` function supports different effect types:
- `'pan'` - Only panning effects
- `'distance'` - Only distance effects
- `'muffled'` - Only muffled effects
- `'random'` - Random combination (default)

### Manual Effect Configuration

You can set specific effects:

```javascript
// In game.js, before calling playAudio()
currentEffects = {
  pan: -0.5,      // Slightly left
  distance: 0.4,  // Moderately distant
  muffled: 0.3    // Slightly muffled
};
```

## Browser Support

- Requires Web Audio API support
- Works in all modern browsers (Chrome, Firefox, Safari, Edge)
- Falls back to standard HTML5 audio if not supported
- Toggle is hidden if Web Audio API is not available

## Future Enhancements

Possible additions:
- Reverb effects (using ConvolverNode)
- Echo/delay effects
- Frequency-specific filtering
- 3D spatial audio (for VR/AR)
- Per-weapon preset effects
- User-adjustable effect sliders


