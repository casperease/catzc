# pwsh/Base.Contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1

Tests every binding contract asset of the repository, one case each, generated at discovery, so `Test-Automation` proves every contract with
no hand-written test ([ADR-REPO-CONTRACT-PROVENBYTESTS](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests)).

## The set

The set is the one `Test-Contracts` checks on a devbox: every asset of each root's current version folder, and the provided assets of every
released version folder still in the tree, since released folders are the pin record. The depended-on assets of a released folder follow
their platform and are not checked
([ADR-REPO-CONTRACT-KEPTWHILEPINNED](../../../../drs/repository/api-contracts.md#rule-adr-repo-contract-keptwhilepinned)).

## Behaviour

Each case checks its asset by its kind and fails with the asset's findings. A tree with no assets discovers no case. One lookup per root,
version and group is made once and shared by every case
([ADR-AUTO-TEST-SETUPONCE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-setuponce)). The file reads only the
repository's files, so its answer cannot differ between the run modes (source-only).
