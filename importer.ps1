<#
---
catzc:
  immutable:
    with_body_sha: "2f253655e0c6"
    warning: "Do Not Edit, this file is generated"
    repo_status: locked
    path: importer.ps1
    source: pwsh/.internal/Catzc.Internal.Importer.psm1
    role: script
    language: powershell
    filetype: ps1
    generator: pwsh/Catzc.Base.ModuleSystem/New-Importer.ps1
---
#>

# This shim carries only the importer's outer parameter form and delegates the whole load sequence to
# Invoke-Importer in pwsh/.internal/Catzc.Internal.Importer.psm1 (the single living copy). It is
# dot-sourced (. ./importer.ps1), so its $global:/$env: effects land in the caller's session.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Invoke-Importer announces RepositoryRoot on its Roots line, the first point a writer is loaded')]
[CmdletBinding()]
param(
    [switch] $ExportPrivates,
    [switch] $AllowWarnings,
    [switch] $DiagnoseLoadTime,
    [switch] $ClearCompiledTypes,
    [switch] $SkipJanitors,
    [switch] $CleanClone,
    [switch] $Bundle,
    [string[]] $Languages,
    [string[]] $Engines
)

Set-StrictMode -Version Latest

# Repository root reference — the one path the shim anchors; the toolset reads it from $env:RepositoryRoot.
$env:RepositoryRoot = $PSScriptRoot

# Load the .internal shared-code loader (the one module imported by path), then the importer overlay, and
# delegate. Catzc.Internal.Importer is import-time orchestration — remove it once the load returns. -Verbose is
# for Invoke-Importer's state-change record, not these imports' per-function detail.
Import-Module (Join-Path $PSScriptRoot 'pwsh/.internal/Catzc.Internal.Loader.psm1') -Scope Global -Force -Verbose:$false
Import-InternalModule Importer -Force -Verbose:$false
try {
    Invoke-Importer @PSBoundParameters
}
finally {
    Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue -Verbose:$false
}
