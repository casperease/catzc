---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-github/tests/Test-GitHistoryClean.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-github/tests
    name: test-git-history-clean-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "697ba93b2f6e"
---

# automation/Catzc.Tooling.Github/tests/Test-GitHistoryClean.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:repo = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-ghtest-' +...`, written with `#`.

```text
A throwaway git repo whose history plants the token on all three surfaces:
a blob (file content), a path (file name), and a commit message.
```
