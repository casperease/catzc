<#
---
catzc:
  immutable:
    with_body_sha: e965e1ca5dc8
  edges:
    docs: "[Get-GlossaryRuleStatements.Tests.ps1.md](docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryRuleStatements.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-PWSH-PESTER-PRIVATETHROUGHMODULE
      - ADR-REPO-VOCAB-DEFINEDTERM
      - ADR-REPO-VOCAB-AVOIDEDPHRASINGREPLACED
---
#>

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
                    '### Rule ADR-TST-WIDGET-SUITE'
                    ''
                    'A **widget suite** is every widget file at rest; write it `A **widget suite** is …`.'
                ) -join "`n"))
        [System.IO.File]::WriteAllText((Join-Path $adrRoot 'repository/gadget-thing.md'), (@(
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
        $script:statements['ADR-TST-WIDGET-SUITE'] | Should -Be 'A **widget suite** is every widget file at rest; write it .'
    }
}
