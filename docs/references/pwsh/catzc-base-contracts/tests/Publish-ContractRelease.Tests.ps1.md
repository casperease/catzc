# pwsh/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Publish-ContractRelease' -Tag 'L0', 'logic',...`, written with `#`.

```text
Publish-ContractRelease freezes a unit's draft as a released version folder
([ADR-REPO-CONTRACT-RELEASEDIMMUTABLE](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-releasedimmutable)): an exact copy plus its .frozen
record, refusing the draft itself, the devbox build version, and a folder that exists. Fixtures are a widget
repository in TestDrive ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)); the settings
are mocked, so the logic tests read no shipped config.
```

## comment:2

Above `$paths = [string[]] @(Get-ChildPath $folder -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A whole-tree walk ([ADR-PWSH-ENUM-ALWAYSBOUNDED](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): the
frozen copy is compared file for file, so nothing is pruned.
```
