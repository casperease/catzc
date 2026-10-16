<#
---
catzc:
  derived:
    path: automation/.internal/assets/Import-Catzc.ps1
    kind: asset
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Internal.Assets
  config:
    synopsis: Loads this Catzc build into the session — build mode's entry point.
    description: |-
      The initializer of a built Catzc package ([ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md),
      [ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md)).
      Authored once under automation/.internal/assets/ and copied verbatim into every build by Invoke-ModuleBuild;
      the build's Catzc.psm1 dot-sources it, so `Import-Module Catzc` and dot-sourcing this file set up the same
      session. Dot-source it (. <build>/Import-Catzc.ps1) so its $global:/$env: effects land in the caller's session.

      It sets the two roots — CatzcModulesRoot to this build's folder (the code root), RepositoryRoot to
      -RepositoryRoot, else the value already set, else the current location (the working root, where out/ and
      repo-relative paths resolve) — then runs the one living importer in its -Bundle mode: preferences, the error
      view, vendored modules, the prebuilt types assembly and its accelerators, then every module's prebuilt manifest.
    parameters:
      RepositoryRoot: The working root. Defaults to the RepositoryRoot already set, else the current location.
      AllowWarnings: Set $global:WarningPreference to Continue instead of Stop (warnings do not fail the load).
    examples:
      - '. ./out/automation/built/full/Catzc/6.6.666/Import-Catzc.ps1 -RepositoryRoot C:/projects/work'
---
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Invoke-Importer announces RepositoryRoot and CatzcModulesRoot on its Roots line, the first point a writer is loaded')]
param(
    [string] $RepositoryRoot,

    [switch] $AllowWarnings
)

Set-StrictMode -Version Latest

# The working root: the caller's choice, else what the session already has, else where the caller stands.
if ($RepositoryRoot) {
    $env:RepositoryRoot = [System.IO.Path]::GetFullPath($RepositoryRoot)
}
elseif (-not $env:RepositoryRoot) {
    $env:RepositoryRoot = (Get-Location).ProviderPath
}

# The code root: this build. Invoke-Importer -Bundle honours it instead of deriving <RepositoryRoot>/automation.
$env:CatzcModulesRoot = $PSScriptRoot

# Load the .internal shared-code loader of this build, then the importer overlay, and delegate. The importer
# overlay is import-time orchestration — remove it once the load returns.
Import-Module (Join-Path $PSScriptRoot '.internal/Catzc.Internal.Loader.psm1') -Scope Global -Force
Import-InternalModule Importer -Force
try {
    Invoke-Importer -Bundle -AllowWarnings:$AllowWarnings
}
finally {
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
}
