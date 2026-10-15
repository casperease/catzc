---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-FileMetaProcessors.Tests.ps1.md
    kind: test-asset
    body_sha: bb093e4a6405
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-FILEMETA#4
---

# automation/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-FileMetaProcessors' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#4' {`.

```text
Test-FileMetaProcessors over in-memory registries and fixture processor functions defined in the module scope.
Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
