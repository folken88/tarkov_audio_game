# Download RPD and AA-12 images only

$ErrorActionPreference = "Continue"

$weaponsDir = "..\public\weapons"
$wikiBase = "https://escapefromtarkov.fandom.com/wiki"

$weaponPages = @{
    'rpd' = 'RPD_7.62x39_light_machine_gun'
    'aa-12' = 'MPS_Auto_Assault-12_Gen.1_12ga_automatic_shotgun'
}

$weaponNames = @{
    'rpd' = 'RPD'
    'aa-12' = 'AA-12'
}

Write-Host "Downloading RPD and AA-12 images..." -ForegroundColor Cyan
Write-Host ""

foreach ($weaponId in $weaponPages.Keys) {
    $weaponFolder = Join-Path $weaponsDir $weaponId
    $weaponName = $weaponNames[$weaponId]
    $outputFile = Join-Path $weaponFolder "$weaponName.png"
    
    if (Test-Path $outputFile) {
        Write-Host "[SKIP] $weaponId (already exists)" -ForegroundColor Yellow
        continue
    }
    
    $wikiPage = $weaponPages[$weaponId]
    $wikiUrl = "$wikiBase/$wikiPage"
    
    Write-Host "Processing $weaponId..." -NoNewline
    
    try {
        $response = Invoke-WebRequest -Uri $wikiUrl -UseBasicParsing -TimeoutSec 20
        $html = $response.Content
        
        $imageUrl = $null
        
        if ($html -match 'escapefromtarkov_gamepedia/images/([^"]+\.(?:png|gif|jpg|jpeg))') {
            $imagePath = $matches[1] -replace '/revision.*$', '' -replace '\?.*$', ''
            $imageUrl = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/$imagePath/revision/latest/scale-to-width-down/320"
        }
        
        if ($imageUrl) {
            Write-Host " Downloading..." -NoNewline
            Invoke-WebRequest -Uri $imageUrl -OutFile $outputFile -UseBasicParsing -TimeoutSec 15
            
            if ((Test-Path $outputFile) -and ((Get-Item $outputFile).Length -gt 0)) {
                $sizeKB = [math]::Round((Get-Item $outputFile).Length/1KB, 1)
                Write-Host " ✓ OK ($sizeKB KB)" -ForegroundColor Green
            } else {
                Write-Host " ✗ FAIL (empty)" -ForegroundColor Red
            }
        } else {
            Write-Host " ✗ FAIL (no image found)" -ForegroundColor Red
            Write-Host "  URL: $wikiUrl"
        }
    } catch {
        Write-Host " ✗ FAIL ($($_.Exception.Message))" -ForegroundColor Red
    }
    
    Start-Sleep -Milliseconds 1000
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green










