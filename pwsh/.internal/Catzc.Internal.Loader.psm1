<#
---
catzc:
  immutable:
    with_body_sha: a6627e11cf94
  edges:
    docs: "[Catzc.Internal.Loader.psm1.md](../../docs/references/pwsh/internal/Catzc.Internal.Loader.psm1.md)"
    cites:
      - PDR-ONELIVE
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

# VS Code marks every terminal it opens, the PowerShell extension's own host included; this is the one reader of that mark.
function Test-IsRunningInVsCode {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    $env:TERM_PROGRAM -eq 'vscode'
}

# A host that runs -File, -Command or -EncodedCommand, or runs -NonInteractive, exits when its command ends and never shows a prompt, unless -NoExit keeps it open.
function Test-IsInteractiveHost {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [string[]] $CommandLine = [System.Environment]::GetCommandLineArgs()
    )

    $exits = $false
    $noExit = $false
    foreach ($argument in @($CommandLine | Select-Object -Skip 1)) {
        if (-not ($argument.StartsWith('-') -or $argument.StartsWith('/'))) {
            continue
        }
        $name = $argument.TrimStart('-', '/').Split(':')[0].ToLowerInvariant()
        if ($name.Length -eq 0) {
            continue
        }
        if ($name.Length -ge 3 -and 'noexit'.StartsWith($name)) {
            $noExit = $true
        }
        elseif ($name.Length -ge 4 -and 'noninteractive'.StartsWith($name)) {
            $exits = $true
        }
        elseif ('file'.StartsWith($name) -or 'command'.StartsWith($name) -or 'encodedcommand'.StartsWith($name) -or $name -eq 'ec') {
            # Everything after the script or the command belongs to it, not to the host.
            $exits = $true
            break
        }
    }
    $noExit -or -not $exits
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

Export-ModuleMember -Function Import-InternalModule, Test-IsRunningInPipeline, Test-IsRunningInVsCode, Test-IsInteractiveHost, Enable-DeferredJanitors, Invoke-DeferredJanitorsPrompt
