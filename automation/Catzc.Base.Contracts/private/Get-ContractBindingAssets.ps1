<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/private/Get-ContractBindingAssets.ps1
    kind: automation-function
    module: Catzc.Base.Contracts
    visibility: private
    adrs:
      - ADR-REPO-CONTRACT#{3,4}
  config:
    synopsis: |-
      Lists the contract assets the repository must honour now: every asset of the current version folder, and the
      provided assets of every released version folder still in the tree.
    description: |-
      Contracts are binding ([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4)) on two
      sets of assets:
      - every asset, in both directions, of each unit's current version folder, -Version;
      - the provided assets of every other released version folder, any version but the draft 0.0.0. Released folders
        are the pin record: a released provided contract is kept while a consumer pins it, and retiring it means
        deleting its folder ([ADR-REPO-CONTRACT#3](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract3)).
      The depended-on assets of an older released folder are not listed: a depended-on contract follows its outside
      platform, so only the current version's expectation binds
      ([ADR-REPO-CONTRACT#3](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract3)).

      When -Version names a release, the draft 0.0.0 is not listed. A contracts/ tree that does not list throws, as
      Get-Contract does.
    parameters:
      Version: The current version folder of every unit, <major>.<minor>.<patch>.
      RepositoryRoot: The repository root that holds contracts/.
    outputs: '[Catzc.Base.Contracts.ContractAsset[]] In Get-Contract''s ordinal order of unit, version, module, then path.'
    examples:
      - Get-ContractBindingAssets -Version 0.0.0 -RepositoryRoot $root
---
#>

function Get-ContractBindingAssets {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Contracts.ContractAsset[]])]
    param(
        [Parameter(Mandatory)]
        [ValidatePattern('^[0-9]+\.[0-9]+\.[0-9]+$')]
        [string] $Version,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    foreach ($asset in Get-Contract -Version '*' -RepositoryRoot $RepositoryRoot) {
        if ($asset.Version -ceq $Version) {
            $asset
        }
        elseif ($asset.Version -cne '0.0.0' -and $asset.Direction -eq [Catzc.Base.Contracts.ContractDirection]::Provided) {
            $asset
        }
    }
}
