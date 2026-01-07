# Download missing weapon images from Tarkov Wiki
# These are the 6 weapons currently missing images

$baseDir = "C:\Users\Forgemaster\Documents\tarkov-sound-game\public\weapons"

# Weapon image URLs (WebP format from wiki)
$weapons = @(
    @{ id = "rpd"; url = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/8/8d/RPDinspect.png"; name = "RPD" },
    @{ id = "aa-12"; url = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/2/2c/AA-12inspect.png"; name = "AA-12" },
    @{ id = "ks-23m"; url = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/5/52/KS-23Minspect.png"; name = "KS-23M" },
    @{ id = "mdr-556"; url = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/a/a4/MDR556inspect.png"; name = "MDR-556" },
    @{ id = "m249"; url = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/3/38/M249inspect.png"; name = "M249" },
    @{ id = "m240b"; url = "https://static.wikia.nocookie.net/escapefromtarkov_gamepedia/images/f/f0/M240Binspect.png"; name = "M240B" }
)

foreach ($weapon in $weapons) {
    $targetDir = Join-Path $baseDir $weapon.id
    $targetFile = Join-Path $targetDir "$($weapon.name).png"
    
    Write-Host "Downloading $($weapon.name)..." -ForegroundColor Cyan
    
    try {
        # Download the file
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0")
        $webClient.DownloadFile($weapon.url, $targetFile)
        
        Write-Host "  ✓ Downloaded to: $targetFile" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nDownload complete!" -ForegroundColor Green










