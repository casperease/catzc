---
catzc:
  derived:
    path: docs/references/infrastructure/modules/private-dns-zone.bicep.md
    kind: comment-page
    body_sha: a9644e681721
---

# infrastructure/modules/private-dns-zone.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('Zone name, e.g. privatelink.database.windows.net.')`, written with `//`.

```text
Reusable bicep module: a private DNS zone (e.g. privatelink.blob.core.windows.net) with a virtual
network link to each listed VNet, which may live in other subscriptions. The hub owns the zones and
links them to every spoke, so a private endpoint registered in a zone resolves from any linked VNet.
Each link is named after its VNet. `az bicep build` inlines it.
```
