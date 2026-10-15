<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Exporter/Build-Modules.ps1
    kind: writer-function
    module: Catzc.Base.Exporter
    visibility: public
    adrs:
      - ADR-AUTO-BUNDLE#1
      - ADR-AUTO-DRYRUN#2
---
#>

<#
.SYNOPSIS
    Builds the selected modules into one installable, versioned Catzc module — build mode's code root.
.DESCRIPTION
    A build that overrides the selection or vendor policy is an experiment, so the footprint limits skip it.
.PARAMETER Module
    Module names to build (closure-expanded by the engine), in place of the bundle's profile.
.PARAMETER Bundle
    The bundle to build (an exporter.yml bundles key). Defaults to default_bundle.
.PARAMETER ModuleProfile
    Defaults to the bundle's profile only when -Module is absent; give both to build their union.
    [comment:2](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment2)
    Empty when -Module names the selection, so the profile never widens an explicit module list.
    [comment:6](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment6)
.PARAMETER VendorPolicy
    The bundle's vendor policy.
    full exists for a build run that tests the build itself, so Pester and PSScriptAnalyzer must travel with it.
    [comment:3](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment3)
.PARAMETER Version
    'auto' (default) or an explicit numeric MAJOR.MINOR.PATCH — see Resolve-CatzcBuildVersion.
.PARAMETER Destination
    The default is per bundle, so two bundles built side by side never share a folder.
.PARAMETER DryRun
    Return the build plan without writing anything.
.PARAMETER Silent
    Suppress the local-version notice and the summary line.
.EXAMPLE
    Build-Modules
.EXAMPLE
    Build-Modules -Bundle azure
.EXAMPLE
    Build-Modules Catzc.Base.Config -DryRun
#>
# -WhatIf narrates to the host and returns no plan, so a test can neither capture nor assert on it.
# [comment:5](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment5)
function Build-Modules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Builds a set of modules; the plural is the contract name (ADR-AUTO-BUNDLE#1)')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Module,

        [string] $Bundle = "$((Get-Config -Config exporter).default_bundle)",

        [string] $ModuleProfile = $(
            $bundles = (Get-Config -Config exporter).bundles
            if (-not $Module -and $bundles.ContainsKey($Bundle)) {
                "$($bundles[$Bundle].profile)"
            }
        ),

        [ValidateSet('runtime', 'full')]
        [string] $VendorPolicy = $(
            $bundles = (Get-Config -Config exporter).bundles
            if ($bundles.ContainsKey($Bundle)) {
                "$($bundles[$Bundle].vendor_policy)"
            }
        ),

        [string] $Version = 'auto',

        [string] $Destination = (Join-Path (Get-OutputRoot) "automation/built/$Bundle"),

        [switch] $DryRun,

        [switch] $Silent
    )

    $config = Get-Config -Config exporter
    Assert-True ($config.bundles.ContainsKey($Bundle)) -ErrorText "Unknown bundle '$Bundle': exporter.yml declares $(@($config.bundles.Keys) -join ', ')."
    $resolvedVersion = Resolve-CatzcBuildVersion -Version $Version -Bundle $Bundle -Silent:$Silent

    $package = $config.package
    $engineArguments = @{
        Version         = $resolvedVersion
        VendorPolicy    = $VendorPolicy
        Destination     = $Destination
        Bundle          = $Bundle
        PackageMetadata = @{
            Guid        = "$($config.module_guid)"
            Author      = "$($package.author)"
            CompanyName = "$($package.company)"
            Description = "$($package.description)"
            Tags        = [string[]] @($package.tags)
            ProjectUri  = "$($package.project_uri)"
            LicenseUri  = "$($package.license_uri)"
        }
        DryRun          = [bool] $DryRun
    }
    if ($Module) {
        $engineArguments.Module = $Module
    }
    if ($ModuleProfile) {
        $engineArguments.ModuleProfile = $ModuleProfile
    }

    # Invoked by name, not by a static call, so the on-demand engine stays off the function-dependency graph.
    # [comment:7](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment7)
    Import-InternalModule Builder
    $engine = 'Invoke-ModuleBuild'
    $result = & $engine @engineArguments

    if (-not $DryRun) {
        # A build with an overridden selection or vendor policy is not the declared bundle, so it goes unmeasured.
        # [comment:8](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment8)
        $isDeclaredBundle = -not ($PSBoundParameters.ContainsKey('Module') -or $PSBoundParameters.ContainsKey('ModuleProfile') -or
            $PSBoundParameters.ContainsKey('VendorPolicy'))
        if ($isDeclaredBundle) {
            Assert-BundleFootprint -Path $result.BuildRoot -Bundle $config.bundles[$Bundle] | Out-Null
        }
        Assert-CatzcBundle -Path $result.BuildRoot
    }

    if (-not $Silent) {
        $verb = if ($DryRun) {
            'Would build'
        }
        else {
            'Built'
        }
        Write-Message "$verb Catzc $Bundle $($result.Version) ($(@($result.Modules).Count) modules, $($result.FileCount) files, types $($result.TypesHash)) -> $(ConvertTo-RepoRelativePath $result.BuildRoot)"
    }

    $result
}
