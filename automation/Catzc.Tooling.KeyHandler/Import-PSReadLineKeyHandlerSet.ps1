<#
.SYNOPSIS
    Applies the captured Windows PSReadLine key bindings on Linux, filtered to Linux-supported functions.
.DESCRIPTION
    PSReadLine on Linux defaults to bash-style editing; this replicates the Windows editing experience by
    applying the captured bindings (configs/key-handler-bindings.yml) through Set-PSReadLineKeyHandler,
    skipping any function the Linux build does not support (configs/key-handler-supported.yml) so an
    unsupported binding is dropped rather than throwing. Runs on Linux only — applying Windows bindings on a
    Windows session would clobber its native handlers, so the real apply path asserts $IsLinux. Use -DryRun
    to see the plan (which bindings apply, which are skipped) on any platform without changing the session.
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

    $bindings = Get-Config -Config key-handler-bindings
    $supported = @((Get-Config -Config key-handler-supported)['functions'])
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
