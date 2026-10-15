<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Environment/Get-EnvironmentPath.ps1
    kind: function
    module: Catzc.Base.Environment
    visibility: public
---
#>

<#
.SYNOPSIS
    Reads the PATH environment variable at the scope given (the Windows registry for User/Machine).
.DESCRIPTION
    The one read seam for the persistent PATH, kept thin so tests mock it; User and Machine exist on Windows only.
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
