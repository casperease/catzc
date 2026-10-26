# pwsh/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ContractAssetNote'`, written with `#`.

```text
A contract asset's note is the header comment its file can carry without changing what its check compares
([ADR-REPO-CONTRACT-CONTRACTASSET](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): a YAML asset's leading '#' lines,
a schema's "$comment", and nothing for every other asset. Fixtures are a widget repository in TestDrive
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `$manifest = Join-Path $script:root 'contracts/widget/0.1.0/contract.yml'`, written with `#`.

```text
Every fixture written so far stays named, so a second note in the same test still finds the first
bound.
```
