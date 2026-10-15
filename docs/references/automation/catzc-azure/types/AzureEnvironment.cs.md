---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/types/AzureEnvironment.cs.md
    kind: comment-page
    body_sha: "2be360de1ee4"
    adrs: []
---

# automation/Catzc.Azure/types/AzureEnvironment.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A resolved environment identity: a named deployment environment paired with the subscription that
serves it. The root of the identity graph (AzureEnvironment → AzureSubscription → Tenant). The name and
short codes compose Azure resource names per the naming standard. Mirrors an `environments` entry in
configs/azure.yml (joined to its serving subscription), so the property names are the YAML keys.
```
