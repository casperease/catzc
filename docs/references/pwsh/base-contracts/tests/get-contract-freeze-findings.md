# pwsh/Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1

Tests `Get-ContractFreezeFindings`. A released version folder is immutable
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)): the command
compares its files with the `.frozen` record `Get-ContractFileHashes` wrote at the freeze. Fixtures are a widget version folder in
`TestDrive:`
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

## The real tree

A second block discovers every released version folder in the repository's `contracts/` tree, one case each: a folder changed since its
release fails here. Released folders are every version folder from 1.0.0 up; a tree with none discovers no case. It reads only the
repository's files, so its answer cannot differ between the run modes (source-only).
