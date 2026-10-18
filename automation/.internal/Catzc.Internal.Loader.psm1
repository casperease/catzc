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

$script:deferredJanitors = $null

# The console session's janitors run once the first prompt has shown: the first render is untouched, the second runs the action and restores the prompt.
function Enable-DeferredJanitors {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Installs an in-memory prompt hook for this session; nothing outside the session changes')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'The hook is session state the importer records in its load record; the janitors announce their own changes when they run')]
    [CmdletBinding()]
    param(
        [scriptblock] $Action,

        [switch] $ShowStateChanges
    )

    if (-not $Action) {
        $show = [bool] $ShowStateChanges
        $Action = {
            Import-InternalModule Importer -Force
            try {
                & (Get-Module Catzc.Internal.Importer) { param($showStateChanges) Invoke-ImporterJanitors -ShowStateChanges:$showStateChanges } $show
            }
            finally {
                Remove-Module Catzc.Internal.Importer -Force -ErrorAction SilentlyContinue
            }
        }.GetNewClosure()
    }

    $previous = $null
    $existing = Get-Command prompt -CommandType Function -ErrorAction Ignore
    if ($existing) {
        $previous = $existing.ScriptBlock
    }
    $script:deferredJanitors = @{ Action = $Action; Previous = $previous; Rendered = 0 }
    Set-Item -Path function:global:prompt -Value { Invoke-DeferredJanitorsPrompt }
}

function Invoke-DeferredJanitorsPrompt {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Restores the prompt the hook replaced; session state only')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('Measure-AnnounceStateChange', '', Justification = 'Undoes the hook Enable-DeferredJanitors installed; the janitors announce their own changes')]
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $state = $script:deferredJanitors
    if (-not $state) {
        return "PS $($ExecutionContext.SessionState.Path.CurrentLocation)$('>' * ($NestedPromptLevel + 1)) "
    }
    $state.Rendered++
    if ($state.Rendered -ge 2) {
        # Restore first, so a janitor that throws leaves a working prompt behind.
        if ($state.Previous) {
            Set-Item -Path function:global:prompt -Value $state.Previous
        }
        else {
            Remove-Item -Path function:global:prompt -ErrorAction Ignore
        }
        $script:deferredJanitors = $null
        & $state.Action
    }
    if ($state.Previous) {
        & $state.Previous
    }
    else {
        "PS $($ExecutionContext.SessionState.Path.CurrentLocation)$('>' * ($NestedPromptLevel + 1)) "
    }
}

Export-ModuleMember -Function Import-InternalModule, Test-IsRunningInPipeline, Enable-DeferredJanitors, Invoke-DeferredJanitorsPrompt
