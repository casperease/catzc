---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-NeutralCodeFinding.Tests.ps1.md
    kind: test-asset
    body_sha: c081a517fe32
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-NeutralCodeFinding' -Tag 'L0', 'logic' {`.

```text
Get-NeutralCodeFinding over fixture test files: ADR-WIDGET-GADGET stands in for a code the ADR registry declares,
and ADR-WIDGET-SPROCKET for a neutral one
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
