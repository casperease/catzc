<#
---
catzc:
  immutable:
    with_body_sha: c0836d3db299
  edges:
    docs: "[Get-CatsDrsRuleIds.Tests.ps1.md](docs/references/pwsh/catzc-base-drs/tests/Get-CatsDrsRuleIds.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Drs/Get-CatsDrsRuleIds.ps1
---
#>

Describe 'Get-CatsDrsRuleIds' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:adrRoot = Join-Path $TestDrive 'adr'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:adrRoot 'principles')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:adrRoot 'widgets')) | Out-Null

        $index = @(
            '# ADR index'
            ''
            '| Code                  | ADR                                      |'
            '| --------------------- | ---------------------------------------- |'
            '| `ADR-WIDGET-GADGET`   | [alpha-thing](principles/alpha-thing.md) |'
            '| `ADR-WIDGET-SPROCKET` | [beta-thing](widgets/beta-thing.md)      |'
        ) -join "`n"
        $script:indexPath = Join-Path $script:adrRoot 'index.md'
        [System.IO.File]::WriteAllText($script:indexPath, $index)

        $alpha = @(
            '# ADR: Alpha'
            ''
            '### Rule ADR-WIDGET-GADGET-TURN'
            ''
            'First alpha rule.'
            ''
            '### Rule ADR-WIDGET-GADGET-SPIN'
            ''
            'Second alpha rule.'
        ) -join "`n"
        [System.IO.File]::WriteAllText((Join-Path $script:adrRoot 'principles/alpha-thing.md'), $alpha)

        $beta = @(
            '# ADR: Beta'
            ''
            '### Rule ADR-WIDGET-SPROCKET-COG'
            ''
            'Only beta rule.'
        ) -join "`n"
        [System.IO.File]::WriteAllText((Join-Path $script:adrRoot 'widgets/beta-thing.md'), $beta)

        # An ADR the index does not reference — its rule id must never appear.
        $gamma = @(
            '# ADR: Gamma'
            ''
            '### Rule ADR-WIDGET-BOLT-STOP'
            ''
            'Unlisted.'
        ) -join "`n"
        [System.IO.File]::WriteAllText((Join-Path $script:adrRoot 'widgets/gamma-thing.md'), $gamma)
    }

    It 'unions the rule ids of every indexed ADR, distinct and sorted in registry form' {
        $ids = Get-CatsDrsRuleIds -IndexPath $script:indexPath
        $ids | Should -Be @('ADR-WIDGET-GADGET-SPIN', 'ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-SPROCKET-COG')
    }

    It 'contributes rule ids only from ADRs the index lists' {
        $ids = Get-CatsDrsRuleIds -IndexPath $script:indexPath
        $ids | Should -Not -Contain 'ADR-WIDGET-BOLT-STOP'
    }
}
