# docs/adr/azure/dora-explains.md

`DORA explanations — azure`

The `Dora explains` rationale for the ADRs in the `azure/` domain, consolidated in one place. Each entry names its ADR and rule code, then
reproduces that ADR's tie to [DORA](../../references/dora/index.md) research and the domain-relevant capability links. The decisions live in
the ADRs themselves; this file carries only their DORA rationale.

## Templating data model

`azure.yml` + `infrastructure/` · [ADR-AZ-DATAMOD](azure-data-model.md)

> DORA's research connects infrastructure-as-code and version-controlled configuration to lower deployment lead time and enable rapid,
> reliable infrastructure changes. This ADR encodes Azure infrastructure as derived, deterministic config with no hand-typed values,
> enabling safe automation.

- [Version control](../../references/dora/capabilities.md#version-control) — configuration is the single source of truth for Azure
  resources.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — templates and configs drive repeatable Azure
  deployments.
- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — infrastructure-as-code model with config-driven
  subscriptions.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — one-living-version data model (no legacy
  shapes).
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Network model

`network.yml` · [ADR-AZ-NETWORK](azure-network-model.md)

> DORA's research shows that infrastructure-as-code and centralized, single-source-of-truth configuration reduce errors and deployment lead
> time. This ADR encodes the network plan as a versioned asset, with cross-asset integrity rules preventing configuration drift.

- [Version control](../../references/dora/capabilities.md#version-control) — IP plan is a versioned, authoritative source.
- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — network topology defined as declarative
  configuration.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — network plan drives template deployments and vnet
  setup.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Resource naming

`Azure resource naming standard`

[ADR-AZ-NAMING](azure-naming-standard.md)

> DORA research shows that standardized, maintainable naming and configuration-driven automation reduce deployment lead time and errors.
> This ADR encodes deterministic, derived resource names that are never hand-typed, enabling safe infrastructure automation.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — standardized, deterministic naming rules reduce
  cognitive load.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — derived naming enables reliable, repeatable
  resource naming.
- [Version control](../../references/dora/capabilities.md#version-control) — naming rules versioned as configuration, reproducible and
  auditable.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Customer model

`Customer model (customer.yml) — catalogue, two-name binding, and the template switch`

[ADR-AZ-CUSTOMER](azure-customer-model.md)

> DORA's research links single-source-of-truth configuration and one-living-version practices to faster, more reliable delivery. This ADR
> encodes the customer catalogue as the authoritative source, enabling predictable customer-scoped deployments without policy coupling.

- [Version control](../../references/dora/capabilities.md#version-control) — customer catalogue as a versioned, authoritative asset.
- [Trunk-based development](../../references/dora/capabilities.md#trunk-based-development) — one-living-version principle (no legacy
  customer definitions).
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — customer model drives repeatable deployment
  patterns.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Landing zones

`Landing zones — a CAF landing zone per subscription, hub and spoke, and the Well-Architected workload that lands in it`

[ADR-AZ-LZ](landing-zones.md)

> DORA's research ties flexible, self-service infrastructure and pervasive security to delivery performance. This ADR gives every
> subscription the same landing zone from one template, with its guardrails as policy, so a workload lands in a secure network by
> configuration rather than by request.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — a subscription's network, policies, and budget
  are one config file.
- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — built-in policies, private endpoints, and Entra
  authentication by default.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — foundation, landing zone, and workload deploy in a
  fixed order through the CD pipelines.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
