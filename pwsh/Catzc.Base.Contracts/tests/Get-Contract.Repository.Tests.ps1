<#
---
catzc:
  immutable:
    with_body_sha: c3cce2a538af
  edges:
    docs: "[Get-Contract.Repository.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-contracts/tests/Get-Contract.Repository.Tests.ps1.md)"
    cites:
      - ADR-REPO-CONTRACT-LAYOUT
---
#>

Describe 'Get-Contract on the repository' -Tag 'L1', 'integrity', 'ADR-REPO-CONTRACT-LAYOUT' {
    It 'lists every version of every unit without error' {
        $assets = @(Get-Contract -Version *)
        foreach ($asset in $assets) {
            $asset | Should -BeOfType ([Catzc.Base.Contracts.ContractAsset])
            $asset.AssetPath | Should -BeLike 'contracts/*'
        }
    }
}
