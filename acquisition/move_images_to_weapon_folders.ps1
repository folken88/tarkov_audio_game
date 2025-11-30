# Move images from old location to new weapon folder structure
# Old: public/images/weapons/{weapon-id}.png
# New: public/weapons/{weapon-id}/image.png

$oldImageDir = "public\images\weapons"
$weaponsDir = "public\weapons"

if (-not (Test-Path $oldImageDir)) {
    Write-Host "Old image directory not found. Nothing to move."
    exit
}

Write-Host "========================================"
Write-Host "Moving Images to Weapon Folders"
Write-Host "========================================"
Write-Host ""

$movedCount = 0
$skippedCount = 0

# Get all images from old location
$oldImages = Get-ChildItem -Path $oldImageDir -File -Filter "*.png"

foreach ($image in $oldImages) {
    # Extract weapon ID from filename (e.g., "ak-103.png" -> "ak-103")
    $weaponId = [System.IO.Path]::GetFileNameWithoutExtension($image.Name)
    $weaponFolder = Join-Path $weaponsDir $weaponId
    
    if (Test-Path $weaponFolder) {
        $newImagePath = Join-Path $weaponFolder "image.png"
        
        # Check if image already exists in new location
        if (Test-Path $newImagePath) {
            Write-Host "Skipped: $weaponId (image already exists in weapon folder)"
            $skippedCount++
        } else {
            # Move image to new location
            Move-Item -Path $image.FullName -Destination $newImagePath -Force
            Write-Host "Moved: $weaponId.png -> weapons/$weaponId/image.png"
            $movedCount++
        }
    } else {
        Write-Host "Warning: Weapon folder not found for $weaponId"
    }
}

Write-Host ""
Write-Host "========================================"
Write-Host "Migration Complete!"
Write-Host "========================================"
Write-Host "Moved: $movedCount images"
Write-Host "Skipped: $skippedCount images (already exist)"
Write-Host ""

