# pwsh/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ContractCheckResults' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-ContractCheckResults checks each contract asset against the real tree by its kind
([ADR-REPO-CONTRACT-PROVENBYTESTS](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-provenbytests),
[ADR-REPO-CONTRACT-CONTRACTASSET](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-contractasset)) and returns one result per asset; a
failed check is a result, never an exception. Every kind has a passing and a failing case. Fixtures are a widget
repository in TestDrive, its assets under contracts/widget/0.0.0/Catzc.Widget/.
```
