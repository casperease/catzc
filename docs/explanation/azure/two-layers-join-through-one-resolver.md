# Templating and identity join through one shared check and one resolver

```text
Templating and identity join through one shared check and one resolver.

1  configuration/ tree                    the templating layer: one config file per deployment, under a template
2  Get-BicepTemplates                     discovery; runs the shared check per file and throws on the first violation
3  Assert-BicepTemplate                   the collect-all validator; runs the same shared check and reports everything
4  Get-BicepSubscriptionConfigViolations  the shared check: subfolder is a customer key, coordinate resolves to one subscription
5  Get-BicepConfigSubscriptionCandidates  the resolver: the subscriptions a (customer?, env) coordinate can resolve to
6  azure.yml                              the identity layer: subscriptions, the environments they serve, an optional customer
7  customer.yml                           the customer catalogue: each key with its two-letter shortcode

Supports ADR-AZ-DATAMOD-TWOCONFIGLAYERS, ADR-AZ-DATAMOD-NAMEKEYEDMAPS and ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY,
and ADR-AZ-CUSTOMER-TWOBINDINGS (architecture lens).
```

Two config layers describe what cats deploys onto Azure. The config layer for identity, `azure.yml` and `customer.yml`, says which
subscriptions exist, which environments each serves and which customer, if any, owns it. The templating layer, the `configuration/` tree
under each template, says which deployments exist. The two never reference each other by name: they join through one resolver that turns a
config's coordinate into its subscription, and one shared check that both discovery and the collect-all validator run, so the rule cannot
drift between its two callers.

```yml drawio
description:
  "The templating layer and the identity layer never reference each other by name: discovery and the collect-all validator both run one
  shared check, which asks one resolver which subscriptions a config's coordinate can resolve to in azure.yml and customer.yml."
about:
  adrs: [ADR-AZ-DATAMOD-TWOCONFIGLAYERS, ADR-AZ-DATAMOD-NAMEKEYEDMAPS, ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY, ADR-AZ-CUSTOMER-TWOBINDINGS]
  lens: architecture
content:
  title: Templating and identity join through one shared check and one resolver
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-templating, label: TEMPLATING LAYER }
    - { id: band-identity, label: IDENTITY LAYER }
  glyphs:
    - { id: g-tree, kind: file, label: configuration/ tree, in: band-templating }
    - { id: g-discovery, kind: code, label: Get-BicepTemplates, in: band-templating }
    - { id: g-validator, kind: code, label: Assert-BicepTemplate, in: band-templating }
    - { id: g-check, kind: gate, label: Get-BicepSubscriptionConfigViolations, in: band-templating }
    - { id: g-candidates, kind: code, label: Get-BicepConfigSubscriptionCandidates, in: band-templating }
    - { id: g-azure, kind: file, label: azure.yml, in: band-identity }
    - { id: g-customer, kind: file, label: customer.yml, in: band-identity }
  edges:
    - { from: g-discovery, to: g-tree, kind: flow, label: "" }
    - { from: g-validator, to: g-tree, kind: flow, label: "" }
    - { from: g-discovery, to: g-check, kind: flow, label: "" }
    - { from: g-validator, to: g-check, kind: flow, label: "" }
    - { from: g-check, to: g-candidates, kind: flow, label: calls }
    - { from: g-candidates, to: g-azure, kind: flow, label: "" }
    - { from: g-candidates, to: g-customer, kind: flow, label: "" }
  markers:
    - { at: g-tree, number: 1 }
    - { at: g-discovery, number: 2 }
    - { at: g-validator, number: 3 }
    - { at: g-check, number: 4 }
    - { at: g-candidates, number: 5 }
    - { at: g-azure, number: 6 }
    - { at: g-customer, number: 7 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-templating: { x: 20, y: 84, w: 1000, h: 340 }
  band-identity: { x: 1040, y: 84, w: 240, h: 340 }
  g-tree: { x: 40, y: 214, w: 180, h: 52 }
  g-discovery: { x: 270, y: 134, w: 190, h: 44 }
  g-validator: { x: 270, y: 300, w: 190, h: 44 }
  g-check: { x: 500, y: 126, w: 240, h: 218 }
  g-candidates: { x: 780, y: 126, w: 230, h: 226 }
  g-azure: { x: 1070, y: 148, w: 180, h: 52 }
  g-customer: { x: 1070, y: 300, w: 180, h: 52 }
```

![The templating and identity config layers join through one shared check and one resolver][diagram]

[diagram]: .assets/two-layers-join-through-one-resolver.drawio.png

## Walkthrough

1. **`configuration/` tree.** Every template under `infrastructure/templates/<name>/` carries a `configuration/` folder: root files for the
   shared platform and one subfolder per customer. The tree is the templating layer's coordinate space, and nothing in it names a
   subscription.
2. **`Get-BicepTemplates`.** Discovery scans the tree, root files first and then each subfolder, and runs the shared check on every file.
   The first violation throws, so a template with a bad config never becomes a discovered template. Discovery also asks the resolver for the
   slot's subscription once the check has passed.
3. **`Assert-BicepTemplate`.** The explicit validator scans the same tree the same way but collects every problem of a template before
   throwing one consolidated error, so it can describe a template that discovery rejects.
4. **`Get-BicepSubscriptionConfigViolations`.** The shared check holds the two conventional rules for one file: a subfolder must be a key of
   the customer catalogue, and the coordinate must resolve to exactly one subscription. It reads the customer keys for the first rule and
   asks the resolver for the second, returning human-readable violations that the caller prefixes with the template's name.
5. **`Get-BicepConfigSubscriptionCandidates`.** The resolver is the single implementation of the resolution rule. For each subscription
   serving the environment it reads the `customer` token through the one accessor that naming also uses: a root coordinate keeps the
   subscriptions with no token, a customer coordinate keeps those whose token is the customer's key or resolves to it.
6. **`azure.yml`.** The subscriptions of the identity configs are maps keyed by name, each with the environments it serves and, for a
   customer subscription, a `customer` token. The shared platform pair are the only subscriptions without one.
7. **`customer.yml`.** The catalogue of customers, each a readable key and a two-letter shortcode. A subscription may bind a customer by
   either, so a shortcode token is resolved to its key through the catalogue; the catalogue itself reads nothing back from `azure.yml`.

## Why it holds

- Two config layers, identity and templating, join through the conventional configuration tree, and the subscription is always resolved from
  that coordinate, never spelled into a path (ADR-AZ-DATAMOD-TWOCONFIGLAYERS).
- Every config's coordinate must resolve to exactly one subscription id, asserted per file at discovery and by integrity tests
  (ADR-AZ-DATAMOD-NAMEKEYEDMAPS).
- The link between the two layers is enforced at discovery by `Get-BicepTemplates` through the shared
  `Get-BicepSubscriptionConfigViolations`, and over the shipped tree by integrity tests (ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY).
- A subscription binds a customer by key or by shortcode, both resolved to the same record by the single resolver `Get-AzureCustomer`
  (ADR-AZ-CUSTOMER-TWOBINDINGS).

## See also

- [Templating data model](../../drs/azure/azure-data-model.md) — the decision this article explains, with the
  [customer model](../../drs/azure/azure-customer-model.md) it pairs with.
- The other lenses on the same coordinate: [meta](config-path-is-a-coordinate.md),
  [implementation](coordinate-resolved-file-by-file-at-discovery.md), [operations](a-bad-coordinate-stops-discovery.md) and
  [governance](coordinate-rules-and-their-gates.md).
- [The Azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
