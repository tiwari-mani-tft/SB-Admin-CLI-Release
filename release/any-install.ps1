param(
  [string]$Tag = "latest"
)

$ErrorActionPreference = "Stop"

if ($env:PROCESSOR_ARCHITECTURE -like "*ARM*") {
    $arch = "arm64"
} else {
    $arch = "amd64"
}

$installDir = "$env:LOCALAPPDATA\Programs\SBAdmin"
$exeName = "sbadmin.exe"

if ($Tag -like "staging*") {
  $installDir = "$env:LOCALAPPDATA\Programs\SBAdmin-Staging"
  $exeName = "sbadmin-staging.exe"
}

$url = "https://github.com/kha-javed-tft/Selfbest_admin_cli/releases/download/$Tag/sbadmin-windows-$arch.zip"
$tempZip = "$env:TEMP\sbadmin-any.zip"

New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Invoke-WebRequest -Uri $url -OutFile $tempZip
Expand-Archive -Force $tempZip $installDir
Remove-Item $tempZip

Rename-Item (Get-ChildItem $installDir *.exe).FullName "$installDir\$exeName" -Force

$path = [Environment]::GetEnvironmentVariable("PATH","User")
if ($path -notlike "*$installDir*") {
  [Environment]::SetEnvironmentVariable("PATH","$path;$installDir","User")
}

Write-Host "✅ Installed $exeName ($Tag)"
