---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestFolders.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-language-test-folders-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: efd0e34da018
---

# automation/Catzc.Base.QualityGates/private/Get-LanguageTestFolders.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$modulesByKebab = @{}`, written with `#`.

```text
The catzc modules of the source tree, by kebab name: the folders under <repository>/automation/, read from the
repository (never the code root), so a build run maps a test folder the same way a source run does.
```
