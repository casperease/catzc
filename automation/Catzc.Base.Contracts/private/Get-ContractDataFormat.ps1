<#
.SYNOPSIS
    Names the data format a contract check parses a file as, from its extension: Json, Yaml, or nothing.
.DESCRIPTION
    The one place the contract checks decide how a file is read:.json is Json;.yml and.yaml are Yaml; any other...
    [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Get-ContractDataFormat.ps1.md#comment1)
.PARAMETER Path
    The file's path; only its extension is read.
.OUTPUTS
    [string] Json or Yaml, or nothing for text.
.EXAMPLE
    Get-ContractDataFormat -Path '.widget/flows/build.yml'   # Yaml
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
