# Check which weapons are missing images
# Compares weapons.js list with actual image files in weapon folders

$ErrorActionPreference = "Continue"

$weaponsDir = "public\weapons"
$weaponsJs = "public\js\weapons.js"

Write-Host "Checking for missing weapon images..." -ForegroundColor Cyan
Write-Host ""

# Extract weapon IDs from weapons.js
$weaponIds = @()
$content = Get-Content $weaponsJs -Raw
$matches = [regex]::Matches($content, "id: '([^']+)'")
foreach ($match in $matches) {
    $weaponIds += $match.Groups[1].Value
}

Write-Host "Found $($weaponIds.Count) weapons in weapons.js" -ForegroundColor Green
Write-Host ""

$missing = @()
$hasImage = @()

foreach ($weaponId in $weaponIds) {
    $folder = Join-Path $weaponsDir $weaponId
    
    if (-not (Test-Path $folder)) {
        $missing += $weaponId
        continue
    }
    
    # Check for image files (png, gif, or jpg)
    $images = Get-ChildItem $folder -Filter "*.png" -ErrorAction SilentlyContinue
    $images += Get-ChildItem $folder -Filter "*.gif" -ErrorAction SilentlyContinue
    $images += Get-ChildItem $folder -Filter "*.jpg" -ErrorAction SilentlyContinue
    
    if ($images.Count -eq 0) {
        $missing += $weaponId
    } else {
        $hasImage += $weaponId
    }
}

Write-Host "=== WEAPONS WITH IMAGES ===" -ForegroundColor Green
Write-Host "Total: $($hasImage.Count)" -ForegroundColor Green
Write-Host ""

Write-Host "=== WEAPONS MISSING IMAGES ===" -ForegroundColor Red
Write-Host "Total: $($missing.Count)" -ForegroundColor Red
Write-Host ""

# Group by category for better readability
$categories = @{
    "Assault Carbines" = @('9a-91', 'adar-2-15', 'as-val-mod4', 'avt-40', 'op-sks', 'rfb', 'sag-ak', 'sag-ak-short', 'sks', 'sr-3m', 'nl545-gp')
    "Assault Rifles" = @('ak-74', 'ak-74n', 'ak-74m', 'ak-101', 'ak-102', 'ak-103', 'ak-104', 'ak-105', 'ak-12', 'ak-15', 'ak-50', 'akm', 'akmn', 'akms', 'akmsn', 'm4a1', 'hk416a5', 'sa-58', 'scar-l', 'scar-h', 'tx-15', 'ash-12', 'rd-704', 'mk47', 'mdr-308', 'mdr-556')
    "Bolt-Action Rifles" = @('mosin', 'sv-98', 't-5000', 'dvl-10', 'm700', 'm700-tac', 'm700-sass', 'm700-ultra', 'axmc', 'marlin-mxlr')
    "DMRs" = @('svd', 'svds', 'vss', 'as-val', 'm1a', 'm1a-sass', 'sr-25', 'rsass')
    "LMGs" = @('rpk-16', 'pkp', 'pkm', 'm249', 'm240b')
    "Shotguns" = @('saiga-12k', 'mp-153', 'mp-133', 'mp-155', 'mp-18', 'toz-106', 'remington-870', 'm1014', 'm590a1')
    "SMGs" = @('mp5', 'mp5k', 'mp5sd', 'mp7', 'mp9', 'pp-19-01', 'pp-91', 'pp-91-01', 'ppsh-41', 'p90', 'ump45', 'saiga-9', 'stm-9', 'sr-2m')
    "Pistols" = @('pm', 'p226', 'glock-17', 'glock-18c', 'm9a3', 'm1911a1', 'tt', 'fn57', 'apb', 'aps', 'sr1mp')
    "Revolvers" = @('rsh12')
    "Grenades" = @('f-1', 'rgd-5', 'm67', 'zarya', 'flash-grenade', 'smoke-grenade')
    "Flares" = @('flare', 'red-flare', 'green-flare', 'white-flare')
}

foreach ($category in $categories.Keys) {
    $categoryMissing = $missing | Where-Object { $categories[$category] -contains $_ }
    if ($categoryMissing.Count -gt 0) {
        Write-Host "$category ($($categoryMissing.Count)):" -ForegroundColor Yellow
        foreach ($weapon in $categoryMissing) {
            Write-Host "  - $weapon" -ForegroundColor White
        }
        Write-Host ""
    }
}

# Show weapons with audio but no images (priority)
Write-Host "=== PRIORITY: Weapons with audio but no images ===" -ForegroundColor Magenta
$weaponsWithAudio = @('ak-103', 'ak-50', 'ash-12', 'axmc', 'dvl-10', 'fn57', 'glock-18c', 'hk416a5', 'm4a1', 'm700', 'marlin-mxlr', 'mdr-308', 'mk47', 'mosin', 'mp-153', 'nl545-gp', 'p90', 'pm', 'rfb', 'rsass', 'rsh12', 'saiga-12k', 'scar-h', 'scar-l', 'sks', 'sr-25', 'sv-98', 'svd', 't-5000', 'tt', 'vpo-209')
$priority = $missing | Where-Object { $weaponsWithAudio -contains $_ }
if ($priority.Count -gt 0) {
    foreach ($weapon in $priority) {
        Write-Host "  ⚠️  $weapon" -ForegroundColor Red
    }
} else {
    Write-Host "  ✓ All weapons with audio have images!" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Cyan
