$scriptFolder = Split-Path $Script:PSCommandPath -Parent
$commonProfileScript = Join-Path $scriptFolder 'profile.ps1'

. $commonProfileScript

# Don't take over my window title!
$global:GitPromptSettings.EnableWindowTitle = $null

Write-Host "Development Environment (.NET)"
& C:\Development\Tools\DevTools.ps1 -DotNet
