---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/types/Tenant.cs.md
    kind: comment-page
    body_sha: a62e246cee2c
    adrs: []
    links: []
---

# automation/Catzc.Azure/types/Tenant.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
An Entra ID tenant — the directory boundary that owns one or more subscriptions. The leaf of the
resolved identity graph (Tenant ← AzureSubscription ← AzureEnvironment). Mirrors one entry of the
`tenants` map in configs/azure.yml, so the property names are the YAML keys verbatim.
```
