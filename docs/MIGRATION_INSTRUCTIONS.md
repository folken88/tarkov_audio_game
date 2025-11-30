# Migration to Combined Weapon Structure

## Overview
We're migrating from separated audio/image folders to a **combined structure** where each weapon has its own folder containing both images and audio.

## New Structure
```
public/
  weapons/
    {weapon-id}/
      image.png (or image.gif)
      close/
        *.mp3
      medium/
        *.mp3
      long/
        *.mp3
```

## Benefits
✅ Everything for one weapon in one place
✅ Easy to see completion status
✅ Cleaner for 160+ weapons
✅ Simpler paths and references

## Migration Steps

### Step 1: Run Migration Script
```batch
migrate_to_combined_structure.bat
```

This will:
- Create `public/weapons/` folder
- Move `public/audio/{weapon}/` → `public/weapons/{weapon}/`
- Move `public/images/weapons/{weapon}.png` → `public/weapons/{weapon}/image.png`
- Rename all images to `image.png` or `image.gif`

### Step 2: Create Missing Weapon Folders
```batch
setup_all_weapon_folders_combined.bat
```

This will:
- Parse all 160+ Tarkov weapons from tarkov.dev
- Create folder structure for EVERY weapon
- Generate `all_tarkov_weapons.json` reference file

### Step 3: Verify Migration
1. Check that `public/weapons/` contains your weapon folders
2. Verify images are renamed to `image.png` or `image.gif`
3. Verify audio files are in close/medium/long subfolders
4. Run the game and gallery to test

## Code Changes (Already Done)
- ✅ `weapons.js`: Updated `getWeaponImageUrl()` to use `weapons/{weaponId}/image.png`
- ✅ `game.js`: Updated audio paths from `audio/` to `weapons/`
- ✅ `gallery.js`: Updated audio paths from `audio/` to `weapons/`

## After Migration
- Old `public/audio/` directory can be deleted if empty
- Old `public/images/weapons/` directory can be deleted if empty
- Each weapon folder should have:
  - `image.png` or `image.gif` (when you add it)
  - `close/`, `medium/`, `long/` folders (for audio you record)

## Example: Adding a New Weapon
1. Create folder: `public/weapons/new-weapon/`
2. Add image: `public/weapons/new-weapon/image.png`
3. Add audio:
   - `public/weapons/new-weapon/medium/sound1.mp3`
   - `public/weapons/new-weapon/long/sound2.mp3`
4. Update `game.js` and `gallery.js` audio mappings
5. Update `WEAPONS_WITH_AUDIO` list in `game.js`

## Rollback (If Needed)
If something goes wrong:
1. Don't delete old `public/audio/` and `public/images/weapons/` folders until you're sure
2. You can manually move files back if needed
3. Revert code changes in `weapons.js`, `game.js`, and `gallery.js`


