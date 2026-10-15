---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/Get-AdrRuleSet.Tests.ps1.md
    kind: test-asset
    body_sha: "85ab9b9e3826"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.Docs/tests/Get-AdrRuleSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-AdrRuleSet' -Tag 'L0', 'logic' {`.

```text
Get-AdrRuleSet over a fixture AdrsConfig (Get-Config mocked): the flattening and effective codes are AdrsConfig
construction rules (its type test), so this pins only the projection and the -Domain filter. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Describe 'Get-AdrRuleSet integrity' -Tag 'L1', 'integrity',...`.

```text
Integrity: adrs.yml and the ADR rule files agree, through the quality gate Test-AdrRegistry
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
```
