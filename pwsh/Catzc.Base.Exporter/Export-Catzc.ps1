<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-exporter/Export-Catzc.ps1.md"
  warning: "Generated Header"
---
#>

function Export-Catzc {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0)]
        [string] $Root,

        [ValidateSet('disk', 'nuget')]
        [string] $To = 'disk',

        [string] $Bundle,
        [string[]] $Module,
        [string] $ModuleProfile,
        [ValidateSet('runtime', 'full')]
        [string] $VendorPolicy,
        [string] $Version = 'auto',
        [switch] $Force,
        [switch] $Silent
    )

    if ($To -eq 'disk') {
        Assert-NotNullOrWhitespace $Root -ErrorText 'Export-Catzc -To disk needs -Root, the destination working root.'
    }

    $buildArguments = @{ Version = $Version; Silent = $Silent }
    if ($Bundle) {
        $buildArguments.Bundle = $Bundle
    }
    if ($Module) {
        $buildArguments.Module = $Module
    }
    if ($ModuleProfile) {
        $buildArguments.ModuleProfile = $ModuleProfile
    }
    if ($VendorPolicy) {
        $buildArguments.VendorPolicy = $VendorPolicy
    }
    $built = Build-Modules @buildArguments

    if ($To -eq 'nuget') {
        $package = New-CatzcNuGetPackage -Source $built.BuildRoot -DestinationPath (Join-Path (Get-OutputRoot -EnsureExists) 'pwsh/packages')
        if (-not $Silent) {
            Write-Message "Packed Catzc $($package.Version) ($($package.FunctionCount) functions) -> $(ConvertTo-RepoRelativePath $package.NuPkg)"
        }
        return $package
    }

    Install-Catzc -Root $Root -Source $built.BuildRoot -Force:$Force -Silent:$Silent
}
