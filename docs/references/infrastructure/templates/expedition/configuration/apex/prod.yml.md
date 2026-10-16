---
catzc:
  derived:
    path: docs/references/infrastructure/templates/expedition/configuration/apex/prod.yml.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "85b062cfbaf8"
---

# infrastructure/templates/expedition/configuration/apex/prod.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `ParametersFile:`, written with `#`.

```text
expedition, apex prod (customer apex, apex_prod subscription): in the apex prod spoke, registered in the prod
hub's private DNS zones. Production class: a provisioned database with geo backups, zone-redundant by the
template default.
```
