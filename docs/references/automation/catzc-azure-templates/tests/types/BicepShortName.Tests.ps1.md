---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
    kind: test-asset
    body_sha: "513d3520a180"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AZ-NAMING#2
---

# automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1

<!-- cspell:ignore deriv abcdef gadge gadgetry getry gadg -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Context 'Derive (folder name -> short_name)' {`.

```text
The C# type that owns short_name derivation + validation
([ADR-AZ-NAMING#2](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming2)).
Loaded by the Import-CSharpTypes pre-pass; referenced by FQN here. Neutral fixture template names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
