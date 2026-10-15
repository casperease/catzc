---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Split-CachedFile.Tests.ps1.md
    kind: test-asset
    body_sha: fd1394ef0742
    adrs:
      - ADR-AUTO-CACHE#10
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Split-CachedFile' -Tag 'L0', 'logic', 'ADR-AUTO-CACHE#10' {`.

```text
The result-cache halves shared by Format-Code and the analyzer: Split-CachedFile reads, Update-ResultCache writes,
Get-ContentStamp fingerprints a check's inputs ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)).
Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
