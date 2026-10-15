---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationTestPaths.ps1.md
    kind: comment-page
    body_sha: "9ddb315ecdf6"
---

# automation/Catzc.Base.QualityGates/private/Get-TestAutomationTestPaths.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `foreach ($testFolder in @(Get-LanguageTestFolders)) {`.

```text
The language test folders (Go, then Python), each after its module's tests folder (Get-LanguageTestFolders
throws on an unmatched folder).
```
