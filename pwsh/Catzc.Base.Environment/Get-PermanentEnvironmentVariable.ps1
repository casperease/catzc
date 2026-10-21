<#
---
catzc:
  immutable:
    with_body_sha: eb3760e28698
  edges:
    docs: "[Get-PermanentEnvironmentVariable.ps1.md](../../docs/references/pwsh/catzc-base-environment/Get-PermanentEnvironmentVariable.ps1.md)"
---
#>

function Get-PermanentEnvironmentVariable {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [ValidateSet('User', 'Machine')]
        [string] $Scope = 'User'
    )

    [System.Environment]::GetEnvironmentVariable($Name, $Scope)
}
