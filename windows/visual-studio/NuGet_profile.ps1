<#
	.SYNOPSIS
		You can customise the prompt (this function is run by PowerShell to display it).
#>
Function Prompt()
{
	$currentLocation = [IO.Path]::GetFileName(
		(Get-Location).Path
	)
	"[NuGet] $currentLocation> "
}

<#
	.SYNOPSIS
		Create a new GUID and copy it to the clipboard.

	.PARAMETER NoClip
		Don't copy the GUID to the clipboard?
#>
Function NGUID([switch] $NoClip) {
	$newGuid = [Guid]::NewGuid()

	If (!$NoClip) {
		# To clipboard
		$newGuid.ToString() | Clip

		Write-Verbose "New GUID '$newGuid' has been copied to the clipboard."
	}
	

	# To pipeline
	$newGuid
}

<# You can automate the IDE using the variable $dte (google "EnvDTE" for details). #>

<#
	.SYNOPSIS
		Disable JetBrains Resharper.
#>
Function Disable-Resharper()
{
	$dte.ExecuteCommand('Resharper_Suspend')
}

<#
	.SYNOPSIS
		Enable JetBrains Resharper.
#>
Function Enable-Resharper()
{
	$dte.ExecuteCommand('Resharper_Resume')
}

<#
	Helper functions for working with NuGet packages.

	Note that Get-Package does not take wildcards, but does do a "starts-with" match on package Ids.
#>

<#
	.SYNOPSIS
		Get all unique versions of packages installed in the solution and its projects.
	.OUTPUTS
		NuGet package information (Id, Version) sorted by package Id.
#>
Function Get-PackageUniqueVersions()
{
	Get-Package |
		Select Id, Version -Unique |
		Sort Id
}

<#
	.SYNOPSIS
		Get all installed Auditing packages in the solution and its projects.
	.OUTPUTS
		NuGet package information sorted by package Id.
#>
Function Get-PackagesForAuditing()
{
	Get-Package Aperture.Auditing | Sort Id
}

<#
	.SYNOPSIS
		Update all installed Auditing packages in the solution and its projects.
#>
Function Update-PackagesForAuditing([string] $PackageSource = 'Aperture20', [switch] $Pre = $false, [switch] $IgnoreDependencies = $false)
{
	Get-PackagesForAuditing |
		Select -ExpandProperty Id -Unique |
		Sort |
		ForEach {
			Update-Package $_ -Source $PackageSource -Prerelease:$Pre -FileConflictAction Ignore -IgnoreDependencies:$IgnoreDependencies
		}
}

<#
	.SYNOPSIS
		Get all installed Core (Platform.*) packages in the solution and its projects.
	.OUTPUTS
		NuGet package information sorted by package Id.
#>
Function Get-PackagesForCore()
{
	Get-Package Aperture.Platform | Sort Id
}

<#
	.SYNOPSIS
		Update all installed Core (Platform.*) packages in the solution and its projects.
#>
Function Update-PackagesForCore([string] $PackageSource = 'Aperture20', [switch] $Pre = $false, [switch] $IgnoreDependencies = $false)
{
	Get-PackagesForCore |
		Select -ExpandProperty Id -Unique |
		Sort |
		ForEach {
			Update-Package $_ -Source $PackageSource -Prerelease:$Pre -FileConflictAction Ignore -IgnoreDependencies:$IgnoreDependencies
		}
}

<#
	.SYNOPSIS
		Get all installed Messaging packages in the solution and its projects.
	.OUTPUTS
		NuGet package information sorted by package Id.
#>
Function Get-PackagesForMessaging()
{
	Get-Package Aperture |
		Where {
			$_.Id -Like 'Aperture.Messaging*' -Or $_.Id -Like 'Aperture.ServiceBus*'
		} | Sort Id
}

<#
	.SYNOPSIS
		Update all installed Messaging packages in the solution and its projects.
#>
Function Update-PackagesForMessaging([string] $PackageSource = 'Aperture20', [switch] $Pre = $false, [switch] $IgnoreDependencies = $false)
{
	Get-PackagesForMessaging |
		Select -ExpandProperty Id -Unique |
		ForEach {
			Update-Package $_ -Source $PackageSource -Prerelease:$Pre -FileConflictAction Ignore -IgnoreDependencies:$IgnoreDependencies
		}
}

<#
	.SYNOPSIS
		Get all installed DMS packages in the solution and its projects.
	.OUTPUTS
		NuGet package information sorted by package Id.
#>
Function Get-PackagesForDms()
{
	Get-Package Aperture.DistributedManagement | Sort Id
}

<#
	.SYNOPSIS
		Update all installed DMS packages in the solution and its projects.
#>
Function Update-PackagesForDms([string] $PackageSource = 'Aperture20', [switch] $Pre = $false, [switch] $IgnoreDependencies = $false)
{
	Get-PackagesForDms |
		Select -ExpandProperty Id -Unique |
		ForEach {
			Update-Package $_ -Source $PackageSource -Prerelease:$Pre -FileConflictAction Ignore -IgnoreDependencies:$IgnoreDependencies
		}
}

<#
	.SYNOPSIS
		Get all installed Provisioning packages in the solution and its projects.
	.OUTPUTS
		NuGet package information sorted by package Id.
#>
Function Get-PackagesForProvisioning()
{
	Get-Package Aperture.Provisioning | Sort Id
}

<#
	.SYNOPSIS
		Update all installed Provisioning packages in the solution and its projects.
#>
Function Update-PackagesForProvisioning([string] $PackageSource = 'Aperture20', [switch] $Pre = $false, [switch] $IgnoreDependencies = $false)
{
	Get-PackagesForProvisioning |
		Select -ExpandProperty Id -Unique |
		ForEach {
			Update-Package $_ -Source $PackageSource -Prerelease:$Pre -FileConflictAction Ignore -IgnoreDependencies:$IgnoreDependencies
		}
}

<#
	.SYNOPSIS
		Get all installed Identity packages in the solution and its projects.
	.OUTPUTS
		NuGet package information sorted by package Id.
#>
Function Get-PackagesForIdentity()
{
	Get-Package Aperture.Identity | Sort Id
}

<#
	.SYNOPSIS
		Update all installed Identity packages in the solution and its projects.
#>
Function Update-PackagesForIdentity([string] $PackageSource = 'Aperture20', [switch] $Pre = $false, [switch] $IgnoreDependencies = $false)
{
	Get-PackagesForIdentity |
		Select -ExpandProperty Id -Unique |
		ForEach {
			Update-Package $_ -Source $PackageSource -Prerelease:$Pre -FileConflictAction Ignore -IgnoreDependencies:$IgnoreDependencies
		}
}

<#
	.SYNOPSIS
		Get all installed Security Template engine packages in the solution and its projects.
	.OUTPUTS
		NuGet package information sorted by package Id.
#>
Function Get-PackagesForSecurityTemplate()
{
	Get-Package Aperture.SecurityTemplate | Sort Id
}

<#
	.SYNOPSIS
		Update all installed Security Template engine packages in the solution and its projects.
#>
Function Update-PackagesForSecurityTemplate([string] $PackageSource = 'Aperture20', [switch] $Pre = $false, [switch] $IgnoreDependencies = $false)
{
	Get-PackagesForSecurityTemplate |
		Select -ExpandProperty Id -Unique |
		ForEach {
			Update-Package $_ -Source $PackageSource -Prerelease:$Pre -FileConflictAction Ignore -IgnoreDependencies:$IgnoreDependencies
		}
}

<#
	.SYNOPSIS
		Get all installed Portal packages in the solution and its projects.
	.OUTPUTS
		NuGet package information sorted by package Id.
#>
Function Get-PackagesForPortal()
{
	Get-Package Aperture |
		Where {
			$_.Id -Like 'Aperture.Portal*' -Or $_.Id -Like 'Aperture.Services*' -Or $_.Id -Eq 'Aperture.Api.TestCommon'
		} | Sort Id
}

<#
	.SYNOPSIS
		Update all installed Portal packages in the solution and its projects.
#>
Function Update-PackagesForPortal([string] $PackageSource = 'Aperture20', [switch] $Pre = $false, [switch] $IgnoreDependencies = $false)
{
	Get-PackagesForPortal |
		Select -ExpandProperty Id -Unique |
		ForEach {
			Update-Package $_ -Source $PackageSource -Prerelease:$Pre -FileConflictAction Ignore -IgnoreDependencies:$IgnoreDependencies
		}
}
