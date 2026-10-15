---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/tests/Assert-LoadedTypesCurrent.Tests.ps1.md
    kind: comment-page
    body_sha: "90add94c66ec"
    adrs:
      - ADR-AUTO-TEST#{3,6}
      - ADR-AUTO-TYPES#15
---

# automation/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Assert-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#15' {`, written with `#`.

```text
Assert-LoadedTypesCurrent with the one measurement (Get-LoadedTypeDrift, in Catzc.Internal.Types) mocked at the
module boundary ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)). Neutral fixture
names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
