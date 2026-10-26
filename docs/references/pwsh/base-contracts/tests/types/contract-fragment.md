# pwsh/Base.Contracts/tests/types/ContractFragment.Tests.ps1

Tests `ContractFragment`, which checks that a real file contains a fragment
([ADR-REPO-CONTRACT-CONTRACTASSET](../../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): JSON and YAML by
key subset, any other text by its non-blank lines in order. Each rule has a passing and a failing target.
