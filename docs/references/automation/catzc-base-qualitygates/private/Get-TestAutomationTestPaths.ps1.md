---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationTestPaths.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "31ed3a23fc1d"
---

# automation/Catzc.Base.QualityGates/private/Get-TestAutomationTestPaths.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($testFolder in @(Get-LanguageTestFolders)) {`, written with `#`.

```text
The language test folders (Go, then Python), each after its module's tests folder (Get-LanguageTestFolders
throws on an unmatched folder).
```
