# Define your custom URL and temporary download path
$url = "https://github.com/Shadowclutch/my-scripts/releases/latest/download/CloudRedirectCLI.exe"
$tempPath = "$env:TEMP\CloudRedirectCLI.exe"

Write-Host "Downloading CloudRedirectCLI.exe from Shadowclutch..." -ForegroundColor Cyan

# Download the file safely
Invoke-WebRequest -Uri $url -OutFile $tempPath

# Check if the file successfully downloaded before trying to run it
if (Test-Path $tempPath) {
    Write-Host "Running CloudRedirectCLI with /stfixer switch..." -ForegroundColor Green
    & $tempPath /stfixer
} else {
    Write-Host "Error: Failed to download the executable." -ForegroundColor Red
}
