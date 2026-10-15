---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/tests/Install-Catzc.Tests.ps1.md
    kind: test-asset
    body_sha: c6a1cdc6416b
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:source = Join-Path $TestDrive...`.

```text
A fixture build (neutral names,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)). Its integrity guard is a
boundary here (Assert-CatzcBundle
has its own tests); the fixture's Import-Catzc.ps1 records how it was invoked, so dot-sourcing the
generated root importer proves the wiring without loading a platform.
```
