# pwsh/Base.Contracts/tests/Test-Contracts.Tests.ps1

Tests `Test-Contracts`, which runs every asset of each root's current version folder, and the provided assets of every released folder,
through its kind's check, checks every released folder against its `.frozen` record, and reports every finding as one issue
([ADR-REPO-CONTRACT-PROVENBYTESTS](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests),
[ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable),
[ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## Fixtures

A widget repository in `TestDrive:`, its assets under `contracts/widget/<version>/`, a released folder frozen by `Publish-ContractRelease`
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). The settings are
mocked, so the logic tests read no shipped config. The checks themselves are pinned by `Get-ContractCheckResults.Tests.ps1`, the freeze
comparison by `Get-ContractFreezeFindings.Tests.ps1`.

## The real tree

A second block runs the repository's own `contracts/` tree through the quality gate. It reads only the repository's files, so its answer
cannot differ between the run modes (source-only).
