---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/EngineSetCheck.Tests.ps1.md
    kind: test-asset
    body_sha: e0a5d7d974e0
    adrs:
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'EngineSetCheck' -Tag 'L0', 'logic' {`.

```text
EngineSetCheck maps the engine-set check's settings and matches its phrases against the engine names it is given —
widget, gadget and sprocket stand in for the model's engines
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) — so no engine name or count is a
literal of the check ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)).
```
