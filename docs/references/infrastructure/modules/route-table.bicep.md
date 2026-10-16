---
catzc:
  immutable:
    with_body_sha: "81e9bb4c7e5a"
    repo_status: locked
    path: docs/references/infrastructure/modules/route-table.bicep.md
    folder: docs/references/infrastructure/modules
    name: route-table-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/modules/route-table.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('Route table name (1-80 characters, unique within the resource...`, written with `//`.

```text
Reusable bicep module: a route table (user-defined routes). The caller passes the routes in the ARM
`routes` shape ({ name, properties: { addressPrefix, nextHopType, nextHopIpAddress? } }). Attach it
to a subnet through virtual-network.bicep or subnet.bicep. `az bicep build` inlines it.
```
