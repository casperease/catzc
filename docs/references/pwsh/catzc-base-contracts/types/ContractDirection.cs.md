# pwsh/Catzc.Base.Contracts/types/ContractDirection.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Contracts;`, written with `//`.

```text
The direction of a contract asset ([ADR-REPO-CONTRACT-BINDINGINTERFACE](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-bindinginterface),
[ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract-directionbyconvention)): DependedOn is what an outside
platform expects of our files and calls; Provided is what an outside consumer may rely on. By convention an asset
that constrains a real repository file is DependedOn and a sample payload is Provided; a per-version contract.yml
overrides a single asset.
```
