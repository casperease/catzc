<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1
    kind: pester-test
---
#>

# Get-ContractCheckResults runs on the repository's own contracts/ tree
# ([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4)): checking every asset of every
# unit's draft returns one result per asset, without error. That every asset passes is the contracts quality gate's work.
Describe 'Get-ContractCheckResults on the repository' -Tag 'L1', 'integrity', 'ADR-REPO-CONTRACT#4' {
    It 'checks every asset of every unit''s draft without error' {
        $assets = @(Get-Contract)
        $results = @(Get-ContractCheckResults)
        $results.Count | Should -Be $assets.Count
        foreach ($result in $results) {
            $result | Should -BeOfType ([Catzc.Base.Contracts.ContractCheckResult])
        }
    }
}
