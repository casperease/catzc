<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Contracts/tests/Get-Contract.Repository.Tests.ps1
    folder: tests
    name: get-contract-repository-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-contracts/tests/Get-Contract.Repository.Tests.ps1.md
    cites:
      - ADR-REPO-CONTRACT#2
---
#>

Describe 'Get-Contract on the repository' -Tag 'L1', 'integrity', 'ADR-REPO-CONTRACT#2' {
    It 'lists every version of every unit without error' {
        $assets = @(Get-Contract -Version *)
        foreach ($asset in $assets) {
            $asset | Should -BeOfType ([Catzc.Base.Contracts.ContractAsset])
            $asset.AssetPath | Should -BeLike 'contracts/*'
        }
    }
}
