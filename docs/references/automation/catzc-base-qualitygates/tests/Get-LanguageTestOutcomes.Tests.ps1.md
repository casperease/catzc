---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-LanguageTestOutcomes.Tests.ps1.md
    kind: test-asset
    body_sha: "0f2b274854c1"
    adrs:
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-LanguageTestOutcomes' -Tag 'L0', 'logic' {`.

```text
Get-LanguageTestOutcomes with the language runners mocked: every discovered test takes the outcome of its result,
or skips with tool_<tool>_missing when the run's source session handed down no managed tool. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `It 'runs the tests under the <Engine> engine with the executable handed down'...`.

```text
Every engine other than the running pwsh, from the model
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)).
```
