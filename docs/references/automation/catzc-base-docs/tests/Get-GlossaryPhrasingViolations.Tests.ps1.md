---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1.md
    kind: comment-page
    body_sha: "93b87ccdf917"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlossaryPhrasingViolations' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-GlossaryPhrasingViolations is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)). Each test writes its
own fixture file under $TestDrive and passes it as the only tracked file
(-TrackedFile, -Root), so no git process runs; the glossary is built in memory from the real types. Fixture terms
and rule codes are neutral (widget/gadget, tst —
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): the avoided phrase is 'widget
bundle'.
```

## comment:2

Above `$script:entry = {`, written with `#`.

```text
One entry from the widget's source avoiding 'widget bundle' (say 'widget suite'), with the source's
options, if any.
```
