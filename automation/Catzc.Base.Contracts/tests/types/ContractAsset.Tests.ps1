<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/types/ContractAsset.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-contracts/tests/types/ContractAsset.Tests.ps1.md
      source: automation/Catzc.Base.Contracts/types/ContractAsset.cs
    adrs:
      - ADR-AUTO-PATH#1
      - ADR-AUTO-PATH#2
      - ADR-REPO-CONTRACT#2
      - ADR-REPO-CONTRACT#6
---
#>

Describe 'ContractAsset' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fragment = [Catzc.Base.Contracts.ContractAssetKind]::Fragment
        $script:dependedOn = [Catzc.Base.Contracts.ContractDirection]::DependedOn
    }

    It 'composes the asset path from its unit, version, module and path' -Tag 'ADR-REPO-CONTRACT#2' {
        $asset = [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.0.0', 'Catzc.Widget', 'docs/gadget.md', $script:fragment, 'docs/gadget.md', $script:dependedOn, $false)
        $asset.AssetPath | Should -Be 'contracts/widget/0.0.0/Catzc.Widget/docs/gadget.md'
        "$asset" | Should -Be 'ContractAsset { AssetPath = contracts/widget/0.0.0/Catzc.Widget/docs/gadget.md, Kind = Fragment, Direction = DependedOn, Target = docs/gadget.md }'
    }

    It 'rejects the path <Value>, which is not in communication form' -Tag 'ADR-AUTO-PATH#1' -ForEach @(
        @{ Value = 'docs\gadget.md' }
        @{ Value = '/docs/gadget.md' }
        @{ Value = './gadget.md' }
        @{ Value = 'docs/../gadget.md' }
        @{ Value = 'docs//gadget.md' }
        @{ Value = 'C:/gadget.md' }
        @{ Value = '' }
    ) {
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.0.0', 'Catzc.Widget', $Value, $script:fragment, 'gadget.md', $script:dependedOn, $false) } |
            Should -Throw '*contract asset*'
    }

    It 'rejects a version that is not a three-part version, and a unit or module of more than one folder' -Tag 'ADR-REPO-CONTRACT#2' {
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', 'v1', 'Catzc.Widget', 'a.md', $script:fragment, 'a.md', $script:dependedOn, $false) } | Should -Throw "*version 'v1'*"
        { [Catzc.Base.Contracts.ContractAsset]::new('widget/gadget', '0.0.0', 'Catzc.Widget', 'a.md', $script:fragment, 'a.md', $script:dependedOn, $false) } | Should -Throw '*one folder name*'
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.0.0', 'Catzc/Widget', 'a.md', $script:fragment, 'a.md', $script:dependedOn, $false) } | Should -Throw '*one folder name*'
    }

    It 'gives a sample payload no target, and every other kind one' -Tag 'ADR-REPO-CONTRACT#6' {
        $sample = [Catzc.Base.Contracts.ContractAssetKind]::Sample
        $provided = [Catzc.Base.Contracts.ContractDirection]::Provided
        [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.0.0', 'Catzc.Widget', 'g.sample.json', $sample, $null, $provided, $false).Target | Should -BeNullOrEmpty
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.0.0', 'Catzc.Widget', 'g.sample.json', $sample, 'g.json', $provided, $false) } | Should -Throw '*has no target*'
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.0.0', 'Catzc.Widget', 'a.md', $script:fragment, $null, $script:dependedOn, $false) } | Should -Throw "*target ''*"
    }
}
