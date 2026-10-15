---
catzc:
  derived:
    path: docs/references/infrastructure/modules/private-dns-zone.bicep.md
    kind: comment-page
    body_sha: ea5e0f2b0b8a
---

# infrastructure/modules/private-dns-zone.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Zone name, e.g. privatelink.database.windows.net.')`.

```text
Reusable bicep module: a private DNS zone (e.g. privatelink.blob.core.windows.net) with a virtual
network link to each listed VNet, which may live in other subscriptions. The hub owns the zones and
links them to every spoke, so a private endpoint registered in a zone resolves from any linked VNet.
Each link is named after its VNet. `az bicep build` inlines it.
```
