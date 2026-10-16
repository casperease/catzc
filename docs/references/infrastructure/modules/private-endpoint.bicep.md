---
catzc:
  immutable:
    with_body_sha: "308ec18c7d76"
    path: docs/references/infrastructure/modules/private-endpoint.bicep.md
    folder: docs/references/infrastructure/modules
    name: private-endpoint-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/modules/private-endpoint.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('Private endpoint name (2-64 characters, unique within the...`, written with `//`.

```text
Reusable bicep module: a private endpoint for one sub-resource of a target service (the `blob` of a
storage account, the `sqlServer` of a SQL server), placed in a subnet, with a private DNS zone group
that registers its address in the given private DNS zones (which may live in the hub's
subscription). `az bicep build` inlines it.
```
