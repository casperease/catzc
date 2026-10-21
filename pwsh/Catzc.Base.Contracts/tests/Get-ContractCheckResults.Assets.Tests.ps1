<#
---
catzc:
  immutable:
    with_body_sha: "6be34f68e8a8"
  edges:
    docs: "[Get-ContractCheckResults.Assets.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TEST-SETUPONCE
      - ADR-REPO-CMDCONTRACT-COMMANDCONTRACT
      - ADR-REPO-CMDCONTRACT-ONEREADER
      - ADR-REPO-CONTRACT-KEPTWHILEPINNED
      - ADR-REPO-CONTRACT-PROVENBYTESTS
---
#>

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
    $script:commandCases = @(foreach ($asset in InModuleScope Catzc.Base.Contracts { Get-ContractBindingAssets -Version 0.0.0 -RepositoryRoot (Get-RepositoryRoot) }) {
            if ($asset.Kind -eq [Catzc.Base.Contracts.ContractAssetKind]::Command) {
                @{
                    Unit    = $asset.Unit
                    Version = $asset.Version
                    Module  = $asset.Module
                    Path    = $asset.Path
                    Name    = [Catzc.Base.Contracts.ContractCommand]::NameOf($asset)
                }
            }
        })
}

Describe 'Binding contract assets' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
    BeforeAll {
        $script:groupContracts = @{}
    }

    It '<Unit> <Version> <Module>: <Path> (<Direction>) holds' -ForEach $script:assetCases {
        $group = "$Unit|$Version|$Module"
        if (-not $script:groupContracts.ContainsKey($group)) {
            $script:groupContracts[$group] = @(Get-Contract -Unit ([WildcardPattern]::Escape($Unit)) `
                    -Version ([WildcardPattern]::Escape($Version)) -Module ([WildcardPattern]::Escape($Module)))
        }
        $assets = @($script:groupContracts[$group] | Where-Object { $_.AssetPath -ceq $AssetPath })
        $assets.Count | Should -Be 1
        $result = Get-ContractCheckResults -Asset $assets[0]
        $result.Passed | Should -BeTrue -Because ($result.Findings -join "`n")
    }
}

Describe 'Command contracts' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CMDCONTRACT-COMMANDCONTRACT', 'ADR-REPO-CMDCONTRACT-ONEREADER' {
    BeforeAll {
        $script:commandContracts = @{}
        foreach ($contract in Get-CommandContract -Unit '*' -Version '*' -Module '*') {
            $key = "$($contract.Asset.Unit)|$($contract.Asset.Version)|$($contract.Asset.Module)|$($contract.Name)"
            if (-not $script:commandContracts.ContainsKey($key)) {
                $script:commandContracts[$key] = [System.Collections.Generic.List[object]]::new()
            }
            $script:commandContracts[$key].Add($contract)
        }
    }

    It 'holds at least the pilot set (<Count> command assets)' -ForEach @(@{ Count = $script:commandCases.Count }) {
        $Count | Should -BeGreaterOrEqual 12
    }

    It '<Unit> <Version> <Module>: <Name> reads as one typed record through Get-CommandContract' -ForEach $script:commandCases {
        $key = "$Unit|$Version|$Module|$Name"
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
