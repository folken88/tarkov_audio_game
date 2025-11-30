# Weapons Needing Audio Files

This document tracks which weapons still need audio files to be recorded.

## Currently Have Audio Files (24 weapons)

✅ **ak-103** - 2 files  
✅ **ak-74** - 3 files (NOTE: Currently contains AK-50 files - needs correction)  
✅ **ash-12** - 3 files  
✅ **dvl-10** - 1 file  
✅ **fn57** - 1 file  
✅ **glock-18c** - 3 files  
✅ **m4a1** - 3 files  
✅ **m700** - 3 files  
✅ **mdr-308** - 2 files  
✅ **mk47** - 2 files  
✅ **mosin** - 1 file  
✅ **mp-153** - 1 file  
✅ **p90** - 1 file  
✅ **rfb** - 1 file  
✅ **rsass** - 2 files  
✅ **rsh12** - 3 files  
✅ **saiga-12k** - 2 files  
✅ **scar-h** - 1 file  
✅ **sr-25** - 2 files  
✅ **sv-98** - 4 files  
✅ **svd** - 4 files (including 1 far range)  
✅ **t-5000** - 3 files  
✅ **tt** - 2 files  
✅ **vpo-209** - 2 files  

## Still Need Audio Files

### Assault Carbines (9 weapons)
- 9A-91
- ADAR 2-15
- AS VAL MOD.4
- AVT-40
- OP-SKS
- SAG AK
- SAG AK Short
- SKS
- SR-3M

### Assault Rifles (18 weapons)
- AK-74N
- AK-74M
- AK-101
- AK-102
- AK-104
- AK-105
- AKM
- AKMN
- AKMS
- AKMSN
- HK 416A5
- SA-58
- SCAR-L
- TX-15 DML
- RD-704
- AK-12
- AK-15
- MDR 5.56x45

### Bolt-Action Rifles (3 weapons)
- M700 Tactical
- M700 SASS
- M700 Ultra

### Designated Marksman Rifles (5 weapons)
- SVDS
- VSS Vintorez
- AS VAL
- M1A
- M1A SASS

### Light Machine Guns (5 weapons)
- RPK-16
- PKP
- PKM
- M249
- M240B

### Shotguns (7 weapons)
- MP-133
- MP-155
- MP-18
- TOZ-106
- Remington 870
- M1014
- M590A1

### Submachine Guns (13 weapons)
- MP5
- MP5K
- MP5SD
- MP7
- MP9
- PP-19-01 Vityaz
- PP-91 Kedr
- PP-91-01 Kedr-B
- PPSh-41
- UMP-45
- Saiga-9
- STM-9
- SR-2M Veresk

### Pistols (8 weapons)
- PM
- P226
- Glock 17
- M9A3
- M1911A1
- APB
- APS
- SR1MP

## Issues to Fix

⚠️ **AK-50 Files**: The files `ak50_burst_reload.mp3`, `ak50_single_shot.mp3`, and `ak50_single_shot_glass_break.mp3` are currently in the `ak-74` folder. These should either be:
1. Moved to a separate `ak-50` folder if AK-50 is a distinct weapon, OR
2. Renamed/replaced with actual AK-74 sounds if they're being used as placeholders

## Total Summary

- **Have audio**: 24 weapons
- **Need audio**: 69 weapons
- **Total weapons**: 93 weapons

## Notes

- Audio files should be organized as: `audio/{weapon-id}/{range}/{filename}.mp3`
- Range categories: `close`, `medium`, `far`
- Multiple files per weapon are recommended for variety
- At least 1-2 files per weapon minimum for the game to work properly


