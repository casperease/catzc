---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-ImprintStep.Tests.ps1.md
    kind: test-asset
    body_sha: "861d34f27069"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-REPO-FORMAT#8
---

# automation/Catzc.Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Invoke-ImprintStep' -Tag 'L0', 'logic', 'ADR-REPO-FORMAT#8' {`.

```text
Invoke-ImprintStep with its seams mocked: the registries (Get-Config) and the C# namespace command (Format-Types), over fixture files
in $TestDrive. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
