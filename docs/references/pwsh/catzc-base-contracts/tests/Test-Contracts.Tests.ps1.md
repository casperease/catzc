# pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-Contracts'`, written with `#`.

```text
Test-Contracts runs every asset of each unit's current version folder, and the provided assets of every released
folder, through its kind's check, checks every released folder against its .frozen record, and reports every finding
as one issue ([ADR-REPO-CONTRACT-PROVENBYTESTS](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests),
[ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable),
[ADR-AUTO-TEST-QUALITYGATE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). Fixtures are a widget repository in
TestDrive, its assets under contracts/widget/<version>/Catzc.Widget/, a released folder frozen by
Publish-ContractRelease ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)); the settings
are mocked, so the logic tests read no shipped config. The checks themselves are pinned by
Get-ContractCheckResults.Tests.ps1, the freeze comparison by Get-ContractFreezeFindings.Tests.ps1.
```

## comment:2

Above `Describe 'Test-Contracts on the repository'`, written with `#`.

```text
The repository's own contracts/ tree, through the quality gate. It reads only the repository's files, so its answer
cannot differ between the run modes (source-only).
```
