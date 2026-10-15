---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/types/AzureSubscription.cs.md
    kind: comment-page
    body_sha: be3ac3b7329b
    adrs: []
---

# automation/Catzc.Azure/types/AzureSubscription.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A resolved subscription identity: a named Azure subscription, the Entra tenant that owns it, and —
for customer subscriptions only — the customer it serves. A mid node of the identity graph
(Tenant ← AzureSubscription ← AzureEnvironment). Mirrors a `subscriptions` entry in configs/azure.yml,
so the property names are the YAML keys verbatim.
```

## comment:2

Above `public string customer { get; }`.

```text
The customer this subscription serves; this value renders into customer resource names. Null for a
non-customer (platform/shared) subscription, so a typed null-check separates the two kinds.
```
