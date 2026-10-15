---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/tests/Write-InformationColored.Tests.ps1.md
    kind: test-asset
    body_sha: "5f30985f0864"
---

# automation/Catzc.Base.Writers/tests/Write-InformationColored.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll { $global:__PesterRunning = $false }`.

```text
Write-InformationColored is a PRIVATE writer (the module's information-stream chokepoint), so it is
reached through InModuleScope rather than as an exported command.
The chokepoint guard returns early during a run ($global:__PesterRunning); lift it so output can be asserted.
```
