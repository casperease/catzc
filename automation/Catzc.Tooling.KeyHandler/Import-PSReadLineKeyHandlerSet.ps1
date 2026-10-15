<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.KeyHandler/Import-PSReadLineKeyHandlerSet.ps1
    kind: function
    module: Catzc.Tooling.KeyHandler
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Applies the captured Windows PSReadLine key bindings on Linux, filtered to Linux-supported functions.
.DESCRIPTION
    Linux only: Windows bindings would clobber a Windows session's native handlers, so the apply asserts it.
    [comment:1](/docs/references/automation/catzc-tooling-keyhandler/Import-PSReadLineKeyHandlerSet.ps1.md#comment1)
.PARAMETER DryRun
    Return the classified plan (one record per binding with Key, Function, Supported) and change nothing.
.EXAMPLE
    Import-PSReadLineKeyHandlerSet
.EXAMPLE
    Import-PSReadLineKeyHandlerSet -DryRun | Where-Object { -not $_.Supported }
#>
function Import-PSReadLineKeyHandlerSet {
    [CmdletBinding()]
    param(
        [switch] $DryRun
    )

    $bindings = (Get-Config -Config key-handler-bindings).bindings
    $supported = @((Get-Config -Config key-handler-supported).functions)
    $plan = @(Select-SupportedKeyHandler -Binding $bindings -SupportedFunction $supported)

    if ($DryRun) {
        return $plan
    }

    if (-not $IsLinux) {
        throw 'Import-PSReadLineKeyHandlerSet applies the Windows bindings on Linux only, where PSReadLine otherwise defaults to bash-style editing — running it on Windows would clobber the native handlers. Use -DryRun to preview the plan here.'
    }
    Assert-PsModule 'PSReadLine'

    $applied = 0
    foreach ($entry in $plan) {
        if ($entry.Supported) {
            Set-PSReadLineKeyHandler -Key $entry.Key -Function $entry.Function
            $applied++
        }
        else {
            Write-Verbose "Skipping Linux-unsupported function '$($entry.Function)' for key '$($entry.Key)'"
        }
    }

    Write-Message "Applied $applied of $($plan.Count) captured key bindings ($($plan.Count - $applied) unsupported on Linux)."
}
