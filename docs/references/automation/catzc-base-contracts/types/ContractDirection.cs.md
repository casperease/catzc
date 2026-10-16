---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/types/ContractDirection.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "93057ef1b5c9"
    adrs:
      - ADR-REPO-CONTRACT#{1,7}
---

# automation/Catzc.Base.Contracts/types/ContractDirection.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Contracts;`, written with `//`.

```text
The direction of a contract asset ([ADR-REPO-CONTRACT#1](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract1),
[ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)): DependedOn is what an outside
platform expects of our files and calls; Provided is what an outside consumer may rely on. By convention an asset
that constrains a real repository file is DependedOn and a sample payload is Provided; a per-version contract.yml
overrides a single asset.
```
