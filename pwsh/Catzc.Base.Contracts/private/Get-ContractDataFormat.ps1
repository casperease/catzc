<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractDataFormat.ps1.md"
  warning: "Generated Header"
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
