---
catzc:
  immutable:
    with_body_sha: e957048a989c
    repo_status: locked
    path: docs/references/infrastructure/modules/vm.bicep.md
    folder: docs/references/infrastructure/modules
    name: vm-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/modules/vm.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('VM name. Also used as the Windows computer name, so keep it <=...`, written with `//`.

```text
Reusable bicep module: a Windows virtual machine with its NIC and a dynamic public IP. Takes an
existing subnet (create the vnet with ../../modules/virtual-network.bicep and pass one of its subnetIds).
Cheapest SKU by default (Standard_B1s) — this is a PoC VM. `az bicep build` inlines it.
```
