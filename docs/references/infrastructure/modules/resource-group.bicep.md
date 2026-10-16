---
catzc:
  immutable:
    with_body_sha: "043e7da02e27"
    repo_status: locked
    path: docs/references/infrastructure/modules/resource-group.bicep.md
    folder: docs/references/infrastructure/modules
    name: resource-group-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
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
