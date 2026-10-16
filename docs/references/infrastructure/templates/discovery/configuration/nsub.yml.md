---
catzc:
  immutable:
    with_body_sha: c5f4b69adf8d
    path: docs/references/infrastructure/templates/discovery/configuration/nsub.yml.md
    folder: docs/references/infrastructure/templates/discovery/configuration
    name: nsub-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
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
