Describe 'Get-GlossaryRuleStatements' -Tag 'L0', 'logic' {
    BeforeAll {
        $drsRoot = Join-Path $TestDrive 'drs'
        [System.IO.Directory]::CreateDirectory((Join-Path $drsRoot 'repository')) | Out-Null
        $script:indexPath = Join-Path $drsRoot 'index.md'
        [System.IO.File]::WriteAllText($script:indexPath, (@(
                    '| Code | Record |'
                    '| ---- | ------ |'
                    '| `ADR-TST-WIDGET` | [widget-thing](repository/widget-thing.md) |'
                    '| `ADR-TST-GADGET` | [gadget-thing](repository/gadget-thing.md) |'
                ) -join "`n"))
        [System.IO.File]::WriteAllText((Join-Path $drsRoot 'repository/widget-thing.md'), (@(
                    '### Rule ADR-TST-WIDGET-SUITE'
                    ''
                    'A **widget suite** is every widget file at rest; write it `A **widget suite** is …`.'
                ) -join "`n"))
        [System.IO.File]::WriteAllText((Join-Path $drsRoot 'repository/gadget-thing.md'), (@(
                    '### Rule ADR-TST-GADGET-RUN'
                    ''
                    'A **gadget run**'
                    'executes widgets.'
                ) -join "`n"))
        $script:statements = InModuleScope Catzc.Base.Docs -Parameters @{ IndexPath = $script:indexPath } {
            Get-GlossaryRuleStatements -IndexPath $IndexPath
        }
    }

    It 'maps every rule of every indexed ADR to its one-line statement' -Tag 'ADR-REPO-VOCAB-DEFINEDTERM' {
        @($script:statements.Keys | Sort-Object) | Should -Be @('ADR-TST-GADGET-RUN', 'ADR-TST-WIDGET-SUITE')
        $script:statements['ADR-TST-GADGET-RUN'] | Should -Be 'A **gadget run** executes widgets.'
    }

    It 'drops inline code spans, which are mentions rather than definitions' -Tag 'ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED' {
        $script:statements['ADR-TST-WIDGET-SUITE'] |
            Should -Be 'A **widget suite** is every widget file at rest; write it .'
    }
}
