---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1.md
    kind: test-asset
    body_sha: a44f4d04e693
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-GlossaryDefinitionViolations' -Tag 'L0', 'logic' {`.

```text
Get-GlossaryDefinitionViolations is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)). A fixture ADR index and
two ADRs live in $TestDrive, and the glossary is built in memory from
the real GlossaryEntry/GlossaryConcept/GlossaryOptions types. Fixture terms and rule codes are neutral
(widget/gadget, tst — [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
