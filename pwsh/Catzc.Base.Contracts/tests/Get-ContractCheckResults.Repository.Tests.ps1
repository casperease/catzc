<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Get-ContractCheckResults on the repository' -Tag 'L1', 'integrity', 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
    It 'checks every asset of every unit''s draft without error' {
        $assets = @(Get-Contract)
        $results = @(Get-ContractCheckResults)
        $results.Count | Should -Be $assets.Count
        foreach ($result in $results) {
            $result | Should -BeOfType ([Catzc.Base.Contracts.ContractCheckResult])
        }
    }
}
