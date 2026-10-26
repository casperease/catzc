# pwsh/Base.Contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1

Tests `Get-ContractCheckResults` on the repository's own `contracts/` tree
([ADR-REPO-CONTRACT-PROVENBYTESTS](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests)): checking every asset
of every root's current version returns one result per asset, without error. That every asset passes is the contracts quality gate's work.
