---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "041a1a0ff043"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AZ-NAMING#2
---

# automation/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1

<!-- cspell:ignore deriv abcdef gadge gadgetry getry gadg -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Context 'Derive (folder name -> short_name)' {`, written with `#`.

```text
The C# type that owns short_name derivation + validation
([ADR-AZ-NAMING#2](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming2)).
Loaded by the Import-CSharpTypes pre-pass; referenced by FQN here. Neutral fixture template names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
