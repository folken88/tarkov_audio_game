# Download the 6 missing weapon images from Tarkov Wiki
# Uses the same method that worked for all other weapons

$ErrorActionPreference = "Continue"

$weaponsDir = "..\public\weapons"
$wikiBase = "https://escapefromtarkov.fandom.com/wiki"

# The 6 weapons missing images
$weaponPages = @{
    'rpd' = 'RPD_7.62x39_light_machine_gun'
    'aa-12' = 'MPS_Auto_Assault-12_Gen.1_12ga_automatic_shotgun'
    'ks-23m' = 'TOZ_KS-23M_23x75mm_pump-action_shotgun'
    'mdr-556' = 'Desert_Tech_MDR_5.56x45_assault_rifle'
    'm249' = 'U.S._Ordnance_M249_7.62x51_light_machine_gun'
    'm240b' = 'U.S._Ordnance_M240B_7.62x51_light_machine_gun'
}

# Human-readable names for filenames
$weaponNames = @{
    'rpd' = 'RPD'
    'aa-12' = 'AA-12'
    'ks-23m' = 'KS-23M'
    'mdr-556' = 'MDR-556'
    'm249' = 'M249'
    'm240b' = 'M240B'
}

Write-Host "========================================"
Write-Host "Downloading 6 Missing Weapon Images"
Write-Host "========================================"
Write-Host ""

$successCount = 0
$failCount = 0
$failedWeapons = @()

foreach ($weaponId in $weaponPages.Keys) {
    $weaponFolder = Join-Path $weaponsDir $weaponId
    $weaponName = $weaponNames[$weaponId]
    $outputFilePng = Join-Path $weaponFolder "$weaponName.png"
    $outputFileGif = Join-Path $weaponFolder "$weaponName.gif"
    
    # Check if image already exists
    if ((Test-Path $outputFilePng) -or (Test-Path $outputFileGif)) {
        Write-Host "[SKIP] $weaponId (image already exists)" -ForegroundColor Yellow
        continue
    }
    
    # Ensure folder exists
    if (-not (Test-Path $weaponFolder)) {
        New-Item -ItemType Directory -Path $weaponFolder -Force | Out-Null
    }
    
    $wikiPage = $weaponPages[$weaponId]
    $wikiUrl = "$wikiBase/$wikiPage"
    
    Write-Host "[$($successCount + $failCount + 1)/6] Processing $weaponId ($weaponName)..." -NoNewline
    
    try {
        # Fetch the wiki page HTML
        $response = Invoke-WebRequest -Uri $wikiUrl -UseBasicParsing -TimeoutSec 20 -ErrorAction Stop
        $html = $response.Content
        
        # Extract image URL from HTML
        $imageUrl = $null
        $imageExtension = "png"
        
        # Pattern 1: Look for infobox image (most common)
        if ($html -match 'escapefromtarkov_gamepedia/images/([^"]+\.(?:png|gif|jpg|jpeg))') {
            $imagePath = $matches[1]
            # Remove query parameters and revision info
            $imagePath = $imagePath -replace '/revision.*$', ''
            $imagePath = $imagePath -replace '\?.*$', ''
            
            # Determine extension
            if ($imagePath -match '\.gif') {
                $imageExtension = "gif"
            } elseif ($imagePath -match '\.(jpg|jpeg)') {
                $imageExtension = "png"
            }
            
            # Construct full URL with scaling
            $imageUrl = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/$imagePath/revision/latest/scale-to-width-down/320"
        }
        
        # Pattern 2: Look for direct image src in infobox
        if (-not $imageUrl -and $html -match 'src="(https://static\.wikia\.nocookie\.net/escapefromtarkov_gamepedia/images/[^"]+\.(?:png|gif|jpg|jpeg))') {
            $fullUrl = $matches[1]
            if ($fullUrl -match '/images/([^/]+/[^/]+/[^"]+\.(?:png|gif|jpg|jpeg))') {
                $imagePath = $matches[1]
                $imagePath = $imagePath -replace '/revision.*$', ''
                $imagePath = $imagePath -replace '\?.*$', ''
                
                if ($imagePath -match '\.gif') {
                    $imageExtension = "gif"
                } elseif ($imagePath -match '\.(jpg|jpeg)') {
                    $imageExtension = "png"
                }
                
                $imageUrl = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/$imagePath/revision/latest/scale-to-width-down/320"
            }
        }
        
        # Pattern 3: Look for data-src (lazy loading)
        if (-not $imageUrl -and $html -match 'data-src="(https://static\.wikia\.nocookie\.net/escapefromtarkov_gamepedia/images/[^"]+\.(?:png|gif|jpg|jpeg))') {
            $fullUrl = $matches[1]
            if ($fullUrl -match '/images/([^/]+/[^/]+/[^"]+\.(?:png|gif|jpg|jpeg))') {
                $imagePath = $matches[1]
                $imagePath = $imagePath -replace '/revision.*$', ''
                $imagePath = $imagePath -replace '\?.*$', ''
                
                if ($imagePath -match '\.gif') {
                    $imageExtension = "gif"
                } elseif ($imagePath -match '\.(jpg|jpeg)') {
                    $imageExtension = "png"
                }
                
                $imageUrl = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/$imagePath/revision/latest/scale-to-width-down/320"
            }
        }
        
        if ($imageUrl) {
            # Determine output file based on extension
            $outputFile = if ($imageExtension -eq "gif") { $outputFileGif } else { $outputFilePng }
            
            # Download the image
            Write-Host " [DL]..." -NoNewline
            Invoke-WebRequest -Uri $imageUrl -OutFile $outputFile -UseBasicParsing -TimeoutSec 15 -ErrorAction Stop
            
            if (Test-Path $outputFile) {
                $fileSize = (Get-Item $outputFile).Length
                if ($fileSize -gt 0) {
                    $sizeKB = [math]::Round($fileSize/1KB, 1)
                    $fileName = Split-Path $outputFile -Leaf
                    Write-Host " [OK] ($sizeKB KB, $fileName)" -ForegroundColor Green
                    $successCount++
                } else {
                    Remove-Item $outputFile -Force -ErrorAction SilentlyContinue
                    Write-Host " [FAIL] (empty file)" -ForegroundColor Red
                    $failCount++
                    $failedWeapons += @{ id = $weaponId; url = $wikiUrl; reason = "empty file" }
                }
            } else {
                Write-Host " [FAIL] (file not created)" -ForegroundColor Red
                $failCount++
                $failedWeapons += @{ id = $weaponId; url = $wikiUrl; reason = "file not created" }
            }
        } else {
            Write-Host " [FAIL] (no image found on page)" -ForegroundColor Red
            Write-Host "   Wiki URL: $wikiUrl" -ForegroundColor Cyan
            $failCount++
            $failedWeapons += @{ id = $weaponId; url = $wikiUrl; reason = "no image found" }
        }
    } catch {
        Write-Host " [FAIL] ($($_.Exception.Message))" -ForegroundColor Red
        Write-Host "   Wiki URL: $wikiUrl" -ForegroundColor Cyan
        $failCount++
        $failedWeapons += @{ id = $weaponId; url = $wikiUrl; reason = $_.Exception.Message }
    }
    
    # Small delay to avoid rate limiting
    Start-Sleep -Milliseconds 1000
}

Write-Host ""
Write-Host "========================================"
Write-Host "Download Summary"
Write-Host "========================================"
Write-Host "  Success: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failCount" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "Green" })
Write-Host ""

if ($failedWeapons.Count -gt 0) {
    Write-Host "Failed Weapons:" -ForegroundColor Red
    foreach ($weapon in $failedWeapons) {
        Write-Host "  - $($weapon.id) : $($weapon.url)" -ForegroundColor Yellow
        Write-Host "    Reason: $($weapon.reason)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Script completed!" -ForegroundColor Cyan

