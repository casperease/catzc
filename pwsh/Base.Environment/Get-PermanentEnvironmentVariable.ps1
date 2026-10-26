<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-environment/Get-PermanentEnvironmentVariable.ps1.md"
  header: "generated"
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
