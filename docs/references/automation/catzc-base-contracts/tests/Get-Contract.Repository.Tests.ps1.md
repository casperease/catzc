# automation/Catzc.Base.Contracts/tests/Get-Contract.Repository.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-Contract on the repository' -Tag 'L1', 'integrity',...`, written with `#`.

```text
Get-Contract runs on the repository's own contracts/ tree
([ADR-REPO-CONTRACT#2](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract2)): the shipped layout lists without
error, and every asset it lists carries a kind, a direction, and paths in communication form.
```
