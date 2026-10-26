Describe 'ContractAsset' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:fragment = [Catzc.Base.Contracts.ContractAssetKind]::Fragment
        $script:dependedOn = [Catzc.Base.Contracts.ContractDirection]::DependedOn
    }

    It 'composes the asset path from its root, version, group and path' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
        $asset = [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', 'gadgets', 'gadget.md', $script:fragment,
            'docs/gadget.md', $script:dependedOn)
        $asset.AssetPath | Should -Be 'contracts/widget/0.1.0/gadgets/gadget.md'
        $asset.Key | Should -Be 'gadgets/gadget.md'
        "$asset" |
            Should -Be 'ContractAsset { AssetPath = contracts/widget/0.1.0/gadgets/gadget.md, Kind = Fragment, Direction = DependedOn, Target = docs/gadget.md }'
    }

    It 'places an asset with no group directly in its version folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
        $asset = [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', '', 'gadget.md', $script:fragment,
            'gadget.md', $script:dependedOn)
        $asset.AssetPath | Should -Be 'contracts/widget/0.1.0/gadget.md'
        $asset.Group | Should -Be ''
    }

    It 'rejects the target <Value>, which is not in communication form' -Tag 'ADR-AUTO-PATH-TWOFORMS' -ForEach @(
        @{ Value = 'docs\gadget.md' }
        @{ Value = '/docs/gadget.md' }
        @{ Value = './gadget.md' }
        @{ Value = 'docs/../gadget.md' }
        @{ Value = 'docs//gadget.md' }
        @{ Value = 'C:/gadget.md' }
    ) {
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', 'gadgets', 'a.md', $script:fragment, $Value,
                $script:dependedOn) } |
            Should -Throw '*contract asset*'
    }

    It 'rejects a version that is not a three-part version, a root or group of more than one name, and a path deeper than its place allows' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', 'v1', 'gadgets', 'a.md', $script:fragment, 'a.md',
                $script:dependedOn) } | Should -Throw "*version 'v1'*"
        { [Catzc.Base.Contracts.ContractAsset]::new('widget/gadget', '0.1.0', 'gadgets', 'a.md', $script:fragment,
                'a.md', $script:dependedOn) } | Should -Throw '*one folder or file name*'
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', 'gadget/s', 'a.md', $script:fragment, 'a.md',
                $script:dependedOn) } | Should -Throw '*one folder or file name*'
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', '', 'x/a.md', $script:fragment, 'a.md',
                $script:dependedOn) } | Should -Throw '*one folder or file name*'
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', 'gadgets', 'x/y/a.md', $script:fragment, 'a.md',
                $script:dependedOn) } | Should -Throw '*one folder and a file name*'
    }

    It 'keys an asset in a group''s folder by its path below the version folder' -Tag 'ADR-REPO-CONTRACT-LAYOUT' {
        $asset = [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', 'gadgets', 'flows/a.md', $script:fragment,
            'a.md', $script:dependedOn)
        $asset.Key | Should -Be 'gadgets/flows/a.md'
        $asset.AssetPath | Should -Be 'contracts/widget/0.1.0/gadgets/flows/a.md'
    }

    It 'gives a sample payload no target, and every other kind one' -Tag 'ADR-REPO-CONTRACT-CONTRACTASSET' {
        $sample = [Catzc.Base.Contracts.ContractAssetKind]::Sample
        $provided = [Catzc.Base.Contracts.ContractDirection]::Provided
        [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', 'gadgets', 'g.sample.json', $sample, $null,
            $provided).Target | Should -BeNullOrEmpty
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', 'gadgets', 'g.sample.json', $sample, 'g.json',
                $provided) } | Should -Throw '*has no target*'
        { [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', 'gadgets', 'a.md', $script:fragment, $null,
                $script:dependedOn) } | Should -Throw "*target ''*"
    }
}
