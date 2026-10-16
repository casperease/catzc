<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Exporter/Export-Catzc.ps1
    name: export-catzc
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Exporter
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Exporter/tests/Export-Catzc.Tests.ps1
    cites:
      - ADR-AUTO-BUNDLE#6
  config:
    synopsis: |-
      Exports catzc — builds it (Build-Modules), then installs it beside a working root or packs it for
      Install-PSResource.
    description: |-
      The top-level export ([ADR-AUTO-BUNDLE#6](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle6)). It builds
      with Build-Modules (exporter.yml defaults; the build
      parameters pass through) and delivers the build:
        - disk (default): the two-part install to -Root (Install-Catzc) — the build under <Root>/.vendor/Catzc/<version>/
          and a root importer.ps1 that enters it with <Root> as the working root;
        - nuget: the build folder packed with Compress-PSResource into <Get-OutputRoot>/automation/packages/, for a
          client to register as a local PSResource repository and Install-PSResource Catzc. Publishing beyond the
          local disk is the release workflow's act, never this function's.
    parameters:
      Root: The destination working root of a disk export (where the root importer.ps1 goes).
      To: disk (default) or nuget.
      Bundle: The bundle to build (an exporter.yml bundles key; see Build-Modules). Defaults to default_bundle.
      Module: Module names to build (see Build-Modules).
      ModuleProfile: A profiles.yml key to build (see Build-Modules).
      VendorPolicy: runtime | full (see Build-Modules).
      Version: '''auto'' (default) or an explicit MAJOR.MINOR.PATCH (see Resolve-CatzcBuildVersion).'
      Force: Re-copy the build on a disk install even when the target is already current.
      Silent: Suppress the build, install and pack summaries.
    examples:
      - 'Export-Catzc -Root C:\work\project        # build + install into C:\work\project\.vendor, importer at the root'
      - 'Export-Catzc -To nuget                     # build + pack into out/automation/packages/'
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
        $package = New-CatzcNuGetPackage -Source $built.BuildRoot -DestinationPath (Join-Path (Get-OutputRoot -EnsureExists) 'automation/packages')
        if (-not $Silent) {
            Write-Message "Packed Catzc $($package.Version) ($($package.FunctionCount) functions) -> $(ConvertTo-RepoRelativePath $package.NuPkg)"
        }
        return $package
    }

    Install-Catzc -Root $Root -Source $built.BuildRoot -Force:$Force -Silent:$Silent
}
