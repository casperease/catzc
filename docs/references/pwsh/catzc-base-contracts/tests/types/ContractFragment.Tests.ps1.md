# pwsh/Base.Contracts/tests/types/ContractFragment.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ContractFragment'`, written with `#`.

```text
ContractFragment checks that a real file contains a fragment
([ADR-REPO-CONTRACT-CONTRACTASSET](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-contractasset)): JSON and YAML by key subset, any
other text by its non-blank lines in order. Each rule has a passing and a failing target.
```
