$path = (Get-Command sbadmin).Source
if ($path) {
    Remove-Item $path -Force
    Write-Host "Deleted sbadmin binary at: $path"
} else {
    Write-Host "sbadmin executable not found in PATH."
}
