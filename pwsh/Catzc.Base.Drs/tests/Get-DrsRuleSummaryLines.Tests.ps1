<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/tests/Get-DrsRuleSummaryLines.Tests.ps1.md"
  header: "generated"
---
#>

Describe 'Get-DrsRuleSummaryLines' -Tag 'L0', 'logic' {
    BeforeAll {
        $path = Join-Path $TestDrive 'widget-one.md'
        $content = @(
            '# docs/drs/widget/widget-one.md'                     # 1
            ''                                                   # 2
            'Prose before the registry cites ADR-GADGET-ONE-TURN.' # 3
            ''                                                   # 4
            '## Rules: ADR-WIDGET-ONE'                           # 5
            ''                                                   # 6
            '### Rule ADR-WIDGET-ONE-SPIN'                       # 7
            ''                                                   # 8
            'A widget spins first.'                              # 9
            'It wraps onto a second line.'                       # 10
            ''                                                   # 11
            '- [Spinning](#spinning)'                            # 12
            ''                                                   # 13
            '### Rule ADR-WIDGET-ONE-FOLLOW'                     # 14
            ''                                                   # 15
            'A gadget follows:'                                  # 16
            ''                                                   # 17
            '- a listed clause, kept'                            # 18
            '```text'                                            # 19
            'fenced text, skipped'                               # 20
            '## not a heading inside a fence'                    # 21
            '```'                                                # 22
            ''                                                   # 23
            '- [Following](#following)'                          # 24
            ''                                                   # 25
            '## Context'                                         # 26
            ''                                                   # 27
            'Context prose is not a rule summary.'               # 28
        ) -join "`n"
        [System.IO.File]::WriteAllText($path, $content)
        $script:lines = InModuleScope Catzc.Base.Drs -Parameters @{ Path = $path } { Get-DrsRuleSummaryLines $Path }
    }

    It 'returns each normative line with its 1-based number and its rule in citation form' -Tag 'ADR-REPO-LINK-ONECITATIONSPELLING' {
        $lines | Should -HaveCount 4
        $lines[0].Rule | Should -Be 'ADR-WIDGET-ONE-SPIN'
        $lines[0].Line | Should -Be 9
        $lines[0].Text | Should -Be 'A widget spins first.'
        $lines[1].Line | Should -Be 10
        $lines[2].Rule | Should -Be 'ADR-WIDGET-ONE-FOLLOW'
        $lines[2].Line | Should -Be 16
        $lines[3].Text | Should -Be '- a listed clause, kept'
    }

    It 'leaves out blank lines, anchor bullets, fenced lines, and prose outside the rule registry' {
        $lines.Line | Should -Not -Contain 3
        $lines.Line | Should -Not -Contain 12
        $lines.Line | Should -Not -Contain 20
        $lines.Line | Should -Not -Contain 21
        $lines.Line | Should -Not -Contain 28
    }

    It 'returns nothing for a file without rules' {
        $plain = Join-Path $TestDrive 'plain.md'
        [System.IO.File]::WriteAllText($plain, "# Plain`n`nNo rules here.`n")
        InModuleScope Catzc.Base.Drs -Parameters @{ Path = $plain } { Get-DrsRuleSummaryLines $Path } | Should -HaveCount 0
    }
}
