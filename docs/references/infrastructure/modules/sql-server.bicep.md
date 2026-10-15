---
catzc:
  derived:
    path: docs/references/infrastructure/modules/sql-server.bicep.md
    kind: comment-page
    body_sha: "495641efb43f"
    adrs: []
---

# infrastructure/modules/sql-server.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('SQL logical server name (1-63 lowercase, globally unique).')`.

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
