<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractDataFormat.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-REPO-CONTRACT#6
  config:
    synopsis: 'Names the data format a contract check parses a file as, from its extension: Json, Yaml, or nothing.'
    description: |-
      The one place the contract checks decide how a file is read
      ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): .json is Json; .yml and .yaml
      are Yaml; any other extension is text, and gives nothing. A fragment of a Json or Yaml file is compared as a key subset,
      of any other file as lines; a schema or a sample payload must be Json or Yaml. The extension compares ordinally.
    parameters:
      Path: The file's path; only its extension is read.
    outputs: '[string] Json or Yaml, or nothing for text.'
    examples:
      - 'Get-ContractDataFormat -Path ''.widget/flows/build.yml''   # Yaml'
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
