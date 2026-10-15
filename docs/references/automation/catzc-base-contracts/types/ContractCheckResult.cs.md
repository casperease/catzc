# docs/references/automation/catzc-base-contracts/types/ContractCheckResult.cs.md

`automation/Catzc.Base.Contracts/types/ContractCheckResult.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

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
