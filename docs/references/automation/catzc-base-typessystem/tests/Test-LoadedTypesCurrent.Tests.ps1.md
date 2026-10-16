---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/tests/Test-LoadedTypesCurrent.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: b27b49261129
    adrs:
      - ADR-AUTO-TEST#{3,6}
      - ADR-AUTO-TYPES#15
---

# automation/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-LoadedTypesCurrent' -Tag 'L0', 'logic', 'ADR-AUTO-TYPES#15' {`, written with `#`.

```text
Test-LoadedTypesCurrent with the one measurement (Get-LoadedTypeDrift, in Catzc.Internal.Types) mocked at the module
boundary ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)); its own logic is tested in
.internal/tests/Get-LoadedTypeDrift.Tests.ps1. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
