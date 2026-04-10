<#
.SYNOPSIS
    Writes the PATH environment variable at a given scope (the Windows registry for User/Machine).
.DESCRIPTION
    The single seam through which the PATH helpers (Add-/Remove-PermanentPath, the tooling uninstallers)
    WRITE the persistent PATH, so tests can Mock the registry boundary
    (`Mock Set-EnvironmentPath -ModuleName <module>`) instead of mutating the real machine PATH (which also
    broadcasts WM_SETTINGCHANGE). User/Machine scopes are a Windows concept; callers gate Windows-only use
    behind $IsWindows. This is the deliberately thin, un-mockable I/O boundary, so it has no unit test of its
    own.
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

    [System.Environment]::SetEnvironmentVariable('PATH', $Value, $Scope)
}
