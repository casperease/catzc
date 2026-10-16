---
catzc:
  immutable:
    with_body_sha: f3bbb2d0bd26
    path: docs/references/automation/catzc-base-qualitygates/tests/Write-TestAutomationHeader.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: write-test-automation-header-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/tests/Write-TestAutomationHeader.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The writers' chokepoint returns early during a run ($global:__PesterRunning); lift it so the banner's
information-stream output can be asserted (see console-output-matters).
```
