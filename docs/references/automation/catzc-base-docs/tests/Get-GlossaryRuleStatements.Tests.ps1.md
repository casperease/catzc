---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-GlossaryRuleStatements.Tests.ps1.md
    kind: test-asset
    body_sha: "6b3b9f901275"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-GlossaryRuleStatements' -Tag 'L0', 'logic' {`.

```text
Get-GlossaryRuleStatements is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4))
over a fixture ADR index and two ADRs in $TestDrive. Fixture rule codes are neutral (tst —
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
