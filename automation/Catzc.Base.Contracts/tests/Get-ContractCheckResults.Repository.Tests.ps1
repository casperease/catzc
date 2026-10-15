<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-REPO-CONTRACT#4
---
#>

# Get-ContractCheckResults runs on the repository's own contracts/ tree: checking every asset of every unit's draft...
# [comment:1](/docs/references/automation/catzc-base-contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1.md#comment1)
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
