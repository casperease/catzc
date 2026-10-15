---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-github/tests/Test-GitHistoryClean.Tests.ps1.md
    kind: test-asset
    body_sha: "4a51b17cb36a"
---

# automation/Catzc.Tooling.Github/tests/Test-GitHistoryClean.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:repo = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-ghtest-' +...`.

```text
A throwaway git repo whose history plants the token on all three surfaces:
a blob (file content), a path (file name), and a commit message.
```
