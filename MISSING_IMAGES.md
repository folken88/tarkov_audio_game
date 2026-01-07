# Missing Weapon Images

## Summary
**6 weapons** out of 118 total are missing images in both the game and gallery.

## Missing Weapons

### 1. RPD (Light Machine Gun)
- **ID**: `rpd`
- **Folder**: `public/weapons/rpd/`
- **Status**: Has audio files, needs image
- **Tarkov Wiki**: https://escapefromtarkov.fandom.com/wiki/RPD
- **Image needed**: `RPD.png`

### 2. AA-12 (Shotgun)
- **ID**: `aa-12`
- **Folder**: `public/weapons/aa-12/`
- **Status**: Has audio files, needs image
- **Tarkov Wiki**: https://escapefromtarkov.fandom.com/wiki/AA-12
- **Image needed**: `AA-12.png`

### 3. KS-23M (Shotgun)
- **ID**: `ks-23m`
- **Folder**: `public/weapons/ks-23m/`
- **Status**: Has audio files, needs image
- **Tarkov Wiki**: https://escapefromtarkov.fandom.com/wiki/KS-23M
- **Image needed**: `KS-23M.png`

### 4. MDR 5.56x45 (Assault Rifle)
- **ID**: `mdr-556`
- **Folder**: `public/weapons/mdr-556/`
- **Status**: Needs both audio and image
- **Tarkov Wiki**: https://escapefromtarkov.fandom.com/wiki/MDR
- **Image needed**: `MDR-556.png`

### 5. M249 (Light Machine Gun)
- **ID**: `m249`
- **Folder**: `public/weapons/m249/`
- **Status**: Needs both audio and image
- **Tarkov Wiki**: https://escapefromtarkov.fandom.com/wiki/M249
- **Image needed**: `M249.png`

### 6. M240B (Light Machine Gun)
- **ID**: `m240b`
- **Folder**: `public/weapons/m240b/`
- **Status**: Needs both audio and image
- **Tarkov Wiki**: https://escapefromtarkov.fandom.com/wiki/M240B
- **Image needed**: `M240B.png`

## How to Add Images

1. Visit the Tarkov Wiki page for each weapon
2. Right-click on the weapon inspection image
3. Save the image as PNG format
4. Rename to match the weapon name (e.g., `RPD.png`, `AA-12.png`)
5. Place in the weapon's folder (e.g., `public/weapons/rpd/RPD.png`)

## Image Requirements
- **Format**: PNG (preferred) or WebP
- **Size**: Typically 200-400px width (will be auto-scaled)
- **Type**: Weapon inspection view (side profile)
- **Source**: Escape from Tarkov Wiki

## Current Stats
- **Total Weapons**: 118
- **With Images**: 112 (94.9%)
- **With Audio**: 49 (41.5%)
- **Complete (both)**: 46 (39.0%)

## Notes
- The FN40GL image was successfully downloaded from the wiki
- The game and gallery will work without images, but weapons will show "No Image" placeholder
- Images are loaded dynamically and checked at runtime
- The gallery uses the `checkImageExists()` function to verify image availability










