<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Exporter/Build-Modules.ps1
    name: build-modules
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    module: Catzc.Base.Exporter
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-exporter/Build-Modules.ps1.md
      test: automation/Catzc.Base.Exporter/tests/Build-Modules.Tests.ps1
    adrs:
      - ADR-AUTO-BUNDLE#1
      - ADR-AUTO-DRYRUN#2
  config:
    synopsis: Builds the selected modules into one installable, versioned Catzc module — build mode's code root.
    description: |-
      The public entry to the build ([ADR-AUTO-BUNDLE#1](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle1)).
      It settles the build's inputs from configs/exporter.yml
      (Get-Config -Config exporter), hands them to the engine (Invoke-ModuleBuild in Catzc.Internal.Builder), and
      verifies what the engine wrote: against the bundle's footprint limits (max_files, max_bytes, when it states them;
      a build that overrides the selection or vendor policy is an experiment, not the bundle, and is not measured),
      then with Assert-CatzcBundle. A build is a build of one named bundle — exporter.yml
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
    parameters:
      Module: Module names to build (closure-expanded by the engine), in place of the bundle's profile.
      Bundle: The bundle to build (an exporter.yml bundles key). Defaults to default_bundle.
      ModuleProfile: |-
        A profiles.yml key whose modules to build (combinable with -Module). Defaults to the bundle's profile when
        -Module is not given.
        The bundle's profile, unless -Module names the selection. Read only when the bundle exists; an unknown
        bundle is rejected in the body with the list of bundles.
      VendorPolicy: |-
        The bundle's vendor policy.
        runtime ships only powershell-yaml; full also ships Pester and PSScriptAnalyzer (needed by a build run, which runs the
        tests against the build). Defaults to the bundle's vendor_policy.
      Version: '''auto'' (default) or an explicit numeric MAJOR.MINOR.PATCH — see Resolve-CatzcBuildVersion.'
      Destination: |-
        The parent folder the Catzc/<version>/ build is written under. Defaults to
        <Get-OutputRoot>/automation/built/<bundle>.
      DryRun: Return the build plan without writing anything.
      Silent: Suppress the local-version notice and the summary line.
    examples:
      - Build-Modules
      - Build-Modules -Bundle azure
      - Build-Modules Catzc.Base.Config -DryRun
---
#>

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

    Import-InternalModule Builder
    $engine = 'Invoke-ModuleBuild'
    $result = & $engine @engineArguments

    if (-not $DryRun) {
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
