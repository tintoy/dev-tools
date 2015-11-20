$scriptFolder = Split-Path $Script:PSCommandPath -Parent
$commonProfileScript = Join-Path $scriptFolder 'profile.ps1'

. $commonProfileScript

# Don't take over my window title!
$global:GitPromptSettings.EnableWindowTitle = $null

<#
    .SYNOPSIS
        Generate content for .gitignore
    .PARAMETER IgnoreTypes
        A list of .gitignore types
#>
Function Get-GitIgnore {
    [Alias('ggi')]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string[]] $IgnoreTypes
    )

    $params = $IgnoreTypes -join ","
    Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | Select -ExpandProperty Content
}

Write-Host "Development Environment (.NET / C++)"
& C:\Development\Tools\DevTools.ps1 -DotNet -CPP
