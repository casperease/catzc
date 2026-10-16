---
catzc:
  immutable:
    with_body_sha: "3bd38a56a6d1"
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/types/BicepSlot.cs.md
    folder: docs/references/automation/catzc-azure-templates/types
    name: bicep-slot-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Templates/types/BicepSlot.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One deployable slot of a template: the unit binding one config file to one (customer?, environment,
slot) coordinate, which resolves to one subscription and one resource group. Nested into
BicepTemplate.slots — a template fans out into one BicepSlot per deployable coordinate.
```

## comment:2

Above `public string slot { get; }`, written with `//`.

```text
The slot discriminator within the environment. The empty string "" (NOT null) is the base/index-0
slot — kept as a sentinel because downstream resolves slots by value (`slot -eq ''` for the base).
```

## comment:3

Above `public string subscription { get; }`, written with `//`.

```text
The subscription this slot deploys into — resolved at discovery from the slot's coordinate: the
one non-customer subscription serving the env (a configuration-root config), or the customer's one
subscription serving it (a configuration/<customer>/ config). Always present.
```

## comment:4

Above `public string customer { get; }`, written with `//`.

```text
The customer this slot is for — the configuration subfolder name (a customer key). The empty
string "" (NOT null) for a configuration-root (shared) slot — a sentinel because downstream
filters by value (`customer -eq ''`).
```
