---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/types/BicepSlot.cs.md
    kind: comment-page
    body_sha: "900edce83a54"
    adrs: []
---

# automation/Catzc.Azure.Templates/types/BicepSlot.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One deployable slot of a template: the unit binding one config file to one (customer?, environment,
slot) coordinate, which resolves to one subscription and one resource group. Nested into
BicepTemplate.slots — a template fans out into one BicepSlot per deployable coordinate.
```

## comment:2

Above `public string slot { get; }`.

```text
The slot discriminator within the environment. The empty string "" (NOT null) is the base/index-0
slot — kept as a sentinel because downstream resolves slots by value (`slot -eq ''` for the base).
```

## comment:3

Above `public string subscription { get; }`.

```text
The subscription this slot deploys into — resolved at discovery from the slot's coordinate: the
one non-customer subscription serving the env (a configuration-root config), or the customer's one
subscription serving it (a configuration/<customer>/ config). Always present.
```

## comment:4

Above `public string customer { get; }`.

```text
The customer this slot is for — the configuration subfolder name (a customer key). The empty
string "" (NOT null) for a configuration-root (shared) slot — a sentinel because downstream
filters by value (`customer -eq ''`).
```
