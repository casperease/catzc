# pwsh/Base.Contracts/tests/types/ContractValue.Tests.ps1

Tests `ContractValue`, which reads a parsed JSON or YAML value as one of the JSON kinds and compares two values by JSON equality
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)), whatever CLR type
each parser chose.
