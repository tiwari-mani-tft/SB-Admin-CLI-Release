# Stop execution on any error
$ErrorActionPreference = "Stop"

$installDir = "$env:LOCALAPPDATA\Programs\SBAdmin"
$exePath = "$installDir\SBAdmin.exe"

if (-Not (Test-Path $exePath)) {
    Write-Host "ℹ️ SBAdmin CLI not found at $exePath"
    exit 0
}

Write-Host "🧹 Removing SBAdmin CLI executable..."
Remove-Item -Force $exePath

# Optionally, remove the directory if empty
if ((Get-ChildItem -Path $installDir -Recurse | Measure-Object).Count -eq 0) {
    Remove-Item -Force -Recurse $installDir
    Write-Host "🗑️ Removed empty install directory $installDir"
}

# Remove $installDir from user PATH environment variable if present
$path = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($path -like "*$installDir*") {
    $newPath = ($path -split ";") | Where-Object { $_ -ne $installDir } -join ";"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    Write-Host "✅ Removed $installDir from PATH environment variable (User scope)."
} else {
    Write-Host "ℹ️ Installation directory not found in PATH."
}

Write-Host "🎉 SBAdmin CLI uninstalled successfully!"
Write-Host "👉 Please restart PowerShell or your terminal."
