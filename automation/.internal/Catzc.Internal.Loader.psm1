<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/.internal/Catzc.Internal.Loader.psm1
    name: catzc-internal-loader
    filetype: psm1
    kind: module
    subkind: internal
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Internal.Loader
    moduletype: pwsh-psm1
    catzc_bundle: minimal
  edges:
    page: docs/references/automation/internal/Catzc.Internal.Loader.psm1.md
---
#>

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

$script:internalRoot = $PSScriptRoot

function Import-InternalModule {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'The loader runs before any writer exists; Invoke-Importer announces the internal modules it loads (its Roots line), and a post-import call is the idempotent no-op')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [switch] $Force
    )

    $moduleName = "Catzc.Internal.$Name"
    if (-not $Force -and (Get-Module $moduleName)) {
        return
    }
    Import-Module (Join-Path $script:internalRoot "$moduleName.psm1") -Scope Global -Force
}

function Test-IsRunningInPipeline {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    [bool]$env:TF_BUILD -or [bool]$env:GITHUB_ACTIONS
}

Export-ModuleMember -Function Import-InternalModule, Test-IsRunningInPipeline
