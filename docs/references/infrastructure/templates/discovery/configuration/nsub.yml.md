---
catzc:
  derived:
    path: docs/references/infrastructure/templates/discovery/configuration/nsub.yml.md
    kind: comment-page
    body_sha: c5f4b69adf8d
---

# infrastructure/templates/discovery/configuration/nsub.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
discovery, shared nonprod subscription (env nsub): the nonprod hub. The kind and the ranges come from
network.yml by config address; the hub peers to the nonprod spokes and links its private DNS zones to them.
```
