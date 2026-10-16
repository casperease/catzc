---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/tests/Install-Catzc.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4d6b796eecc3"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:source = Join-Path $TestDrive...`, written with `#`.

```text
A fixture build (neutral names,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)). Its integrity guard is a
boundary here (Assert-CatzcBundle
has its own tests); the fixture's Import-Catzc.ps1 records how it was invoked, so dot-sourcing the
generated root importer proves the wiring without loading a platform.
```
