# docs/references/infrastructure/modules/sql-database.bicep.md

`infrastructure/modules/sql-database.bicep`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Name of the existing SQL logical server that hosts this...`.

```text
Reusable bicep module: a single SQL database on an existing logical server, with the Well-Architected
defaults — zone redundancy wherever the tier supports it, geo-redundant backup storage, and a
short-term backup retention policy. Serverless SKUs (`GP_S_Gen5`) take an auto-pause delay and a
minimum capacity. Templates reference it with a relative `module` declaration
(../../modules/sql-database.bicep); `az bicep build` inlines it.
```
