# Stop execution on any error
$ErrorActionPreference = "Stop"

# Install location
$installDir = "$env:LOCALAPPDATA\Programs\SBAdmin"
$exePath    = "$installDir\sbadmin.exe"
$tempZip    = "$env:TEMP\sbadmin.zip"

# Detect architecture
if ([Environment]::Is64BitOperatingSystem) {
    if ($env:PROCESSOR_ARCHITECTURE -like "*ARM*") {
        $arch = "arm64"
    } else {
        $arch = "amd64"
    }
} else {
    Write-Error "Unsupported architecture. Only 64-bit systems are supported."
    exit 1
}

# Release ZIP URL
$url = "https://github.com/tiwari-mani-tft/SB-Admin-CLI-Release/releases/latest/download/sbadmin-windows-$arch.zip"

Write-Host "Downloading SBAdmin CLI (windows-$arch)..."

# Create install directory
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Download ZIP
Invoke-WebRequest -Uri $url -OutFile $tempZip

Write-Host "Extracting..."

# Extract ZIP
Expand-Archive -Path $tempZip -DestinationPath $installDir -Force

# Ensure executable name is lowercase
$extractedExe = Get-ChildItem $installDir -Filter "*.exe" | Select-Object -First 1
if ($extractedExe.Name -ne "sbadmin.exe") {
    Rename-Item $extractedExe.FullName $exePath -Force
}

# Cleanup
Remove-Item $tempZip -Force

Write-Host "Installing... sbadmin"

# Add to PATH if missing
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($path -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$path;$installDir", "User")
    Write-Host "Added SBAdmin to PATH"
} else {
    Write-Host "SBAdmin already in PATH"
}
Write-Host ""
Write-Host "Installation complete!"
Write-Host "Restart PowerShell, then run:"
Write-Host "sbadmin version"
