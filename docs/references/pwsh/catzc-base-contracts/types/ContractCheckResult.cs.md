# pwsh/Base.Contracts/types/ContractCheckResult.cs

The result of checking one contract asset against the repository, as `Get-ContractCheckResults` returns it
([ADR-REPO-CONTRACT-PROVENBYTESTS](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests),
[ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)). A result type, not a
config mirror, so the properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Properties

- **`Asset`** — the `ContractAsset` checked.
- **`Passed`** — true when the check found nothing; derived from `Findings`, never set apart from them.
- **`Findings`** — one precise, human-readable message per way the repository breaks the asset, in the order found; empty when it passed.

Construction rejects a missing asset and a blank finding. No findings at all (null or empty) is a pass.
