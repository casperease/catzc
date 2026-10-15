---
catzc:
  derived:
    path: docs/references/infrastructure/modules/subnet.bicep.md
    kind: comment-page
    body_sha: ba94392f6e9d
    adrs: []
---

# infrastructure/modules/subnet.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Name of the existing virtual network (in the deployment...`.

```text
Reusable bicep module: one subnet added to an existing virtual network that the template does not
deploy itself. A VNet the template deploys declares all its subnets inline (virtual-network.bicep),
because redeploying a VNet without one of its subnets tries to delete it. `az bicep build` inlines it.
```
