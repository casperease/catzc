<#
.SYNOPSIS
    Reads the PATH environment variable at the scope given (the Windows registry for User/Machine).
.DESCRIPTION
    The single seam through which the PATH helpers (Add-/Remove-PermanentPath, Sync-SessionPath, the tooling...
    [comment:1](/docs/references/automation/catzc-base-environment/Get-EnvironmentPath.ps1.md#comment1)
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
