---
catzc:
  derived:
    path: docs/references/infrastructure/modules/virtual-network.bicep.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e83064f03359
---

# infrastructure/modules/virtual-network.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('A subnet of the virtual network.')`, written with `//`.

```text
Reusable bicep module: a virtual network with its subnets declared inline. A virtual network owns its
subnets: redeploying a VNet whose subnet list omits a subnet tries to delete that subnet, so the VNet a
template deploys lists every subnet here (subnet.bicep is for adding a subnet to a VNet the template
does not deploy). Each subnet may carry a network security group (nsg.bicep) and a route table
(route-table.bicep). Templates reference it with a relative `module` declaration
(../../modules/virtual-network.bicep); `az bicep build` inlines it.
```
