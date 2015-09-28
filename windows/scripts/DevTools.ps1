Param(
    [switch] $DotNet,
    [switch] $CPP,
    [switch] $Jdk7,
    [switch] $Jdk8
)

##################
# Type definitions



##################
# Helper functions

Function Get-VsCommonToolsDirectory
{
    $vsBaseDirectory = Get-32BitSoftwareRegistryValue -RelativePath 'Microsoft\VisualStudio\SxS\VS7' -Name '14.0'
    If (!$vsBaseDirectory)
    {
        Throw 'Cannot find Visual Studio 2015 base directory in the registry.';
    }

    $vsCommonToolsDirectory = Join-Path $vsBaseDirectory 'Common7\Tools'

    Return $vsCommonToolsDirectory
}

Function Get-WindowsSdkDirectory
{
    $windowsSdkDirectory = Get-32BitSoftwareRegistryValue -RelativePath 'Microsoft\Microsoft SDKs\Windows\v10.0' -Name 'InstallationFolder'
    If (!$windowsSdkDirectory)
    {
        Throw 'Cannot find Windows 10 SDK base directory in the registry.';
    }

    $vsCommonToolsDirectory = Join-Path $vsBaseDirectory 'Common7\Tools'

    Return $vsCommonToolsDirectory
}

Function Get-32BitSoftwareRegistryValue([string] $RelativePath, [string] $Name)
{
    If ([Environment]::Is64BitProcess)
    {
        $key = 'HKLM:\SOFTWARE\Wow6432Node'
    }
    Else
    {
        $key = 'HKLM:\SOFTWARE'
    }

    $key = Join-Path $key $RelativePath
    $value = Get-ItemPropertyValue $key -Name $Name

    Return $value
}

Function Convert-PathStringToPathSet([string] $PathString) {
    # Path order is important (but case is not).
    $PathSet = New-Object 'System.Collections.Generic.SortedSet`1[[System.String,mscorlib]]' -ArgumentList ([System.StringComparer]::OrdinalIgnoreCase)

    If ($PathString) {
        ForEach ($path in $PathString.Split(';')) {
            $trimmedPath = $path.Trim()
            If ($trimmedPath) {
                $PathSet.Add($trimmedPath) | Out-Null
            }
        }
    }

    Write-Output $PathSet -NoEnumerate # Don't try to be overly helpful and convert it to a fucking array.
}

Function Convert-PathSetToPathString([System.Collections.Generic.SortedSet`1[[System.String,mscorlib]]] $PathSet) {
    Return [string]::Join(";", $PathSet)
}

<#
    TODO: Implement DotNet and CPP parameters
#>

If ($Jdk7) {
    $JdkVersion = '1.7.0_79'
}
ElseIf ($Jdk8) {
    $JdkVersion = '1.8.0_60'
}

#######################
# Environment variables

If ($DotNet) {
    $env:Framework40Version = 'v4.0'
    $env:FrameworkDir = 'C:\WINDOWS\Microsoft.NET\Framework\'
    $env:FrameworkDIR32 = 'C:\WINDOWS\Microsoft.NET\Framework\'
    $env:FrameworkVersion = 'v4.0.30319'
    $env:FrameworkVersion32 = 'v4.0.30319'
    $env:NETFXSDKDir = 'C:\Program Files (x86)\Windows Kits\NETFXSDK\4.6\'
    $env:FSHARPINSTALLDIR = Join-Path ${env:ProgramFiles(x86)} 'Microsoft SDKs\F#\4.0\Framework\v4.0\'
}

If ($CPP) {
    # CPP:Includes
    $includes = Convert-PathStringToPathSet($env:INCLUDE)

    $includes.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\VC\INCLUDE')
    ) | Out-Null
    $includes.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\VC\ATLMFC\INCLUDE')
    ) | Out-Null
    $includes.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\include\10.0.10240.0\ucrt')
    ) | Out-Null
    $includes.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\NETFXSDK\4.6\include\um')
    ) | Out-Null
    $includes.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\include\10.0.10240.0\shared')
    ) | Out-Null
    $includes.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\include\10.0.10240.0\um')
    ) | Out-Null
    $includes.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\include\10.0.10240.0\winrt')
    ) | Out-Null

    $env:INCLUDE = Convert-PathSetToPathString $includes

    # CPP: Libraries
    $libraries = Convert-PathStringToPathSet $env:LIB

    $libraries.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\VC\LIB')
    ) | Out-Null
    $libraries.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\VC\ATLMFC\LIB')
    ) | Out-Null
    $libraries.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\lib\10.0.10240.0\ucrt\x86')
    ) | Out-Null
    $libraries.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\NETFXSDK\4.6\lib\um\x86')
    ) | Out-Null
    $libraries.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\lib\10.0.10240.0\um\x86')
    ) | Out-Null

    $env:LIB = Convert-PathSetToPathString $libraries
}

<#
    TODO: This is clumsy - just build native PS lists and have a function that appends the list to a path string with sorted-set semantics (existing entries have priority).
#>

# Library Paths
$libraryPaths = Convert-PathStringToPathSet $env:LIBPATH

If ($DotNet) {
    $libraryPaths.Add(
        'C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319'
    ) | Out-Null
}
If ($CPP) {
    $libraryPaths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\VC\LIB')
    ) | Out-Null
    $libraryPaths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\VC\ATLMFC\LIB')
    ) | Out-Null
    $libraryPaths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\UnionMetadata')
    ) | Out-Null
    $libraryPaths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\References')
    ) | Out-Null
    $libraryPaths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\References\Windows.Foundation.UniversalApiContract\1.0.0.0')
    ) | Out-Null
    $libraryPaths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\References\Windows.Foundation.FoundationContract\1.0.0.0')
    ) | Out-Null
    $libraryPaths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\References\indows.Networking.Connectivity.WwanContract\1.0.0.0')
    ) | Out-Null
    $libraryPaths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft SDKs\Windows Kits\10\ExtensionSDKs\Microsoft.VCLibs\14.0\References\CommonConfiguration\neutral')
    ) | Out-Null
}

$env:LIBPATH = Convert-PathSetToPathString $libraryPaths

# Paths
$paths = Convert-PathStringToPathSet $env:Path

If ($DotNet) {
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'HTML Help Workshop')
    ) | Out-Null
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft SDKs\F#\4.0\Framework\v4.0')
    ) | Out-Null
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft SDKs\TypeScript\1.0')
    ) | Out-Null
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft SDKs\TypeScript\1.5')
    ) | Out-Null
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6 Tools')
    ) | Out-Null
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\Common7\IDE')
    ) | Out-Null
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TestWindow')
    ) | Out-Null
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\Common7\Tools')
    ) | Out-Null
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\Team Tools\Performance Tools')
    ) | Out-Null
}
If ($CPP) {
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\VC\BIN')
    ) | Out-Null
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\VC\VCPackages')
    ) | Out-Null
}
If ($DotNet -Or $CPP) {
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'MSBuild\14.0\bin')
    ) | Out-Null
    $paths.Add(
        (Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\bin\x86')
    ) | Out-Null
}
If ($DotNet) {
    $paths.Add(
        (Join-Path $env:windir 'C:\WINDOWS\Microsoft.NET\Framework\v4.0.30319')
    ) | Out-Null
}
If ($JdkVersion) {
    $env:JAVA_HOME = Join-Path $env:ProgramFiles "Java\jdk$JdkVersion"
    $env:JDK_HOME = Join-Path $env:ProgramFiles "Java\jdk$JdkVersion"
    $paths.Add(
        (Join-Path $env:JDK_HOME 'bin')
    ) | Out-Null
    $paths.Add(
        'C:\Development\Tools\ant\bin'
    ) | Out-Null
    $paths.Add(
        ('C:\Development\Tools\gradle\bin')
    ) | Out-Null
    $paths.Add(
        ('C:\Development\Tools\activator')
    ) | Out-Null
}

$env:Path = Convert-PathSetToPathString $paths

$env:PATHEXT = '.COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.PY'
$env:UCRTVersion = '10.0.1 0240.0'
$env:UniversalCRTSdkDir = Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\'

If ($CPP) {
    $env:VCINSTALLDIR = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\VC\'
    $env:WindowsLibPath = 'C:\Program Files (x86)\Windows Kits\10\UnionMetadata;C:\Program Files (x86)\Windows Kits\10\References;C:\Program Files (x86)\Windows Kits\10\References\Windows.Foundation.UniversalApiContract\1.0.0.0;C:\Program Files (x86)\Windows Kits\10\References\Windows.Foundation.FoundationContract\1.0.0.0;C:\Program Files (x86)\Windows Kits\10\References\indows.Networking.Connectivity.WwanContract\1.0.0.0'
}

$env:VisualStudioVersion = '14.0'
$env:VS110COMNTOOLS = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 11.0\Common7\Tools\'
$env:VS120COMNTOOLS = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 12.0\Common7\Tools\'
$env:VS140COMNTOOLS = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\Common7\Tools\'
$env:VSINSTALLDIR = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\'
$env:VSSDK140Install = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio 14.0\VSSDK\'
$env:WindowsSdkDir = Join-Path ${env:ProgramFiles(x86)} 'Windows Kits\10\'
$env:WindowsSDKLibVersion = '10.0.10240.0\'
$env:WindowsSDKVersion = '10.0.10240.0\'
$env:WindowsSDK_ExecutablePath_x64 = Join-Path ${env:ProgramFiles(x86)} 'Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6 Tools\x64\'
$env:WindowsSDK_ExecutablePath_x86 = Join-Path ${env:ProgramFiles(x86)} 'Microsoft SDKs\Windows\v10.0A\bin\NETFX 4.6 Tools\'

# Set up the window / tab title
$devComponents = @()
If ($DotNet) {
    $devComponents += '.NET'
}
If ($CPP) {
    $devComponents += 'C++'
}
If ($Jdk7) {
    $devComponents += 'JDK7'
}
If ($Jdk8) {
    $devComponents += 'JDK8'
}

$windowTitle = "Dev"
If ($devComponents.Length) {
    $windowTitle += ' ('
    $windowTitle += [string]::Join(', ', $devComponents)
    $windowTitle += ')'
}
$Host.UI.RawUI.WindowTitle = $windowTitle
