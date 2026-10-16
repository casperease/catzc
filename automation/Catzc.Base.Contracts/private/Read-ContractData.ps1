<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/private/Read-ContractData.ps1
    folder: private
    name: read-contract-data
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-contracts/private/Read-ContractData.ps1.md
    cites:
      - ADR-REPO-CONTRACT#6
  config:
    synopsis: Reads and parses a JSON or YAML file for a contract check, throwing a finding-ready message when it cannot.
    description: |-
      Parses by the format Get-ContractDataFormat names: Json with ConvertFrom-Json -AsHashtable, Yaml with the vendored
      ConvertFrom-Yaml -Ordered, the first document only. The result is the value model ContractValue reads (objects as
      dictionaries, arrays as lists, scalars as CLR values, an empty document as null), and an array is returned whole,
      never enumerated. A file of any other format, and a file that does not parse, throw a message naming the file,
      which a contract check reports as its finding
      ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)).
    parameters:
      RepositoryRoot: The repository root the path is relative to.
      Path: The file, repository-relative and '/'-separated.
    outputs: '[object] The parsed document.'
    examples:
      - '$gadget = Read-ContractData -RepositoryRoot $root -Path ''.widget/gadget.yml'''
---
#>

function Read-ContractData {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $Path
    )

    $format = Get-ContractDataFormat -Path $Path
    if (-not $format) {
        throw "'$Path' is neither JSON nor YAML (.json, .yml, .yaml), so it cannot be parsed."
    }
    $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $Path))
    try {
        if ($format -ceq 'Json') {
            $data = $text | ConvertFrom-Json -AsHashtable -NoEnumerate -Depth 100
        }
        else {
            $data = $text | ConvertFrom-Yaml -Ordered
        }
    }
    catch {
        throw "'$Path' does not parse as ${format}: $($_.Exception.Message)"
    }
    $PSCmdlet.WriteObject($data, $false)
}
