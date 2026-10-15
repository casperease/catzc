---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Get-LoadedTypeDrift.Tests.ps1.md
    kind: test-asset
    body_sha: "8505fdc05eee"
    adrs:
      - ADR-AUTO-TYPES#12
---

# automation/.internal/tests/Get-LoadedTypeDrift.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
Get-LoadedTypeDrift over fixture code roots in $TestDrive. A fixture source named for a type this process has
loaded (Catzc.Base.Objects/ConsoleText) counts as loaded; a neutral one (Catzc.Widget/Gadget) never is. Each case
writes its own session record for its own fixture root, and removes it after, so the real roots' records are
untouched ([ADR-AUTO-TYPES#12](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types12)).
```
