<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractAssetKind.ps1
    kind: automation-function
    module: Catzc.Base.Contracts
    visibility: private
    relatives:
      test: automation/Catzc.Base.Contracts/tests/Get-ContractAssetKind.Tests.ps1
    adrs:
      - ADR-REPO-CONTRACT#6
  config:
    synopsis: Picks a contract asset's kind from its file name alone.
    description: |-
      The name rule of [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6):
      `<path>.schema.json` is a Schema, `<name>.sample.<ext>` is a Sample, and any other name is a Fragment, or a Presence
      when the asset is empty (an empty fragment requires presence only). The schema suffix is checked first, so a
      schema is never read as a sample.
    parameters:
      Name: The asset's file name (its last path segment).
      IsEmpty: The asset holds nothing but whitespace.
    outputs: '[Catzc.Base.Contracts.ContractAssetKind]'
    examples:
      - 'Get-ContractAssetKind -Name ''build.yml.schema.json''   # Schema'
---
#>

function Get-ContractAssetKind {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAssetKind])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Name,

        [switch] $IsEmpty
    )

    if ($Name -cmatch '^.+\.schema\.json$') {
        return [Catzc.Base.Contracts.ContractAssetKind]::Schema
    }
    if ($Name -cmatch '^.+\.sample\.[^.]+$') {
        return [Catzc.Base.Contracts.ContractAssetKind]::Sample
    }
    if ($IsEmpty) {
        return [Catzc.Base.Contracts.ContractAssetKind]::Presence
    }
    [Catzc.Base.Contracts.ContractAssetKind]::Fragment
}
