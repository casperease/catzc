Describe 'Get-CatsAdrRuleIds' -Tag 'L0', 'logic' {
    BeforeAll {
        # A fixture ADR tree: an index beside two ADR files it lists (paths relative to the index folder),
        # plus a third ADR the index does NOT list — so we can assert only listed ADRs contribute.
        $script:adrRoot = Join-Path $TestDrive 'adr'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:adrRoot 'principles')) | Out-Null
        [System.IO.Directory]::CreateDirectory((Join-Path $script:adrRoot 'automation')) | Out-Null

        $index = @(
            '# ADR index'
            ''
            '| Code | ADR |'
            '| ---- | --- |'
            '| `ADR-ALPHA` | [alpha-thing](principles/alpha-thing.md) |'
            '| `ADR-BETA`  | [beta-thing](automation/beta-thing.md) |'
        ) -join "`n"
        $script:indexPath = Join-Path $script:adrRoot 'index.md'
        [System.IO.File]::WriteAllText($script:indexPath, $index)

        $alpha = @(
            '# ADR: Alpha'
            ''
            '### Rule ADR-ALPHA:1'
            ''
            'First alpha rule.'
            ''
            '### Rule ADR-ALPHA:2'
            ''
            'Second alpha rule.'
        ) -join "`n"
        [System.IO.File]::WriteAllText((Join-Path $script:adrRoot 'principles/alpha-thing.md'), $alpha)

        $beta = @(
            '# ADR: Beta'
            ''
            '### Rule ADR-BETA:1'
            ''
            'Only beta rule.'
        ) -join "`n"
        [System.IO.File]::WriteAllText((Join-Path $script:adrRoot 'automation/beta-thing.md'), $beta)

        # An ADR the index does not reference — its rule id must never appear.
        $gamma = @(
            '# ADR: Gamma'
            ''
            '### Rule ADR-GAMMA:1'
            ''
            'Unlisted.'
        ) -join "`n"
        [System.IO.File]::WriteAllText((Join-Path $script:adrRoot 'automation/gamma-thing.md'), $gamma)
    }

    It 'unions the rule ids of every indexed ADR, distinct and sorted in registry form' {
        $ids = Get-CatsAdrRuleIds -IndexPath $script:indexPath
        $ids | Should -Be @('ADR-ALPHA:1', 'ADR-ALPHA:2', 'ADR-BETA:1')
    }

    It 'contributes rule ids only from ADRs the index lists' {
        $ids = Get-CatsAdrRuleIds -IndexPath $script:indexPath
        $ids | Should -Not -Contain 'ADR-GAMMA:1'
    }
}
