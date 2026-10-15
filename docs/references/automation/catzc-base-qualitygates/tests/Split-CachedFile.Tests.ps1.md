---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Split-CachedFile.Tests.ps1.md
    kind: comment-page
    body_sha: "05d20c8d4a2f"
    adrs:
      - ADR-AUTO-CACHE#10
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Split-CachedFile' -Tag 'L0', 'logic', 'ADR-AUTO-CACHE#10' {`, written with `#`.

```text
The result-cache halves shared by Format-Code and the analyzer: Split-CachedFile reads, Update-ResultCache writes,
Get-ContentStamp fingerprints a check's inputs ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)).
Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
