---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-TestRun.Tests.ps1.md
    kind: test-asset
    body_sha: "10299dcdb74d"
---

# automation/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:testsDir = Join-Path $TestDrive 'widget/tests'`.

```text
A fixture tests/ folder with two files: widget mixes a source-only test with a runnable one; gadget is
source-only throughout. Discovery is faked over them (the Pester test shape Get-TestBlockTag walks).
```
