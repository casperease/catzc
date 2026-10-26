# pwsh/Base.Contracts/tests/types/ContractCheckResult.Tests.ps1

Tests `ContractCheckResult`, the result of checking one contract asset
([ADR-REPO-CONTRACT-PROVENBYTESTS](../../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests)): `Passed` is
derived from the findings, and it renders console-ready
([ADR-BCL-TYPES-CONSOLEREADYTOSTRING](../../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-consolereadytostring)).
