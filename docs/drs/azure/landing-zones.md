# ADR: Landing zones — a CAF landing zone per subscription and the Well-Architected workload in it

Pairs with [`network-model`](azure-network-model.md) (the IP plan the landing zone deploys) and [`data-model`](azure-data-model.md) (the
configuration tree and the config-addressed parameters it reads).

## Rules: ADR-AZ-LZ

### Rule ADR-AZ-LZ-LANDINGZONE

A **landing zone** is the network, the guardrails, and the cost control a workload lands in, deployed once per subscription at subscription
scope by the `discovery` template, the **Cloud Adoption Framework** (CAF) application landing zone. Its boundary is the subscription: it
owns no **management group** and deploys nothing at management-group or tenant level, and it holds no workload of its own.

- [The subscription landing zone](#the-subscription-landing-zone)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-LZ-HUBANDSPOKE

The landing zones form a hub-and-spoke network. A **hub** is the landing zone of a shared subscription; a **spoke** is the landing zone of a
customer subscription, peered to the hub of its tier. Peering is static and two-sided: a spoke's config names its hub, and a hub's config
lists its spokes. The private DNS zones live in the hub and are linked to the hub and to every spoke it lists. `network.yml` is the one home
of every range, and the landing zone reads the kind, the address space, and the subnets by config address, never as a copy.

- [Hub and spoke](#hub-and-spoke)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-LZ-THREEBUILTINPOLICIES

Every landing zone assigns three built-in policies: allowed locations (its region), a required tag on resources, and no public IP address on
a network interface. Whether they enforce or only audit is the repository-wide setting `policy_enforcement`, read by config address, with
its sensible default declared once ([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)).
The subscription's activity log streams to `foundation`'s Log Analytics workspace through a diagnostic setting the landing zone deploys,
never through a deploy-if-not-exists policy. The policies are built-in only, each pinned by its definition id in `discovery/main.bicep` and
registered in `guids.yml`, and each is assigned once per subscription, with no exclusion and no exemption.

- [Guardrails](#guardrails)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-LZ-WORKLOADOWNSNONE

A workload lands in its landing zone and owns none of it. `expedition` places its private endpoints in the `private-endpoints` subnet of its
customer's spoke (the shared platform's in the hub's `shared-services` subnet) and registers them in the hub's private DNS zones; it creates
no network, peering, DNS zone, or policy.

- [The workload in the landing zone](#the-workload-in-the-landing-zone)

### Rule ADR-AZ-LZ-EVERYPILLAR

The workload realises every **pillar** of the Azure **Well-Architected Framework**, each as a module default or a config value. Reliability:
zone-redundant storage, and in production a zone-redundant database with geo-redundant backups. Security: no public network access, private
endpoints only, TLS 1.2 minimum, a managed identity, and Entra ID authentication (ADR-AZ-LZ-SQLENTRAADMINS). Cost optimisation: a serverless
database that pauses when idle outside production, a provisioned one in production. Operational excellence: diagnostics from every resource
to `foundation`'s workspace, and the CAF tags on every resource. Performance efficiency: the database SKU, tier, and capacity per
environment class, from the config.

- [The Well-Architected checklist](#the-well-architected-checklist)

### Rule ADR-AZ-LZ-SQLENTRAADMINS

A SQL server authenticates its administrators through an Entra ID group first. Beside it sits one **break-glass login**, a SQL login whose
password is a Key Vault reference to `foundation`'s vault in the same subscription, so the repository holds no secret.

- [SQL authentication](#sql-authentication)

### Rule ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS

A peering and a DNS zone link need both virtual networks to exist. So a spoke is added in three steps: the hub deploys without listing the
new spoke, the spoke deploys and peers to the hub, then the hub's config lists the spoke and the hub deploys again, adding its peering and
its zone links. A hub that lists a spoke whose virtual network does not exist fails its deploy. A new set of landing zones rolls out the
same way: hubs, then spokes, then hubs again.

- [Adding a spoke](#adding-a-spoke)

### Rule ADR-AZ-LZ-GOVERNANCELIMITS

The landing zone governs location, tagging, and exposure, and nothing else. It defines no custom policy, assigns no regulatory initiative
and no resource-provider or resource-type policy, makes no assignment above a subscription, and grants no role to an application team. A
repository whose customer carries a regulation, or that must narrow the services a subscription may use, adds the matching built-in
definition to the landing zone's set, pinned like the others.

- [Governance limits](#governance-limits)

### Rule ADR-AZ-LZ-COSTATTRIBUTION

Every landing zone deploys a monthly budget whose alerts at 50, 80, and 100 percent of actual cost reach the subscription's `Owner` role,
and every resource names its paying team in `cost-center` and its workload in `workload`.
- [Cost attribution](#cost-attribution)

### Rule ADR-AZ-LZ-CAFPRINCIPLES

The landing zone follows the five CAF design principles at subscription level and deviates from two on purpose. Subscriptions are the unit
of management and are given to the repository, never vended by it, and policy is assigned per subscription, never inherited from a
management group. Every change is an Azure Resource Manager deployment through Bicep and the az CLI, and every service is Azure-native.
Monitoring is one Log Analytics workspace per subscription, not one central workspace.

- [CAF design principles](#caf-design-principles)

### Rule ADR-AZ-LZ-CAFMANAGEMENT

Management is one Log Analytics workspace per subscription from `foundation`, kept 30 days, with the subscription's activity log and the
diagnostics of every resource sent there by a diagnostic setting the owning template deploys, never by policy. It adds no virtual machine
tooling, no on-premises forwarding, no alert rule, no lock, and no flow log; a customer with a longer retention obligation or a virtual
machine adds the matching piece to the template that owns the resource.

- [CAF management](#caf-management)

### Rule ADR-AZ-LZ-CAFTAGS

Every taggable resource carries the six **CAF tags** from its config, lowercase and holding codes only: `cost-center` (required by policy),
`workload`, `environment`, `owner`, `criticality`, and `data-classification`. A shared module takes `tags` exactly when its resource type
supports them. Region, tier, repository, service-level, and purpose tags are not used.

- [CAF tags](#caf-tags)

### Rule ADR-AZ-LZ-CAFSECURITY

The platform's security is the three subscription policies, one Key Vault per subscription authorized through Azure RBAC, system-assigned
managed identities, private endpoints for data, and the diagnostics of every resource in the subscription's workspace. Defender for Cloud,
Sentinel, Purview, customer-managed keys, and every virtual machine control are not deployed.

- [CAF security](#caf-security)

### Rule ADR-AZ-LZ-CAFIDENTITY

Every principal the templates name is a group or a role, never a user, and services authenticate as system-assigned managed identities. The
templates create no group, user, role assignment, custom role, or directory resource; the tenant's directory, its sign-in policies, and its
privileged access belong to the tenant's administrators.

- [CAF identity](#caf-identity)

### Rule ADR-AZ-LZ-CAFDELIVERY

Everything that builds, tests, deploys, or documents the platform is code in one Git repository, developed trunk-based on `main` with
short-lived branches, built and tested on every change under `infrastructure/`, and deployed only by pipelines on Microsoft-hosted agents
through one service connection per subscription. Pipelines hold no secret. The service connections, the Azure DevOps environments and their
checks, and the server's branch policies are created outside the repository.

- [CAF delivery](#caf-delivery)

### Rule ADR-AZ-LZ-COSTBYCLASS

Cost is shaped by configuration, not by a different design. The modules hold the production-grade defaults and a non-production config turns
them down: the same SKU family and tier, but a serverless database that pauses when idle, no zone redundancy, locally redundant backups with
a 7-day restore window, an audit-only policy mode, and a smaller budget. Every resource is billed pay-as-you-go, because reservations,
savings plans, licence benefits, and dev/test offers are bought at the billing account and the subscription offer, above the subscription
the repository deploys into. Shared services exist once per subscription and per tier and are consumed, never copied, and production and
non-production are never consolidated.

- [Cost by configuration](#cost-by-configuration)

### Rule ADR-AZ-LZ-PERFBYCONFIG

Performance is capacity set by configuration on platform services. The templates choose managed services over custom builds, in one region,
and write every capacity (database SKU, vCores, serverless floor and ceiling, budget) as a per-environment-class config value. The examples
set no numeric performance target, run no load test, and tune no schema, because they deploy no application code, users, or flows; a
workload built on them sets its own targets, tests, alerts, and tuning before its first production deploy. Measurement is a diagnostic
setting per resource into the subscription's own workspace, so production and non-production signals never share one.

- [Performance by configuration](#performance-by-configuration)

### Rule ADR-AZ-LZ-ONEREGIONRELIABILITY

Reliability is redundancy inside one region, isolation per customer subscription, and recovery by redeploy and restore. Every resource is a
managed platform service built from a shared module with secure, redundant defaults, and no template runs self-managed compute: storage is
zone-redundant in every environment, and a production database is zone-redundant with geo-redundant backups. A second region is not
prepared, because every environment maps to one region, and a regional recovery changes the environment's region and redeploys. The examples
have no users, so they hold no flow catalogue, failure mode analysis per flow, availability objective, or resiliency drill; those belong to
a workload that has users.

- [Reliability in one region](#reliability-in-one-region)

### Rule ADR-AZ-LZ-SECUREBYDEFAULT

Security is a secure default of each shared Bicep module, so every caller gets it unless it turns it off, with the subscription-wide
guardrails in the landing zone and the per-environment settings in config. Data services have public network access off and are reached only
through private endpoints, inbound internet traffic is denied at every workload subnet, data is encrypted in transit with TLS 1.2 at minimum
and at rest with the platform's Microsoft-managed keys, people reach data through Entra ID groups and services through managed identities,
and the repository holds no secret. Incident response, threat detection, conditional access, and management groups belong to the tenant's
administrators and security operations; the repository supplies the owner tag, the configuration tree as inventory, and the logs in one
workspace.

- [Security by default](#security-by-default)

### Rule ADR-AZ-LZ-OPSASCODE

The infrastructure is built and run as code, with no WAF-specific mechanism beside it. The standard practices are the ADRs, enforced by
quality gates; routine operations are version-controlled automation functions and pipelines, never manual runbooks kept elsewhere; all Azure
infrastructure is declarative Bicep, one parameterised template per rate of change, shared modules, and one config per configuration slot,
deployed only by pipelines; and every change travels one supply chain, a CD pipeline triggered by its deployable unit's globset that builds
once and deploys the same artifact in dependency order into subscriptions it asserts. Team roles, decision authority, and the incident
response roles belong to the operating organisation, and the repository carries what a repository can: the `owner` tag, the written
procedure, and the logs.

- [Operations as code](#operations-as-code)

## Context

The repository deploys infrastructure per subscription and per customer, through templates whose configuration tree is the deployment
inventory ([data-model](azure-data-model.md)). `foundation` gives every subscription its Log Analytics workspace and Key Vault. What a
workload needs beyond that — a network to land in, private name resolution, guardrails that stop a non-compliant resource, and a cap on
spend — is the same for every workload of a subscription, so it belongs to the subscription, not to each workload.

Microsoft's Cloud Adoption Framework calls that shared foundation a landing zone, and its Azure Well-Architected Framework names the five
qualities a workload is reviewed against. The examples in this repository tell that story in three templates: `foundation`, then `discovery`
(the landing zone), then `expedition` (a workload that lands in it), each deployed after the one before.

## Decision

### The subscription landing zone

`discovery` deploys at subscription scope (`deployment_target: Subscription`), one config per subscription keyed by the per-subscription
environment (`nsub`, `psub`), at the same coordinates as `foundation`. Each deploy creates one resource group with the virtual network, a
network security group per subnet that carries workloads (allowing traffic inside the virtual networks, denying inbound traffic from the
internet), the guardrails, and a budget whose alerts go to the subscription's `Owner` role, so no address is kept in a config.

The landing zone stops at the subscription. Management groups, their policy inheritance, and tenant-level deployments belong to whoever
administers the tenant; a repository that deploys into subscriptions it is given cannot assume it owns the hierarchy above them. Everything
the landing zone needs — its policies, its diagnostics, its budget — is assigned at subscription level, where the service connection that
deploys it has rights.

### Hub and spoke

Each tier of shared subscriptions (non-production, production) holds a hub; each customer subscription holds a spoke peered to the hub of
its tier ([ADR-AZ-NETWORK-PERSUBSCRIPTION](azure-network-model.md#rule-adr-az-network-persubscription)). The hub reserves `GatewaySubnet`
and `AzureFirewallSubnet`, and nothing is deployed into them, so a gateway or a firewall can be added without renumbering. A spoke adds a
route table on every subnet.

Peering is declared on both sides because Azure models it on both sides: a peering is a child of one virtual network and points at the
other. Declaring both in configs keeps the topology readable from the configuration tree alone, with no discovery step at deploy time.

The private DNS zones of the private-link services the workloads use live once, in the hub, and are linked to every spoke the hub lists. A
private endpoint in any spoke then resolves through the same zone, and no spoke carries a copy that could disagree.

The ranges come from `network.yml` by config address ([ADR-AZ-NETWORK-ONEIPPLAN](azure-network-model.md#rule-adr-az-network-oneipplan),
[ADR-AZ-DATAMOD-VALUEBYADDRESS](azure-data-model.md#rule-adr-az-datamod-valuebyaddress)): the kind, the address space, and the subnet map of
the subscription. The landing zone's config therefore holds names, never addresses, and the overlap check of the network plan
([ADR-AZ-NETWORK-NOOVERLAP](azure-network-model.md#rule-adr-az-network-nooverlap)) guarantees that any hub can peer to any spoke.

### Guardrails

The three policies are Azure built-in definitions, so their meaning is Microsoft's and needs no custom definition to maintain. Allowed
locations keeps every resource in the landing zone's region; the required tag keeps cost attributable; no public IP address on a network
interface keeps workloads behind private endpoints.

Whether the assignments enforce is a property of the repository, not of a template. `azure.yml` holds it as `policy_enforcement`; its
sensible default enforces in production and audits outside it, and a stricter repository overrides it in config
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)). The landing zone's `psub` config
reads the production mode and its `nsub` config the non-production mode, by config address.

Every resource the templates deploy carries the six CAF tags (`workload`, `environment`, `owner`, `cost-center`, `criticality`, and
`data-classification`) from its config, the required one among them, because the production assignment denies a resource without it.
`foundation` passes the same tags, so its resources pass the policy too. Only `cost-center` is required by policy; the other five are
required by convention and by review. Append and modify effects are not used: they fill a missing tag after the fact from a value the policy
holds rather than the config, and a modify policy needs a managed identity and remediation tasks for resources that exist before it. The
templates write every tag deterministically, so the policy's job is to stop a resource that skipped them, and deny does that.

Each policy is assigned at subscription scope, the highest level the repository owns, through
`infrastructure/modules/policy-assignment.bicep`, once per subscription and named per config (`policyAssignmentNames`, with the `-loc-pa`,
`-tag-pa`, and `-pip-pa` suffixes). `discovery/main.bicep` holds the three definition ids in its `policyDefinitions` map, each with its
parameters and a non-compliance message, and each config reads `policyEnforcementMode` from `global.azure.policy_enforcement`. No assignment
sets `assignIdentity`, so no remediation identity exists. Every resource group of the subscription inherits the assignments, those of
`foundation` and `expedition` included. Production and non-production differ through the enforcement mode, never through a narrower
assignment.

Keeping the policies current is a matter of their ids. Microsoft revises a built-in definition in place under the same id, so an assignment
follows the current version with no change here. When a definition is deprecated or a better one appears, the id in `main.bicep` and its
`guids.yml` entry (`policy_allowed_locations`, `policy_require_tag_on_resources`, `policy_nic_no_public_ip`) change together in one reviewed
change, and the repository never carries the old and the new definition side by side ([PDR-ONELIVE](../principles/one-living-version.md)).

The subscription's activity log streams to `foundation`'s workspace through a diagnostic setting the landing zone deploys. A
deploy-if-not-exists policy would reach the same end through a remediation task that runs later, needs a managed identity with rights to
write the setting, and reports compliance after the fact. A diagnostic setting in the template is deterministic: it exists when the deploy
succeeds, and a failed deploy says why.

### The workload in the landing zone

`expedition` deploys into its own resource group, one per configuration slot, inside the subscription its landing zone serves. It looks up
the spoke's `private-endpoints` subnet by name (the shared platform's `shared-services` subnet in the hub) and places a private endpoint for
each data service there, each registered in the hub's matching private DNS zone. It never creates a network or a guardrail: the landing zone
owns those, so every workload of a subscription meets the same network and the same policies. Each environment in `azure.yml` names one
region (`region: westeurope`, `region_code: weu`): `discovery` creates its resource group through `resource-group.bicep` at `location`,
which defaults to `deployment().location`, and `expedition` defaults `location` to `resourceGroup().location`, which must match the region
of the network it lands in.

### The Well-Architected checklist

The five pillars are a review checklist, and each line of ADR-AZ-LZ-EVERYPILLAR is something the template does, not an aspiration. The
settings that every caller should share — public access off, TLS 1.2, zone redundancy, a managed identity — are secure defaults of the
shared Bicep modules, so `foundation` gets them too; the settings that differ by environment class — the SKU, the backup redundancy and
retention, the serverless pause — are config values.

### Governance limits

The landing zone assigns built-in definitions only, which Azure publishes at tenant level and every subscription can assign, so no custom
definition has a hierarchy to live in. A custom definition, if one were ever written, would sit at subscription level beside its assignment
until the repository gained rights over the tenant's hierarchy.

The example customers carry no regulatory obligation, so the policy set holds only the three guardrails every subscription needs. The
`data-classification` tag records how sensitive a workload's data is, but no policy reads it. The assignment module takes an initiative id
as readily as a definition id, so a regulatory initiative is one more pinned entry in `discovery`'s set. The same holds for a resource-type
policy: which services a subscription may use is left to the rights of the identity that deploys into it, and nothing registers or restricts
a resource provider.

Policy belongs to the landing zone and a workload owns none of it ([ADR-AZ-LZ-WORKLOADOWNSNONE](#rule-adr-az-lz-workloadownsnone)). The
templates grant no role to a team; the only role assignment a module can make is the remediation role of a policy assignment's managed
identity, which no assignment of the landing zone uses. A team that needs a policy for its application proposes it for the landing zone,
through review like any other change. Role assignments for people belong to whoever administers the subscription.

The repository makes no assignment above a subscription, so it has no root-level assignment to keep few, and the subscription assignments
carry no exclusion to manage. Assignments that a tenant's administrators make at a management group above the subscriptions apply alongside
the landing zone's and are theirs to manage.

### Cost attribution

`discovery` deploys one Cost Management budget per subscription through `infrastructure/modules/budget.bicep`: a monthly amount from its
config, in the subscription's billing currency, with alerts at 50, 80, and 100 percent of actual cost to the holders of the subscription's
`Owner` role, so no address is kept in a config. The amounts are plain config values that anyone reading the repository can see and review.
`foundation` and `expedition` have no budget of their own; their cost counts against the subscription's.
The CAF tags carry the metadata cost analysis groups by: `cost-center` names the paying team, `workload` the project, and `owner` and
`environment` let spend group further. `Deploy-Bicep` creates the resource group of a resource-group template (`foundation`, `expedition`)
through `Deploy-AzureResourceGroup` with no CAF tags, and afterwards writes only the deployment-provenance tags (`Set-BicepTrackingTagSet`).
The required-tag policy covers resources, not resource groups, so the deploy succeeds, but cost grouped by resource group, or inherited from
it, has nothing to read there. The resource group should take the template's CAF tags from its config. `discovery` creates its own resource
group through `infrastructure/modules/resource-group.bicep`, so its resource group and every resource in it carry the tags.

### CAF design principles

Subscription democratization is partly followed. `azure.yml` declares every subscription, and a customer subscription carries a `customer`
key ([ADR-AZ-CUSTOMER-TWOBINDINGS](azure-customer-model.md#rule-adr-az-customer-twobindings)). The shared platform holds `shared_nonprod`
and `shared_prod`, and each customer its own pair or a non-production subscription alone. A non-production subscription serves `dev`, `test`
and `nsub`, a production one `preprod`, `prod` and `psub`; `dev` and `test` are kept apart by resource group, one per configuration slot
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)). Self-service is a pull request
([DDR-SELFSERV-CONSUMERSPROVISION](../design/self-service.md#rule-ddr-selfserv-consumersprovision)): a team adds a subscription entry, a
network and one config per template. Subscription vending and management groups are not adopted, because the repository deploys into
subscriptions it is given. A new customer therefore waits for the tenant's administrator, and the budget and guardrails of a shared
non-production subscription govern `dev` and `test` alike.

Policy-driven governance is partly followed. The three built-in policies are the tool-agnostic guardrails, and CI adds guards before deploy
that policy cannot: every template compiles and every rendered parameters file is checked against the compiled parameter model
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](azure-data-model.md#rule-adr-az-datamod-parametercontract)). The set is narrow: public network access on
a data service, a missing diagnostic setting, and a TLS minimum are set by the shared modules and not guarded against another tool. Each
landing zone assigns its own copy, with no management group to inherit from, so outside the three policies compliance rests on module
defaults and review, and outside production the default mode audits and does not block.

Control and management plane: the control plane is Azure Resource Manager. `Deploy-Bicep` runs `az deployment group create` or
`az deployment sub create`, and `-DryRun` runs Azure's `--what-if` ([ADR-AZ-CLI-AZBYDEFAULT](prefer-az-cli.md#rule-adr-az-cli-azbydefault)).
catzc is a command line in front of Azure, kept thin: it delegates to Bicep and the az CLI and never clones the vendor's behaviour
([DDR-THINPLAT-DELEGATENOTREIMPLEMENT](../design/thin-platforms.md#rule-ddr-thinplat-delegatenotreimplement)). The management plane
deviates: `foundation` gives each subscription its own Log Analytics workspace, and the landing zone and the workload of that subscription
send diagnostics and the activity log there. A view across customers needs a cross-workspace query and a platform-wide alert is one alert
per workspace, and the gain is that one customer's telemetry stays in that customer's subscription.

The application-centric model is followed: workloads are segmented by customer subscription and environment class, not by management group
archetype, so every landing zone carries the same three assignments from one template and one setting, which cannot drift. The shared
modules include `vm.bicep`, so an IaaS workload would land in the same subnets under the same policies as the PaaS one.

Azure-native design is followed: Bicep from the shared modules, Azure built-in policy, Azure Monitor, Key Vault, Private DNS and Entra ID,
with no third-party firewall, agent or secret store. `azure.yml` pins `bicep_min_version`, and `Assert-AzCliBicep` fails a Bicep build on an
older CLI. Resource API versions are written in each module by hand and several are older or preview (`2021-05-01-preview` on the diagnostic
settings), so a new capability reaches the templates when someone updates a module.

### CAF management

The workspace is per subscription on purpose: each customer's telemetry stays in the subscription that customer's access covers, and
non-production and production stay apart. `foundation` deploys it through `log-analytics.bicep`, and `discovery` and `expedition` find it by
`logAnalyticsResourceGroupName` and `logAnalyticsName` in their configs. A workspace holds the default 30 days (`retentionInDays` accepts 30
to 730 and `foundation` does not pass it), no example customer needs logs kept for years, and so no export to immutable storage exists; a
longer retention per environment class is a config value, and a customer with a longer obligation adds a data export beside the workspace
([EDR-AZ-WAF-OE-OE07](../external/azure/waf/operational-excellence.md#rule-edr-az-waf-oe-oe07)). Access to a workspace is the role-based
access of its subscription; `log-analytics.bicep` sets no access-control mode, and the templates assign no role to people.

Diagnostics exist when a deploy succeeds, because `diagnostic-setting.bicep` (kinds fixed by its `@allowed` decorator, categories by the
`allLogs` group plus the kind's metrics) is part of the template, which a deploy-if-not-exists policy cannot promise. The subscription's
activity log, `ServiceHealth` and `ResourceHealth` included, streams from `discovery` through `subscription-diagnostic-setting.bicep`, which
sends every category (`Administrative`, `Security`, and `Policy` among them); `discovery` sends the virtual network and every network
security group, and `expedition` the storage account, its blob service, and the database. `foundation`'s own Key Vault sends nothing, though
the module supports it. Platform metrics sit in Azure Monitor with no configuration and the diagnostic setting copies them beside the logs
(`AllMetrics` for the virtual network, `Transaction` for the storage account and its blob service); the logs are queryable per subscription,
and no saved query, workbook, or dashboard exists.

Alerting is only the budget's: `budget.bicep` sends its thresholds to the subscription's `Owner` role. The shape of the rest follows the
same rule, one action group per subscription in `foundation` addressed to `Owner`, and alert rules in the templates that own the resources,
never Microsoft's baseline alerts deployed by policy ([ADR-AZ-LZ-THREEBUILTINPOLICIES](#rule-adr-az-lz-threebuiltinpolicies)). Service
Health and Resource Health alerts belong to `discovery`. No module places a lock; the hub's virtual network and private DNS zones, and
`foundation`'s Key Vault with the break-glass password, are the resources one would protect. The network security groups and the virtual
network send logs and metrics, not flows, so no Traffic Analytics exists; it would arrive with flow logs into the workspace and a flow-log
storage account in `foundation`.

The workload relies on the platform's own redundancy and backup: zone-redundant storage (`Standard_ZRS`) in every environment, a production
database that is zone-redundant (`databaseZoneRedundant` is false in development) with geo-redundant backups
(`databaseBackupStorageRedundancy` `Geo` in production, `Local` in development), short-term retention (`databaseBackupRetentionDays` 35 in
production, 7 in development, set by `sql-database.bicep`) and blob and container soft delete of 7 days by default, with the `@minValue`,
`@maxValue`, and `@allowed` bounds keeping a config within what the service accepts ([ADR-AZ-LZ-EVERYPILLAR](#rule-adr-az-lz-everypillar)).
No policy audits redundancy or backup, and no backup vault exists because nothing deployed needs one. No range of the plan overlaps another,
which `NetworkConfig` checks, so a recovery network added to the plan falls under the same check
([ADR-AZ-NETWORK-NOOVERLAP](azure-network-model.md#rule-adr-az-network-nooverlap)).

Recommendations that assume a virtual machine (Site Recovery, Update Manager, Machine Configuration) or a hybrid link (ExpressRoute, an
on-premises monitoring system) have nothing to act on: `vm.bicep` exists among the shared modules but no template uses it, the hub's
`GatewaySubnet` holds nothing, every environment maps to one region, and every log stays in Azure. A workload sits in one resource group of
one subscription, named by the `workload` tag, which gives the grouping an Azure Service Group would add; Azure Monitor health models are in
preview and build on Service Groups, so the tool of a health model is chosen when that work begins.

### CAF tags

The tag set is written out in full in each config (eighteen copies across the three templates) and cost is split below the subscription by
`cost-center` and `workload`; tag inheritance is not used, because every template passes the tags to each resource itself. Only
`cost-center` is required, by the landing zone's policy, which checks that the key is present and not its value. The `workload` tag names
the template (`foundation`, `landing-zone`, `expedition`), and `environment` is the environment class for the per-subscription templates
(`nonprod`, `prod`) and the standard environment for `expedition`. `criticality` (`low`, `medium`, `high`) and `data-classification`
(`internal`, `confidential`) are the classification tags, and no service-level tag is set because no example workload declares one.
`cost-center` equals `owner` (`platform` or the customer key), since the customer is the unit of cost and of accountability; budget alerts
go to the subscription's `Owner` role, not to the tag.

Tags carry codes only: team codes, class values, and template names. Every key and value is lowercase with hyphens between words, matching
[ADR-AZ-NAMING-LOWERCASECOMPONENTS](azure-naming-standard.md#rule-adr-az-naming-lowercasecomponents); CAF's examples run the words together
(`costcenter`), which the hyphen replaces for readability. `Deploy-Bicep` adds three provenance tags after a deploy through
`Set-BicepTrackingTagSet`: the commit, the build id, and the branch, with mixed-case keys (`Deployed_From_Commit`) from
`Get-BicepTrackTagNameSet`. A devbox deploy records the local branch name as it stands, so a branch named after a person would put that name
in a tag; whether a devbox deploy records its branch is open. The provenance tags land on the resource group of `foundation` and
`expedition` and on the subscription for `discovery`, whose keys carry the template name as a prefix (`discovery_Deployed_From_Commit`). The
required-tag assignment is `requireTag`, named per subscription by `policyAssignmentNames` (`-tag-pa`), with parameter `requiredTagName`
defaulting to `cost-center`; the policy ignores types that cannot carry a tag, so it never denies a peering or a budget. The peering,
subnet, policy assignment, budget, and diagnostic setting modules take no `tags`, and `foundation` and `expedition` set `owner` on every
taggable resource, while their resource groups carry only the provenance tags. The values in use are `criticality: high` for the shared
platform and each production subscription, `medium` for customer non-production in `foundation` and `discovery`, `low` outside production
and `high` in production for `expedition`; `data-classification` is `internal` for the platform and `confidential` for customers.

No region tag is set, because the region is a component of every name and the allowed-locations policy holds each landing zone to its
region, so a tag would repeat what the name and the resource's location state; resource selectors in the tag policy are unused for the same
reason. No tier tag is set, because each example template is one tier, and the provenance tags name the commit in place of a repository tag.
No purpose tag is set, because the example workloads model no business process; a workload that serves one adds its purpose tags in its own
configs. No Microsoft workload assessment runs against these subscriptions, and the `workload` and `criticality` tags are what one would
read.

### CAF security

The activity log streams to `foundation`'s Log Analytics workspace and every resource that emits logs sends them to its subscription's
workspace, one per subscription rather than one for the tenant; an archive to storage
beyond two years is not needed. Access audit reports, real-time alerts through Event Grid, an incident response plan
([EDR-AZ-WAF-SE-SE12](../external/azure/waf/security.md#rule-edr-az-waf-se-se12)), and the tracking of Azure roadmaps as a process belong to
the tenant's security operations or are served by the retrieval dates of the records. No virtual
machine is deployed, so patch tracking, policy-deployed extensions, security drift, attestation, and just-in-time access have nothing to act
on, and no endpoint or user application exists for endpoint management, Defender for Cloud Apps, or application onboarding.

The shared Bicep modules are the allowlist of services, each with secure defaults. The landing zone assigns three built-in policies at subscription level in place of the management-group policy set of the CAF
reference landing zone. Access follows Zero Trust through Entra ID identities, a
service connection per subscription pinned on every deploy, and private endpoints for data, though `foundation`'s vault and workspace accept
public traffic. Each workload deploys the diagnostic settings of its own resources, so its monitoring travels with
its template. Data at rest uses Microsoft-managed keys, and the `data-classification` tag labels each resource in place of Purview. No
workload has public ingress, so the Zero Trust application delivery pattern and the accelerators' network variants do not apply; workload
networking is private by plan (`network.yml`, a security group per workload subnet, private endpoints). Sentinel, its identity feeds, and threat hunting are the tenant's security operations; `foundation`'s workspace is
where Sentinel would attach and the repository supplies the logs.

Key Vault is federated: `foundation` deploys one vault per subscription from one module, so every customer and tier has its own vault with
the same configuration and no policy is needed. No vault is central to the tenant, though a workload's secret sits in the platform's vault.
Every vault authorizes its data plane through Azure RBAC with no access policies and has the platform's soft delete: `key-vault.bicep` fixes
`enableRbacAuthorization: true` and an empty `accessPolicies`, neither a parameter, so no caller falls back to access policies, and it sets
no retention, no network rule, and `enabledForTemplateDeployment` on, because Azure Resource Manager resolves `expedition`'s break-glass
reference at deploy time. The roles on a vault are granted outside the repository, and the vault name stays taken until a deleted vault's
retention ends. `storage-account.bicep` turns shared-key access off, so every data request carries an Entra ID token. The vaults hold
no key and no certificate, so certificate automation has no use; rotation of the one secret, the break-glass password, is manual. The environments of one tier share their tier's vault and the same secret name, `exped-sql-admin-password` (`dev`
and `test` read the shared non-production vault, so they share one break-glass password), and a secret name per configuration slot is
planned. The platform's vault is the platform's, not the workload's, which fits the one secret in use, a recovery credential no application
reads at run time; a workload that needs run-time secrets creates its own vault from `key-vault.bicep` in its own resource group.

### CAF identity

The identity recommendations that assume a directory the repository runs, or a tenant setting, are not the repository's: every resource the
templates deploy authenticates through Entra ID alone, no workload uses a legacy directory protocol or users from outside the tenant, the
repository synchronises no on-premises directory, federates through no AD FS, publishes no application through application proxy, deploys no
directory server, file share, or virtual machine, and so has no directory subnet, replica set, Arc-managed server, or directory-server rule.
The tenant's authentication methods, multi-factor authentication, Conditional Access, Defender for Identity, separate administrative
accounts, emergency-access accounts, Entra log streaming (a tenant diagnostic setting needs rights above any subscription), access packages,
built-in directory roles, administrative units, Privileged Identity Management, access reviews, protected actions, and eligibility for Owner
and User Access Administrator are tenant settings, and the repository grants no directory role
([ADR-AZ-DATAMOD-ONETENANT](azure-data-model.md#rule-adr-az-datamod-onetenant)).

Every principal the templates name is a group or a role: the SQL administrator is an Entra ID group and the budget alerts go to the `Owner`
role. `sql-server.bicep` defaults `entraAdminPrincipalType` to `Group` and `entraOnlyAuthentication` to `true`, and every `expedition`
config names the group `zct-exped-sql-admins` (`entraAdminLogin`) with a placeholder object id registered in `guids.yml` as
`entra_sql_admin_group`, so one group administers every customer's SQL server in every environment. `budget.bicep` takes `contactRoles`,
defaulting to `Owner`. The break-glass login is `exped-break-glass`, with `entraOnlyAuthentication: false` and the password
`exped-sql-admin-password` as a Key Vault reference; it is the one path outside the tenant's sign-in policies. At the level the repository
owns, the break-glass SQL login keeps a SQL server reachable, and monitoring its use is planned. Every subscription gets the same landing
zone from `discovery`, but it assigns no role and creates no group, role assignment, or user-assigned identity, and the repository defines
no custom role and owns no management group. Role assignments as code are planned: one standard role set declared once and deployed to every
landing zone, at subscription level in `discovery` and at resource level in `expedition`, never above a subscription, starting from built-in
roles, with the combined effect of stacked assignments reviewed and a condition limiting which roles the deploying identity may assign. Data
roles are planned as code, and Key Vault and storage authorize their data plane through Entra ID and Azure RBAC, SQL through its Entra ID
administrator group, with attribute-based conditions weighed with those data roles. Pinning resource-context access as a default of the
workspace module is planned.

Every `expedition` config names the same SQL administrator group, and the environments of one tier share their service connection, their
vault secret, and the SQL administrator group; a group per customer and environment and separating the rest is planned. Managed identities
are system-assigned to one resource of one configuration slot, so none is shared; the storage account and the SQL server carry them, but
nothing grants them a role, and access between resources through them is planned (`storage-account.bicep` and `sql-server.bicep` output the
`principalId`). `policy-assignment.bicep` gives a remediating policy, when `assignIdentity` is set, a system-assigned identity and grants
each id in `roleDefinitionIds` directly to its principal (`principalType: 'ServicePrincipal'`) on the subscription, and no landing-zone
policy needs it. Every deploy runs through the service connection of its subscription (`sc-<owner>-nonprod`, `sc-<owner>-prod`), handed to
`AzureCLI@2` or `AzurePowerShell@5` by `.ado/pipelines/steps/invoke-automation.yaml` in `azcli` mode, pinned by `-SubscriptionIdAssertIs`,
and the infrastructure CI builds offline in mode `none` and needs no Azure identity; the environments of one subscription (`nsub`, `dev`,
`test`) share its one service connection; separating the landing-zone identity from the workload identity is planned, and so is workload
identity federation for every service connection, since the kind of a service connection is set outside the repository. No template deploys
an application that users sign in to, so the Microsoft identity platform and its checklist are not a template concern.

### CAF delivery

Templates, modules, configs, policy assignments, pipelines, automation, and ADRs all live in one Git repository, which is private by the
visibility of its server remote, outside the repository, and built to hold no secret either way. What the repository shares publicly is the
built catzc package, published by a manual release workflow, never the infrastructure templates and their configs. All Azure infrastructure
is declarative Bicep with shared modules and one config per configuration slot, deployed only by pipelines. The landing zone's three policy
assignments are Bicep in `discovery`, pinned by definition id and deployed by its pipeline; they deny in production and audit elsewhere,
none uses a modify or append effect, and the landing zone makes no exemption: a team that needs a different policy proposes a change to the
landing zone, reviewed like any other.

Development is trunk-based on `main`, with short-lived branches that carry nothing automation reads from their names and no release or
version branches. The delivery design takes `main` to advance by squash merge only, and its change detection relies on it; the rule that
`main` admits merges only through a pull request, the merge type, and per-branch permissions are server settings outside the repository. In
the `main-via-pr` variant every change enters `main` through a pull request with blocking build validation; the repository runs
`main-direct`, and a required-reviewer policy is planned. Blocking build validation per globset is configured in `build-validation.yml`;
minimum reviewers, vote reset, automatic reviewers, and comment resolution are planned. Every fix, urgent or not, is a commit that the same
pipelines deploy; a written emergency-change procedure is planned, and so is a rollback by deploying an earlier commit's artifact, since a
rollback today is a revert commit that the same pipelines deploy, and removing what a revert takes out of a template needs its own step.

A CI pipeline builds and tests every template, as a pull-request check and again on the merged commit: each template is validated, compiled,
and checked against its parameter model ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](azure-data-model.md#rule-adr-az-datamod-parametercontract)).
Globset-triggered CD pipelines deploy the templates in order, and every commit to `main` that touches a deployable-unit is deployed to its
non-production subscriptions; production deploys in the same stage as non-production instead of by promotion. The Bicep linter as a quality
gate and system tests of a deployed template in an on-demand environment are planned. Each deploy runs through the service connection of its
own subscription and asserts that subscription; federated credentials, one identity per template and environment, and a read-only identity
for previews are planned. The one deploy-time secret is a Key Vault reference resolved by Azure Resource Manager. Every deployment job names
an Azure DevOps environment per template target, whose checks and approvals are not declared in the repository. `Deploy-Bicep -DryRun` runs
the Azure what-if preview; running it before every pipeline deploy is planned.

The pipelines are `.ado/pipelines/ci-infrastructure.yaml` (CI for all three templates, which runs `Assert-BicepTemplate` and `Build-Bicep`
for each, then the infrastructure test suite), `cd-shared.yaml` for the shared platform, and thin customer pipelines (`cd-apex.yaml`,
`cd-nova.yaml`, `cd-flux.yaml`) that extend `extends/cd-customer.yaml`. Each CD pipeline runs the same CI engine, publishes one artifact per
template, and deploys it unchanged in stage order: `foundation` (`nsub` and `psub` as two jobs of one stage), then `discovery` (hubs from
`cd-shared.yaml`, spokes from the customer pipelines), then `expedition` (one job per configuration slot); every job runs on
`vmImage: ubuntu-latest`. The deployment jobs name the Azure DevOps environments `shared-nsub`, `shared-psub`, `shared-main-uat`, and
`shared-test`, and `<customer>-main-uat`, `<customer>-<env>`, or `<customer>-<env>-<slot>`. `build-validation.yml` binds each declared
globset (`automation`, `infrastructure`, `shared`, and one per customer) to its pipeline, applied by `Sync-AdoBuildValidations`;
`Register-AdoPipeline` registers a pipeline from its file, `Test-AdoPipelineTriggerGlob` keeps each trigger equal to its globset, and
`Get-GlobSetChangeRange` diffs `HEAD^1..HEAD` to find what a squash merge changed. `Build-Bicep` compiles a template and renders a
parameters file per slot (failing a config left `UNDEFINED`), `Assert-BicepTemplate` validates `options.yml`, the config classification,
identity references, and parameter alignment, and `Deploy-Bicep` deploys the built artifact into an asserted subscription; the deploys are
incremental, so a resource removed from a template stays in Azure, and no scan of the compiled templates exists. The variant is
`git_workspace: main-direct` in `variants.yml`. The service connections and the Azure DevOps environments are created in the Azure DevOps
portal; an exemption, if one were needed, would be a `Microsoft.Authorization/policyExemptions` resource in `discovery`. Adding a customer
is a change of `customer.yml`, `azure.yml`, `network.yml`, a config per template, a globset, and a thin CD pipeline, reviewed like any
other. The built catzc package is made by `Export-Catzc`, and the toolchain versions are pinned in `tools.yml`. The shipped `azure.yml`
carries placeholder subscription ids.

Provisioning and configuring every landing zone and workload is automated; the rollout of a new spoke and the seeding of the break-glass
secret are manual. The repository deploys its own templates to its own rules, not Microsoft's accelerators, which assume management groups
and a platform it does not own, and `foundation`, `discovery`, and `expedition` deployed in order stand in for the base an accelerator would
provide. Its delivery framework is its own flow model grounded in the DORA research, and it improves continuously from evidence rather than
through an assessed roadmap; the delivery metrics are DORA's, and nothing in the repository collects them from the pipelines yet. The
toolchain is chosen once and pinned, Git, Azure DevOps and GitHub pipelines, Bicep, the az CLI, and Pester, and installed the same way on a
devbox and in a pipeline. The infrastructure runs on Azure DevOps Pipelines, and the catzc automation's CI and release run on GitHub
Actions; planning and collaboration tools belong to the operating organisation.

### Cost by configuration

Cost is open to the team. A landing zone's budget is the `budgetAmount` value in its `discovery` config (500 for shared non-production, 1000
for shared production, 300 for each customer's non-production subscription and 800 for `apex` production, per month in the subscription's
billing currency), so anyone who reads the repository reads every budget and a change to one goes through review like any other. The CAF
tags name the paying team (`cost-center`) and the accountable one (`owner`) on every resource, for example `owner: platform` and
`cost-center: platform` in `nsub.yml` and `owner: apex` and `cost-center: apex` in `apex/psub.yml`; `expedition` carries
`cost-center: platform` in `dev.yml` and `cost-center: apex` in `apex/prod.yml`. The workload has no budget of its own and its cost counts
against its subscription's. Training, cost champions, and recognition belong to the organisation that runs the repository. The budget
amounts are plain config values with no cost model behind them. The cost drivers a model would name are `foundation`'s workspace ingestion
(`PerGB2018`), its retention and its Key Vault operations, `discovery`'s virtual network, peering data transfer and private DNS zones, and
`expedition`'s database (`GP_S_Gen5` at up to 2 vCores in non-production, `GP_Gen5` at 2 vCores in production), its backup redundancy and
its storage account.

Cost is grouped by tag: the six CAF tags are on every resource that takes tags, the required-tag policy makes `cost-center` mandatory
([ADR-AZ-LZ-THREEBUILTINPOLICIES](#rule-adr-az-lz-threebuiltinpolicies)), and `budget.bicep` alerts the holders of the subscription's
`Owner` role at each threshold. The `budgetThresholds` default is 50, 80, and 100 percent of actual cost, and the module takes one
`thresholdType` per budget. `foundation`'s workspace and vault carry the CAF tags and its resource group does not; `discovery`'s resource
group and every tagged resource do; `expedition`'s resources do and its resource group does not.

The platform guardrails are the allowed-locations and required-tag policies (`requiredTagName` defaults to `cost-center`) and the budget,
which alerts and never stops a resource. Whether the policies deny or audit is `policy_enforcement` in `azure.yml`. The cost-bearing
settings are typed parameters: `databaseTier` is `@allowed`, `databaseBackupRetentionDays` is bounded 1 to 35, `budgetAmount` has a minimum
of 1, and every rendered parameters file is checked against those bounds
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](azure-data-model.md#rule-adr-az-datamod-parametercontract)). `databaseSkuName` is a free string, and no
policy restricts resource types or SKUs. `Deploy-Bicep -DryRun` runs Azure's `--what-if` preview, and a CD pipeline deploys through one
service connection per subscription and asserts the target with `-SubscriptionIdAssertIs`. `foundation`'s SKUs are module defaults
(`PerGB2018`, `standard`).

Rates are the billing account's. Every resource is pay-as-you-go: the workspace on `PerGB2018`, the vault on `standard`, a provisioned
`GP_Gen5` production database at 2 vCores (the one candidate for a reservation, bought at the billing account), and nothing in `discovery`
carries commitment-based pricing. The SQL database module exposes no licence type, so Azure Hybrid Benefit cannot be selected.

Each resource is configured to its meter. A serverless SQL database bills compute per second while it runs and only storage while paused, so
non-production configs use `GP_S_Gen5` with `databaseAutoPauseDelay: 60` and `databaseMinCapacity: "0.5"`, while production is provisioned
`GP_Gen5` at `databaseSkuCapacity: 2`. A Log Analytics workspace bills per ingested gigabyte, so `diagnostic-setting.bicep` picks the
categories each resource kind needs (a storage account sends only its `Transaction` metrics and no logs). `discovery` sends the activity
log, the virtual network's diagnostics and each network security group's logs to `foundation`'s workspace, each a per-gigabyte cost there.
The repository keeps no catalogue of each service's meter and runs no billing proof of concept.

The configuration tree is the inventory: one config file is one resource group
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)), names are deterministic
([ADR-AZ-NAMING-DETERMINISTICNAMES](azure-naming-standard.md#rule-adr-az-naming-deterministicnames)), and every resource carries `owner`, so
a resource found in a subscription traces to its template and team. Disaster recovery is a redeploy from the templates plus the database's
backups, never a warm standby. The deployment mode defaults to `Incremental`, so a resource removed from a template stays in Azure until
someone deletes it, and nothing finds such an orphan or a resource group with no config. `discovery` reserves `GatewaySubnet` and
`AzureFirewallSubnet` as address space only, so no cost accrues for them. `expedition` holds one storage account and one database per
configuration slot, with no secondary region; a special slot (`apex/dev-blu.yml`) is a second full copy of the workload.

Environment class is a config decision ([ADR-AZ-LZ-EVERYPILLAR](#rule-adr-az-lz-everypillar)). The non-production `expedition` configs
(`dev.yml`, `test.yml`, `apex/dev.yml`, `apex/dev-blu.yml`, `nova/dev.yml`) set `GP_S_Gen5` with auto-pause, `databaseZoneRedundant: false`,
`databaseBackupStorageRedundancy: Local`, and `databaseBackupRetentionDays: 7`; `apex/prod.yml` sets `GP_Gen5`, zone redundancy by default,
`Geo`, and 35 days. The storage account takes the module's `Standard_ZRS` in every class, because `expedition` exposes no storage SKU.
`foundation` is identical in both classes (the workspace keeps 30 days in each, the minimum). Policy enforcement audits outside production
by default ([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)). Off-hours shutdown is
not used, because auto-pause stops the database's compute when idle, and no environment is ephemeral.

Each example workload carries one flow (one database and one storage account serving one purpose), so there is no flow inventory to separate
or combine; a workload with flows of different value records them, and their tiers, in its own template. The templates deploy infrastructure
with no application code, so a workload that ships code optimises it in its own repository.

Data is kept as long as it earns its cost. The workspace keeps 30 days, the minimum of `log-analytics.bicep` (`foundation`'s
`retentionInDays` takes the default and no config raises it); deleted blobs and containers are kept 7 days; backup redundancy and
point-in-time retention are per-class config values; `discovery` stores no data of its own. The storage account is fixed on the `Hot` access
tier and carries no lifecycle management policy.

The one component that scales does so within a ceiling set in config: in non-production the serverless database moves between
`databaseMinCapacity: "0.5"` and `databaseSkuCapacity: 2` vCores and pauses at zero use, and in production it is provisioned at a fixed 2
vCores. Nothing in `foundation` or `discovery` scales.

People's time goes to decisions: every template composes the shared modules in `infrastructure/modules/`, so a secure or cheap default is
written once; a config reads a shared value (a network range, a subscription id, the policy mode) by config address
([ADR-AZ-DATAMOD-VALUEBYADDRESS](azure-data-model.md#rule-adr-az-datamod-valuebyaddress)); a change triggers only the CD pipelines whose
deployable units it touches ([durable-sha-globs](../flow/durable-sha-globs.md)); `ci-infrastructure.yaml` compiles every template and checks
every parameters file before a deploy can fail on it; budget alerts go to the `Owner` role, so no address list is kept. This applies the
repository's stance on waste ([reduce-waste](../principles/reduce-waste.md)) to infrastructure. A new customer subscription or configuration
slot is a config file, not a design.

Shared services exist once ([ADR-AZ-LZ-LANDINGZONE](#rule-adr-az-lz-landingzone)). `foundation` gives one workspace and one Key Vault per
subscription, which `discovery` and `expedition` send diagnostics to and read the break-glass password from. Each tier's hub holds the SQL
and blob private DNS zones once and links them to every spoke ([ADR-AZ-LZ-HUBANDSPOKE](#rule-adr-az-lz-hubandspoke)). The shared platform's
workload (`dev.yml`, `test.yml`) places its private endpoints in the hub's `shared-services` subnet instead of a network of its own. Each
configuration slot has its own SQL server with one database; denser hosting (several databases per server, an elastic pool) is not used,
because each slot is its own resource group. Each tier has its own hub and each customer a subscription per class.

### Performance by configuration

Capacity is configuration, not code: every capacity a template uses is a parameter, and its value per environment class is written in the
per-slot config ([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)), so the capacity
of every deployment is readable from the configuration tree. No utilisation history, forecast, or record of service limits backs the values.
`foundation`'s workspace uses the `PerGB2018` pay-as-you-go tier and 30-day retention, the defaults of `log-analytics.bicep`, and its vault
the `standard` SKU, the default of `key-vault.bicep`; both bill by use. `discovery` reads its ranges from `network.yml` by config address
([ADR-AZ-DATAMOD-VALUEBYADDRESS](azure-data-model.md#rule-adr-az-datamod-valuebyaddress)): one `/16` per subscription and a `/24` for the
private endpoints and for each environment, which caps the private endpoints a spoke can hold; its budget (1000 for the production hub, 300
for the apex non-production spoke) is the one capacity-like number in its configs. Every `expedition` config names the database capacity:
`GP_S_Gen5` with a ceiling of 2 vCores and a floor of 0.5 outside production, `GP_Gen5` with 2 vCores in production; the storage account is
`Standard_ZRS` from the module default and has no capacity setting.

The templates use managed services throughout and no virtual machine (`vm.bicep` exists as a module that no template uses). Every
environment in `azure.yml` names one region, `westeurope`, and the allowed-locations policy keeps resources there
([ADR-AZ-LZ-THREEBUILTINPOLICIES](#rule-adr-az-lz-threebuiltinpolicies)), so the workload, its private endpoints, and its workspace never
cross a region. `foundation` deploys a managed workspace and a vault; `discovery` peers each spoke to its hub on the Azure backbone and
holds the private DNS zones in the hub, so a workload reaches its data services over private addresses
([ADR-AZ-LZ-HUBANDSPOKE](#rule-adr-az-lz-hubandspoke)); `expedition` deploys Azure SQL Database (General Purpose, Gen5) and a StorageV2
account on the `Hot` access tier, both reached only through private endpoints. Outside production the database is serverless (`GP_S_Gen5`)
and in production it is provisioned (`GP_Gen5`) and zone-redundant by the template default.

Measurement is a diagnostic setting per resource, from the shared `diagnostic-setting.bicep` module, which picks the log and metric
categories each resource kind exposes, into the workspace `foundation` deploys in the same subscription. Since production and non-production
run in different subscriptions (`azure.yml`), their signals land in different workspaces by construction. The subscription's activity log
arrives through `subscription-diagnostic-setting.bicep`, with `ServiceHealth`, `ResourceHealth`, and `Autoscale` among the eight categories
it sends. `discovery` sends the virtual network (all logs and `AllMetrics`) and every network security group (all logs). `expedition`'s
storage account sends its `Transaction` metrics, its blob service its logs and `Transaction` metrics, and its database its logs, which carry
its query-store and wait statistics, and its `Basic`, `InstanceAndAppAdvanced`, and `WorkloadManagement` metrics; the SQL server and the
private endpoints have no diagnostic setting. `foundation`'s vault has none either, although the module supports the `keyVault` kind, and
the workspace's 30-day retention bounds how far back a comparison reaches. No baseline, alert, dashboard, synthetic transaction, saved
query, or workbook is deployed, and the architecture is documented in the reference articles under `docs/references/infrastructure/`.

Two scaling mechanisms exist, both by configuration. Outside production Azure scales the serverless database between the
`databaseMinCapacity` floor and the `databaseSkuCapacity` ceiling and pauses it after `databaseAutoPauseDelay` minutes idle (0.5 to 2 vCores
and 60 minutes in `dev.yml`, `test.yml`, `apex/dev.yml`, `apex/dev-blu.yml`, and `nova/dev.yml`), so the ceiling is the upper limit; and the
configuration slot is the unit of scale-out, a special slot (`apex/dev-blu.yml`) deploying a whole second copy of the workload into its own
resource group, while a new customer gets its own subscription, spoke, and landing zone, much as the Deployment Stamps pattern does.
Production is provisioned at a fixed 2 vCores in `apex/prod.yml`, no autoscale rule exists, and there is no data to partition. The address
plan reserves a `/16` per spoke, so the number of spokes, not their size, is what grows.

The repository's tests verify code, configs, and compiled templates; testing in production, the L4 tier
([ADR-AUTO-TEST-TESTINGINPRODUCTION](../automation/test-automation.md#rule-adr-auto-test-testinginproduction)), observes a released system
but measures no performance. `azure.yml` gives each production subscription a `preprod` environment and `network.yml` gives the apex
production spoke a `preprod` subnet, but no `expedition` config targets `preprod`. A workload's performance targets belong beside its
template, in its reference article under `docs/references/infrastructure/`.

The templates deploy no application code, so the code half of optimisation is the workload's. The infrastructure half follows from the
choice of platform services: TLS ends at the managed services, identity is a managed identity and Entra ID rather than stored credentials
([ADR-AZ-LZ-SQLENTRAADMINS](#rule-adr-az-lz-sqlentraadmins)), and backups are platform features. The network is as simple as the landing
zone allows: one virtual network, a network security group per workload subnet, no appliance in the traffic path, and the reserved firewall
subnet empty. `expedition` holds one empty database and one storage account with a 7-day soft delete and no schema, index, cache, read
replica, or lifecycle rule, so data tuning is the workload's that owns a schema.

Flows are not inventoried, because the workload has none. The CAF tags carry `criticality`, which rates each deployment, not each flow:
`high` for the shared subscriptions and for production, `medium` for `foundation` and `discovery` in a customer's non-production
subscription, and `low` for the non-production workload (`high` in `apex/prod.yml`). Nothing reserves capacity or limits traffic by it.
Isolation comes from the customer model: each customer has its own subscriptions, spokes, workspace, vault, and workload resources, so one
customer's load never shares a database with another's.

The operational tasks the templates carry run on the platform. A deployment is `Deploy-Bicep`, an `az deployment group create` (or
`sub create` for `discovery`) in Azure's default incremental mode, so a redeploy changes only what differs and removes nothing. Backups are
the database's automated backups and the storage account's soft delete: point-in-time restore keeps 7 days of locally redundant backups
outside production and 35 days of geo-redundant ones in production, and blob soft delete keeps 7 days. The break-glass password is a Key
Vault reference resolved at deploy time, so rotating it touches no running resource. Adding a spoke takes three deploys in a fixed order
([ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](#rule-adr-az-lz-linksneedbothnetworks)). No maintenance window, off-peak schedule, alert, triage plan, or
on-call rota is set, and access to the workspace is whatever role the subscription grants.

What the repository does continuously is change the templates through the same build and verification as any code: `ci-infrastructure.yaml`
compiles and verifies every template on every change under `infrastructure/`, and `azure.yml` pins the minimum Bicep version
(`bicep_min_version`), so a newer platform feature arrives as a reviewed template change. The SKU, capacity, and serverless settings per
environment class are the knobs a review would turn, each a one-line config change.

### Reliability in one region

Simplicity is the shape of the templates. Every resource comes from a shared module in `infrastructure/modules/`, and the settings every
caller shares (zone redundancy, public access off, TLS 1.2, a managed identity) are module defaults, so a template states only what differs
([ADR-AZ-LZ-EVERYPILLAR](#rule-adr-az-lz-everypillar)). Cross-cutting concerns live once: secrets in `foundation`'s Key Vault, logs in its
workspace, the network and private DNS zones in the landing zone ([ADR-AZ-LZ-WORKLOADOWNSNONE](#rule-adr-az-lz-workloadownsnone)), and SQL
access through an Entra ID group ([ADR-AZ-LZ-SQLENTRAADMINS](#rule-adr-az-lz-sqlentraadmins)). `foundation` deploys two managed services
(`log-analytics.bicep`, `key-vault.bicep`), passing names and tags and keeping every module default, and neither exposes a redundancy
setting. `discovery` deploys only platform networking and governance resources: a resource group, a virtual network with inline subnets, a
network security group per workload subnet, a route table on a spoke, peerings, the hub's two private DNS zones, three built-in policy
assignments, the activity-log diagnostic setting, and a budget, with no custom policy definition to maintain. `expedition` deploys a
`Standard_ZRS` storage account (`storage-account.bicep`) and an Azure SQL logical server with one database (`sql-server.bicep`,
`sql-database.bicep`) reached through two private endpoints, with no virtual machine and no self-managed database.

The unit the repository rates is the deployment, not a flow: every config carries `criticality` among the CAF tags. The rating follows
dependency, not environment: the shared non-production hub is `high`, because every non-production spoke resolves its private endpoints
through its DNS zones. `foundation` is `high` for the shared platform's `nsub` and `psub` and for each customer's `psub`, and `medium` for a
customer's `nsub`; `discovery` rates both hubs and a production spoke (`apex/psub.yml`) `high` and the non-production spokes (`apex`,
`nova`, `flux`) `medium`; `expedition` is `low` for every non-production config (`dev.yml`, `test.yml`, `apex/dev.yml`, the special slot
`apex/dev-blu.yml`, `nova/dev.yml`) and `high` for `apex/prod.yml`. No check or template reads the tag; it labels for people and for cost
and inventory queries.

The dependencies of the templates are these. `foundation` depends on no other template. Its Key Vault is a strong dependency of every
`expedition` deploy, because the break-glass password is a Key Vault reference resolved at deploy time, and no dependency of the running
database; its workspace is a weak dependency of everything that sends diagnostics, since an outage loses telemetry, not function. A spoke
depends strongly on its hub for name resolution, because the private DNS zones live only in the hub
([ADR-AZ-LZ-HUBANDSPOKE](#rule-adr-az-lz-hubandspoke)), so a deleted or broken DNS zone breaks every private endpoint of that tier; the
peering is a strong dependency of anything in a spoke that calls the hub's `shared-services` subnet; and the region is a strong dependency
of all of it ([ADR-AZ-NETWORK-ONEADDRESSSPACE](azure-network-model.md#rule-adr-az-network-oneaddressspace)). At run time `expedition`
depends strongly on its spoke's `private-endpoints` subnet (the hub's `shared-services` subnet for the shared platform) and on the hub's
`privatelink` DNS zones, and weakly on the workspace; at deploy time it depends strongly on `discovery` and on `foundation`'s vault.

The production settings of `expedition` imply recovery points without stating them as objectives: `apex/prod.yml` sets
`databaseBackupRetentionDays: 35` and `databaseBackupStorageRedundancy: Geo`, and blobs are recoverable for 7 days after deletion;
non-production sets `databaseBackupRetentionDays: 7` and `databaseBackupStorageRedundancy: Local`. `foundation` holds no business data, and
`discovery` holds configuration, not data, and recovers by redeploying. An availability objective needs measured traffic, which the example
deployments do not have.

Zone-redundant deployment is the module default: `storage-account.bicep` defaults `skuName` to `Standard_ZRS`, and `sql-database.bicep`
turns `zoneRedundant` on for every tier that supports it and defaults `backupStorageRedundancy` to `Geo`. A template weakens that only by a
config value, and only outside production, where the cost saving outweighs a zone outage
([ADR-AZ-LZ-EVERYPILLAR](#rule-adr-az-lz-everypillar)). Storage is `Standard_ZRS` in every `expedition` config; `apex/prod.yml` omits
`databaseZoneRedundant`, so the template default `true` applies, while every non-production config sets `databaseZoneRedundant: false` and
`databaseBackupStorageRedundancy: Local`. Every environment maps to one region, so geo-redundant backups are the only copy outside it. The
network is the hub-and-spoke shape, with one hub per tier holding the only copy of the private DNS zones, and each hub reserves
`GatewaySubnet` and `AzureFirewallSubnet` so a gateway or firewall is added without renumbering. No module places a resource lock.

Scaling: none of the templates deploys compute, so application scaling does not arise, and storage, the workspace and the vault scale inside
the platform. Outside production the serverless SKU scales automatically between `databaseMinCapacity` and `databaseSkuCapacity`, the cap
kept in config (`databaseSkuName: GP_S_Gen5`, `databaseMinCapacity: "0.5"`, `databaseSkuCapacity: 2`, `databaseAutoPauseDelay: 60`); in
production the database is `GP_Gen5` at `databaseSkuCapacity: 2`, so more capacity is a config change and a deploy, and no signal says one
is needed. The network's room to grow is the address plan: each spoke has a `/16` with `/24` subnets
([ADR-AZ-NETWORK-PERSUBSCRIPTION](azure-network-model.md#rule-adr-az-network-persubscription)), so its `private-endpoints` subnet has room
for many more private endpoints.

The isolation unit is the customer subscription: each gets its own `foundation`, its own spoke from `discovery`, and its own `expedition`
deployments, so a fault or a bad deploy in one customer's subscription does not reach another's, and a broken spoke deploy leaves the hub
and the other spokes untouched ([ADR-AZ-LZ-LANDINGZONE](#rule-adr-az-lz-landingzone)). The hub is the one shared part of a tier. Failover
inside a region is the platform's: zone-redundant storage and a zone-redundant database fail over without a deploy, in production and not in
non-production. `storage-account.bicep` turns on soft delete for blobs and containers (`deleteRetentionDays`, 7 by default, which
`expedition` keeps), so an accidental delete is recoverable. The vault module sets no purge protection. No template deploys an alert, an
action group, or a runbook, so no failure triggers an automated action; retries, checkpoints and a degraded mode belong to application code,
which the examples do not have.

Resiliency is tested where Azure is not needed: `ci-infrastructure.yaml` compiles every template, renders every config, and checks each
rendered parameters file against the compiled parameter model
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](azure-data-model.md#rule-adr-az-datamod-parametercontract)), so a reliability setting outside its
`@allowed` values or bounds, such as a `databaseBackupStorageRedundancy` that is not `Geo`, `GeoZone`, `Zone` or `Local`, or a
`databaseBackupRetentionDays` above 35, fails the build. The values a production config chooses are not checked; a pull request that
overrides a module default shows in review. `Deploy-Bicep -DryRun` runs Azure's `--what-if` preview against a real subscription. Fault
injection, failover drills, and restore tests are not run, because the example deployments target the placeholder subscriptions in
`azure.yml`, with nothing running to test; a deployment that adopts the templates for real starts with a timed restore of its production
database.

Recovery is a redeploy and a restore. Every template is infrastructure as code with its full configuration in the repository, and an
incremental deploy is idempotent, so a lost subscription is rebuilt by deploying `foundation`, `discovery`, and `expedition` in that order,
the order the customer CD pipelines encode, with the hub-spoke-hub order for peerings
([ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](#rule-adr-az-lz-linksneedbothnetworks)). The secrets in the vault are not in the repository by design, so
the break-glass password is restored by whoever owns it. Data comes back from backups: a production database restores from its geo-redundant
backups, into another region when its own is down, kept 35 days; non-production backups are `Local`, so a regional loss loses non-production
data, which is the accepted cost trade. There is no prepared secondary region: a regional recovery means changing the environment's `region`
and `region_code` in `azure.yml`, re-spelling the region-coded resource names written in every config
([ADR-AZ-DATAMOD-STATICRESOURCENAMES](azure-data-model.md#rule-adr-az-datamod-staticresourcenames)), and redeploying. This is the largest
reliability gap and a deliberate limit on what the repository covers.

Telemetry reaches one workspace and no alert reads it. Diagnostics flow to `foundation`'s workspace through `diagnostic-setting.bicep` (logs
by the `allLogs` category group plus the metrics each resource kind exposes), and the subscription's activity log through
`subscription-diagnostic-setting.bicep`, whose categories include `ServiceHealth` and `ResourceHealth`
([ADR-AZ-LZ-CAFMANAGEMENT](#rule-adr-az-lz-cafmanagement)). `discovery` sends the virtual network and every network security group;
`expedition` the storage account, its blob service, and the database; `foundation`'s own Key Vault sends none, though the module supports
the `keyVault` kind. There is no health model, and the workspace keeps data for the module default of 30 days (`retentionInDays`).

### Security by default

The baseline is written in three places, each the owner of one part. The Security line of
[ADR-AZ-LZ-EVERYPILLAR](#rule-adr-az-lz-everypillar) names what a workload gets, the shared modules in `infrastructure/modules/` carry those
settings as secure defaults, and the three guardrails of [ADR-AZ-LZ-THREEBUILTINPOLICIES](#rule-adr-az-lz-threebuiltinpolicies) turn part of
it into policy as code, with `policy_enforcement` in `pwsh/Azure/configs/azure.yml` deciding whether they deny or only audit
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)). `discovery` assigns the three
policies through `policy-assignment.bicep` at subscription scope, reading the enforcement mode by config address
(`global.azure.policy_enforcement.production` in `psub.yml`, `.nonproduction` in `nsub.yml`). No external benchmark initiative is assigned
to a landing zone and nothing measures a deployed subscription against one. `foundation`'s two resources come from `log-analytics.bicep` and
`key-vault.bicep` and carry the CAF tags, so they pass the required-tag policy; `expedition` takes every secure default of
`storage-account.bicep` and `sql-server.bicep` and overrides only `entraOnlyAuthentication`, to keep the break-glass login.

Security is a property of every change
([EDR-DORA-SECURITY-SECUREPATHAUTOMATED](../external/dora/pervasive-security.md#rule-edr-dora-security-securepathautomated)), and the build
checks hold part of it. Every rendered parameters file must satisfy the template's parameter contract, and a `secureString` parameter must
be a Key Vault reference, never a literal ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](azure-data-model.md#rule-adr-az-datamod-parametercontract)):
`expedition`'s `administratorLoginPassword` is `@secure()` and every config supplies it as a `reference` to `foundation`'s vault (secret
`exped-sql-admin-password`). A config address reaches only version-controlled config, so it never carries a secret. Every GUID in tracked
text is a registered entry in the managed-GUID registry
([ADR-AUTO-GUIDS-EVERYGUIDREGISTERED](../automation/managed-guids.md#rule-adr-auto-guids-everyguidregistered)), so a tenant or subscription
id cannot enter the tree unreviewed; a GUID is an identifier, not a credential, so this is not secret scanning. Logic tests never name a
live identity ([ADR-AUTO-TEST-DISTINCTFIXTURES](../automation/test-automation.md#rule-adr-auto-test-distinctfixtures)). Deployment is
staged: each CD pipeline deploys `foundation`, then `discovery`, then `expedition`, non-production before production, each through the
service connection of its subscription and pinned by `-SubscriptionIdAssertIs` ([az-session-verification](az-session-verification.md)).
There is no secret scan, dependency or static analysis scan of the Bicep code, or threat model of the templates.

Every config of the three templates sets the CAF tag `data-classification` beside `workload`, `environment`, `owner`, `cost-center`, and
`criticality`: `internal` for the shared platform (the hubs, `foundation`'s shared configs) and `confidential` for the customer
subscriptions (for example `apex/psub.yml`). The tag labels the resource, not the data inside it; nothing validates its values and no
control is chosen by it. Classification inside a database is the workload owner's.

The segments come from the data model and the network plan. Each customer has its own subscriptions, one per tier
(`pwsh/Azure/configs/azure.yml`), and each configuration slot is one resource group
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)). The landing zones form a
hub-and-spoke network ([ADR-AZ-NETWORK-PERSUBSCRIPTION](azure-network-model.md#rule-adr-az-network-persubscription)) whose ranges never
overlap ([ADR-AZ-NETWORK-NOOVERLAP](azure-network-model.md#rule-adr-az-network-nooverlap)), and spokes peer only to their hub, never to each
other. Each subscription has its own service connection (`sc-apex-nonprod`, `sc-apex-prod`, and so on), and every deploy pins its
subscription with `-SubscriptionIdAssertIs`. `foundation` gives each subscription one workspace and one vault, so a customer's logs and
secrets never share a resource with another customer's. A spoke gets a network security group on `private-endpoints` and on each workload
subnet (`dev`, `test`), and the hub one on `shared-services`, all with the same two rules: `allow-virtual-network-inbound`, which uses the
`VirtualNetwork` service tag that covers every peered network and so leaves east-west traffic between a spoke and the hub open, and a deny
of inbound traffic from the internet. `expedition` has its own resource group per configuration slot and its private endpoints in its
customer's `private-endpoints` subnet, or the hub's `shared-services` subnet for the shared platform. Management groups are left to the
tenant's administrators.

Microsoft Entra ID is the one identity provider. The storage account and the SQL server each have a system-assigned managed identity, the
storage account refuses shared-key and SAS authorization (`allowSharedKeyAccess: false`), and the Key Vault authorizes through Azure RBAC
(`enableRbacAuthorization: true`, no access policies). A SQL server's administrator is an Entra ID group, so access follows group membership
([ADR-AZ-LZ-SQLENTRAADMINS](#rule-adr-az-lz-sqlentraadmins)): `expedition` sets `entraAdminLogin: zct-exped-sql-admins` with its
`entraAdminObjectId`, `entraAdminPrincipalType` left at `Group`, and `entraOnlyAuthentication: false` to keep the break-glass login
`exped-break-glass`, the one non-identity credential, whose password lives in `foundation`'s vault. The templates make no role assignments:
no Key Vault, storage, or SQL data role is granted in code, the managed identities receive no role, the permission that lets a deploy
resolve the break-glass reference and the roles of the vault's readers are granted outside the repository, and conditional access,
just-in-time access, and access reviews are tenant settings. The policy assignments carry no managed identity, because none of the three
policies deploys or modifies a resource; `policy-assignment.bicep` grants remediation roles only when `assignIdentity` is set.

The workload is private by default. `storage-account.bicep` and `sql-server.bicep` set `publicNetworkAccess: 'Disabled'`, the storage
network rules deny by default, and the SQL "allow Azure services" rule exists only when public access is enabled. Each data service is
reached through `private-endpoint.bicep`, registered in the hub's private DNS zones
([ADR-AZ-LZ-WORKLOADOWNSNONE](#rule-adr-az-lz-workloadownsnone)); `expedition` has two private endpoints (`blobPrivateEndpointName`,
`sqlPrivateEndpointName`) in the subnet named by `privateEndpointSubnetName`. The network plan lives in `pwsh/Azure/configs/network.yml` and
uses private ranges only ([ADR-AZ-NETWORK-ONEIPPLAN](azure-network-model.md#rule-adr-az-network-oneipplan)). The policy against public IP
addresses on network interfaces closes the most common way to expose a virtual machine. `privateEndpointNetworkPolicies` defaults to
`Enabled` in `virtual-network.bicep`, so the security groups apply to the private endpoints too; `GatewaySubnet` and `AzureFirewallSubnet`
carry no security group. The hub hosts two private DNS zones, SQL Database and Blob Storage, linked to every spoke it lists. The workload
has no internet-facing endpoint, so a web application firewall and DDoS protection have nothing to protect. Egress is not filtered: the hub
reserves `AzureFirewallSubnet` and deploys no firewall, and the spoke route tables (`routeTableName`) carry no routes. `foundation`'s Key
Vault and Log Analytics workspace accept public network traffic, since the modules set no `publicNetworkAccess`.

In transit, the storage account sets `minimumTlsVersion: 'TLS1_2'` and `supportsHttpsTrafficOnly: true`, and the SQL server sets
`minimalTlsVersion: '1.2'`; both are fixed in the modules, not parameters. At rest, storage service encryption and SQL transparent data
encryption are on by the platform's default with Microsoft-managed keys; the modules do not set them and nothing turns them off, and the
geo-redundant backups of `apex/prod.yml` are encrypted the same way. Customer-managed keys are not adopted: the highest classification in
use is `confidential`, which platform-managed keys serve, and a customer-managed key adds a vault dependency to every read of the data; a
classification that requires one would make it a config value of the storage and SQL modules. `foundation`'s Key Vault holds secrets, not
encryption keys, and neither it nor the Log Analytics module sets a TLS minimum, so the platform's own minimum applies. `discovery` stores
no data.

Hardening lives in the shared modules as secure defaults, so every template inherits it
([The Well-Architected checklist](#the-well-architected-checklist)). `storage-account.bicep` turns off anonymous blob access and shared-key
access and enables soft delete for blobs and containers (`deleteRetentionDays: 7`); `sql-server.bicep` defaults to Entra-only authentication
with no SQL login and no public access; the no-public-IP policy enforces one hardening rule at scale. Three modules miss these defaults:
`key-vault.bicep` sets neither `publicNetworkAccess` nor purge protection, `vm.bicep` creates a Basic dynamic public IP address and takes a
local administrator password (no template uses it, and the no-public-IP policy denies it in an enforcing landing zone), and
`data-factory.bicep` fixes `publicNetworkAccess: 'Enabled'` (no template uses it either). The budget limits the cost of an abuse of
`discovery`'s subscription.

The repository holds no secret. A `@secure()` parameter takes a Key Vault `reference`, and the parameter contract rejects a literal for it;
a config address reaches only committed config, so it cannot name a secret
([ADR-AZ-DATAMOD-VALUEBYADDRESS](azure-data-model.md#rule-adr-az-datamod-valuebyaddress)). In automation, a secret travels as a protected
value and reaches a child process only through one seam that masks it
([ADR-AUTO-ENVVAR-SECRETTOCHILDPROCESS](../automation/environment-variables.md#rule-adr-auto-envvar-secrettochildprocess)). Managed
identities and Entra ID groups remove most credentials before they exist. `foundation` deploys one Key Vault per subscription
(`keyVaultName`, for example `ps-weu-zct-fnd-ap-kv` for apex production), so each customer's secrets stay in its own subscription and each
environment tier has its own copy. The one secret in use is the break-glass password, `exped-sql-admin-password`, referenced from the vault
of the subscription `expedition` deploys to; it is set in the vault by hand and read by Azure Resource Manager at the next deploy, so its
rotation is manual. `discovery` uses no secret.

`foundation`'s Log Analytics workspace is the one sink of each subscription, outside every workload's resource group. The landing zone
streams the subscription's activity log there, including the `Administrative`, `Security`, and `Policy` categories, and
`diagnostic-setting.bicep` sends each resource's logs (category group `allLogs`) and metrics to it; `discovery` sends the virtual network
and every network security group, and `expedition` the storage account, its blob service, and the database. The workspace keeps 30 days
(`retentionInDays` default of `log-analytics.bicep`). The vault sends no diagnostics, so secret reads are not logged. No Microsoft Defender
for Cloud plan, Microsoft Sentinel, or SQL auditing is deployed.

The repository's tests run before deploy, on the code: `Build-Bicep` compiles each template and checks every rendered parameters file
against its contract, and `Test-AzureNetworkPlan` checks the network plan. None of them reads a security property of the compiled templates,
and nothing tests a deployed workload; a regression in a module default is caught by review.

Incident response is an operating process of the organisation that runs the tenant, not a resource a template deploys. The repository
supplies its inputs: the `owner` and `criticality` tags on every resource, the configuration tree as the deployment inventory
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)), and the logs of each subscription
in one workspace. The budget alerts, which go to the subscription's `Owner` role, are the only alerts the templates create; recovery uses
the database's point-in-time restore (`databaseBackupRetentionDays`), which is a reliability setting.

### Operations as code

The repository's standard practices are its domain rules: the decision records under `docs/drs/`, each rule cited by code and enforced,
where a machine can enforce it, by a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../automation/test-automation.md#rule-adr-auto-test-qualitygate)). Compliance built in as guardrails is the
landing zone's policy assignments, in force in production and auditing outside it. A learning, blameless culture is the DORA capability
[generative organizational culture](../external/dora/generative-organizational-culture.md). The CAF tags on every resource include `owner`,
`criticality`, and `data-classification`: every config tags `foundation`'s workspace and vault with `owner: platform` and
`criticality: high` for the shared platform, a hub carries `owner: platform`, a spoke carries the customer's key as its owner (`owner: apex`
in `configuration/apex/`), and each `expedition` config tags its resources with the workload, the environment, the owner, and a criticality
that follows the environment class (`low` in a development special slot, `high` in production).

Routine operations are automation, not documents: building, deploying, and validating a template are the `Build-Bicep`, `Deploy-Bicep`, and
`Assert-BicepTemplate` functions, run the same way on a devbox and in a pipeline. A scheduled routine is a CRON pipeline invoking an
idempotent function ([FDR-TYPE-CRONISSCHEDULER](../flow/pipeline-types.md#rule-fdr-type-cronisscheduler)). Operational state and runbooks
never live outside version control ([PDR-EAC-NOUNVERSIONEDSTATE](../principles/everything-as-code.md#rule-pdr-eac-nounversionedstate)), and
the task guides under `docs/how-to/` (adding a deployable unit, adding an infrastructure template) are the written procedures for the
changes that recur. Two operations stay manual: putting the break-glass SQL password (`exped-sql-admin-password`) into `foundation`'s vault
before the first `expedition` deploy, and the three-step rollout of a new spoke
([ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](#rule-adr-az-lz-linksneedbothnetworks)), which `cd-shared.yaml` and the customer CD pipelines leave to a
person; there is no emergency-change procedure.

The branching strategy is trunk-based development on `main` ([trunk-based-development](../external/dora/trunk-based-development.md)). A pull
request is the authenticated ingress to the server remote
([DDR-REMOTE-PULLREQUESTISINGRESS](../design/server-remote-integration.md#rule-ddr-remote-pullrequestisingress)), and the build-validation
policies in `build-validation.yml` bind each deployable unit's and each track's globset to its pipeline as a blocking check on `main`. The
CI engine builds and verifies inside the integration budget
([FDR-CD-SHORTINTEGRATIONCYCLE](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-shortintegrationcycle)), and static analysis is a
set of quality gates (`Test-ScriptAnalyzer`, `Test-Markdownlint`, `Test-Spelling`, `Test-Formatting`). Every change under `infrastructure/`
runs `ci-infrastructure.yaml` as a pull-request check and again on the merged commit. Traceability is built into the deploy: after a
successful deploy, `Deploy-Bicep` runs `Set-BicepTrackingTagSet`, which tags the target resource group (`foundation`, and `expedition` per
slot) or the subscription (`discovery`) with the commit, the build id, and the branch. No secret scan of changes and no required-reviewer
policy are configured; `build-validation.yml` holds build validations only.

Tools are standard and pinned: the Bicep CLI, the az CLI ([ADR-AZ-CLI-AZBYDEFAULT](prefer-az-cli.md#rule-adr-az-cli-azbydefault)), Pester,
PSScriptAnalyzer, markdownlint, and Prettier, each locked to a version in `tools.yml` and installed by the same installer on a devbox and in
a pipeline ([ADR-AUTO-DEPS-LOCKEDTOOLVERSIONS](../automation/controlling-systemwide-deps.md#rule-adr-auto-deps-lockedtoolversions)).
Formatting is one standard per file language, configured in `languages.yml` and applied by `Format-Code`, Bicep by `bicep format`. Every
Azure name follows one deterministic naming standard
([ADR-AZ-NAMING-DETERMINISTICNAMES](azure-naming-standard.md#rule-adr-az-naming-deterministicnames); `nsub-weu-zct-fnd-log` for
`foundation`'s workspace, and a storage account, whose type allows no hyphen, takes the concatenated form), every resource carries the CAF
tags, and every decision is an ADR. The delivery metrics are DORA's ([metrics](../../references/dora/metrics.md)). The repository has no
`bicepconfig.json`, so `az bicep build` runs the Bicep linter with its default rule levels, and a linter warning does not fail the build.

Everything the infrastructure needs lives in version control
([PDR-EAC-EVERYTHINGCOMMITTED](../principles/everything-as-code.md#rule-pdr-eac-everythingcommitted)): declarative Bicep under
`infrastructure/`, shared modules under `infrastructure/modules/`, and one config per slot under each template's `configuration/`
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)). One template serves every
environment; only its config varies, and a value that another config owns is read by config address, never copied
([ADR-AZ-DATAMOD-VALUEBYADDRESS](azure-data-model.md#rule-adr-az-datamod-valuebyaddress)). The three templates are the split by rate of
change: `foundation` changes least, `discovery` rarely, `expedition` with its workload. A secure parameter takes a Key Vault reference, so
no secret sits in a config; the vault is RBAC-authorised with no access policies to drift. `discovery` reads the network's kind, address
space, and subnets from `network.yml` and the policy enforcement mode from `azure.yml` by config address, so its config holds names, never
ranges. The secure defaults (public access off, TLS 1.2, managed identities) are module defaults, and what varies by environment class (SKU,
zone redundancy, backup redundancy and retention, the serverless pause) is config. Every template deploys in `Incremental` mode (the default
of `deployment_mode`), so a resource removed from a template stays in Azure until someone deletes it, and no check scans the compiled
templates for misconfiguration.

The delivery flow is the supply chain. Each deployable unit, the shared platform and each customer, has a globset in `globs.yml` that
triggers its CD pipeline through the globset's native path filter
([FDR-GLOBS-NATIVEPATHFILTER](../flow/durable-sha-globs.md#rule-fdr-globs-nativepathfilter)). The CD pipeline runs the same CI engine as
`ci-infrastructure.yaml` ([FDR-TYPE-ONECIENGINE](../flow/pipeline-types.md#rule-fdr-type-oneciengine)), publishes one artifact per template,
and its deploy stages consume those artifacts unchanged, build once and deploy many
([FDR-CD-SEPARATEPIPELINEKINDS](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-separatepipelinekinds)). The stages run
`foundation`, then `discovery`, then `expedition` (one deployment job per slot; a customer with no `expedition` config passes an empty list
and gets no stage), and each deploy asserts the subscription its service connection logs into (`-SubscriptionIdAssertIs`). Hubs deploy from
`cd-shared.yaml` and spokes from the customer pipelines, so the spoke rollout order spans two pipelines. Configuration that reaches the
cloud enters only through version control
([FDR-TYPE-CONFIGENTERSTHROUGHINPUT](../flow/pipeline-types.md#rule-fdr-type-configentersthroughinput)). The shipped CD pipelines deploy
non-production and production in the same stage: `cd-shared.yaml` deploys `nsub` and `psub` side by side, and `extends/cd-customer.yaml`
deploys each customer's `dev` and `prod` side by side, whereas the flow model keeps CD within non-production and reaches production through
a DEPLOY pipeline behind a manual gate ([FDR-CD-CDSTAYSINNONPROD](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-cdstaysinnonprod),
[FDR-CD-PRODPROGRESSIONISDEPLOY](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-prodprogressionisdeploy)); `.ado/pipelines/` holds
no DEPLOY pipeline. The shipped pipelines deploy only on `main`, after the CI stage, in dependency order, each into an asserted
subscription, with no bake time between non-production and production, and they do not run the what-if preview that `Deploy-Bicep -DryRun`
offers. The flow model defines safe deployment as one tagged artifact built once, promoted through non-production behind the RC and RBC
gates ([FDR-CD-TWORELEASEGATES](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-tworeleasegates)), then staged inactive in pre-prod
and activated to production
([FDR-CD-TWOENVIRONMENTACTIVATION](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-twoenvironmentactivation)), and a DEPLOY pipeline
deploys one pinned commit's artifact, so rolling back is deploying the commit before it
([FDR-TYPE-DEPLOYISPINNED](../flow/pipeline-types.md#rule-fdr-type-deployispinned)). Read-only standing access to the subscriptions is a
tenant setting. `discovery` is the riskiest template, since a change to peering, routing, or a policy assignment reaches every workload of
the subscription; a slot is a deployment of its own, so a special slot can take a change before the base slot.

Monitoring is part of the infrastructure, deployed by the same templates
([monitoring-and-observability](../external/dora/monitoring-and-observability.md)). `foundation` gives every subscription one Log Analytics
workspace (`PerGB2018`, the module's 30-day retention in every config), so telemetry is central per subscription and separate between
non-production and production. Each template sends the diagnostics of the resources it deploys to that workspace through the
`diagnostic-setting.bicep` module, and the subscription's activity log through `subscription-diagnostic-setting.bicep`
([ADR-AZ-LZ-CAFMANAGEMENT](#rule-adr-az-lz-cafmanagement)); `foundation`'s own Key Vault sends no diagnostics, `discovery` sends the
activity log, the virtual network and each network security group, and `expedition` the storage account, the blob service, and the database.
A diagnostic setting in the template exists when the deploy succeeds, which a deploy-if-not-exists policy cannot promise. `expedition`
deploys no compute, so it has no application telemetry to trace. There is no health model, alert rule, or dashboard, and the only alerts are
the landing zone's budget thresholds, sent to the subscription's `Owner` role.

The architecture carries the containment and recovery side of an incident. Workloads sit behind private endpoints with public access off,
each subnet that carries workloads has a network security group that denies inbound traffic from the internet, a spoke has a route table on
every subnet, the hub reserves `AzureFirewallSubnet`, and a SQL server keeps a break-glass login beside its Entra ID administrator group
([ADR-AZ-LZ-SQLENTRAADMINS](#rule-adr-az-lz-sqlentraadmins)). The activity log of every subscription is the audit trail, and the provenance
tags name the commit behind any deployed resource, so a bad change is found and redeployed from the commit before it. No alert routes an
incident to anyone, and no response plan, escalation path, or drill exists as a version-controlled procedure; a blameless review that
changes a rule, a gate, or an ADR is how the repository learns.

Infrastructure is tested in tiers by `Test-Automation` ([ADR-AUTO-TEST](../automation/test-automation.md)), each test tagged with its tier
and category and kept in the module it tests. For infrastructure, `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for
every template and then `Test-Automation -Suite infrastructure`, whose L2 test builds every shipped template and checks each rendered
parameters file against the compiled parameter model
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](azure-data-model.md#rule-adr-az-datamod-parametercontract)); a build that leaves the literal `UNDEFINED`
in a config fails, and `Test-AzureNetworkPlan` checks the network plan. No L3 system test deploys a template to an on-demand environment
([FDR-CD-INNERANDOUTERLOOP](../flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-innerandouterloop),
[ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree)), and no L4 test observes a
deployed landing zone or workload
([ADR-AUTO-TEST-TESTINGINPRODUCTION](../automation/test-automation.md#rule-adr-auto-test-testinginproduction)); a special slot (`dev-blu`)
is a purpose-built second deployment beside a base slot.

The automation is the catzc module system itself: every operation is a function in a module under `pwsh/`, tested by
[ADR-AUTO-TEST](../automation/test-automation.md), idempotent ([ADR-AUTO-IDEM](../automation/idempotent-state-functions.md)), previewable
with `-DryRun` ([ADR-AUTO-DRYRUN](../automation/dry-run.md)), and bounded in time
([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)). Pipelines call it
through one runner and keep their YAML declarative ([FDR-TYPE-ALLTHROUGHRUNNER](../flow/pipeline-types.md#rule-fdr-type-allthroughrunner)),
so the same function runs on a devbox and in a pipeline ([ADR-AUTO-PARITY](../automation/devbox-pipeline-parity.md)). It drives Azure
through the az CLI. Desired state in Azure is held by the landing zone's policy assignments, which deny a resource that breaks them in
production and audit it elsewhere. `foundation` needs no bootstrap beyond the resource group `Deploy-Bicep` creates; `expedition`'s storage
account and SQL server each take a system-assigned managed identity, and its database's serverless pause outside production is platform
automation set by config. Monitoring-driven self-healing is not used: the templates deploy platform services (storage, SQL Database,
networking) whose recovery Azure performs.

### SQL authentication

An Entra ID group as the server's administrator ties database access to the directory: joining or leaving the group grants or revokes it,
and no password is shared. A break-glass SQL login stays beside it, so the server stays reachable when the directory or the group is
unavailable. Its password is a Key Vault reference to `foundation`'s vault, resolved by Azure Resource Manager at deploy time, so the
repository never holds it ([data-model](azure-data-model.md)).

### Adding a spoke

A peering points at a remote virtual network, and a DNS zone link names one, so both networks must exist before either is created. The hub
lists its spokes, so the order is fixed by ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS: the hub first without the new spoke, then the spoke, which peers
to the existing hub, then the hub again with the spoke listed. A hub deploy that lists a spoke whose network does not exist fails, naming
the missing network; once the spoke is deployed, the next hub deploy completes it.

### How this is enforced

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `discovery` and `expedition` on every change under
  `infrastructure/`, so a template or config that does not compile, or a config address that does not resolve, fails the build.
- The parameter-model test binds every template `Get-BicepTemplates` finds and checks each rendered parameters file against the compiled
  parameter model ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](azure-data-model.md#rule-adr-az-datamod-parametercontract)).
- `NetworkConfig` and `Test-AzureNetworkPlan` hold the network plan: the kind of each subscription's network, its subnets, and no overlap
  ([network-model](azure-network-model.md)).
- `AzureConfig` declares the default of `policy_enforcement` and rejects an unknown key or mode, and `discovery`'s `@allowed` decorator on
  `policyEnforcementMode` rejects any other value at build time.
- `Test-ManagedGuids` fails an unregistered GUID in tracked text, so a built-in definition id enters `discovery/main.bicep` only with its
  `guids.yml` entry ([ADR-AUTO-GUIDS](../automation/managed-guids.md)).
- Not yet in place: a check over the compiled templates (`main.json`) that fails a resource without the CAF tags.
- `globs.yml` declares `template-azure-subscription-discovery` and `template-azure-workload-expedition` as base deployable units, composed
  by the customer and shared-platform units, so a change to either template triggers every CD pipeline that deploys it
  ([durable-sha-globs](../flow/durable-sha-globs.md)); the customer CD pipeline deploys `foundation`, then `discovery`, then `expedition`.

## Consequences

- Every subscription gets the same landing zone from one template, so the network, the policies, and the budget of a new customer
  subscription are a config file, not a design.
- A workload template carries only its own resources; a second workload lands in the same spoke with no network work.
- Policy enforcement changes for the whole repository with one edit to `azure.yml`.
- The repository never needs rights above a subscription, at the cost of leaving management-group policy to the tenant's administrators.
- Adding a spoke takes three deploys in a fixed order; the static peering list keeps the topology reviewable in the configuration tree.
