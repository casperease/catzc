---
catzc:
  derived:
    path: docs/references/infrastructure/templates/expedition/configuration/apex/dev.yml.md
    folder: docs/references/infrastructure/templates/expedition/configuration/apex
    name: dev-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "401fe45a1c96"
---

# infrastructure/templates/expedition/configuration/apex/dev.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
expedition, apex dev (customer apex, apex_nonprod subscription): in the apex nonprod spoke, registered in
the nonprod hub's private DNS zones. Nonprod class: a serverless database that pauses when idle.
```
