---
catzc:
  derived:
    path: docs/references/infrastructure/modules/sql-server.bicep.md
    folder: docs/references/infrastructure/modules
    name: sql-server-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: bbdebac4eda9
---

# infrastructure/modules/sql-server.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('SQL logical server name (1-63 lowercase, globally unique).')`, written with `//`.

```text
Reusable bicep module: a SQL logical server with the Well-Architected defaults — an Entra ID
administrator (a group by default), Entra-only authentication, no public network access, TLS 1.2
minimum, and a system-assigned managed identity. Reach it through a private endpoint
(../../modules/private-endpoint.bicep, group id `sqlServer`). Databases are separate
(../../modules/sql-database.bicep). Templates reference it with a relative `module` declaration;
`az bicep build` inlines it.

A break-glass SQL login is opt-in: pass `entraOnlyAuthentication: false` together with
`administratorLogin` and `administratorLoginPassword` (the password as a Key Vault reference).
```
