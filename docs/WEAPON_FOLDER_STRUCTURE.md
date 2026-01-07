# Weapon Folder Structure

## Overview
Each weapon in the game now has its own dedicated folder containing all assets (image and sounds) in one place.

## Structure
```
public/weapons/
  {weapon-id}/
    image.png (or image.gif)
    close/
      *.mp3 (close range sounds)
    medium/
      *.mp3 (medium range sounds)
    far/
      *.mp3 (far range sounds)
```

## Examples
- `public/weapons/ak-103/image.png`
- `public/weapons/ak-103/close/ak103_close_shot.mp3`
- `public/weapons/ak-103/medium/ak103_fullauto.mp3`
- `public/weapons/ak-103/far/ak103_distant_shot.mp3`

## Setup Scripts

### Create All Weapon Folders
Run `setup_all_weapon_folders.ps1` (or `.bat`) to create folders for all weapons defined in `weapons.js`:
- Creates weapon folder if it doesn't exist
- Creates `close/`, `medium/`, and `far/` subfolders
- Automatically migrates any existing `long/` folders to `far/`

### Migrate Long to Far
Run `migrate_long_to_far.bat` to rename all `long/` folders to `far/` folders (if needed).

### Move Images
Run `move_images_to_weapon_folders.ps1` to move images from the old `public/images/weapons/` location to the new structure.

## Image Naming
- Standard name: `image.png`
- Alternative: `image.gif` (for animated images like scar-h)
- The code tries `image.png` first, with error handling for missing images

## Audio Organization
- **close/**: Close range weapon sounds (within ~50m)
- **medium/**: Medium range weapon sounds (~50-200m)
- **far/**: Far range weapon sounds (200m+)

## Benefits
✅ All weapon assets in one place
✅ Easy to see completion status
✅ Cleaner organization for 160+ weapons
✅ Simpler paths and references
✅ Easy to add new weapons

