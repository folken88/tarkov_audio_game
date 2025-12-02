# Audio/Image Synchronization Issues

## Critical Issue: Image/Sound Mismatch

**Problem**: Some weapons have images showing suppressors but play both suppressed AND loud audio randomly. This confuses players who are training to identify weapons by sound.

## Weapons with Mixed Audio (NEED FIX)

### 1. AKS-74U ❌ **CRITICAL**
- **Current Image**: Shows suppressor (tarkov_aks-74u_suppressor_waffle.png)
- **Audio Files**: 
  - `tarkov_kalashnikov_aks-74u_assault_rifle_burst_loud.mp3`
  - `tarkov_kalashnikov_aks-74u_assault_rifle_burst_suppressed.mp3`
  - `tarkov_kalashnikov_aks-74u_assault_rifle_single_loud.mp3`
  - `tarkov_kalashnikov_aks-74u_assault_rifle_single_suppressed.mp3`
- **Problem**: Image shows suppressor but game randomly plays LOUD or SUPPRESSED sounds
- **Fix Options**:
  - A) Get a neutral AKS-74U image without visible suppressor
  - B) Remove loud audio files and only use suppressed
  - C) Create two separate weapons: "AKS-74U" and "AKS-74U Suppressed"

### 2. M1A
- **Audio Files**: Has BOTH loud and suppressed variants
- **Recommended**: Use neutral image or split into two weapons

### 3. HK416A5  
- **Audio Files**: Has BOTH loud and suppressed variants
- **Recommended**: Use neutral image or split into two weapons

### 4. SCAR-L
- **Audio Files**: Has BOTH loud and suppressed variants
- **Recommended**: Use neutral image or split into two weapons

### 5. M4A1
- **Audio Files**: Has BOTH loud (`m4_loud_1shot.mp3`, `m4_fullauto.mp3`) and suppressed (`m4_silenced_burst.mp3`)
- **Recommended**: Use neutral image or split into two weapons

### 6. SVD
- **Audio Files**: Has BOTH loud and suppressed variants
- **Recommended**: Use neutral image or split into two weapons

## Weapons with Suppressed-Only Audio ✅

These weapons should ALWAYS show suppressors in images:

1. **DVL-10** ✅ - Only has `dvl_silenced.mp3` (image shows suppressor - CORRECT)
2. **AS VAL** ✅ - Always suppressed by design (image OK)
3. **MPX** - Only suppressed audio (need to verify image)
4. **SR-25** - Only suppressed audio
5. **RSASS** - Only suppressed audio  
6. **P90** - Only suppressed audio (`p90_silenced_burst.mp3`)

## Weapons with Loud-Only Audio ✅

These weapons should NEVER show suppressors in images:

1. **RPD** ✅ - Only loud audio (image says "loud" - CORRECT)
2. **PKM** - Only loud audio
3. **SA-58** - Only loud audio
4. **SR-2M** - Only loud audio (filenames say "loud")
5. **G36** - Only loud audio (filenames say "loud")
6. **AUG-A3** - Only loud audio (filenames say "loud")
7. **MP5** - Only loud audio (filenames say "loud")

## Recommendations

### Immediate Action Needed:
1. **AKS-74U** - This is the most critical issue. Either:
   - Get a new AKS-74U image WITHOUT suppressor visible, OR
   - Remove the loud audio files (keep only suppressed), OR
   - Split into two weapons

### Future Consistency:
- For weapons with mixed audio, either:
  - Use neutral images that don't clearly show suppressor presence/absence
  - Split them into separate weapon entries (e.g., "M4A1" and "M4A1 Suppressed")
  - Ensure audio selection matches the image (remove audio files that don't match)

## File Naming Convention
- Images ending in `_suppressor` or `_silenced` = Shows suppressor
- Images ending in `_loud` = Does NOT show suppressor
- Neutral images = No suffix, shouldn't clearly show suppressor presence

