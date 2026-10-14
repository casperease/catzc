# One test per binding contract asset, generated at discovery, so Test-Automation proves every contract with no
# hand-written test ([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4)). The set is
# the one Test-Contracts checks on a devbox: every asset of each unit's draft, 0.0.0, and the provided assets of every
# released version folder still in the tree, since released folders are the pin record; the depended-on assets of a
# released folder follow their platform and are not checked
# ([ADR-REPO-CONTRACT#3](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract3)). Each test checks its asset by
# its kind and fails with the asset's findings. A tree with no assets discovers no test here. It reads only the
# repository's files, so its answer cannot differ between the run modes (source-only).
BeforeDiscovery {
    $script:assetCases = @(foreach ($asset in InModuleScope Catzc.Base.Contracts { Get-ContractBindingAssets -Version 0.0.0 -RepositoryRoot (Get-RepositoryRoot) }) {
            @{
                Unit      = $asset.Unit
                Version   = $asset.Version
                Module    = $asset.Module
                Path      = $asset.Path
                AssetPath = $asset.AssetPath
                Direction = "$($asset.Direction)"
            }
        })
}

Describe 'Binding contract assets' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CONTRACT#4' {
    It '<Unit> <Version> <Module>: <Path> (<Direction>) holds' -ForEach $script:assetCases {
        $assets = @(Get-Contract -Unit ([WildcardPattern]::Escape($Unit)) -Version ([WildcardPattern]::Escape($Version)) `
                -Module ([WildcardPattern]::Escape($Module)) | Where-Object { $_.AssetPath -ceq $AssetPath })
        $assets.Count | Should -Be 1
        $result = Get-ContractCheckResults -Asset $assets[0]
        $result.Passed | Should -BeTrue -Because ($result.Findings -join "`n")
    }
}
