Describe 'Get-DrsRuleIds' -Tag 'L0', 'logic' {
    BeforeAll {
        # An index beside two records it lists, plus a third it does not, so only listed records may contribute.
        $script:drsRoot = Join-Path $TestDrive 'adr'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:drsRoot 'principles')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:drsRoot 'widgets')) | Out-Null

        $index = @(
            '# ADR index'
            ''
            '| Code                  | ADR                                      |'
            '| --------------------- | ---------------------------------------- |'
            '| `ADR-WIDGET-GADGET`   | [alpha-thing](principles/alpha-thing.md) |'
            '| `ADR-WIDGET-SPROCKET` | [beta-thing](widgets/beta-thing.md)      |'
        ) -join "`n"
        $script:indexPath = Join-Path $script:drsRoot 'index.md'
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
        [System.IO.File]::WriteAllText((Join-Path $script:drsRoot 'principles/alpha-thing.md'), $alpha)

        $beta = @(
            '# ADR: Beta'
            ''
            '### Rule ADR-WIDGET-SPROCKET-COG'
            ''
            'Only beta rule.'
        ) -join "`n"
        [System.IO.File]::WriteAllText((Join-Path $script:drsRoot 'widgets/beta-thing.md'), $beta)

        # A record the index does not reference — its rule id must never appear.
        $gamma = @(
            '# ADR: Gamma'
            ''
            '### Rule ADR-WIDGET-BOLT-STOP'
            ''
            'Unlisted.'
        ) -join "`n"
        [System.IO.File]::WriteAllText((Join-Path $script:drsRoot 'widgets/gamma-thing.md'), $gamma)
    }

    It 'unions the rule ids of every indexed ADR, distinct and sorted in registry form' {
        $ids = Get-DrsRuleIds -IndexPath $script:indexPath
        $ids | Should -Be @('ADR-WIDGET-GADGET-SPIN', 'ADR-WIDGET-GADGET-TURN', 'ADR-WIDGET-SPROCKET-COG')
    }

    It 'contributes rule ids only from ADRs the index lists' {
        $ids = Get-DrsRuleIds -IndexPath $script:indexPath
        $ids | Should -Not -Contain 'ADR-WIDGET-BOLT-STOP'
    }
}
