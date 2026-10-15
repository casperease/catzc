<#
.SYNOPSIS
    Picks a contract asset's kind from its file name alone.
.DESCRIPTION
    The name rule of: `<path>.schema.json` is a Schema, `<name>.sample.<ext>` is a Sample, and any other name is a...
    [ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)
    [comment:1](/docs/references/automation/catzc-base-contracts/private/Get-ContractAssetKind.ps1.md#comment1)
.PARAMETER Name
    The asset's file name (its last path segment).
.PARAMETER IsEmpty
    The asset holds nothing but whitespace.
.OUTPUTS
    [Catzc.Base.Contracts.ContractAssetKind]
.EXAMPLE
    Get-ContractAssetKind -Name 'build.yml.schema.json'   # Schema
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
