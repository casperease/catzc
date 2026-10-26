# pwsh/Base.Contracts/tests/Build-ContractReference.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Build-ContractReference'`, written with `#`.

```text
Build-ContractReference writes one page per unit, docs/references/contracts/<unit>.md, listing each version folder's
assets with their notes ([ADR-REPO-CONTRACT-LAYOUT](/docs/drs/repository/api-contracts.md#rule-adr-repo-contract-layout)), as a
committed generated page ([ADR-REPO-README-AUTHOREDSOURCES](/docs/drs/repository/generated-readmes.md#rule-adr-repo-readme-authoredsources)).
Fixtures are a widget repository in TestDrive ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Describe 'Build-ContractReference — generated contract reference'`, written with `#`.

```text
The real contract reference against the real contracts/ tree: the committed pages are what the writer would write now.
Reads only the repository's files.
```
