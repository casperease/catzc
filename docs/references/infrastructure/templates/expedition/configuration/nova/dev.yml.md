---
catzc:
  immutable:
    with_body_sha: "035ded2f9c82"
    path: docs/references/infrastructure/templates/expedition/configuration/nova/dev.yml.md
    folder: docs/references/infrastructure/templates/expedition/configuration/nova
    name: dev-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/templates/expedition/configuration/nova/dev.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
expedition, nova dev (customer nova, nova_nonprod subscription): in the nova nonprod spoke, registered in the
nonprod hub's private DNS zones. Nonprod class: a serverless database that pauses when idle.
```
