<#
.SYNOPSIS
    Reads the PATH environment variable at a given scope (the Windows registry for User/Machine).
.DESCRIPTION
    The single seam through which the PATH helpers (Add-/Remove-PermanentPath, Sync-SessionPath, the tooling
    uninstallers) READ the persistent PATH, so tests can Mock the registry boundary
    (`Mock Get-EnvironmentPath -ModuleName <module>`) instead of reading the real machine. Paired with
    Set-EnvironmentPath for writes. User/Machine scopes are a Windows concept; callers gate Windows-only use
    behind $IsWindows. This is the deliberately thin, un-mockable I/O boundary, so it has no unit test of its
    own.
.PARAMETER Scope
    Which environment scope to read: User (default), Machine, or Process.
.EXAMPLE
    Get-EnvironmentPath                 # User-scope PATH
.EXAMPLE
    Get-EnvironmentPath -Scope Machine
#>
function Get-EnvironmentPath {
    [OutputType([string])]
    param(
        [ValidateSet('User', 'Machine', 'Process')]
        [string] $Scope = 'User'
    )

    [System.Environment]::GetEnvironmentVariable('PATH', $Scope)
}
