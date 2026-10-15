<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1
    kind: pester-test
---
#>

# Get-GlossaryRuleStatements is private, so it is exercised through the module (InModuleScope, per
# [ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4))
# over a fixture ADR index and two ADRs in $TestDrive. Fixture rule codes are neutral (tst —
# [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Get-GlossaryRuleStatements' -Tag 'L0', 'logic' {
    BeforeAll {
        $adrRoot = Join-Path $TestDrive 'adr'
        [System.IO.Directory]::CreateDirectory((Join-Path $adrRoot 'repository')) | Out-Null
        $script:indexPath = Join-Path $adrRoot 'index.md'
        [System.IO.File]::WriteAllText($script:indexPath, (@(
                    '| Code | ADR |'
                    '| ---- | --- |'
                    '| `ADR-TST-WIDGET` | [widget-thing](repository/widget-thing.md) |'
                    '| `ADR-TST-GADGET` | [gadget-thing](repository/gadget-thing.md) |'
                ) -join "`n"))
        [System.IO.File]::WriteAllText((Join-Path $adrRoot 'repository/widget-thing.md'), (@(
                    '### Rule ADR-TST-WIDGET:1'
                    ''
                    'A **widget suite** is every widget file at rest; write it `A **widget suite** is …`.'
                ) -join "`n"))
        [System.IO.File]::WriteAllText((Join-Path $adrRoot 'repository/gadget-thing.md'), (@(
                    '### Rule ADR-TST-GADGET:1'
                    ''
                    'A **gadget run**'
                    'executes widgets.'
                ) -join "`n"))
        $script:statements = InModuleScope Catzc.Base.Docs -Parameters @{ IndexPath = $script:indexPath } {
            Get-GlossaryRuleStatements -IndexPath $IndexPath
        }
    }

    It 'maps every rule of every indexed ADR to its one-line statement' -Tag 'ADR-REPO-VOCAB#1' {
        @($script:statements.Keys | Sort-Object) | Should -Be @('ADR-TST-GADGET:1', 'ADR-TST-WIDGET:1')
        $script:statements['ADR-TST-GADGET:1'] | Should -Be 'A **gadget run** executes widgets.'
    }

    It 'drops inline code spans, which are mentions rather than definitions' -Tag 'ADR-REPO-VOCAB#5' {
        $script:statements['ADR-TST-WIDGET:1'] | Should -Be 'A **widget suite** is every widget file at rest; write it .'
    }
}
