<#
---
catzc:
  derived:
    path: automation/.internal/Catzc.Internal.Loader.psm1
    kind: internal-module
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
