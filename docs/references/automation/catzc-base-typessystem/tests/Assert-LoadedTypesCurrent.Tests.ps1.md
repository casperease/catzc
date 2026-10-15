---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/tests/Assert-LoadedTypesCurrent.Tests.ps1.md
    kind: test-asset
    body_sha: b6d76d8b9e59
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#6
      - ADR-AUTO-TYPES#15
---

# automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Assert-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#15' {`.

```text
Assert-LoadedTypesCurrent with the one measurement (Get-LoadedTypeDrift, in Catzc.Internal.Types) mocked at the
module boundary ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)). Neutral fixture
names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
