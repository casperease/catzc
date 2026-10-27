# ADR: Landing zones — a CAF landing zone per subscription and the Well-Architected workload in it

Pairs with [`network-model`](azure-network-model.md) (the IP plan the landing zone deploys) and [`data-model`](azure-data-model.md) (the
configuration tree and the config-addressed parameters it reads).

## Rules: ADR-AZ-LZ

### Rule ADR-AZ-LZ-LANDINGZONE

A **landing zone** is the network, the guardrails, and the cost control a workload lands in, deployed once per subscription at subscription
scope by the `discovery` template, the **Cloud Adoption Framework** (CAF) application landing zone. Its boundary is the subscription: it
owns no **management group** and deploys nothing at management-group or tenant level, and it holds no workload of its own.

- [The subscription landing zone](landing-zones/landing-zones-topology.md#the-subscription-landing-zone)
- [How this is enforced](landing-zones/landing-zones-operations.md#how-this-is-enforced)

### Rule ADR-AZ-LZ-HUBANDSPOKE

The landing zones form a hub-and-spoke network. A **hub** is the landing zone of a shared subscription; a **spoke** is the landing zone of a
customer subscription, peered to the hub of its tier. Peering is static and two-sided: a spoke's config names its hub, and a hub's config
lists its spokes. The private DNS zones live in the hub and are linked to the hub and to every spoke it lists. `network.yml` is the one home
of every range, and the landing zone reads the kind, the address space, and the subnets by config address, never as a copy.

- [Hub and spoke](landing-zones/landing-zones-topology.md#hub-and-spoke)
- [How this is enforced](landing-zones/landing-zones-operations.md#how-this-is-enforced)

### Rule ADR-AZ-LZ-LANDINGZONEPOLICIES

Every landing zone assigns the ten policies of `landing-zone-policies.bicep`: allowed locations (its region), the six CAF tags required on
resources (one custom definition, deny), no public IP address on a network interface, no public network access on a storage account and on a
SQL server, a diagnostic setting on every data resource, the allowed storage SKUs, the allowed virtual machine sizes, the allowed resource
types (the types the shared modules declare), and the Microsoft cloud security benchmark initiative, assigned to audit only. Whether the
assignments enforce or only audit is the repository-wide setting `policy_enforcement`, read by config address, with its sensible default
declared once ([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)); the benchmark is
`DoNotEnforce` whatever the setting. The subscription's activity log streams to `foundation`'s Log Analytics workspace through a diagnostic
setting the landing zone deploys, never through a deploy-if-not-exists policy. Apart from the CAF-tags definition the policies are built-in,
each pinned by its definition id in `landing-zone-policies.bicep`, and each is assigned once per subscription, with no exclusion and no
exemption.

- [Guardrails](landing-zones/landing-zones-topology.md#guardrails)
- [How this is enforced](landing-zones/landing-zones-operations.md#how-this-is-enforced)

### Rule ADR-AZ-LZ-WORKLOADOWNSNONE

A workload lands in its landing zone and owns none of it. `expedition` places its private endpoints in the `private-endpoints` subnet of its
customer's spoke (the shared platform's in the hub's `shared-services` subnet) and registers them in the hub's private DNS zones; it creates
no network, peering, DNS zone, or policy.

- [The workload in the landing zone](landing-zones/landing-zones-topology.md#the-workload-in-the-landing-zone)

### Rule ADR-AZ-LZ-EVERYPILLAR

The workload realises every **pillar** of the Azure **Well-Architected Framework**, each as a module default or a config value. Reliability:
zone-redundant storage, and in production a zone-redundant database with geo-redundant backups. Security: no public network access, private
endpoints only, TLS 1.2 minimum, a managed identity, and Entra ID authentication (ADR-AZ-LZ-SQLENTRAADMINS). Cost optimisation: a serverless
database that pauses when idle outside production, a provisioned one in production. Operational excellence: diagnostics from every resource
to `foundation`'s workspace, and the CAF tags on every resource. Performance efficiency: the database SKU, tier, and capacity per
environment class, from the config.

- [The Well-Architected checklist](landing-zones/landing-zones-topology.md#the-well-architected-checklist)

### Rule ADR-AZ-LZ-SQLENTRAADMINS

A SQL server authenticates its administrators through an Entra ID group first. Beside it sits one **break-glass login**, a SQL login whose
password is a Key Vault reference to `foundation`'s vault in the same subscription, so the repository holds no secret.

- [SQL authentication](landing-zones/landing-zones-operations.md#sql-authentication)

### Rule ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS

A peering and a DNS zone link need both virtual networks to exist. So a spoke is added in three steps: the hub deploys without listing the
new spoke, the spoke deploys and peers to the hub, then the hub's config lists the spoke and the hub deploys again, adding its peering and
its zone links. A hub that lists a spoke whose virtual network does not exist fails its deploy. A new set of landing zones rolls out the
same way: hubs, then spokes, then hubs again.

- [Adding a spoke](landing-zones/landing-zones-operations.md#adding-a-spoke)

### Rule ADR-AZ-LZ-GOVERNANCELIMITS

The landing zone governs location, tagging, exposure, data diagnostics, the storage and virtual machine SKUs, and the resource types, and
nothing else. Its one custom definition is the CAF-tags rule, defined at subscription scope beside its assignment; every other assignment is
a built-in pinned by its id, and its one initiative is the Microsoft cloud security benchmark, assigned to audit only. The allowed resource
types are derived at build time from the types the shared modules deploy (the `module_resource_types` fact), never a hand-kept list. It
assigns no regulatory initiative and no resource-provider policy, makes no assignment above a subscription, and grants roles only as
ADR-AZ-LZ-CAFIDENTITY declares. A repository whose customer carries a regulation adds the matching built-in initiative to the landing zone's
set, pinned like the others.

- [Governance limits](landing-zones/landing-zones-topology.md#governance-limits)

### Rule ADR-AZ-LZ-COSTATTRIBUTION

Every landing zone deploys a monthly budget whose alerts at 50, 80, and 100 percent of actual cost reach the subscription's `Owner` role,
and every resource names its paying team in `cost-center` and its workload in `workload`.

- [Cost attribution](landing-zones/landing-zones-topology.md#cost-attribution)

### Rule ADR-AZ-LZ-CAFPRINCIPLES

The landing zone follows the five CAF design principles at subscription level and deviates from two on purpose. Subscriptions are the unit
of management and are given to the repository, never vended by it, and policy is assigned per subscription, never inherited from a
management group. Every change is an Azure Resource Manager deployment through Bicep and the az CLI, and every service is Azure-native.
Monitoring is one Log Analytics workspace per subscription, not one central workspace.

- [CAF design principles](landing-zones/landing-zones-caf.md#caf-design-principles)

### Rule ADR-AZ-LZ-CAFMANAGEMENT

Management is one Log Analytics workspace per subscription from `foundation`, kept 30 days, with the subscription's activity log and the
diagnostics of every resource sent there by a diagnostic setting the owning template deploys, never by policy. It adds no virtual machine
tooling and no on-premises forwarding. The templates add what the resources need: Service Health and Resource Health alerts, SQL database
metric alerts and a break-glass sign-in alert, delete locks on the hub network, the private DNS zones and the Key Vault, and a virtual
network flow log where a flow-log storage account is configured. Each workload's health model is an Azure Monitor workbook in its own
template, `health-workbook.bicep` through `workbook.bicep`, over the Resource Health and the fired alerts of the workload's resource group;
never an Azure Monitor health model, which is in preview and builds on Service Groups at tenant level. A customer with a longer retention
obligation or a virtual machine adds the matching piece to the template that owns the resource.

- [CAF management](landing-zones/landing-zones-caf.md#caf-management)

### Rule ADR-AZ-LZ-CAFTAGS

Every taggable resource carries the six **CAF tags** from its config, lowercase and holding codes only: `cost-center`, `workload`,
`environment`, `owner`, `criticality`, and `data-classification`, all six required by policy. A shared module takes `tags` exactly when its
resource type supports them. Region, tier, repository, service-level, and purpose tags are not used.

- [CAF tags](landing-zones/landing-zones-caf.md#caf-tags)

### Rule ADR-AZ-LZ-CAFSECURITY

The platform's security is the landing zone's policy assignments, one Key Vault per subscription authorized through Azure RBAC,
system-assigned managed identities, private endpoints for data, the diagnostics of every resource in the subscription's workspace, and
Defender for Cloud: `discovery` turns on the Defender plans of the services the landing zone runs (`defenderPlans`) and assigns the
Microsoft cloud security benchmark initiative in `DoNotEnforce` mode, so it measures and never denies. Sentinel, Purview, customer-managed
keys, and every virtual machine control are not deployed.

- [CAF security](landing-zones/landing-zones-caf.md#caf-security)

### Rule ADR-AZ-LZ-CAFIDENTITY

The templates assign built-in roles to groups and managed identities, never to users; no group, user, custom role or directory object is
created. Each role id is addressed from `roles.yml`, each group object id from the `groups:` map of `azure.yml` by owner and environment
class, and services authenticate as system-assigned managed identities. Operators grant roles only under an attribute-based condition that
limits them to the data roles; the data roles themselves carry no condition, because no tagged-container model exists to condition them on.
The tenant's directory, its groups' membership, its sign-in policies, and its privileged access belong to the tenant's administrators.

- [CAF identity](landing-zones/landing-zones-caf.md#caf-identity)

### Rule ADR-AZ-LZ-CAFDELIVERY

Everything that builds, tests, deploys, or documents the platform is code in one Git repository, developed trunk-based on `main` with
short-lived branches, built and tested on every change under `infrastructure/`, and deployed only by pipelines on Microsoft-hosted agents
through one service connection per subscription. Pipelines hold no secret, and no service connection holds one either: every connection
authenticates by workload identity federation, the only scheme `service-connections.yml` can express, and `Sync-AdoServiceConnections`
applies that file to Azure DevOps the way `Sync-AdoEnvironmentApprovals` applies the environments' checks, so the connections are code in
the repository like the rest. The server's branch policies are created outside the repository.

- [CAF delivery](landing-zones/landing-zones-caf.md#caf-delivery)

### Rule ADR-AZ-LZ-COSTBYCLASS

Cost is shaped by configuration, not by a different design. The modules hold the production-grade defaults and a non-production config turns
them down: the same SKU family and tier, but a serverless database that pauses when idle, no zone redundancy, locally redundant backups with
a 7-day restore window, an audit-only policy mode, and a smaller budget. Every resource is billed pay-as-you-go, because reservations,
savings plans, licence benefits, and dev/test offers are bought at the billing account and the subscription offer, above the subscription
the repository deploys into. Shared services exist once per subscription and per tier and are consumed, never copied, and production and
non-production are never consolidated.

- [Cost by configuration](landing-zones/landing-zones-well-architected.md#cost-by-configuration)

### Rule ADR-AZ-LZ-PERFBYCONFIG

Performance is capacity set by configuration on platform services. The templates choose managed services over custom builds, in one region,
and write every capacity (database SKU, vCores, serverless floor and ceiling, budget) as a per-environment-class config value. The examples
set no numeric performance target, run no load test, and tune no schema, because they deploy no application code, users, or flows; a
workload built on them sets its own targets, tests, alerts, and tuning before its first production deploy. Measurement is a diagnostic
setting per resource into the subscription's own workspace, so production and non-production signals never share one.

- [Performance by configuration](landing-zones/landing-zones-well-architected.md#performance-by-configuration)

### Rule ADR-AZ-LZ-ONEREGIONRELIABILITY

Reliability is redundancy inside one region, isolation per customer subscription, and recovery by redeploy and restore. Every resource is a
managed platform service built from a shared module with secure, redundant defaults, and no template runs self-managed compute: storage is
zone-redundant in every environment, and a production database is zone-redundant with geo-redundant backups. A second region is not
prepared, because every environment maps to one region, and a regional recovery changes the environment's region and redeploys. The examples
have no users, so they hold no flow catalogue, failure mode analysis per flow, availability objective, or resiliency drill; those belong to
a workload that has users.

- [Reliability in one region](landing-zones/landing-zones-well-architected.md#reliability-in-one-region)

### Rule ADR-AZ-LZ-SECUREBYDEFAULT

Security is a secure default of each shared Bicep module, so every caller gets it unless it turns it off, with the subscription-wide
guardrails in the landing zone and the per-environment settings in config. Data services have public network access off and are reached only
through private endpoints, inbound internet traffic is denied at every workload subnet, data is encrypted in transit with TLS 1.2 at minimum
and at rest with the platform's Microsoft-managed keys, people reach data through Entra ID groups and services through managed identities,
and the repository holds no secret. Incident response, threat detection, conditional access, and management groups belong to the tenant's
administrators and security operations; the repository supplies the owner tag, the configuration tree as inventory, and the logs in one
workspace.

- [Security by default](landing-zones/landing-zones-well-architected.md#security-by-default)

### Rule ADR-AZ-LZ-OPSASCODE

The infrastructure is built and run as code, with no WAF-specific mechanism beside it. The standard practices are the ADRs, enforced by
quality gates; routine operations are version-controlled automation functions and pipelines, never manual runbooks kept elsewhere; all Azure
infrastructure is declarative Bicep, one parameterised template per rate of change, shared modules, and one config per configuration slot,
deployed only by pipelines; and every change travels one supply chain, a CD pipeline triggered by its deployable unit's globset that builds
once and deploys the same artifact in dependency order into subscriptions it asserts. Team roles, decision authority, and the incident
response roles belong to the operating organisation, and the repository carries what a repository can: the `owner` tag, the written
procedure, and the logs.

- [Operations as code](landing-zones/landing-zones-operations.md#operations-as-code)

## Context

The repository deploys infrastructure per subscription and per customer, through templates whose configuration tree is the deployment
inventory ([data-model](azure-data-model.md)). `foundation` gives every subscription its Log Analytics workspace and Key Vault. What a
workload needs beyond that — a network to land in, private name resolution, guardrails that stop a non-compliant resource, and a cap on
spend — is the same for every workload of a subscription, so it belongs to the subscription, not to each workload.

Microsoft's Cloud Adoption Framework calls that shared foundation a landing zone, and its Azure Well-Architected Framework names the five
qualities a workload is reviewed against. The examples in this repository tell that story in three templates: `foundation`, then `discovery`
(the landing zone), then `expedition` (a workload that lands in it), each deployed after the one before.

## Decision

The decision is told in four pages, one per group of sections:

- [Topology, guardrails and limits](landing-zones/landing-zones-topology.md):
  [The subscription landing zone](landing-zones/landing-zones-topology.md#the-subscription-landing-zone),
  [Hub and spoke](landing-zones/landing-zones-topology.md#hub-and-spoke), [Guardrails](landing-zones/landing-zones-topology.md#guardrails),
  [The workload in the landing zone](landing-zones/landing-zones-topology.md#the-workload-in-the-landing-zone),
  [The Well-Architected checklist](landing-zones/landing-zones-topology.md#the-well-architected-checklist),
  [Governance limits](landing-zones/landing-zones-topology.md#governance-limits),
  [Cost attribution](landing-zones/landing-zones-topology.md#cost-attribution).
- [The Cloud Adoption Framework areas](landing-zones/landing-zones-caf.md):
  [CAF design principles](landing-zones/landing-zones-caf.md#caf-design-principles),
  [CAF management](landing-zones/landing-zones-caf.md#caf-management), [CAF tags](landing-zones/landing-zones-caf.md#caf-tags),
  [CAF security](landing-zones/landing-zones-caf.md#caf-security), [CAF identity](landing-zones/landing-zones-caf.md#caf-identity),
  [CAF delivery](landing-zones/landing-zones-caf.md#caf-delivery).
- [The Well-Architected pillars](landing-zones/landing-zones-well-architected.md):
  [Cost by configuration](landing-zones/landing-zones-well-architected.md#cost-by-configuration),
  [Performance by configuration](landing-zones/landing-zones-well-architected.md#performance-by-configuration),
  [Reliability in one region](landing-zones/landing-zones-well-architected.md#reliability-in-one-region),
  [Security by default](landing-zones/landing-zones-well-architected.md#security-by-default).
- [Operations, authentication and enforcement](landing-zones/landing-zones-operations.md):
  [Operations as code](landing-zones/landing-zones-operations.md#operations-as-code),
  [SQL authentication](landing-zones/landing-zones-operations.md#sql-authentication),
  [Adding a spoke](landing-zones/landing-zones-operations.md#adding-a-spoke),
  [How this is enforced](landing-zones/landing-zones-operations.md#how-this-is-enforced).

## Consequences

- Every subscription gets the same landing zone from one template, so the network, the policies, and the budget of a new customer
  subscription are a config file, not a design.
- A workload template carries only its own resources; a second workload lands in the same spoke with no network work.
- Policy enforcement changes for the whole repository with one edit to `azure.yml`.
- The repository never needs rights above a subscription, at the cost of leaving management-group policy to the tenant's administrators.
- Adding a spoke takes three deploys in a fixed order; the static peering list keeps the topology reviewable in the configuration tree.
