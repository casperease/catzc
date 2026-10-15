---
catzc:
  derived:
    path: docs/references/infrastructure/modules/budget.bicep.md
    kind: reference
    body_sha: "7dfd5da36da1"
    adrs: []
---

# infrastructure/modules/budget.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `targetScope = 'subscription'`.

```text
Reusable bicep module: a cost budget at subscription scope, with one alert per threshold. Alerts go
to the holders of the listed subscription roles (Owner by default), so no email address is kept in
configuration. `az bicep build` inlines it.
```
