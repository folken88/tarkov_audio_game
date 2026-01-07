# Downloading Missing Weapon Images

## Current Status

We have **74 weapons** missing images. The automated download script needs image URLs added manually.

## Quick Start

1. Run the download script:
   ```powershell
   cd tarkov-sound-game
   .\download_images_simple.ps1
   ```

2. This will download the 5 images we currently have URLs for.

## Adding More Image URLs

To add more weapons:

1. Open `download_images_simple.ps1`
2. Find the `$imageUrls` hashtable
3. Add entries in this format:
   ```powershell
   'weapon-id' = 'path/filename.png'
   ```

### How to Find Image URLs

1. Visit the weapon's wiki page (e.g., `https://escapefromtarkov.fandom.com/wiki/AK-74M`)
2. Right-click the main weapon image
3. Copy image address
4. Extract the path part (between `/images/` and `/revision/`)
5. Add to the script

Example:
- Full URL: `https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/a/a1/Ak74m.png/revision/latest/...`
- Path to use: `a/a1/Ak74m.png`

## Priority Weapons

These have audio files but no images:
- **scar-h** (SCAR-H)
- **axmc** (AXMC)
- **fn57** (FN Five-seveN)

## Alternative: Manual Download

If scripts aren't working, you can manually:
1. Visit each wiki page
2. Right-click the image
3. "Save image as..."
4. Save to `public/weapons/{weapon-id}/image.png`


