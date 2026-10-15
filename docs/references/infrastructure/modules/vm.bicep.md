---
catzc:
  derived:
    path: docs/references/infrastructure/modules/vm.bicep.md
    kind: comment-page
    body_sha: d05b845ae536
---

# infrastructure/modules/vm.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('VM name. Also used as the Windows computer name, so keep it <=...`.

```text
Reusable bicep module: a Windows virtual machine with its NIC and a dynamic public IP. Takes an
existing subnet (create the vnet with ../../modules/virtual-network.bicep and pass one of its subnetIds).
Cheapest SKU by default (Standard_B1s) — this is a PoC VM. `az bicep build` inlines it.
```
