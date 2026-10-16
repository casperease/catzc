---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/types/ContractCheckResult.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "1a78cc7b4ea8"
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-CONTRACT#{4,6}
---

# automation/Catzc.Base.Contracts/types/ContractCheckResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The result of checking one contract asset against the repository
([ADR-REPO-CONTRACT#4](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract4),
[ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)), as Get-ContractCheckResults returns it.
A result type, not a config mirror, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
  Asset     the ContractAsset checked
  Passed    true when the check found nothing; derived from Findings, never set apart from them
  Findings  one precise, human-readable message per way the repository breaks the asset, in the order found; empty
            when it passed
Construction rejects a missing asset and a blank finding; no findings at all (null or empty) is a pass.
```
