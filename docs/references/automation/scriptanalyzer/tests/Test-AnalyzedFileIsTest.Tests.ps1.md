---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/tests/Test-AnalyzedFileIsTest.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "5cd65051eef5"
---

# automation/.scriptanalyzer/tests/Test-AnalyzedFileIsTest.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-AnalyzedFileIsTest' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-AnalyzedFileIsTest is the one test-file scope check the custom analyzer rules share: by file name when the
analyzer reads a file (the gate), by Pester structure when it reads an editor buffer with no file name (VS Code).
```
