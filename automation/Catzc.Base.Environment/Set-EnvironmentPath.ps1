<#
.SYNOPSIS
    Writes the PATH environment variable at the scope given (the Windows registry for User/Machine).
.DESCRIPTION
    The single seam through which the PATH helpers (Add-/Remove-PermanentPath, the tooling uninstallers)
    WRITE the persistent PATH, so tests can Mock the registry boundary
    (`Mock Set-EnvironmentPath -ModuleName <module>`) instead of mutating the real machine PATH (which also
    broadcasts WM_SETTINGCHANGE). User/Machine scopes are a Windows concept; callers guard Windows-only use
    with $IsWindows. This is the deliberately thin, un-mockable I/O boundary, so it has no unit test of its
    own.

    Because every persistent PATH write passes through here, this is also where it is announced
    ([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)): one line
    names the scope and the entries added and removed. Writing the value the
    scope already holds is a no-op, so it neither writes nor announces.
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
