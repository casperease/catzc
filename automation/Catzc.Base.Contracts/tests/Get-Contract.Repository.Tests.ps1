<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/Get-Contract.Repository.Tests.ps1
    kind: pester-test
---
#>

# Get-Contract runs on the repository's own contracts/ tree
# ([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)): the shipped layout lists without
# error, and every asset it lists carries a kind, a direction, and paths in communication form.
Describe 'Get-Contract on the repository' -Tag 'L1', 'integrity', 'ADR-REPO-CONTRACT#2' {
    It 'lists every version of every unit without error' {
        $assets = @(Get-Contract -Version *)
        foreach ($asset in $assets) {
            $asset | Should -BeOfType ([Catzc.Base.Contracts.ContractAsset])
            $asset.AssetPath | Should -BeLike 'contracts/*'
        }
    }
}
