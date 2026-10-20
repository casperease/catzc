<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/tests/types/ContractCheckResult.Tests.ps1
    folder: tests/types
    name: contract-check-result-tests
    filetype: ps1
    role: test
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[ContractCheckResult.Tests.ps1.md](docs/references/pwsh/catzc-base-contracts/tests/types/ContractCheckResult.Tests.ps1.md)"
    cites:
      - ADR-AUTO-TYPES-CONSOLEREADYTOSTRING
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

    It 'renders console-ready' -Tag 'ADR-AUTO-TYPES-CONSOLEREADYTOSTRING' {
        "$([Catzc.Base.Contracts.ContractCheckResult]::new($script:asset, [string[]] @()))" | Should -BeLike 'ContractCheckResult { Passed = True, Asset = *'
    }
}
