---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-BicepFormat.Tests.ps1.md
    kind: test-asset
    body_sha: e15ec05eca03
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Invoke-BicepFormat' -Tag 'L0', 'logic' {`.

```text
The bicep engine with the tool boundary mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
the probe finds a managed Bicep CLI, and the mock writes the --outfile copy the engine compares. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {`.

```text
The fake formatter collapses runs of spaces in every file the --pattern names, in place, as `bicep format
--pattern` does.
```
