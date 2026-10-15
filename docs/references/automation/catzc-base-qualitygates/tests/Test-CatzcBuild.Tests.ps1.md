---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.Tests.ps1.md
    kind: test-asset
    body_sha: a4605af50907
---

# automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:harness = 'Catzc.Base.QualityGates'`.

```text
Build-Modules (Catzc.Base.Exporter) is the boundary: mocked here, so this test file proves the wiring
without a real build.
```
