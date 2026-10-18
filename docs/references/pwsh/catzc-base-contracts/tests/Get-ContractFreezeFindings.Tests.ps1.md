# automation/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ContractFreezeFindings' -Tag 'L0', 'logic',...`, written with `#`.

```text
A released version folder is immutable ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)):
Get-ContractFreezeFindings compares its files with the .frozen record Get-ContractFileHashes wrote at the freeze.
Fixtures are a widget version folder in TestDrive ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `BeforeDiscovery {`, written with `#`.

```text
Every released version folder in the repository's contracts/ tree, one test each, discovered from the tree: a folder
changed since its release fails here ([ADR-REPO-CONTRACT#5](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract5)).
Released folders are every version folder but the draft 0.0.0; a tree with none discovers no test. It reads only the
repository's files, so its answer cannot differ between the run modes (source-only).
```
