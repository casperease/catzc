# Catzc.Azure

The Azure identity module. It owns the _model_ behind every Azure deployment — the tenants, customers, environments, and subscriptions the
platform deploys into, and the network plan that overlays them — and the resolution logic that turns a name into the full identity the rest
of the Azure stack needs. It holds the source-of-truth configuration; the templating module
([Catzc.Azure.Templates](../azure-templates/index.md)) consumes it.

## Responsibilities

| Responsibility   | Area         | Name                                                                         |
| ---------------- | ------------ | ---------------------------------------------------------------------------- |
| responsibility:1 | model        | [Identity and topology model](#responsibility1--identity-and-topology-model) |
| responsibility:2 | subscription | [Subscription resolution](#responsibility2--subscription-resolution)         |
| responsibility:3 | environment  | [Environment resolution](#responsibility3--environment-resolution)           |
| responsibility:4 | catalog      | [Global catalog accessors](#responsibility4--global-catalog-accessors)       |

### responsibility:1 — Identity and topology model

The declared shape of the Azure estate: the tenants, the customers (each with a readable key and a short code), the environments (each with
a region, region code, and short code), and the subscriptions (each bound to a tenant, optionally to a customer, and serving a set of
environments). Overlaid on this is the IP plan: a range per environment, and a hub-and-spoke network per subscription — a hub in each shared
subscription, a spoke in each customer subscription, with no two networks overlapping. This is data, not behaviour — it lives in three
configuration assets, `azure.yml`, `customer.yml` (the customers) and `network.yml`, and is the single source of truth the whole Azure stack
resolves against; a quality gate keeps the IP plan in step with the environments and subscriptions. The live identities these files carry
are declared in `identity-tokens.yml`, so a hermetic logic test that names one is found
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)). See
[data-model](../../../drs/azure/azure-data-model.md) and [network-model](../../../drs/azure/azure-network-model.md).

### responsibility:2 — Subscription resolution

Turning a subscription name into its full identity: its id and tenant, the customer it belongs to (if any), and its per-subscription
identity environment. A subscription is the deployment target, and this responsibility is where "which subscription, and what does that
imply" is answered.

### responsibility:3 — Environment resolution

Turning an environment name into its full identity in the context of a serving subscription: its region and region code, its short code, and
the resolved subscription that serves it. This is the join between the environment dimension and the subscription dimension.

### responsibility:4 — Global catalog accessors

Whole-estate lookups that aren't tied to one subscription or environment: the list of customers, one customer resolved from either its key
or its short code, and the minimum Bicep CLI version the estate requires. These are thin readers over the identity model for callers that
need a catalog rather than a single resolved identity.

## What the module does

This module is pure resolution over a declared model. It performs no Azure API calls and changes no state — it reads `azure.yml` and
`network.yml`, validates each through its config type on load, checks with a quality gate that the network plan stays in sync with the
environments and subscriptions, and answers questions about identity. The governing principle is "optimise for ease of configuration and
codebase-as-source-of-truth": the configuration is shaped for a human to read and edit, and the non-trivial joins between its dimensions
live here, in code, rather than being denormalised into the config.

The model has two independent dimensions — subscriptions and environments — that meet at deployment time. Responsibility 2 resolves the
subscription dimension, responsibility 3 resolves the environment dimension _in the context of_ a subscription, and the catalog accessors in
responsibility 4 expose the whole sets when a caller needs to enumerate rather than resolve. The customer is never a dimension a caller
selects directly; it is derived from the resolved subscription, which is why "which customer" is answered through subscription resolution
rather than as its own input.

Everything downstream — resource naming, build, deploy — phrases its questions in terms this module answers, so the identity model has
exactly one home. Adding a tenant, customer, environment, or subscription is an edit to `azure.yml` (and a matching `network.yml` entry for
a standard environment or a subscription: a hub for a shared one, a spoke for a customer's); the validation on load and the quality gate are
what stop the two assets from drifting apart.

The diagram below draws identity resolution from the source. Every Azure identity resolves from `azure.yml` and `customer.yml` through the
configuration loader, each into its own registered type. The live az session is matched back to the declared subscriptions and must match
exactly one.

```yml drawio
description:
  Azure identities resolve only from the typed azure.yml and customer.yml; the az session subscription is looked up in the azure config and
  must match exactly one declared subscription before it reaches the subscription resolver.
about:
  adrs: [ADR-AZ-SESSION, ADR-AZ-DATAMOD, ADR-AZ-CUSTOMER]
  lens: source
content:
  title: Azure identities resolve from config; session must match one
  kind: reference
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-session, label: SESSION }
    - { id: band-config, label: CONFIG }
  groups:
    - { id: grp-cli, label: Catzc.Azure.Cli, in: band-session }
    - { id: grp-base-config, label: Catzc.Base.Config, in: band-config }
    - { id: grp-resolvers, label: resolvers, in: band-config }
  glyphs:
    - { id: g-current-sub, kind: code, label: Get-CurrentAzSubscription, in: grp-cli }
    - { id: g-session-sub, kind: gate, label: Get-AzCliSessionSubscription, in: grp-cli }
    - { id: g-azure-yml, kind: file, label: azure.yml, in: band-config }
    - { id: g-customer-yml, kind: file, label: customer.yml, in: band-config }
    - { id: g-get-config, kind: code, label: Get-Config, in: grp-base-config }
    - { id: g-azure-config, kind: type, label: AzureConfig, in: band-config }
    - { id: g-customer-config, kind: type, label: CustomerConfig, in: band-config }
    - { id: g-azure-customer, kind: code, label: Get-AzureCustomer, in: band-config }
    - { id: g-azure-sub, kind: code, label: Get-AzureSubscription, in: grp-resolvers }
    - { id: g-azure-env, kind: code, label: Get-AzureEnvironment, in: grp-resolvers }
  edges:
    - { from: g-get-config, to: g-azure-yml, kind: flow, label: "" }
    - { from: g-get-config, to: g-customer-yml, kind: flow, label: "" }
    - { from: g-get-config, to: g-azure-config, kind: flow, label: feeds }
    - { from: g-get-config, to: g-customer-config, kind: flow, label: feeds }
    - { from: g-azure-sub, to: g-azure-config, kind: flow, label: reads }
    - { from: g-session-sub, to: g-azure-config, kind: flow, label: reads }
    - { from: g-azure-customer, to: g-customer-config, kind: flow, label: reads }
    - { from: g-azure-sub, to: g-azure-customer, kind: flow, label: calls }
    - { from: g-session-sub, to: g-current-sub, kind: flow, label: calls }
    - { from: g-session-sub, to: g-azure-sub, kind: flow, label: calls }
    - { from: g-azure-env, to: g-azure-sub, kind: flow, label: calls }
  markers:
    - { at: g-azure-yml, number: 1 }
    - { at: g-customer-yml, number: 2 }
    - { at: g-get-config, number: 3 }
    - { at: g-azure-config, number: 4 }
    - { at: g-customer-config, number: 5 }
    - { at: g-azure-customer, number: 6 }
    - { at: g-azure-sub, number: 7 }
    - { at: g-azure-env, number: 8 }
    - { at: g-current-sub, number: 9 }
    - { at: g-session-sub, number: 10 }
  chips:
    - { at: g-session-sub, kind: count, text: "1" }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-session: { x: 400, y: 84, w: 880, h: 190 }
  band-config: { x: 20, y: 292, w: 1260, h: 220 }
  grp-cli: { x: 604, y: 98, w: 292, h: 170 }
  g-current-sub: { x: 645, y: 132, w: 210, h: 40 }
  g-session-sub: { x: 622, y: 208, w: 256, h: 54 }
  g-azure-yml: { x: 40, y: 322, w: 110, h: 46 }
  g-customer-yml: { x: 40, y: 432, w: 110, h: 46 }
  grp-base-config: { x: 190, y: 356, w: 180, h: 92 }
  g-get-config: { x: 210, y: 396, w: 140, h: 40 }
  g-azure-config: { x: 410, y: 326, w: 130, h: 40 }
  g-customer-config: { x: 410, y: 436, w: 130, h: 40 }
  g-azure-customer: { x: 650, y: 436, w: 200, h: 40 }
  grp-resolvers: { x: 634, y: 302, w: 532, h: 96 }
  g-azure-sub: { x: 650, y: 346, w: 200, h: 40 }
  g-azure-env: { x: 950, y: 346, w: 200, h: 40 }
```

![Azure identities resolve from config; session must match one](../.assets/azure-identity-resolves-from-config.drawio.png)

## Division

The module's public functions and configuration, sorted into the responsibilities above.

| Responsibility                                 | Function                           |
| ---------------------------------------------- | ---------------------------------- |
| responsibility:1 — Identity and topology model | `Test-AzureNetworkPlan`            |
| config                                         | `azure.yml`                        |
|                                                | `customer.yml`                     |
|                                                | `network.yml`                      |
|                                                | `identity-tokens.yml`              |
| responsibility:2 — Subscription resolution     | `Get-AzureSubscription`            |
|                                                | `Get-AzureSubscriptionCustomer`    |
|                                                | `Get-AzureSubscriptionEnvironment` |
| responsibility:3 — Environment resolution      | `Get-AzureEnvironment`             |
| responsibility:4 — Global catalog accessors    | `Get-AzureCustomers`               |
|                                                | `Get-AzureCustomer`                |
|                                                | `Get-AzureBicepMinVersion`         |
