param($AppId)

function Get-SteamPath {
    $paths = @(
        "HKCU:\Software\Valve\Steam",
        "HKLM:\Software\WOW6432Node\Valve\Steam",
        "HKLM:\Software\Valve\Steam"
    )
    foreach ($p in $paths) {
        try {
            $val = (Get-ItemProperty -Path $p -Name "SteamPath" -ErrorAction Stop).SteamPath
            if ($val) { return ($val.Trim('"') -replace '/', '\') }
        } catch {}
    }
    return "C:\Program Files (x86)\Steam"
}

function Get-SteamInstallPath($AppId) {
    $steam = Get-SteamPath
    $content = Get-Content "$steam\steamapps\libraryfolders.vdf" -Raw
    $paths = [regex]::Matches($content, '"path"\s+"([^"]+)"') | ForEach-Object { $_.Groups[1].Value -replace '\\\\', '\' -replace '/', '\' }
    foreach ($path in $paths) {
        if (Test-Path "$path\steamapps\appmanifest_$AppId.acf") {
            $manifest = Get-Content "$path\steamapps\appmanifest_$AppId.acf" -Raw
            $folder = [regex]::Match($manifest, '"installdir"\s+"([^"]+)"').Groups[1].Value
            return "$path\steamapps\common\$folder"
        }
    }
    return $null
}

# --- CloudRedirect Execution Script ---
# Define the source URL from Selectively11 and the local destination path
$url = "https://github.com/Selectively11/CloudRedirect/releases/latest/download/CloudRedirectCLI.exe"
$tempPath = "$env:TEMP\CloudRedirectCLI.exe"

Write-Host "Downloading CloudRedirectCLI.exe from Selectively11..." -ForegroundColor Cyan

# Download the executable safely using standard PowerShell protocols
Invoke-WebRequest -Uri $url -OutFile $tempPath

# Check if the download succeeded before executing the application
if (Test-Path $tempPath) {
    Write-Host "Running CloudRedirectCLI with /stfixer switch..." -ForegroundColor Green
    & $tempPath /stfixer
} else {
    Write-Host "Error: Failed to download the executable from the source repository." -ForegroundColor Red
}
