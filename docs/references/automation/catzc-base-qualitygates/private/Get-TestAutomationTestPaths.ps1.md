---
catzc:
  immutable:
    with_body_sha: "31ed3a23fc1d"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationTestPaths.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-test-automation-test-paths-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
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
