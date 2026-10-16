---
catzc:
  immutable:
    with_body_sha: "433a23513767"
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrRuleSet.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: get-adr-rule-set-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#{3,35}
---

# automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-AdrRuleSet' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-AdrRuleSet over a fixture AdrsConfig (Get-Config mocked): the flattening and effective codes are AdrsConfig
construction rules (its type test), so this pins only the projection and the -Domain filter. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Get-AdrRuleSet integrity' -Tag 'L1', 'integrity',...`, written with `#`.

```text
Integrity: adrs.yml and the ADR rule files agree, through the quality gate Test-AdrRegistry
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
```
