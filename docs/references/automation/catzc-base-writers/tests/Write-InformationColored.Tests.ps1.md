---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/tests/Write-InformationColored.Tests.ps1.md
    folder: docs/references/automation/catzc-base-writers/tests
    name: write-information-colored-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "713185b89500"
---

# automation/Catzc.Base.Writers/tests/Write-InformationColored.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll { $global:__PesterRunning = $false }`, written with `#`.

```text
Write-InformationColored is a PRIVATE writer (the module's information-stream chokepoint), so it is
reached through InModuleScope rather than as an exported command.
The chokepoint guard returns early during a run ($global:__PesterRunning); lift it so output can be asserted.
```
