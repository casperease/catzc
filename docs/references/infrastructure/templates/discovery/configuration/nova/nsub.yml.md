---
catzc:
  immutable:
    with_body_sha: c6d4ff513794
    path: docs/references/infrastructure/templates/discovery/configuration/nova/nsub.yml.md
    folder: docs/references/infrastructure/templates/discovery/configuration/nova
    name: nsub-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/templates/discovery/configuration/nova/nsub.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
discovery, nova nonprod subscription (env nsub, customer nova): a spoke. The kind and the ranges come from
network.yml by config address; the spoke peers to the nonprod hub. nova is dev-only -> nonprod only.
```
