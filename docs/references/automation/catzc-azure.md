# Catzc.Azure

The Azure identity module. It owns the _model_ behind every Azure deployment — the tenants, customers, environments, and subscriptions the
platform deploys into, and the network plan that overlays them — and the resolution logic that turns a name into the full identity the rest
of the Azure stack needs. It holds the source-of-truth configuration; the templating module
([Catzc.Azure.Templates](catzc-azure-templates.md)) consumes it.

## Domains

| Domain   | Area         | Name                                                                 |
| -------- | ------------ | -------------------------------------------------------------------- |
| domain:1 | model        | [Identity and topology model](#domain1--identity-and-topology-model) |
| domain:2 | subscription | [Subscription resolution](#domain2--subscription-resolution)         |
| domain:3 | environment  | [Environment resolution](#domain3--environment-resolution)           |
| domain:4 | catalog      | [Global catalog accessors](#domain4--global-catalog-accessors)       |

### domain:1 — Identity and topology model

The declared shape of the Azure estate: the tenants, the customers (each with a readable key and a short code), the environments (each with
a region, region code, and short code), and the subscriptions (each bound to a tenant, optionally to a customer, and serving a set of
environments). Overlaid on this is the per-environment IP plan. This is data, not behaviour — it lives in two configuration assets,
`azure.yml` and `network.yml`, and is the single source of truth the whole Azure stack resolves against. See
[data-model](../../adr/azure/data-model.md) and [network-model](../../adr/azure/network-model.md).

### domain:2 — Subscription resolution

Turning a subscription name into its full identity: its id and tenant, the customer it belongs to (if any), and its per-subscription
identity environment. A subscription is the deployment target, and this domain is where "which subscription, and what does that imply" is
answered.

### domain:3 — Environment resolution

Turning an environment name into its full identity in the context of a serving subscription: its region and region code, its short code, and
the resolved subscription that serves it. This is the join between the environment dimension and the subscription dimension.

### domain:4 — Global catalog accessors

Whole-estate lookups that aren't tied to one subscription or environment: the list of customers, and the minimum Bicep CLI version the
estate requires. These are thin readers over the identity model for callers that need a catalog rather than a single resolved identity.

## What the module does

This module is pure resolution over a declared model. It performs no Azure API calls and changes no state — it reads `azure.yml` and
`network.yml`, validates their internal consistency on load, and answers questions about identity. The governing principle is "optimise for
ease of configuration and codebase-as-source-of-truth": the configuration is shaped for a human to read and edit, and the non-trivial joins
between its dimensions live here, in code, rather than being denormalised into the config.

The model has two independent dimensions — subscriptions and environments — that meet at deployment time. Domain 2 resolves the subscription
dimension, domain 3 resolves the environment dimension _in the context of_ a subscription, and the catalog accessors in domain 4 expose the
whole sets when a caller needs to enumerate rather than resolve. The customer is never a dimension a caller selects directly; it is derived
from the resolved subscription, which is why "which customer" is answered through subscription resolution rather than as its own input.

Everything downstream — resource naming, build, deploy — phrases its questions in terms this module answers, so the identity model has
exactly one home. Adding a tenant, customer, environment, or subscription is an edit to `azure.yml` (and a matching `network.yml` entry for
a standard environment); the validation on load is what stops the two assets from drifting apart.

## Division

The module's public functions and configuration, sorted into the domains above.

| Domain                                 | Function                           |
| -------------------------------------- | ---------------------------------- |
| domain:1 — Identity and topology model | `azure.yml`                        |
|                                        | `network.yml`                      |
| domain:2 — Subscription resolution     | `Get-AzureSubscription`            |
|                                        | `Get-AzureSubscriptionCustomer`    |
|                                        | `Get-AzureSubscriptionEnvironment` |
| domain:3 — Environment resolution      | `Get-AzureEnvironment`             |
| domain:4 — Global catalog accessors    | `Get-AzureCustomers`               |
|                                        | `Get-AzureBicepMinVersion`         |
