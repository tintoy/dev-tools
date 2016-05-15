$msbuild = Get-Command "${env:ProgramFiles(x86)}\MSBuild\14.0\Bin\MSBuild.exe"

<#
    .SYNOPSIS
        Run MSBuild.

    .PARAMETER Target
        The name of the MSBuild project target to invoke.
    .PARAMETER ProjectFile
        The name of the MSBuild project file to use.
    .PARAMETER Configuration
        The name of the MSBuild project configuration to use.
#>
Function Invoke-MSBuild(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Target,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $ProjectFile,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [string] $Configuration = 'Debug'
    ) {

    & $msbuild $ProjectFile "/t:$Target" "/p:Configuration=$Configuration"
}
New-Alias -Name mb -Value 'Invoke-MSBuild' -Description 'Run MSBuild.' -Force

Export-ModuleMember -Function Invoke-MSBuild
Export-ModuleMember -Alias mb

<#
    .SYNOPSIS
        Run MSBuild using the 'Build' target.

    .PARAMETER ProjectFile
        The name of the MSBuild project file to use.
    .PARAMETER Configuration
        The name of the MSBuild project configuration to use.
#>
Function Invoke-MSBuildBuild(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $ProjectFile,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [string] $Configuration = 'Debug'
    ) {

    Invoke-MSBuild -Target 'Build' -ProjectFile $ProjectFile -Configuration $Configuration
}
New-Alias -Name mbb -Value 'Invoke-MSBuildBuild' -Description "Run MSBuild using the 'Build' target." -Force

Export-ModuleMember -Function Invoke-MSBuildBuild
Export-ModuleMember -Alias mbb

<#
    .SYNOPSIS
        Run MSBuild using the 'Clean' target.

    .PARAMETER ProjectFile
        The name of the MSBuild project file to use.
    .PARAMETER Configuration
        The name of the MSBuild project configuration to use.
#>
Function Invoke-MSBuildClean(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $ProjectFile,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [string] $Configuration = 'Debug'
    ) {

    Invoke-MSBuild -Target 'Clean' -ProjectFile $ProjectFile -Configuration $Configuration
}
New-Alias -Name mbc -Value 'Invoke-MSBuildClean' -Description "Run MSBuild using the 'Clean' target." -Force

Export-ModuleMember -Function Invoke-MSBuildClean
Export-ModuleMember -Alias mbc

<#
    .SYNOPSIS
        Run MSBuild using the 'Rebuild' target.

    .PARAMETER ProjectFile
        The name of the MSBuild project file to use.
    .PARAMETER Configuration
        The name of the MSBuild project configuration to use.
#>
Function Invoke-MSBuildRebuild(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true, Position = 1)]
        [string] $ProjectFile,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $false)]
        [string] $Configuration = 'Debug'
    ) {

    Invoke-MSBuild -Target 'Clean' -ProjectFile $ProjectFile -Configuration $Configuration
}
New-Alias -Name mbr -Value 'Invoke-MSBuildRebuild' -Description "Run MSBuild using the 'Rebuild' target." -Force

Export-ModuleMember -Function Invoke-MSBuildRebuild
Export-ModuleMember -Alias mbr
