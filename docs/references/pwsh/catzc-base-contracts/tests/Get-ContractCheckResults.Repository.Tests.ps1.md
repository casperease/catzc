# pwsh/Base.Contracts/tests/Get-ContractCheckResults.Repository.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ContractCheckResults on the repository'`, written with `#`.

```text
Get-ContractCheckResults runs on the repository's own contracts/ tree
([ADR-REPO-CONTRACT-PROVENBYTESTS](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-provenbytests)): checking every asset of every
unit's draft returns one result per asset, without error. That every asset passes is the contracts quality gate's work.
```
