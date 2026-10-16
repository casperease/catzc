---
catzc:
  immutable:
    with_body_sha: d2536c4ce4db
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/tests/Get-GlossaryRuleStatements.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: get-glossary-rule-statements-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlossaryRuleStatements' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-GlossaryRuleStatements is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4))
over a fixture ADR index and two ADRs in $TestDrive. Fixture rule codes are neutral (tst —
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
