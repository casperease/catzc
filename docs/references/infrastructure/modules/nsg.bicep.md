---
catzc:
  immutable:
    with_body_sha: "5c9e3b705c1b"
    path: docs/references/infrastructure/modules/nsg.bicep.md
    folder: docs/references/infrastructure/modules
    name: nsg-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/modules/nsg.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('Network security group name (1-80 characters, unique within the...`, written with `//`.

```text
Reusable bicep module: a network security group. The caller passes the rules in the ARM
`securityRules` shape ({ name, properties: { priority, direction, access, protocol, … } }); the
Azure default rules (allow VNet and load-balancer inbound, deny all other inbound) always apply
beneath them. Attach it to a subnet through virtual-network.bicep or subnet.bicep. `az bicep build`
inlines it.
```
