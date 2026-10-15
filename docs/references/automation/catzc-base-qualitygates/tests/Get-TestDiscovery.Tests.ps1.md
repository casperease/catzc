---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestDiscovery.Tests.ps1.md
    kind: test-asset
    body_sha: "4aefb0e97ccc"
---

# automation/Catzc.Base.QualityGates/tests/Get-TestDiscovery.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$discovery.Tests | Should -HaveCount 2`.

```text
Both tests are discovered, none ran (the throwing bodies prove SkipRun held), and the block chain
is live — the tag consumers (Get-TestTagViolations / Split-TestAutomationFiles) walk it from this object.
```
