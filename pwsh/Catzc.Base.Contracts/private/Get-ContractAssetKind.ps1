<#
---
catzc:
  immutable:
    with_body_sha: "346670f69ce9"
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/Get-ContractAssetKind.Tests.ps1
    docs: "[Get-ContractAssetKind.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractAssetKind.ps1.md)"
    cites:
      - ADR-REPO-CMDCONTRACT-COMMANDCONTRACT
      - ADR-REPO-CONTRACT-CONTRACTASSET
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
