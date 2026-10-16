---
catzc:
  immutable:
    with_body_sha: "4c2b0eba9568"
    path: docs/references/infrastructure/modules/sql-database.bicep.md
    folder: docs/references/infrastructure/modules
    name: sql-database-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/modules/sql-database.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('Name of the existing SQL logical server that hosts this...`, written with `//`.

```text
Reusable bicep module: a single SQL database on an existing logical server, with the Well-Architected
defaults — zone redundancy wherever the tier supports it, geo-redundant backup storage, and a
short-term backup retention policy. Serverless SKUs (`GP_S_Gen5`) take an auto-pause delay and a
minimum capacity. Templates reference it with a relative `module` declaration
(../../modules/sql-database.bicep); `az bicep build` inlines it.
```
