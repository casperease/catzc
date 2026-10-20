<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.KeyHandler/Import-PSReadLineKeyHandlerSet.ps1
    name: import-ps-read-line-key-handler-set
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.KeyHandler
    moduletype: pwsh-folder
    catzc_bundle: full
    visibility: public
  edges:
    test: pwsh/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1
    docs: "[Import-PSReadLineKeyHandlerSet.ps1.md](docs/references/pwsh/catzc-tooling-keyhandler/Import-PSReadLineKeyHandlerSet.ps1.md)"
---
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
