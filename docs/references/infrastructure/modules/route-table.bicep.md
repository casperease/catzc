---
catzc:
  derived:
    path: docs/references/infrastructure/modules/route-table.bicep.md
    kind: comment-page
    body_sha: adb808ebd2dd
---

# infrastructure/modules/route-table.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Route table name (1-80 characters, unique within the resource...`.

```text
Reusable bicep module: a route table (user-defined routes). The caller passes the routes in the ARM
`routes` shape ({ name, properties: { addressPrefix, nextHopType, nextHopIpAddress? } }). Attach it
to a subnet through virtual-network.bicep or subnet.bicep. `az bicep build` inlines it.
```
