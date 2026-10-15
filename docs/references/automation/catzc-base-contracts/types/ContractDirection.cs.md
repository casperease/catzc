# docs/references/automation/catzc-base-contracts/types/ContractDirection.cs.md

`automation/Catzc.Base.Contracts/types/ContractDirection.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Contracts;`.

```text
The direction of a contract asset ([ADR-REPO-CONTRACT#1](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract1),
[ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)): DependedOn is what an outside
platform expects of our files and calls; Provided is what an outside consumer may rely on. By convention an asset
that constrains a real repository file is DependedOn and a sample payload is Provided; a per-version contract.yml
overrides a single asset.
```
