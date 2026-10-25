<#
---
catzc:
  docs: "../../../../docs/references/pwsh/catzc-base-contracts/tests/types/ContractCheckResult.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'ContractCheckResult' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:asset = [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.1.0', 'Catzc.Widget', 'gadget.md',
            [Catzc.Base.Contracts.ContractAssetKind]::Presence, 'gadget.md', [Catzc.Base.Contracts.ContractDirection]::DependedOn)
    }

    It 'passes with no findings, and fails with one' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
        [Catzc.Base.Contracts.ContractCheckResult]::new($script:asset, [string[]] @()).Passed | Should -BeTrue
        [Catzc.Base.Contracts.ContractCheckResult]::new($script:asset, $null).Passed | Should -BeTrue
        $failed = [Catzc.Base.Contracts.ContractCheckResult]::new($script:asset, [string[]] @('gadget is missing'))
        $failed.Passed | Should -BeFalse
        $failed.Findings | Should -Be @('gadget is missing')
    }

    It 'rejects a missing asset and a blank finding' -Tag 'ADR-REPO-CONTRACT-PROVENBYTESTS' {
        { [Catzc.Base.Contracts.ContractCheckResult]::new($null, [string[]] @()) } | Should -Throw '*the asset is required*'
        { [Catzc.Base.Contracts.ContractCheckResult]::new($script:asset, [string[]] @(' ')) } | Should -Throw '*a finding is an empty message*'
    }

    It 'renders console-ready' -Tag 'ADR-BCL-TYPES-CONSOLEREADYTOSTRING' {
        "$([Catzc.Base.Contracts.ContractCheckResult]::new($script:asset, [string[]] @()))" | Should -BeLike 'ContractCheckResult { Passed = True, Asset = *'
    }
}
