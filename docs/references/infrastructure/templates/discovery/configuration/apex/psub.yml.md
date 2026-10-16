---
catzc:
  immutable:
    with_body_sha: afb19b22eeae
    repo_status: locked
    path: docs/references/infrastructure/templates/discovery/configuration/apex/psub.yml.md
    folder: docs/references/infrastructure/templates/discovery/configuration/apex
    name: psub-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/templates/discovery/configuration/apex/psub.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
discovery, apex prod subscription (env psub, customer apex): a spoke. The kind and the ranges come from
network.yml by config address; the spoke peers to the prod hub.
```
