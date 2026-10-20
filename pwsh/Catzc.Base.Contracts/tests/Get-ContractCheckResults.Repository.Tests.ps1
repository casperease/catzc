<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1
    folder: tests
    name: get-contract-check-results-repository-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[Get-ContractCheckResults.Repository.Tests.ps1.md](docs/references/pwsh/catzc-base-contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1.md)"
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
