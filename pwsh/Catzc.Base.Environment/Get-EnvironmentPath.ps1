<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Environment/Get-EnvironmentPath.ps1
    name: get-environment-path
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Environment
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
