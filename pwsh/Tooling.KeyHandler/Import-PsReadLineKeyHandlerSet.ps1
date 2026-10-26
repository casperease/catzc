function Import-PsReadLineKeyHandlerSet {
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
        throw 'Import-PsReadLineKeyHandlerSet applies the Windows bindings on Linux only, where PSReadLine otherwise defaults to bash-style editing — running it on Windows would clobber the native handlers. Use -DryRun to preview the plan here.'
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
