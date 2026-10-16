---
catzc:
  derived:
    path: docs/references/infrastructure/modules/resource-group.bicep.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "043e7da02e27"
---

# infrastructure/modules/resource-group.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `targetScope = 'subscription'`, written with `//`.

```text
Reusable bicep module: a resource group, deployed at subscription scope. A subscription-level template
(targetScope = 'subscription') creates its resource groups with it and then deploys resource-group
modules into them (`scope: resourceGroup(<name>)`). `az bicep build` inlines it.
```
