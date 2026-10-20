<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/private/Get-ContractDataFormat.ps1
    folder: private
    name: get-contract-data-format
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    docs: "[Get-ContractDataFormat.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractDataFormat.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-CONTRACTASSET
---
#>

function Get-ContractDataFormat {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    switch -CaseSensitive ([System.IO.Path]::GetExtension($Path)) {
        '.json' {
            'Json'
        }
        '.yml' {
            'Yaml'
        }
        '.yaml' {
            'Yaml'
        }
    }
}
