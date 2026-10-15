---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/types/SubscriptionContext.cs.md
    kind: comment-page
    body_sha: f6044ce64c83
    adrs: []
    links: []
---

# automation/Catzc.Azure.Cli/types/SubscriptionContext.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A snapshot of the az CLI's currently active subscription (the shape of `az account show`). Captured so
it can be saved and later restored around a subscription switch.
```
