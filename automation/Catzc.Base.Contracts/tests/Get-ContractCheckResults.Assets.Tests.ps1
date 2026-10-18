<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1
    folder: tests
    name: get-contract-check-results-assets-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1.md
    cites:
      - ADR-REPO-CMDCONTRACT#{1,5}
      - ADR-REPO-CONTRACT#{3,4}
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

Describe 'Binding contract assets' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CONTRACT#4' {
    It '<Unit> <Version> <Module>: <Path> (<Direction>) holds' -ForEach $script:assetCases {
        $assets = @(Get-Contract -Unit ([WildcardPattern]::Escape($Unit)) -Version ([WildcardPattern]::Escape($Version)) `
                -Module ([WildcardPattern]::Escape($Module)) | Where-Object { $_.AssetPath -ceq $AssetPath })
        $assets.Count | Should -Be 1
        $result = Get-ContractCheckResults -Asset $assets[0]
        $result.Passed | Should -BeTrue -Because ($result.Findings -join "`n")
    }
}

Describe 'Command contracts' -Tag 'L1', 'integrity', 'source-only', 'ADR-REPO-CMDCONTRACT#1', 'ADR-REPO-CMDCONTRACT#5' {
    It 'holds at least the pilot set (<Count> command assets)' -ForEach @(@{ Count = $script:commandCases.Count }) {
        $Count | Should -BeGreaterOrEqual 12
    }

    It '<Unit> <Version> <Module>: <Name> reads as one typed record through Get-CommandContract' -ForEach $script:commandCases {
        $contracts = @(Get-CommandContract -Name ([WildcardPattern]::Escape($Name)) -Module ([WildcardPattern]::Escape($Module)) `
                -Unit ([WildcardPattern]::Escape($Unit)) -Version ([WildcardPattern]::Escape($Version)))
        $contracts.Count | Should -Be 1
        $contracts[0].Name | Should -Be $Name
        $contracts[0].Signature | Should -Not -BeNullOrEmpty
        $contracts[0].Signature | Should -Not -BeLike 'not readable*'
    }
}
