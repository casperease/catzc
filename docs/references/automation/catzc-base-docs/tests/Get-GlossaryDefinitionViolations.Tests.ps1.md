---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: get-glossary-definition-violations-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "47786d06e1b1"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlossaryDefinitionViolations' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-GlossaryDefinitionViolations is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)). A fixture ADR index and
two ADRs live in $TestDrive, and the glossary is built in memory from
the real GlossaryEntry/GlossaryConcept/GlossaryOptions types. Fixture terms and rule codes are neutral
(widget/gadget, tst — [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
