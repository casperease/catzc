<#
---
catzc:
  derived:
    path: automation/.internal/Catzc.Internal.Loader.psm1
    kind: internal-module
---
#>

# Never removed with Bootstrap: it stays loaded so a post-import cover function can still ensure a shared module.
# [comment:1](/docs/references/automation/internal/Catzc.Internal.Loader.psm1.md#comment1)

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

$script:internalRoot = $PSScriptRoot

function Import-InternalModule {
    <#
    .SYNOPSIS
        Loads a .internal shared module once into the global session (idempotent).
    .DESCRIPTION
        Idempotent, so a hot-path cover function pays nothing; only the importer's first load passes -Force.
        [comment:2](/docs/references/automation/internal/Catzc.Internal.Loader.psm1.md#comment2)
    .PARAMETER Name
        The bare area name of the shared module — 'Types' resolves to .internal/Catzc.Internal.Types.psm1.
    .PARAMETER Force
        Reload even when the module is already loaded (the importer's initial load uses this).
    .EXAMPLE
        Import-InternalModule Types
        Ensures Catzc.Internal.Types is loaded, then the caller can use Get-CombinedTypeHash.
    #>
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
    <#
    .SYNOPSIS
        Returns true if the current session is running inside a CI/CD pipeline.
    .DESCRIPTION
        It lives in the always-loaded loader so the bootstrap pre-pass and every module ask the same function.
        [comment:3](/docs/references/automation/internal/Catzc.Internal.Loader.psm1.md#comment3)
    .EXAMPLE
        Test-IsRunningInPipeline
    .EXAMPLE
        if (Test-IsRunningInPipeline) { Write-Verbose 'Running in CI' }
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    # Azure DevOps agents set TF_BUILD, GitHub Actions runners set GITHUB_ACTIONS; either one means a pipeline.
    # [comment:4](/docs/references/automation/internal/Catzc.Internal.Loader.psm1.md#comment4)
    [bool]$env:TF_BUILD -or [bool]$env:GITHUB_ACTIONS
}

Export-ModuleMember -Function Import-InternalModule, Test-IsRunningInPipeline
