---
catzc:
  derived:
    path: docs/references/infrastructure/modules/private-endpoint.bicep.md
    kind: comment-page
    body_sha: "6cad842c51ba"
    adrs: []
---

# infrastructure/modules/private-endpoint.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Private endpoint name (2-64 characters, unique within the...`.

```text
Reusable bicep module: a private endpoint for one sub-resource of a target service (the `blob` of a
storage account, the `sqlServer` of a SQL server), placed in a subnet, with a private DNS zone group
that registers its address in the given private DNS zones (which may live in the hub's
subscription). `az bicep build` inlines it.
```
