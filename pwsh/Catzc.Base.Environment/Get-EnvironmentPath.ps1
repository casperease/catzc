<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-environment/Get-EnvironmentPath.ps1.md"
  header: "generated"
---
#>

function Get-EnvironmentPath {
    [OutputType([string])]
    param(
        [ValidateSet('User', 'Machine', 'Process')]
        [string] $Scope = 'User'
    )

    [System.Environment]::GetEnvironmentVariable('PATH', $Scope)
}
