---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-PythonLint.ps1.md
    kind: comment-page
    body_sha: c25a857d6808
---

# automation/Catzc.Base.QualityGates/Test-PythonLint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$check = Invoke-PythonWorkspaceTool -Tool 'ruff check --output-format...`.

```text
--output-format concise prints one '<file>:<line>:<column>: <code> <message>' line per finding; exit 1 means
findings, anything above it means ruff itself failed.
```
