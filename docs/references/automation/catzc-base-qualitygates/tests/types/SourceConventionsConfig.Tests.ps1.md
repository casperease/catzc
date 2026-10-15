---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/types/SourceConventionsConfig.Tests.ps1.md
    kind: test-asset
    body_sha: "4a5876a1a50f"
    adrs:
      - ADR-AUTO-DEFAULT#6
---

# automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'SourceConventionsConfig' -Tag 'L0' {`.

```text
SourceConventionsConfig maps source-conventions.yml: an omitted check takes every default of its type
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), and an unknown key fails at
construction.
```
