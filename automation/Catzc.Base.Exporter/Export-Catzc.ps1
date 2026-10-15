<#
.SYNOPSIS
    Exports catzc — builds it (Build-Modules), then installs it beside a working root or packs it for
    Install-PSResource.
.DESCRIPTION
    Publishing beyond the local disk is the release workflow's act, never this function's.
    [ADR-AUTO-BUNDLE#6](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle6)
    [comment:1](/docs/references/automation/catzc-base-exporter/Export-Catzc.ps1.md#comment1)
.PARAMETER Root
    The destination working root of a disk export (where the root importer.ps1 goes).
.PARAMETER To
    disk (default) or nuget.
.PARAMETER Bundle
    The bundle to build (an exporter.yml bundles key; see Build-Modules). Defaults to default_bundle.
.PARAMETER Module
    Module names to build (see Build-Modules).
.PARAMETER ModuleProfile
    A profiles.yml key to build (see Build-Modules).
.PARAMETER VendorPolicy
    runtime | full (see Build-Modules).
.PARAMETER Version
    'auto' (default) or an explicit MAJOR.MINOR.PATCH (see Resolve-CatzcBuildVersion).
.PARAMETER Force
    Re-copy the build on a disk install even when the target is already current.
.PARAMETER Silent
    Suppress the build, install and pack summaries.
.EXAMPLE
    Export-Catzc -Root C:\work\project        # build + install into C:\work\project\.vendor, importer at the root
.EXAMPLE
    Export-Catzc -To nuget                     # build + pack into out/automation/packages/
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
        $package = New-CatzcNuGetPackage -Source $built.BuildRoot -DestinationPath (Join-Path (Get-OutputRoot -EnsureExists) 'automation/packages')
        if (-not $Silent) {
            Write-Message "Packed Catzc $($package.Version) ($($package.FunctionCount) functions) -> $(ConvertTo-RepoRelativePath $package.NuPkg)"
        }
        return $package
    }

    Install-Catzc -Root $Root -Source $built.BuildRoot -Force:$Force -Silent:$Silent
}
