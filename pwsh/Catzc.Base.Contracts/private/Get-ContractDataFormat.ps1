<#
---
catzc:
  immutable:
    with_body_sha: "33738b64b5dd"
  edges:
    docs: "[Get-ContractDataFormat.ps1.md](../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractDataFormat.ps1.md)"
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
