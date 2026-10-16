---
catzc:
  immutable:
    with_body_sha: a29cb678bfb3
    path: docs/references/automation/catzc-azure/types/AzureSubscription.cs.md
    folder: docs/references/automation/catzc-azure/types
    name: azure-subscription-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure/types/AzureSubscription.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A resolved subscription identity: a named Azure subscription, the Entra tenant that owns it, and —
for customer subscriptions only — the customer it serves. A mid node of the identity graph
(Tenant ← AzureSubscription ← AzureEnvironment). Mirrors a `subscriptions` entry in configs/azure.yml,
so the property names are the YAML keys verbatim.
```

## comment:2

Above `public string customer { get; }`, written with `//`.

```text
The customer this subscription serves; this value renders into customer resource names. Null for a
non-customer (platform/shared) subscription, so a typed null-check separates the two kinds.
```
