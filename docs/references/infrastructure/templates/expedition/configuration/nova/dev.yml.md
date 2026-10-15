---
catzc:
  derived:
    path: docs/references/infrastructure/templates/expedition/configuration/nova/dev.yml.md
    kind: comment-page
    body_sha: "94290169c2cf"
    adrs: []
    links: []
---

# infrastructure/templates/expedition/configuration/nova/dev.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `ParametersFile:`.

```text
expedition, nova dev (customer nova, nova_nonprod subscription): in the nova nonprod spoke, registered in the
nonprod hub's private DNS zones. Nonprod class: a serverless database that pauses when idle.
```
