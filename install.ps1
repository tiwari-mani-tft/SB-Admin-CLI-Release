# Stop execution on any error
$ErrorActionPreference = "Stop"

# Define installation directory and executable path
$installDir = "$env:LOCALAPPDATA\Programs\SBAdmin"
$exePath = "$installDir\SBAdmin.exe"

# Determine system architecture
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

# URL for the latest release download
$url = "https://github.com/tiwari-mani-tft/SB-Admin-CLI-Release/releases/latest/download/SBAdmin-windows-$arch.exe"

Write-Host "Downloading SBAdmin CLI for architecture: $arch..."
# Create install directory if it doesn't exist
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

# Download the executable
Invoke-WebRequest -Uri $url -OutFile $exePath

Write-Host "Installing..."

# Check if install directory is in user PATH; add it if missing
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($path -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable("PATH", "$path;$installDir", "User")
    Write-Host "Added $installDir to PATH environment variable (User scope)."
} else {
    Write-Host "Installation directory already present in PATH."
}

Write-Host "Installation complete!"
Write-Host "Please restart PowerShell or your terminal, then run: SBAdmin version"
