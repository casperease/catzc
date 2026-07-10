# DORA explanations — azure

The `Dora explains` rationale for the ADRs in the `azure/` domain, consolidated in one place. Each entry
names its ADR and rule code, then reproduces that ADR's tie to [DORA](https://dora.dev/research/) research and
the domain-relevant capability links. The decisions live in the ADRs themselves; this file carries only their
DORA rationale.

## Templating data model (`azure.yml` + `infrastructure/`) (`ADR-AZ-DATAMOD`)

DORA's research connects infrastructure-as-code and version-controlled configuration to lower deployment lead time and enable rapid,
reliable infrastructure changes. This ADR encodes Azure infrastructure as derived, deterministic config with no hand-typed values, enabling
safe automation.

- [Version control](https://dora.dev/capabilities/version-control/) — configuration is the single source of truth for Azure resources.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — templates and configs drive repeatable Azure deployments.
- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — infrastructure-as-code model with config-driven
  subscriptions.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — one-living-version data model (no legacy shapes).
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Network model (`network.yml`) (`ADR-AZ-NETWORK`)

DORA's research shows that infrastructure-as-code and centralized, single-source-of-truth configuration reduce errors and deployment lead
time. This ADR encodes the network plan as a versioned asset, with cross-asset integrity rules preventing configuration drift.

- [Version control](https://dora.dev/capabilities/version-control/) — IP plan is a versioned, authoritative source.
- [Flexible infrastructure](https://dora.dev/capabilities/flexible-infrastructure/) — network topology defined as declarative configuration.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — network plan drives template deployments and vnet setup.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Azure resource naming standard (`ADR-AZ-NAMING`)

DORA research shows that standardized, maintainable naming and configuration-driven automation reduce deployment lead time and errors. This
ADR encodes deterministic, derived resource names that are never hand-typed, enabling safe infrastructure automation.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — standardized, deterministic naming rules reduce cognitive
  load.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — derived naming enables reliable, repeatable resource
  naming.
- [Version control](https://dora.dev/capabilities/version-control/) — naming rules versioned as configuration, reproducible and auditable.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.

## Customer model (`customer.yml`) — catalogue, two-name binding, and the template switch (`ADR-AZ-CUSTOMER`)

DORA's research links single-source-of-truth configuration and one-living-version practices to faster, more reliable delivery. This ADR
encodes the customer catalogue as the authoritative source, enabling predictable customer-scoped deployments without policy coupling.

- [Version control](https://dora.dev/capabilities/version-control/) — customer catalogue as a versioned, authoritative asset.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — one-living-version principle (no legacy customer
  definitions).
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — customer model drives repeatable deployment patterns.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
