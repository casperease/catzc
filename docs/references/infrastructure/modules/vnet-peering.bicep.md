---
catzc:
  derived:
    path: docs/references/infrastructure/modules/vnet-peering.bicep.md
    kind: comment-page
    body_sha: "6e9d6d286125"
---

# infrastructure/modules/vnet-peering.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Name of the existing local virtual network (in the deployment...`.

```text
Reusable bicep module: one side of a virtual network peering, on a local VNet towards a remote VNet
(which may live in another subscription). A peering is two-sided: the hub deploys hub -> spoke and
the spoke deploys spoke -> hub, each with this module. `az bicep build` inlines it.
```
