---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/Test-AnalyzedFileIsTest.Tests.ps1.md
    kind: test-asset
    body_sha: "4489b422b15c"
---

# automation/.scriptanalyzer/tests/Test-AnalyzedFileIsTest.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-AnalyzedFileIsTest' -Tag 'L0', 'logic' {`.

```text
Test-AnalyzedFileIsTest is the one test-file scope check the custom analyzer rules share: by file name when the
analyzer reads a file (the gate), by Pester structure when it reads an editor buffer with no file name (VS Code).
```
