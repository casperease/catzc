---
catzc:
  immutable:
    with_body_sha: a63f865eb97f
    path: docs/references/infrastructure/templates/discovery/configuration/psub.yml.md
    folder: docs/references/infrastructure/templates/discovery/configuration
    name: psub-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/templates/discovery/configuration/psub.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
discovery, shared prod subscription (env psub): the prod hub. The kind and the ranges come from network.yml
by config address; the hub peers to the prod spokes and links its private DNS zones to them.
```
