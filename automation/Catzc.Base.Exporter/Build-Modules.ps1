<#
.SYNOPSIS
    Builds the selected modules into one installable, versioned Catzc module — build mode's code root.
.DESCRIPTION
    The public entry to the build ([ADR-AUTO-BUNDLE#1](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle1)).
    It settles the build's inputs from configs/exporter.yml
    (Get-Config -Config exporter), hands them to the engine (Invoke-ModuleBuild in Catzc.Internal.Builder), and
    verifies what the engine wrote with Assert-CatzcBundle:

      modules       -Module and/or -ModuleProfile (combinable; the engine closure-expands the union over
                    dependencies.yml); neither -> exporter.yml default_profile
      version       Resolve-CatzcBuildVersion -Version (auto: 6.6.666 on a devbox, calculated in a pipeline)
      vendor policy -VendorPolicy, else exporter.yml vendor_policy
      destination   -Destination, else <Get-OutputRoot>/automation/build; the build lands in
                    <Destination>/Catzc/<version>/
      package       exporter.yml module_guid + package.* -> the engine's PackageMetadata for Catzc.psd1

    -DryRun returns the engine's plan and writes nothing (so there is nothing to verify). Returns the engine's
    result (BuildRoot, Version, Modules, TypesHash, ContentHash, FileCount, DryRun).
.PARAMETER Module
    Module names to build (closure-expanded by the engine).
.PARAMETER ModuleProfile
    A profiles.yml key whose modules to build (combinable with -Module).
.PARAMETER VendorPolicy
    runtime ships only powershell-yaml; full also ships Pester and PSScriptAnalyzer (needed to run the test suite
    against the build).
.PARAMETER Version
    'auto' (default) or an explicit numeric MAJOR.MINOR.PATCH — see Resolve-CatzcBuildVersion.
.PARAMETER Destination
    The parent folder the Catzc/<version>/ build is written under.
.PARAMETER DryRun
    Return the build plan without writing anything.
.PARAMETER Silent
    Suppress the local-version notice and the summary line.
.EXAMPLE
    Build-Modules
.EXAMPLE
    Build-Modules -ModuleProfile full -VendorPolicy full
.EXAMPLE
    Build-Modules Catzc.Base.Config -DryRun
#>
# Uses -DryRun, not ShouldProcess/-WhatIf — see
# [ADR-AUTO-DRYRUN#2](/docs/adr/automation/powershell/prefer-dryrun-over-shouldprocess.md#rule-adr-auto-dryrun2).
function Build-Modules {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Builds a set of modules; the plural is the contract name (ADR-AUTO-BUNDLE:1)')]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Position = 0)]
        [string[]] $Module,

        [string] $ModuleProfile,

        [ValidateSet('runtime', 'full')]
        [string] $VendorPolicy,

        [string] $Version = 'auto',

        [string] $Destination,

        [switch] $DryRun,

        [switch] $Silent
    )

    $config = Get-Config -Config exporter
    if (-not $Module -and -not $ModuleProfile) {
        $ModuleProfile = "$($config.default_profile)"
    }
    if (-not $VendorPolicy) {
        $VendorPolicy = "$($config.vendor_policy)"
    }
    if (-not $Destination) {
        $Destination = Join-Path (Get-OutputRoot) 'automation/build'
    }
    $resolvedVersion = Resolve-CatzcBuildVersion -Version $Version -Silent:$Silent

    $package = $config.package
    $engineArguments = @{
        Version         = $resolvedVersion
        VendorPolicy    = $VendorPolicy
        Destination     = $Destination
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
        Write-Message "$verb Catzc $($result.Version) ($(@($result.Modules).Count) modules, $($result.FileCount) files, types $($result.TypesHash)) -> $(ConvertTo-RepoRelativePath $result.BuildRoot)"
    }

    $result
}
