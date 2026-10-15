<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/Get-Contract.Repository.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-REPO-CONTRACT#2
---
#>

# Get-Contract runs on the repository's own contracts/ tree: the shipped layout lists without error, and every asset...
# [comment:1](/docs/references/automation/catzc-base-contracts/tests/Get-Contract.Repository.Tests.ps1.md#comment1)
Describe 'Get-Contract on the repository' -Tag 'L1', 'integrity', 'ADR-REPO-CONTRACT#2' {
    It 'lists every version of every unit without error' {
        $assets = @(Get-Contract -Version *)
        foreach ($asset in $assets) {
            $asset | Should -BeOfType ([Catzc.Base.Contracts.ContractAsset])
            $asset.AssetPath | Should -BeLike 'contracts/*'
        }
    }
}
