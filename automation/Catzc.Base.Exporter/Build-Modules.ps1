<#
.SYNOPSIS
    Builds the selected modules into one installable, versioned Catzc module — build mode's code root.
.DESCRIPTION
    The public entry to the build.
    [ADR-AUTO-BUNDLE#1](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle1)
    [comment:1](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment1)
.PARAMETER Module
    Module names to build (closure-expanded by the engine), in place of the bundle's profile.
.PARAMETER Bundle
    The bundle to build (an exporter.yml bundles key). Defaults to default_bundle.
.PARAMETER ModuleProfile
    A profiles.yml key whose modules to build (combinable with -Module).
    [comment:2](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment2)
.PARAMETER VendorPolicy
    runtime ships only powershell-yaml; full also ships Pester and PSScriptAnalyzer (needed by a build run, which...
    [comment:3](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment3)
.PARAMETER Version
    'auto' (default) or an explicit numeric MAJOR.MINOR.PATCH — see Resolve-CatzcBuildVersion.
.PARAMETER Destination
    The parent folder the Catzc/<version>/ build is written under.
    [comment:4](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment4)
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
# Uses -DryRun, not ShouldProcess/-WhatIf — see.
# [ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2)
# [comment:5](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment5)
function Build-Modules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Builds a set of modules; the plural is the contract name (ADR-AUTO-BUNDLE#1)')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Module,

        [string] $Bundle = "$((Get-Config -Config exporter).default_bundle)",

        # The bundle's profile, unless -Module names the selection.
        # [comment:6](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment6)
        [string] $ModuleProfile = $(
            $bundles = (Get-Config -Config exporter).bundles
            if (-not $Module -and $bundles.ContainsKey($Bundle)) {
                "$($bundles[$Bundle].profile)"
            }
        ),

        # The bundle's vendor policy.
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

    # The engine is an.internal module, loaded on demand and not part of the post-import command set, so it is...
    # [comment:7](/docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md#comment7)
    Import-InternalModule Builder
    $engine = 'Invoke-ModuleBuild'
    $result = & $engine @engineArguments

    if (-not $DryRun) {
        # The footprint limits describe the bundle as declared.
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
