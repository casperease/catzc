---
catzc:
  derived:
    path: docs/references/infrastructure/modules/resource-group.bicep.md
    kind: comment-page
    body_sha: bff4fc640bd3
    adrs: []
    links: []
---

# infrastructure/modules/resource-group.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `targetScope = 'subscription'`.

```text
Reusable bicep module: a resource group, deployed at subscription scope. A subscription-level template
(targetScope = 'subscription') creates its resource groups with it and then deploys resource-group
modules into them (`scope: resourceGroup(<name>)`). `az bicep build` inlines it.
```
