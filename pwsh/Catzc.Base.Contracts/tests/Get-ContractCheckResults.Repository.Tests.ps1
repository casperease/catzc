<#
---
catzc:
  immutable:
    with_body_sha: "5f02df4e92bd"
  edges:
    docs: "[Get-ContractCheckResults.Repository.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-PROVENBYTESTS
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
