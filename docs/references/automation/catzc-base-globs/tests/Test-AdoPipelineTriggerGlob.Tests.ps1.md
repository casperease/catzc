---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1.md
    kind: test-asset
    body_sha: "245085ce8846"
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-AdoPipelineTriggerGlob' -Tag 'L0', 'logic' {`.

```text
Test-AdoPipelineTriggerGlob is a quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35), drift detection): each pipeline's
actual trigger vs its globset's projection, compared as sets (ADO path filters are order-independent). A drifted
or missing pipeline is one issue; the report goes to $TestDrive.
```
