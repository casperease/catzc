---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/tests/New-CatzcNuGetPackage.Tests.ps1.md
    kind: test-asset
    body_sha: "50e4f7f4a705"
    adrs:
      - ADR-AUTO-TEST#20
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1

<!-- cspell:ignore nfunction -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:source = Join-Path $TestDrive...`.

```text
A minimal fixture build (neutral names,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)), packed ONCE: every
assertion below is a facet
of the one pack ([ADR-AUTO-TEST#20](/docs/adr/automation/test-automation.md#rule-adr-auto-test20)) —
Compress-PSResource costs real time.
```
