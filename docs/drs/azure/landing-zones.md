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
and every resource names its paying team in `cost-center` and its workload in `workload`. Cost exports, forecast alerts, and anomaly alerts
are not yet deployed, and the resource groups that `Deploy-Bicep` creates for `foundation` and `expedition` carry no CAF tags.

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
Sentinel, Purview, customer-managed keys, and every virtual machine control are not deployed; a vault with purge protection, a closed
network, and audited use is the planned hardening.

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
`foundation` and `expedition` have no budget of their own; their cost counts against the subscription's. The oversight not yet deployed is
the rest of Cost Management: no cost export writes daily data to storage, the budget compares against actual cost only, and there is no
anomaly alert ([EDR-AZ-WAF-CO-CO03](../external/azure/waf/cost-optimization.md#rule-edr-az-waf-co-co03)).

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
workspace, one per subscription rather than one for the tenant; a retention per environment class is planned and an archive to storage
beyond two years is not needed. Access audit reports, real-time alerts through Event Grid, an incident response plan
([EDR-AZ-WAF-SE-SE12](../external/azure/waf/security.md#rule-edr-az-waf-se-se12)), and the tracking of Azure roadmaps as a process belong to
the tenant's security operations or are served by the retrieval dates of the records. Microsoft Defender for Cloud is planned as a resource
of the landing zone, deployed by `discovery` for the services its workloads use, not through a deploy-if-not-exists policy. No virtual
machine is deployed, so patch tracking, policy-deployed extensions, security drift, attestation, and just-in-time access have nothing to act
on, and no endpoint or user application exists for endpoint management, Defender for Cloud Apps, or application onboarding.

The shared Bicep modules are the allowlist of services, each with secure defaults; a policy that denies a resource type outside them is
planned. The landing zone assigns three built-in policies at subscription level in place of the management-group policy set of the CAF
reference landing zone, and a benchmark initiative in audit mode is planned. Access follows Zero Trust through Entra ID identities, a
service connection per subscription pinned on every deploy, and private endpoints for data, though `foundation`'s vault and workspace accept
public traffic until the planned closure. Each workload deploys the diagnostic settings of its own resources, so its monitoring travels with
its template. Data at rest uses Microsoft-managed keys, and the `data-classification` tag labels each resource in place of Purview. No
workload has public ingress, so the Zero Trust application delivery pattern and the accelerators' network variants do not apply; workload
networking is private by plan (`network.yml`, a security group per workload subnet, private endpoints) and egress filtering through a hub
firewall is planned. Sentinel, its identity feeds, and threat hunting are the tenant's security operations; `foundation`'s workspace is
where Sentinel would attach and the repository supplies the logs.

Key Vault is federated: `foundation` deploys one vault per subscription from one module, so every customer and tier has its own vault with
the same configuration and no policy is needed. No vault is central to the tenant, though a workload's secret sits in the platform's vault.
Every vault authorizes its data plane through Azure RBAC with no access policies and has the platform's soft delete: `key-vault.bicep` fixes
`enableRbacAuthorization: true` and an empty `accessPolicies`, neither a parameter, so no caller falls back to access policies, and it sets
no retention, no network rule, and `enabledForTemplateDeployment` on, because Azure Resource Manager resolves `expedition`'s break-glass
reference at deploy time. The roles on a vault are granted outside the repository, and the vault name stays taken until a deleted vault's
retention ends. `storage-account.bicep` turns shared-key access off, so every data request carries an Entra ID token. Purge protection is
planned as a module default, and with it permanent deletion is closed, so custom roles that alone may purge are not needed. The vaults hold
no key and no certificate, so certificate automation has no use; rotation of the one secret, the break-glass password, is manual and planned
to be automated. A vault's network access is planned to be closed, public network access off with a private endpoint in the hub's private
DNS in place of the service endpoints CAF names, and vault use is planned to be audited in the workspace through the `keyVault` kind of the
diagnostic setting module. The environments of one tier share their tier's vault and the same secret name, `exped-sql-admin-password` (`dev`
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
