---
catzc:
  derived:
    path: docs/references/infrastructure/modules/log-analytics.bicep.md
    kind: comment-page
    body_sha: "84f3fc913e58"
    adrs: []
    links: []
---

# infrastructure/modules/log-analytics.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `@description('Log Analytics workspace name.')`.

```text
Reusable bicep module: a Log Analytics workspace. Templates reference it with a relative `module`
declaration (../../modules/log-analytics.bicep); `az bicep build` inlines it.
```
