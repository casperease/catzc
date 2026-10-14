<#
.SYNOPSIS
    Builds the selected modules into one installable, versioned Catzc module — build mode's code root.
.DESCRIPTION
    The public entry to the build ([ADR-AUTO-BUNDLE#1](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle1)).
    It settles the build's inputs from configs/exporter.yml
    (Get-Config -Config exporter), hands them to the engine (Invoke-ModuleBuild in Catzc.Internal.Builder), and
    verifies what the engine wrote with Assert-CatzcBundle. A build is a build of one named bundle — exporter.yml
    bundles.<name>, a release identity with its own profile, version line and vendor policy:

      bundle        -Bundle, else exporter.yml default_bundle
      modules       the bundle's profile; -Module and/or -ModuleProfile override it for an experiment or a test
                    (combinable; the engine closure-expands the union over dependencies.yml)
      version       Resolve-CatzcBuildVersion -Version -Bundle (auto: 6.6.666 on a devbox, the bundle's
                    MAJOR.MINOR plus the commit count in a pipeline)
      vendor policy -VendorPolicy, else the bundle's vendor_policy
      destination   -Destination, else <Get-OutputRoot>/automation/built/<bundle>; the build lands in
                    <Destination>/Catzc/<version>/, so two bundles never share a folder
      package       exporter.yml module_guid + package.* -> the engine's PackageMetadata for Catzc.psd1

    -DryRun returns the engine's plan and writes nothing (so there is nothing to verify). Returns the engine's
    result (BuildRoot, Version, Modules, TypesHash, ContentHash, FileCount, Dirty, DryRun).
.PARAMETER Module
    Module names to build (closure-expanded by the engine), in place of the bundle's profile.
.PARAMETER Bundle
    The bundle to build (an exporter.yml bundles key). Defaults to default_bundle.
.PARAMETER ModuleProfile
    A profiles.yml key whose modules to build (combinable with -Module). Defaults to the bundle's profile when
    -Module is not given.
.PARAMETER VendorPolicy
    runtime ships only powershell-yaml; full also ships Pester and PSScriptAnalyzer (needed by a build run, which runs the
    tests against the build). Defaults to the bundle's vendor_policy.
.PARAMETER Version
    'auto' (default) or an explicit numeric MAJOR.MINOR.PATCH — see Resolve-CatzcBuildVersion.
.PARAMETER Destination
    The parent folder the Catzc/<version>/ build is written under. Defaults to
    <Get-OutputRoot>/automation/built/<bundle>.
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
# Uses -DryRun, not ShouldProcess/-WhatIf — see
# [ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
function Build-Modules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Builds a set of modules; the plural is the contract name (ADR-AUTO-BUNDLE:1)')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Module,

        [string] $Bundle = "$((Get-Config -Config exporter).default_bundle)",

        # The bundle's profile, unless -Module names the selection (resolved below, once the bundle is known).
        [string] $ModuleProfile,

        # The bundle's vendor policy unless given (resolved below).
        [ValidateSet('runtime', 'full')]
        [string] $VendorPolicy,

        [string] $Version = 'auto',

        # <Get-OutputRoot>/automation/built/<bundle> unless given (resolved below).
        [string] $Destination,

        [switch] $DryRun,

        [switch] $Silent
    )

    $config = Get-Config -Config exporter
    Assert-True ($config.bundles.ContainsKey($Bundle)) -ErrorText "Unknown bundle '$Bundle': exporter.yml declares $(@($config.bundles.Keys) -join ', ')."
    $bundleConfig = $config.bundles[$Bundle]
    if (-not $Module -and -not $ModuleProfile) {
        $ModuleProfile = "$($bundleConfig.profile)"
    }
    if (-not $VendorPolicy) {
        $VendorPolicy = "$($bundleConfig.vendor_policy)"
    }
    if (-not $Destination) {
        $Destination = Join-Path (Get-OutputRoot) "automation/built/$Bundle"
    }
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

    # The engine is an .internal module, loaded on demand and not part of the post-import command set, so it is
    # invoked by name — which keeps it off the static function-dependency graph (the pattern the bootstrap
    # helpers use) while still resolving through normal command lookup.
    Import-InternalModule Builder
    $engine = 'Invoke-ModuleBuild'
    $result = & $engine @engineArguments

    if (-not $DryRun) {
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
