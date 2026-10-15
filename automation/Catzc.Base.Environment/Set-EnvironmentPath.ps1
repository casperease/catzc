<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Environment/Set-EnvironmentPath.ps1
    kind: function
    module: Catzc.Base.Environment
    visibility: public
    adrs:
      - ADR-AUTO-CONSOLE#11
---
#>

<#
.SYNOPSIS
    Writes the PATH environment variable at the scope given (the Windows registry for User/Machine).
.DESCRIPTION
    The one write seam for the persistent PATH, so tests mock it; it announces each change and skips an equal value.
    [ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)
    [comment:1](/docs/references/automation/catzc-base-environment/Set-EnvironmentPath.ps1.md#comment1)
.PARAMETER Value
    The full PATH string to persist.
.PARAMETER Scope
    Which environment scope to write: User (default) or Machine.
.EXAMPLE
    Set-EnvironmentPath 'C:\foo;C:\bar'
#>
function Set-EnvironmentPath {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Thin wrapper around [Environment]::SetEnvironmentVariable — the registry I/O seam that exists for testability; guarding/dry-run is the caller''s concern (see Add-/Remove-PermanentPath).')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyString()]
        [string] $Value,

        [ValidateSet('User', 'Machine')]
        [string] $Scope = 'User'
    )

    $current = [System.Environment]::GetEnvironmentVariable('PATH', $Scope)
    if ($current -eq $Value) {
        return
    }
    $before = @($current -split ';' | Where-Object { $_ })
    $after = @($Value -split ';' | Where-Object { $_ })
    $added = @($after | Where-Object { $_ -notin $before })
    $removed = @($before | Where-Object { $_ -notin $after })

    [System.Environment]::SetEnvironmentVariable('PATH', $Value, $Scope)
    $change = @(
        if ($added) {
            "added '$($added -join "', '")'"
        }
        if ($removed) {
            "removed '$($removed -join "', '")'"
        }
    )
    if (-not $change) {
        $change = @('reordered')
    }
    Write-Message "$Scope PATH: $($change -join '; ')"
}
