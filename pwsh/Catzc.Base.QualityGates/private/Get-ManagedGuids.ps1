<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-ManagedGuids.ps1
    folder: private
    name: get-managed-guids
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-ManagedGuids.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-ManagedGuids.ps1.md)"
---
#>

function Get-ManagedGuids {
    [CmdletBinding()]
    param()

    (Get-Config -Config guids).guids
}
