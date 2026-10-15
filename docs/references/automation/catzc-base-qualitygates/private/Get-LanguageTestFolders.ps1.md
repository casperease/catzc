---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
    kind: comment-page
    body_sha: "1bffc3908cdc"
---

# automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$modulesByKebab = @{}`.

```text
The catzc modules of the source tree, by kebab name: the folders under <repository>/automation/, read from the
repository (never the code root), so a build run maps a test folder the same way a source run does.
```
