# Check which weapons are missing images
# Compares weapons.js with actual image files

$weaponsJsPath = "public\js\weapons.js"
$weaponsDir = "public\weapons"

Write-Host "========================================"
Write-Host "Checking Missing Weapon Images"
Write-Host "========================================"
Write-Host ""

# Read weapons.js and extract weapon IDs
$content = Get-Content $weaponsJsPath -Raw
$pattern = "id:\s*['""]([^'""]+)['""]"
$matches = [regex]::Matches($content, $pattern)

$weaponsWithImages = @()
$weaponsWithoutImages = @()

foreach ($match in $matches) {
    $weaponId = $match.Groups[1].Value
    
    if ($weaponId) {
        $weaponFolder = Join-Path $weaponsDir $weaponId
        $hasImage = (Test-Path (Join-Path $weaponFolder "image.png")) -or (Test-Path (Join-Path $weaponFolder "image.gif"))
        
        if ($hasImage) {
            $weaponsWithImages += $weaponId
        } else {
            $weaponsWithoutImages += $weaponId
        }
    }
}

Write-Host "Weapons WITH images: $($weaponsWithImages.Count)"
Write-Host "Weapons WITHOUT images: $($weaponsWithoutImages.Count)"
Write-Host "Total weapons: $($weaponsWithImages.Count + $weaponsWithoutImages.Count)"
Write-Host ""

if ($weaponsWithoutImages.Count -gt 0) {
    Write-Host "========================================"
    Write-Host "Missing Images:"
    Write-Host "========================================"
    $weaponsWithoutImages | ForEach-Object { Write-Host "  - $_" }
    Write-Host ""
    
    # Export to file
    $weaponsWithoutImages | Out-File -FilePath "missing_images.txt" -Encoding UTF8
    Write-Host "List saved to: missing_images.txt"
}

Write-Host ""


