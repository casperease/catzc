---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-GlossarySourceViolations.Tests.ps1.md
    kind: test-asset
    body_sha: "5d8ad78572fb"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-GlossarySourceViolations' -Tag 'L0', 'logic' {`.

```text
Get-GlossarySourceViolations is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)). The sources are built
in memory from the real GlossaryConfig type and passed in, and adrs.yml
is mocked to two fixture ADR domains, so each test breaks exactly one cross-source fact. Fixture terms are neutral
(widget/gadget, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
