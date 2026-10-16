---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-GlossaryFormViolations.Tests.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b17180a593cb
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlossaryFormViolations' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-GlossaryFormViolations is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)). Each test writes its
own fixture file under $TestDrive and passes it as the only tracked file (-TrackedFile, -Root), so no git process
runs; the glossary is built in memory from the real types. Fixture terms and rule codes are neutral (widget/gadget,
tst — [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): the family is 'widget', with
the forms 'gadget' and 'CI'.
```
