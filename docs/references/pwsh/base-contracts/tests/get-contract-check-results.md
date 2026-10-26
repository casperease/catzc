# pwsh/Base.Contracts/tests/Get-ContractCheckResults.Tests.ps1

Tests `Get-ContractCheckResults`, which checks each contract asset against the real tree by its kind
([ADR-REPO-CONTRACT-PROVENBYTESTS](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests),
[ADR-REPO-CONTRACT-CONTRACTASSET](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)) and returns one result
per asset; a failed check is a result, never an exception. Every kind has a passing and a failing case.

## Fixtures

A widget repository in `TestDrive:`, its assets under `contracts/widget/`. A helper adds an asset by the path of the file it binds, as a
fragment or schema does; a sample, a command contract and the schema of a sample sit in the group their folder names, under the provided
root.
