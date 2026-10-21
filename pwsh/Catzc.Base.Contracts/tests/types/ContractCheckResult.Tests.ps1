<#
---
catzc:
  immutable:
    with_body_sha: cb1ea9b59513
  edges:
    docs: "[ContractCheckResult.Tests.ps1.md](docs/references/pwsh/catzc-base-contracts/tests/types/ContractCheckResult.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Contracts/types/ContractCheckResult.cs
    cites:
      - ADR-BCL-TYPES-CONSOLEREADYTOSTRING
      - ADR-REPO-CONTRACT-PROVENBYTESTS
---
#>

Describe 'ContractCheckResult' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:asset = [Catzc.Base.Contracts.ContractAsset]::new('widget', '0.0.0', 'Catzc.Widget', 'gadget.md',
            [Catzc.Base.Contracts.ContractAssetKind]::Presence, 'gadget.md', [Catzc.Base.Contracts.ContractDirection]::DependedOn, $false)
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
