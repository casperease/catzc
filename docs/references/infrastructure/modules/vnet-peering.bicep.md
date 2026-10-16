---
catzc:
  derived:
    path: docs/references/infrastructure/modules/vnet-peering.bicep.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f5934d1be60a
---

# infrastructure/modules/vnet-peering.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('Name of the existing local virtual network (in the deployment...`, written with `//`.

```text
Reusable bicep module: one side of a virtual network peering, on a local VNet towards a remote VNet
(which may live in another subscription). A peering is two-sided: the hub deploys hub -> spoke and
the spoke deploys spoke -> hub, each with this module. `az bicep build` inlines it.
```
