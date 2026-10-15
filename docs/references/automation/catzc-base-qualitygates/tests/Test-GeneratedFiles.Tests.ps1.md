---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-GeneratedFiles.Tests.ps1.md
    kind: test-asset
    body_sha: "49380add934d"
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-GeneratedFiles' -Tag 'L0', 'logic' {`.

```text
Test-GeneratedFiles is a quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): each L0 case mocks every generator
at the module boundary and reads the collected issues; the report goes to $TestDrive. The integrity blocks that run it
over the real tree live beside each generator's own tests.
```
