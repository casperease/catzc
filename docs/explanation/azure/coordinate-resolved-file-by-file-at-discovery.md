# Discovery resolves every config file's coordinate through one shared check

```text
Discovery resolves every config file's coordinate through one shared check.

1  configuration/apex/nsub.yml            a shipped config of the foundation template: customer apex, environment nsub, base slot
2  Get-BicepTemplates                     discovery: loads azure.yml, gathers root files then subfolders, skips default.yml
3  Resolve-BicepConfigName                splits the filename on the first '-' into environment and slot; throws on a bad name
4  azure.yml                              the subscriptions the resolver filters: serving the env, with or without a customer
5  Get-BicepConfigSubscriptionCandidates  the resolver: the subscriptions the (customer?, env) coordinate can resolve to
6  Get-AzureCustomer                      resolves a subscription's shortcode token to its key through customer.yml
7  Get-BicepSubscriptionConfigViolations  the shared check: the subfolder is a key; exactly one candidate
8  has an invalid config                  the throw: Template '<name>' has an invalid config: <violations>.
9  BicepSlot                              the slot: name, environment, slot, subscription, customer; one per config file

Supports ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION, ADR-AZ-DATAMOD-NAMEKEYEDMAPS and ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY,
and ADR-AZ-CUSTOMER-TWOBINDINGS and ADR-AZ-CUSTOMER-KEYISSUBFOLDER (implementation lens).
```

Discovery is the moment cats turns a template's `configuration/` tree into slots, and it is where the coordinate of every config file is
resolved and checked. For each file, `Get-BicepTemplates` parses the filename, runs the shared check on the (customer?, env) coordinate, and
only then builds the slot with the one subscription the resolver returns. The shipped `foundation` template's `apex/nsub.yml` is the
example: its coordinate is customer `apex`, environment `nsub`, base slot, and it resolves to `apex_nonprod`.

```yml drawio
description:
  Discovery parses each config file's name, resolves its (customer, environment) coordinate through the one shared check, and builds a slot
  only when exactly one subscription remains; any violation stops with one invalid-config throw.
about:
  rules:
    - ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION
    - ADR-AZ-DATAMOD-NAMEKEYEDMAPS
    - ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY
    - ADR-AZ-CUSTOMER-TWOBINDINGS
    - ADR-AZ-CUSTOMER-KEYISSUBFOLDER
  lens: implementation
content:
  title: Discovery resolves every config file's coordinate through one shared check
  kind: explanation
  flow: top-to-bottom
  theme: dark
  bands:
    - { id: band-discovery, label: DISCOVERY }
    - { id: band-resolver, label: RESOLVER }
    - { id: band-identity, label: IDENTITY }
  glyphs:
    - { id: g-config, kind: file, label: configuration/apex/nsub.yml, in: band-discovery }
    - { id: g-discovery, kind: code, label: Get-BicepTemplates, in: band-discovery }
    - { id: g-resolve-name, kind: code, label: Resolve-BicepConfigName, in: band-discovery }
    - { id: g-violations, kind: gate, label: Get-BicepSubscriptionConfigViolations, in: band-discovery }
    - { id: f-invalid, kind: failure, label: has an invalid config, in: band-discovery }
    - { id: g-slot, kind: type, label: BicepSlot, in: band-discovery }
    - { id: g-candidates, kind: code, label: Get-BicepConfigSubscriptionCandidates, in: band-resolver }
    - { id: g-customer, kind: code, label: Get-AzureCustomer, in: band-resolver }
    - { id: g-azure, kind: file, label: azure.yml, in: band-identity }
    - { id: g-customer-file, kind: file, label: customer.yml, in: band-identity }
  edges:
    - { from: g-discovery, to: g-config, kind: flow, label: reads }
    - { from: g-discovery, to: g-resolve-name, kind: flow, label: calls }
    - { from: g-resolve-name, to: g-violations, kind: flow, label: "" }
    - { from: g-violations, to: g-slot, kind: flow, label: "" }
    - { from: g-resolve-name, to: f-invalid, kind: fail, label: "" }
    - { from: g-violations, to: f-invalid, kind: fail, label: "" }
    - { from: g-candidates, to: g-violations, kind: flow, label: "" }
    - { from: g-customer, to: g-candidates, kind: flow, label: calls }
    - { from: g-candidates, to: g-azure, kind: flow, label: reads }
    - { from: g-customer, to: g-customer-file, kind: flow, label: reads }
  markers:
    - { at: g-config, number: 1 }
    - { at: g-discovery, number: 2 }
    - { at: g-resolve-name, number: 3 }
    - { at: g-azure, number: 4 }
    - { at: g-candidates, number: 5 }
    - { at: g-customer, number: 6 }
    - { at: g-violations, number: 7 }
    - { at: f-invalid, number: 8 }
    - { at: g-slot, number: 9 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-discovery: { x: 20, y: 84, w: 1260, h: 250 }
  band-resolver: { x: 20, y: 354, w: 1260, h: 120 }
  band-identity: { x: 20, y: 494, w: 1260, h: 120 }
  g-config: { x: 40, y: 134, w: 190, h: 52 }
  g-discovery: { x: 270, y: 138, w: 180, h: 44 }
  g-resolve-name: { x: 490, y: 138, w: 230, h: 44 }
  g-violations: { x: 760, y: 126, w: 320, h: 68 }
  g-slot: { x: 1120, y: 142, w: 130, h: 36 }
  f-invalid: { x: 490, y: 244, w: 230, h: 44 }
  g-candidates: { x: 760, y: 398, w: 320, h: 44 }
  g-customer: { x: 1110, y: 398, w: 150, h: 44 }
  g-azure: { x: 840, y: 538, w: 160, h: 52 }
  g-customer-file: { x: 1110, y: 538, w: 150, h: 52 }
```

![Discovery resolves every config file's coordinate through one shared check][diagram]

[diagram]: .assets/coordinate-resolved-file-by-file-at-discovery.drawio.png

## Walkthrough

1. **`configuration/apex/nsub.yml`.** The file lives under the `foundation` template. Its subfolder, `apex`, is its customer; its name,
   `nsub`, is its environment with the base slot. The whole coordinate is in the path.
2. **`Get-BicepTemplates`.** Discovery loads `azure.yml` once with `Get-Config -Config azure`, then gathers each template's config files:
   the root files first, then every subfolder's, both sorted, each tagged with its subfolder as its customer (empty for a root file).
   `default.yml` is reserved and skipped.
3. **`Resolve-BicepConfigName`.** The filename is split on the first `-`: the part before must be a defined environment, the remainder is
   the optional slot of one to three lowercase alphanumerics. An unknown environment throws, and so does a slot that is malformed. Discovery
   rethrows either with the template name and the file's location.
4. **`azure.yml`.** The identity config's subscriptions, each with the environments it serves and, for a customer subscription, a `customer`
   token by key or shortcode. The resolver receives it as `-AzureConfig`.
5. **`Get-BicepConfigSubscriptionCandidates`.** For each subscription serving the environment, the resolver reads its customer token through
   `Get-AzureSubscriptionCustomer`. A root coordinate keeps the subscriptions with no token; a customer coordinate keeps those whose token
   equals the subfolder's key, or resolves to it.
6. **`Get-AzureCustomer`.** When a token is not the key itself, the resolver resolves it through the catalogue, keys first and then
   shortcodes, so `ap` and `apex` bind the same customer. An unknown token throws at that moment.
7. **`Get-BicepSubscriptionConfigViolations`.** The shared check runs per file with the customer, the environment, the azure config and a
   human-readable location. It first checks that a subfolder is one of the customer keys and returns early if not; then it asks the resolver
   and flags zero candidates or more than one. The env-class and customer-class checks follow it, each a shared rule of its own.
8. **Has an invalid config.** Any violation throws `Template '<name>' has an invalid config: <violations>.`, and a bad filename throws
   `Template '<name>' has <location> — <message>`. Discovery stops at the first bad file.
9. **`BicepSlot`.** With the check passed, discovery asks the resolver once more and takes its only candidate as the slot's subscription,
   then builds the slot from the config name, the environment, the slot, the subscription and the customer. The slot's resource group is
   derived later, at deploy time, from that coordinate.

## Why it holds

- One config file is one (customer?, env, slot), one subscription and one Azure resource group, with the filename `<env>[-<slot>]` parsed by
  splitting on the first `-` (ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION).
- A configuration subfolder is always a customer key, and every coordinate must resolve to exactly one subscription id, asserted per file at
  discovery (ADR-AZ-DATAMOD-NAMEKEYEDMAPS).
- The link across the two layers is enforced at discovery by `Get-BicepTemplates` through the shared `Get-BicepSubscriptionConfigViolations`
  (ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY).
- A subscription binds a customer by either its key or its shortcode, and `Get-AzureCustomer` is the single resolver, keys first and then
  shortcodes (ADR-AZ-CUSTOMER-TWOBINDINGS).
- The customer key is the subfolder name, and a subfolder that is not a defined key is a discovery error (ADR-AZ-CUSTOMER-KEYISSUBFOLDER).

## See also

- [Templating data model](../../drs/azure/azure-data-model.md) — the decision this article explains, with the
  [customer model](../../drs/azure/azure-customer-model.md) it pairs with.
- The other lenses on the same coordinate: [meta](config-path-is-a-coordinate.md), [architecture](two-layers-join-through-one-resolver.md),
  [operations](a-bad-coordinate-stops-discovery.md) and [governance](coordinate-rules-and-their-gates.md).
- [The Azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
