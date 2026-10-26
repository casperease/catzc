# pwsh/Base.Contracts/types/ContractCheckResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The result of checking one contract asset against the repository
([ADR-REPO-CONTRACT-PROVENBYTESTS](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests),
[ADR-REPO-CONTRACT-CONTRACTASSET](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)), as Get-ContractCheckResults returns it.
A result type, not a config mirror, so the properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
  Asset     the ContractAsset checked
  Passed    true when the check found nothing; derived from Findings, never set apart from them
  Findings  one precise, human-readable message per way the repository breaks the asset, in the order found; empty
            when it passed
Construction rejects a missing asset and a blank finding; no findings at all (null or empty) is a pass.
```
