<#
---
catzc:
  immutable:
    with_body_sha: "45f5fd229342"
  edges:
    docs: "[Get-EnvironmentPath.ps1.md](docs/references/pwsh/catzc-base-environment/Get-EnvironmentPath.ps1.md)"
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
