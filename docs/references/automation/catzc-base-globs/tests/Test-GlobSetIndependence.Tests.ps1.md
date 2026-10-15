---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
    kind: test-asset
    body_sha: a9054e8670a7
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#10
---

# automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-GlobSetIndependence' -Tag 'L0', 'logic' {`.

```text
Test-GlobSetIndependence is a quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over per-layer independence
([ADR-FLOW-CD-GLOBS#10](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs10)). The registry, the derived
module sets and the tracked-file universe are mocked with neutral fixtures (widget/gadget,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); the report goes to $TestDrive.
```
