$ErrorActionPreference = "Stop"

$installDir = "$env:LOCALAPPDATA\Programs\SBAdmin-Staging"
$tempZip = "$env:TEMP\sbadmin-staging.zip"

if ($env:PROCESSOR_ARCHITECTURE -like "*ARM*") {
    $arch = "arm64"
} else {
    $arch = "amd64"
}

$url = "https://github.com/kha-javed-tft/Selfbest_admin_cli/releases/download/staging-latest/sbadmin-windows-$arch.zip"

New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Invoke-WebRequest -Uri $url -OutFile $tempZip
Expand-Archive -Force $tempZip $installDir
Remove-Item $tempZip

Rename-Item (Get-ChildItem $installDir *.exe).FullName "$installDir\sbadmin-staging.exe" -Force

$path = [Environment]::GetEnvironmentVariable("PATH","User")
if ($path -notlike "*$installDir*") {
  [Environment]::SetEnvironmentVariable("PATH","$path;$installDir","User")
}

Write-Host "✅ sbadmin-staging installed"
