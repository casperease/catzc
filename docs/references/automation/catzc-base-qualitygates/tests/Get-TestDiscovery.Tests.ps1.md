---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestDiscovery.Tests.ps1.md
    kind: comment-page
    body_sha: "8f25e1467cfe"
---

# automation/Catzc.Base.QualityGates/tests/Get-TestDiscovery.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$discovery.Tests | Should -HaveCount 2`, written with `#`.

```text
Both tests are discovered, none ran (the throwing bodies prove SkipRun held), and the block chain
is live — the tag consumers (Get-TestTagViolations / Split-TestAutomationFiles) walk it from this object.
```
