---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-BuildArtifact.Tests.ps1.md
    kind: test-asset
    body_sha: "50c6d6534cfb"
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-BuildArtifact' -Tag 'L0', 'logic' {`.

```text
Test-BuildArtifact is a quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): each L0 case mocks the build, the
child-pwsh probe, the source reads, and the formatter at the module boundary, and reads the collected issues; the
report goes to $TestDrive. The integrity blocks that build and load the real tree call the gate from their own test files.
```
