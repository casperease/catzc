<#
---
catzc:
  immutable:
    with_body_sha: "9773c30253d5"
    repo_status: locked
    path: importer.ps1
    source: automation/.internal/Catzc.Internal.Importer.psm1
    kind: script
    language: powershell
    filetype: ps1
    generator: automation/Catzc.Base.ModuleSystem/New-Importer.ps1
---
#>

# This shim carries only the importer's outer parameter form and delegates the whole load sequence to
# Invoke-Importer in automation/.internal/Catzc.Internal.Importer.psm1 (the single living copy). It is
# dot-sourced (. ./importer.ps1), so its $global:/$env: effects land in the caller's session.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Invoke-Importer announces RepositoryRoot on its Roots line, the first point a writer is loaded')]
[CmdletBinding()]
param(
    [switch] $ExportPrivates,
    [switch] $AllowWarnings,
    [switch] $DiagnoseLoadTime,
    [switch] $DiagnoseBlocking,
    [switch] $ClearCompiledTypes,
    [switch] $SkipJanitors,
    [switch] $CleanClone,
    [switch] $Bundle
)

Set-StrictMode -Version Latest

# Repository root reference — the one path the shim anchors; the toolset reads it from $env:RepositoryRoot.
$env:RepositoryRoot = $PSScriptRoot

# Load the .internal shared-code loader (the one module imported by path), then the importer overlay, and
# delegate. Catzc.Internal.Importer is import-time orchestration — remove it once the load returns. -Verbose is
# for Invoke-Importer's state-change record, not these imports' per-function detail.
Import-Module (Join-Path $PSScriptRoot 'automation/.internal/Catzc.Internal.Loader.psm1') -Scope Global -Force -Verbose:$false
Import-InternalModule Importer -Force -Verbose:$false
try {
    Invoke-Importer @PSBoundParameters
}
finally {
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue -Verbose:$false
}
