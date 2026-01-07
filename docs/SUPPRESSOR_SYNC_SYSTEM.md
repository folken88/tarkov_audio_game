# Audio/Image Suppressor Synchronization System

## Overview

This system ensures that weapon audio files always match the weapon images in terms of suppressor presence. Players will never hear loud gunfire while seeing a suppressed weapon, or vice versa.

## How It Works

### 1. Weapon Metadata (`weapons.js`)

Each weapon is tagged with a suppressor status based on its image:

```javascript
export const WEAPON_SUPPRESSOR_STATUS = {
  // 'suppressed' - Image shows suppressor
  'aks-74u': 'suppressed',
  'dvl-10': 'suppressed',
  'as-val': 'suppressed',
  // ... etc
  
  // 'loud' - Image shows NO suppressor
  'rpd': 'loud',
  'rpk-16': 'loud',
  'g36': 'loud',
  // ... etc
  
  // 'neutral' - Image is ambiguous or we have both variants
  'm4a1': 'neutral',
  'hk416a5': 'neutral',
  // ... etc
};
```

### 2. Audio Filtering (`weapons.js`)

The `filterAudioBySuppressorStatus()` function filters audio files:

- **suppressed** → Only allows audio with "suppressed", "silenced", or "silent" in filename
- **loud** → Only allows audio WITHOUT "suppressed/silenced" in filename (prefers files with "loud")
- **neutral** → Allows all audio files (no filtering)

### 3. Integration (`game.js`)

The `getAvailableAudioFiles()` function automatically applies filtering before returning audio files for gameplay.

## Current Configuration

### Weapons Marked as SUPPRESSED (7)
These weapons will ONLY play suppressed/silenced audio:
- AKS-74U (image shows waffle suppressor)
- DVL-10 (Saboteur variant)
- AS VAL (always suppressed by design)
- MPX (suppressed variant)
- SR-25 (suppressed variant)
- RSASS (suppressed variant)
- P90 (suppressed variant)

### Weapons Marked as LOUD (12)
These weapons will NEVER play suppressed audio:
- RPD (loud variant image)
- RPK-16 (loud ice cream cone variant)
- SCAR-H (loud variant)
- MK-18 (loud variant)
- G36 (loud audio files)
- AUG-A3 (loud audio files)
- MP5 (loud audio files)
- SR-2M (loud audio files)
- PKM (machine gun)
- SA-58 (FAL, loud)
- AK-50 (BMG anti-materiel)
- ASh-12 (primarily loud)

### Weapons Marked as NEUTRAL (5)
These weapons can play any audio (need better images):
- M4A1 (has both loud and suppressed audio, neutral image)
- HK416A5 (has both variants)
- SCAR-L (has both variants)
- M1A (has both variants)
- SVD (has both variants)

## Example: AKS-74U Fix

**Before** (BROKEN):
- Image: Shows waffle suppressor
- Audio: Randomly plays LOUD or SUPPRESSED (4 files total)
- Result: ❌ Player confusion

**After** (FIXED):
- Image: Shows waffle suppressor
- Audio: ONLY plays suppressed files (filtered from 4 to 2 files)
- Result: ✅ Always matches

## Adding New Weapons

When adding a new weapon:

1. **Check the image** - Does it show a suppressor?
2. **Check the audio** - Do filenames include "loud", "suppressed", or "silenced"?
3. **Add to `WEAPON_SUPPRESSOR_STATUS`**:
   - If image shows suppressor → `'weapon-id': 'suppressed'`
   - If image shows NO suppressor → `'weapon-id': 'loud'`
   - If ambiguous or has both → `'weapon-id': 'neutral'`
4. **Test** - Play the weapon multiple times to verify audio always matches image

## Future Improvements

For weapons currently marked as 'neutral':
- Get multiple images (one suppressed, one loud)
- OR get neutral images that don't clearly show suppressor presence
- OR remove audio files that don't match the single image we have










