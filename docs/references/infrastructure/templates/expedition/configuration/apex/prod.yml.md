---
catzc:
  derived:
    path: docs/references/infrastructure/templates/expedition/configuration/apex/prod.yml.md
    kind: reference
    body_sha: "980ff1237dbc"
    adrs: []
---

# infrastructure/templates/expedition/configuration/apex/prod.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `ParametersFile:`.

```text
expedition, apex prod (customer apex, apex_prod subscription): in the apex prod spoke, registered in the prod
hub's private DNS zones. Production class: a provisioned database with geo backups, zone-redundant by the
template default.
```
