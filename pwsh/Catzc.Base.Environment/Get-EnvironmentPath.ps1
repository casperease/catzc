<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-environment/Get-EnvironmentPath.ps1.md"
  warning: "Generated Header"
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
