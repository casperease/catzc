<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Environment/Get-PermanentEnvironmentVariable.ps1
    name: get-permanent-environment-variable
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
    docs: "[Get-PermanentEnvironmentVariable.ps1.md](docs/references/pwsh/catzc-base-environment/Get-PermanentEnvironmentVariable.ps1.md)"
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
