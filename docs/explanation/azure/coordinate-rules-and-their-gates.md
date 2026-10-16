---
catzc:
  derived:
    path: docs/explanation/azure/coordinate-rules-and-their-gates.md
    kind: explanation
    language: markdown
    filetype: md
    track: docs
    body_sha: "57d23475251f"
    adrs:
      - ADR-AZ-CUSTOMER#{2,6}
      - ADR-AZ-DATAMOD#{1-3,5,8}
    links:
      - docs/.assets/explanation/adr-az-datamod--coordinate-rules-and-their-gates--governance.drawio.md
      - docs/.assets/explanation/adr-az-datamod--coordinate-rules-and-their-gates--governance.drawio.png
      - docs/adr/azure/azure-customer-model.md
      - docs/adr/azure/azure-data-model.md
      - docs/explanation/azure/a-bad-coordinate-stops-discovery.md
      - docs/explanation/azure/config-path-is-a-coordinate.md
      - docs/explanation/azure/coordinate-resolved-file-by-file-at-discovery.md
      - docs/explanation/azure/index.md
      - docs/explanation/azure/two-layers-join-through-one-resolver.md
      - docs/explanation/index.md#how-to-read-the-diagrams
---

# Two ADRs rule the coordinate; one shared check and the integrity tests hold them

```text
Two ADRs rule the coordinate; one shared check and the integrity tests hold them.

1  config file                            the coordinate: root or customer subfolder, env and slot in the name (D1, D2, C6)
2  Get-BicepTemplates                     discovery runs the shared check per file, fail-fast (D8)
3  shipped template integrity             the integrity test that runs the validator over every shipped template (D3, D8)
4  Assert-BicepTemplate                   the collect-all validator, the second caller of the shared check (D8)
5  Get-BicepSubscriptionConfigViolations  the shared check: a subfolder is a key, one subscription, key or shortcode (D3, C6, C2)
6  subscription                           the resolved value, never a path segment or an argument (D1)
7  resource group                         its name derived by the namer; no gate checks a config for a typed one (D5, no gate)

Supports ADR-AZ-DATAMOD#1, #2, #3, #5 and #8, and ADR-AZ-CUSTOMER#2 and #6 (governance lens).
```

Two decisions govern a config file's coordinate in cats: the templating data model, which says what the path means and that it resolves to
exactly one subscription, and the customer model, which says that a subfolder is a customer key and that a subscription may bind a customer
by key or shortcode. Every rule but one is held by a gate: the shared check that discovery and the validator both run, and the integrity
tests that run the validator over the shipped tree. The one rule without a gate, that the resource-group name is derived and never typed, is
held by the code that derives it.

![Two ADRs rule the coordinate; one shared check and the integrity tests hold them](../../.assets/explanation/adr-az-datamod--coordinate-rules-and-their-gates--governance.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-az-datamod--coordinate-rules-and-their-gates--governance.drawio.md).

## Walkthrough

1. **Config file.** The path `configuration/[<customer>/]<env>[-<slot>].yml` is ruled three times: the root is the shared platform and a
   subfolder a customer (ADR-AZ-DATAMOD#1), one file is one (customer?, env, slot), one subscription and one resource group
   (ADR-AZ-DATAMOD#2), and the subfolder is the customer key (ADR-AZ-CUSTOMER#6).
2. **`Get-BicepTemplates`.** Discovery is the gate the data model names for joining the layers: it runs the shared check on every file and
   throws on the first violation (ADR-AZ-DATAMOD#8).
3. **Shipped template integrity.** An integrity test runs `Assert-BicepTemplate` over every shipped template without building it, and a
   second one checks the environment and customer of every slot discovery found against the identity configs. Together they are the
   "integrity tests" that ADR-AZ-DATAMOD#3 and #8 name beside discovery.
4. **`Assert-BicepTemplate`.** The validator is the second caller of the shared check, collecting rather than failing fast, so the rule has
   one implementation and two callers (ADR-AZ-DATAMOD#8).
5. **`Get-BicepSubscriptionConfigViolations`.** The shared check holds the exactly-one rule (ADR-AZ-DATAMOD#3) and the subfolder-is-a-key
   rule (ADR-AZ-CUSTOMER#6), and through the resolver it honours the key-or-shortcode binding of a subscription's customer
   (ADR-AZ-CUSTOMER#2).
6. **Subscription.** The resolved subscription is a value the gate produced, never a path segment and never a deploy argument
   (ADR-AZ-DATAMOD#1).
7. **Resource group.** The group's name is derived by `Get-BicepResourceGroupName` for both the deploy target and the scope of the tracking
   tag, and never hand-typed (ADR-AZ-DATAMOD#5). No gate checks a resource-group-target config for a typed name, which is why the rule's
   chip is dashed: the code derives the name whatever a config says, and only a subscription-target config is asserted to carry none.

## Why it holds

- The subscription is resolved from the coordinate and never spelled into a path, and there is no subscription-group entity
  (ADR-AZ-DATAMOD#1).
- One config file is one (customer?, env, slot), one subscription and one resource group, and the tree is the inventory (ADR-AZ-DATAMOD#2).
- Every coordinate must resolve to exactly one subscription id, asserted per file at discovery and by integrity tests (ADR-AZ-DATAMOD#3).
- The resource-group name is derived by `Get-BicepResourceGroupName`, never hand-typed (ADR-AZ-DATAMOD#5).
- The link between the two layers is enforced at discovery through the shared `Get-BicepSubscriptionConfigViolations` and over the shipped
  tree by integrity tests (ADR-AZ-DATAMOD#8).
- A subscription binds a customer by key or shortcode through the single resolver (ADR-AZ-CUSTOMER#2), and the key is the subfolder name
  (ADR-AZ-CUSTOMER#6).

## Where the code and the ADR differ

The data model states the exactly-one rule as ADR-AZ-DATAMOD#3, but the code that enforces it cites other rules: the shared check cites
ADR-AZ-DATAMOD#8 and the filename parser cites ADR-AZ-DATAMOD#2, and no file cites #3.

## See also

- [Templating data model](../../adr/azure/azure-data-model.md) — the decision this article explains, with the
  [customer model](../../adr/azure/azure-customer-model.md) it pairs with.
- The other lenses on the same coordinate: [meta](config-path-is-a-coordinate.md), [architecture](two-layers-join-through-one-resolver.md),
  [implementation](coordinate-resolved-file-by-file-at-discovery.md) and [operations](a-bad-coordinate-stops-discovery.md).
- [The Azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
