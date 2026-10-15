---
catzc:
  derived:
    path: docs/references/automation/catzc-base-contracts/types/ContractAssetKind.cs.md
    kind: comment-page
    body_sha: "362c50782a72"
    adrs:
      - ADR-REPO-CONTRACT#6
---

# automation/Catzc.Base.Contracts/types/ContractAssetKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Contracts;`.

```text
The kind of a contract asset, picked by its name alone
([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): Presence is an empty fragment (the
real file must exist); Fragment is a file with no suffix (the real file must exist and contain it); Schema is
`<path>.schema.json` (a JSON Schema the real file at `<path>`, or the sample payload of the same name beside it, validates
against); Sample is `<name>.sample.<ext>` (a payload the owning module's tests produce or parse).
```
