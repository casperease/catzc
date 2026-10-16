---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-PythonLint.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: c11a569779b3
---

# automation/Catzc.Base.QualityGates/Test-PythonLint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$check = Invoke-PythonWorkspaceTool -Tool 'ruff check --output-format...`, written with `#`.

```text
--output-format concise prints one '<file>:<line>:<column>: <code> <message>' line per finding; exit 1 means
findings, anything above it means ruff itself failed.
```
