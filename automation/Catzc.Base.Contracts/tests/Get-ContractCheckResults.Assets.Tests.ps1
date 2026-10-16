<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1.md
    adrs:
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
