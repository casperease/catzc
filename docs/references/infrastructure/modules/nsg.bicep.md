---
catzc:
  derived:
    path: docs/references/infrastructure/modules/nsg.bicep.md
    kind: comment-page
    body_sha: "11a43e56100a"
---

# infrastructure/modules/nsg.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Network security group name (1-80 characters, unique within the...`.

```text
Reusable bicep module: a network security group. The caller passes the rules in the ARM
`securityRules` shape ({ name, properties: { priority, direction, access, protocol, … } }); the
Azure default rules (allow VNet and load-balancer inbound, deny all other inbound) always apply
beneath them. Attach it to a subnet through virtual-network.bicep or subnet.bicep. `az bicep build`
inlines it.
```
