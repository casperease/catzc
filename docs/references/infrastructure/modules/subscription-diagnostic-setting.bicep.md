---
catzc:
  derived:
    path: docs/references/infrastructure/modules/subscription-diagnostic-setting.bicep.md
    kind: comment-page
    body_sha: aa9262f43991
---

# infrastructure/modules/subscription-diagnostic-setting.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `targetScope = 'subscription'`.

```text
Reusable bicep module: a diagnostic setting at subscription scope that sends the subscription's
activity log to a Log Analytics workspace (which may live in another subscription). Resource-level
settings use diagnostic-setting.bicep. `az bicep build` inlines it.
```
