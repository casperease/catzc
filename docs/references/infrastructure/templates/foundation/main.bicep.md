---
catzc:
  derived:
    path: docs/references/infrastructure/templates/foundation/main.bicep.md
    kind: reference
    body_sha: "68583318f4f6"
    adrs: []
---

# infrastructure/templates/foundation/main.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `param location string = resourceGroup().location`.

```text
foundation — the once-per-subscription baseline: a Log Analytics workspace + a Key Vault. Deployed
once per subscription (envs nsub/psub), in the shared subscription and in each customer's. The Key
Vault holds shared secrets for that subscription — notably the SQL admin password that consuming
templates reference. Resources come from the reusable modules in infrastructure/modules/.
```
