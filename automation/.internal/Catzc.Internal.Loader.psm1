# Catzc.Internal.Loader — the always-loaded entry point for.internal shared code.
# [ADR-PRIN-ONELIVE](/docs/adr/principles/one-living-version.md)
# [comment:1](/docs/references/automation/internal/Catzc.Internal.Loader.psm1.md#comment1)

Set-StrictMode -Version Latest   # this module's scope: every function here runs strict

$script:internalRoot = $PSScriptRoot

function Import-InternalModule {
    <#
    .SYNOPSIS
        Loads a .internal shared module once into the global session (idempotent).
    .DESCRIPTION
        Trusts the importer has already cleared PSModulePath and set the error preferences, so it just imports the...
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
        The one pipeline-detection function.
        [ADR-FLOW-CD-DETECT#1](/docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect1)
        [comment:3](/docs/references/automation/internal/Catzc.Internal.Loader.psm1.md#comment3)
    .EXAMPLE
        Test-IsRunningInPipeline
    .EXAMPLE
        if (Test-IsRunningInPipeline) { Write-Verbose 'Running in CI' }
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    # Azure DevOps sets TF_BUILD=True GitHub Actions sets GITHUB_ACTIONS=true
    # [comment:4](/docs/references/automation/internal/Catzc.Internal.Loader.psm1.md#comment4)
    [bool]$env:TF_BUILD -or [bool]$env:GITHUB_ACTIONS
}

Export-ModuleMember -Function Import-InternalModule, Test-IsRunningInPipeline
