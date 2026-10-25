<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/private/Get-ContractAssetKind.ps1.md"
  header: "generated"
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

    if ($Name -cmatch '^.+\.command\.yml$') {
        return [Catzc.Base.Contracts.ContractAssetKind]::Command
    }
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
