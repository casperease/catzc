# One case per binding asset, generated at discovery, so every contract is proven with no hand-written test.
BeforeDiscovery {
    $script:assetCases = @(foreach ($asset in InModuleScope Catzc.Base.Contracts { Get-ContractBindingAssets -Version 0.1.0 -RepositoryRoot (Get-RepositoryRoot) }) {
            @{
                Root      = $asset.Root
                Version   = $asset.Version
                Group     = $asset.Group
                Path      = $asset.Path
                AssetPath = $asset.AssetPath
                Target    = $asset.Target
                Direction = "$($asset.Direction)"
            }
        })
    $script:commandCases = @(foreach ($asset in InModuleScope Catzc.Base.Contracts { Get-ContractBindingAssets -Version 0.1.0 -RepositoryRoot (Get-RepositoryRoot) }) {
            if ($asset.Kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Command) {
                @{
                    Root    = $asset.Root
                    Version = $asset.Version
                    Group   = $asset.Group
                    Path    = $asset.Path
                    Name    = [Catzc.Base.Contracts.ContractCommand]::NameOf($asset)
                }
            }
        })
}

Describe 'Binding contract assets' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
    BeforeAll {
        # One filtered lookup per unit, version and module, shared by every case.
        $script:groupContracts = @{}
    }

    It '<Root> <Version> <Group>: <Path> -> <Target> (<Direction>) holds' -ForEach $script:assetCases {
        $groupKey = "$Root|$Version|$Group"
        if (-not $script:groupContracts.ContainsKey($groupKey)) {
            $script:groupContracts[$groupKey] = @(Get-Contract -Root ([WildcardPattern]::Escape($Root)) `
                    -Version ([WildcardPattern]::Escape($Version)) -Group ([WildcardPattern]::Escape($Group)))
        }
        $assets = @($script:groupContracts[$groupKey] | Where-Object { $_.AssetPath -ceq $AssetPath -and $_.Target -ceq $Target })
        $assets.Count | Should -Be 1
        $result = Get-ContractCheckResults -Asset $assets[0]
        $result.Passed | Should -BeTrue -Because ($result.Findings -join "`n")
    }
}

Describe 'Command contracts' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CMDCONTRACT-COMMANDCONTRACT', 'ADR-REPO-CMDCONTRACT-ONEREADER' {
    BeforeAll {
        $script:commandContracts = @{}
        foreach ($contract in Get-CommandContract -Root '*' -Version '*' -Module '*') {
            $key = "$($contract.Asset.Root)|$($contract.Asset.Version)|$($contract.Asset.Group)|$($contract.Name)"
            if (-not $script:commandContracts.ContainsKey($key)) {
                $script:commandContracts[$key] = [System.Collections.Generic.List[object]]::new()
            }
            $script:commandContracts[$key].Add($contract)
        }
    }

    It 'holds at least the pilot set (<Count> command assets)' -ForEach @(@{ Count = $script:commandCases.Count }) {
        $Count | Should -BeGreaterOrEqual 12
    }

    It '<Root> <Version> <Group>: <Name> reads as one typed record through Get-CommandContract' -ForEach $script:commandCases {
        $key = "$Root|$Version|$Group|$Name"
        $contracts = @()
        if ($script:commandContracts.ContainsKey($key)) {
            $contracts = @($script:commandContracts[$key])
        }
        $contracts.Count | Should -Be 1
        $contracts[0].Name | Should -Be $Name
        $contracts[0].Signature | Should -Not -BeNullOrEmpty
        $contracts[0].Signature | Should -Not -BeLike 'not readable*'
    }
}
