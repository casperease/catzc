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

## Well-Architected reliability

`Well-Architected reliability — Microsoft's reliability checklist, cited, and what the templates do about each item`

[ADR-AZ-WAFRE](waf/reliability.md)

> DORA's research treats reliability as an outcome a team engineers for and measures, not one it hopes for. This ADR records, item by item,
> which reliability settings the templates carry by default and which are planned, so the gap is visible in the repository.

- [Reliability engineering](../../references/dora/capabilities.md#reliability-engineering) — zone redundancy and backups are module defaults
  and config values, each item with a status.
- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — diagnostics flow to one workspace per
  subscription.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Well-Architected security

`Well-Architected security — what the repository does about each item of the WAF security checklist`

[ADR-AZ-WAFSE](waf/security.md)

> DORA's research ties pervasive security, built into the delivery flow rather than reviewed at its end, to delivery performance. This ADR
> records which security items the shared modules enforce by default and which are planned.

- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — private endpoints, TLS 1.2, managed identities, and Entra
  authentication are secure defaults.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — the same defaults reach every environment through
  the same templates.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Well-Architected cost optimization

`Well-Architected cost optimization — what the repository does about each item of Microsoft's checklist`

[ADR-AZ-WAFCO](waf/cost-optimization.md)

> DORA's research links flexible infrastructure, provisioned on demand and sized by configuration, to delivery performance. This ADR records
> which cost items the configs realise — serverless outside production, budgets per subscription — and which are planned.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — SKUs and budgets are config values per
  environment class.
- [Version control](../../references/dora/capabilities.md#version-control) — every cost setting is reviewable in the configuration tree.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Well-Architected operational excellence

`Operational excellence — the Well-Architected checklist, item by item, as this repository delivers and runs its infrastructure`

[ADR-AZ-WAFOE](waf/operational-excellence.md)

> DORA's research is the repository's own basis for how it delivers; the operational excellence pillar overlaps it most. This ADR maps each
> item to the pipelines, gates, and conventions that already realise it, and names what is planned.

- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — infrastructure changes flow through the CI and CD
  pipelines.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — every deploy runs from a template and its config.
- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — diagnostics and tags on every
  resource.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Well-Architected performance efficiency

`Performance efficiency — the Well-Architected checklist PE:01 to PE:12, rule by rule, against foundation, discovery and expedition`

[ADR-AZ-WAFPE](waf/performance-efficiency.md)

> DORA's research ties flexible infrastructure and monitoring to delivery performance. This ADR records which performance items the configs
> realise — capacity per environment class — and which, such as load tests and capacity alerts, are planned.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — tier and capacity are config values.
- [Monitoring systems](../../references/dora/capabilities.md#monitoring-systems) — metrics reach one workspace per subscription.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF design principles

`CAF landing zone design principles — Microsoft's five principles, cited, and where this repository follows or deviates from each`

[ADR-AZ-CAFPRIN](caf/design-principles.md)

> DORA's research favours self-service platforms and loosely coupled teams. This ADR records where the repository follows Microsoft's
> landing-zone principles — subscription democratisation, policy-driven governance, an application-centric landing zone — and where it
> deviates.

- [Platform engineering](../../references/dora/capabilities.md#platform-engineering) — the landing zone is one template every subscription
  receives.
- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — a workload lands in its subscription with no
  network work.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF governance

`CAF governance — what the repository does about each of Microsoft's governance design recommendations`

[ADR-AZ-CAFGOV](caf/governance.md)

> DORA's research finds that lightweight, automated controls beat heavyweight change approval. This ADR records which governance items are
> policy assignments and budgets in the landing zone, and which are planned.

- [Streamlining change approval](../../references/dora/capabilities.md#streamlining-change-approval) — guardrails are policy, not review
  boards.
- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — deny in production, audit outside it, by sensible
  default.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF naming and tagging

`CAF naming and tagging — what the repository does about each of Microsoft's naming and tagging recommendations`

[ADR-AZ-CAFNAME](caf/naming-and-tagging.md)

> DORA's research ties maintainable, standardised conventions to delivery performance. This ADR records how derived names and the CAF tags
> on every resource answer Microsoft's naming and tagging recommendations.

- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — names are derived, never hand-typed.
- [Work visibility in value stream](../../references/dora/capabilities.md#work-visibility-in-value-stream) — tags attribute every resource
  to its workload, owner, and cost center.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF security

`CAF security — what the repository does about each recommendation of the landing-zone security design area`

[ADR-AZ-CAFSEC](caf/landing-zone-security.md)

> DORA's research ties pervasive security to delivery performance. This ADR records which landing-zone security recommendations the
> templates realise and which are planned.

- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — secure defaults in the shared modules and policies in the
  landing zone.
- [Monitoring and observability](../../references/dora/capabilities.md#monitoring-and-observability) — the activity log streams to the
  subscription's workspace.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF resource organization

`CAF resource organization — what the repository does about each management group and subscription recommendation`

[ADR-AZ-CAFRESORG](caf/resource-organization.md)

> DORA's research links flexible, self-service infrastructure to delivery performance. This ADR records how a subscription is onboarded by
> pull request and why the repository deploys nothing above a subscription.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — subscription vending is a config change.
- [Version control](../../references/dora/capabilities.md#version-control) — the subscription inventory lives in `azure.yml`.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF management

`CAF management — what the repository does about each of Microsoft's management design recommendations`

[ADR-AZ-CAFMGMT](caf/management.md)

> DORA's research ties monitoring and proactive failure notification to delivery performance. This ADR records which management
> recommendations the workspaces and diagnostics realise and which, such as alerts, are planned.

- [Monitoring systems](../../references/dora/capabilities.md#monitoring-systems) — one Log Analytics workspace per subscription.
- [Proactive failure notification](../../references/dora/capabilities.md#proactive-failure-notification) — alerts and action groups are a
  recorded follow-up.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF billing and tenant

`CAF billing and tenant — what the repository does about each of Microsoft's billing and Entra tenant design recommendations`

[ADR-AZ-CAFBILL](caf/billing-and-tenant.md)

> DORA's research favours clear boundaries between what a team owns and what it is given. This ADR records which billing and tenant
> recommendations sit outside the repository and which it realises through budgets and tags.

- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — the tenant and billing account are administered
  outside the repository.
- [Work visibility in value stream](../../references/dora/capabilities.md#work-visibility-in-value-stream) — budgets and cost tags per
  subscription.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF identity and access

`CAF identity and access — what the repository does about each recommendation of the landing-zone identity and access design area`

[ADR-AZ-CAFIAM](caf/identity-and-access.md)

> DORA's research ties pervasive security to delivery performance. This ADR records which identity recommendations the templates realise —
> managed identities, Entra ID administrators, Key Vault references — and which are planned.

- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — no secret in the repository; access through groups.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — deploys run under service connections, never a
  person's account.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF network topology

`CAF network topology — what the repository does about each topology, IP addressing, segmentation, and Virtual Network Manager recommendation`

[ADR-AZ-CAFNETTOP](caf/network-topology.md)

> DORA's research links infrastructure as code and a single source of truth to fewer errors. This ADR records how the hub-and-spoke network
> and its ranges in `network.yml` answer Microsoft's topology recommendations.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — every range and subnet is configuration.
- [Version control](../../references/dora/capabilities.md#version-control) — the network plan is one checked file.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF network connectivity

`CAF network connectivity — what the repository does about each recommendation on reaching, leaving, and protecting its networks`

[ADR-AZ-CAFNETCON](caf/network-connectivity.md)

> DORA's research ties pervasive security to delivery performance. This ADR records which connectivity recommendations — inbound and
> outbound internet, inspection, encryption — the landing zone realises and which are planned.

- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — no public IP on a network interface, private endpoints
  only.
- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — reserved subnets let a gateway or firewall be
  added by config.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF network private access

`CAF network private access — what the repository does about each recommendation on PaaS connectivity and DNS`

[ADR-AZ-CAFNETPRV](caf/network-private-access.md)

> DORA's research ties pervasive security to delivery performance. This ADR records how private endpoints and the hub's private DNS zones
> answer Microsoft's PaaS connectivity and DNS recommendations.

- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — public network access off by default.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — endpoints and zone records deploy with the
  workload.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## CAF platform automation and DevOps

`CAF platform automation and DevOps — what the repository does about each recommendation of the design area`

[ADR-AZ-CAFDEVOPS](caf/platform-automation-and-devops.md)

> DORA's research is the repository's own basis for how it delivers, and this design area overlaps it most. This ADR maps each
> recommendation to the pipelines, gates, and infrastructure as code that already realise it, and names what is planned.

- [Continuous delivery](../../references/dora/capabilities.md#continuous-delivery) — every change reaches the environments through the same
  pipelines.
- [Version control](../../references/dora/capabilities.md#version-control) — templates, configs, and pipelines live in one repository.
- [Test automation](../../references/dora/capabilities.md#test-automation) — templates compile and configs resolve in CI on every change.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Az CLI over Az PowerShell

`Prefer Az CLI over Az PowerShell modules`

[ADR-AZ-CLI](prefer-az-cli.md)

> DORA research links tool standardization and process isolation to faster deployments and fewer failures. Using a single executable tool
> across all environments removes version skew and assembly conflicts.

- [Flexible infrastructure](../../references/dora/capabilities.md#flexible-infrastructure) — single tool, process isolation, no hidden
  dependencies.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — single tool eliminates environment-specific
  failures.
- [Code maintainability](../../references/dora/capabilities.md#code-maintainability) — explicit dependencies and simple return types reduce
  risk.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.

## Az CLI session verification

`Az CLI session verification — three layers, and verify is not connect`

[ADR-AZ-SESSION](az-session-verification.md)

> DORA's research links robust authentication and authorization practices to reliable, secure deployments. Layering session verification and
> keeping concerns separate enables safe, auditable automation while maintaining module independence.

- [Pervasive security](../../references/dora/capabilities.md#pervasive-security) — layered verification ensures sessions are authenticated
  to the correct subscription before any deployment automation proceeds.
- [Loosely coupled teams](../../references/dora/capabilities.md#loosely-coupled-teams) — separating by-args and config-aware verification
  allows modules to verify session state without depending on templating configuration.
- [Deployment automation](../../references/dora/capabilities.md#deployment-automation) — clean session verification functions enable safe,
  automated deployments with proper auth checks at each layer.
- [DORA research reference](../../references/dora/index.md) — the overview these findings sit within.
