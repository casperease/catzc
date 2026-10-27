# Landing zones: Topology, guardrails and limits

Part of the decision of [ADR-AZ-LZ](../landing-zones.md), which holds the rules these sections justify.

## The subscription landing zone

`discovery` deploys at subscription scope (`deployment_target: Subscription`), one config per subscription keyed by the per-subscription
environment (`nsub`, `psub`), at the same coordinates as `foundation`. Each deploy creates one resource group with the virtual network, a
network security group per subnet that carries workloads (allowing traffic inside the virtual networks, denying inbound traffic from the
internet), the guardrails, and a budget whose alerts go to the subscription's `Owner` role, so no address is kept in a config.

The landing zone stops at the subscription. Management groups, their policy inheritance, and tenant-level deployments belong to whoever
administers the tenant; a repository that deploys into subscriptions it is given cannot assume it owns the hierarchy above them. Everything
the landing zone needs — its policies, its diagnostics, its budget — is assigned at subscription level, where the service connection that
deploys it has rights.

## Hub and spoke

Each tier of shared subscriptions (non-production, production) holds a hub; each customer subscription holds a spoke peered to the hub of
its tier ([ADR-AZ-NETWORK-PERSUBSCRIPTION](../azure-network-model.md#rule-adr-az-network-persubscription)). The hub reserves `GatewaySubnet`
and `AzureFirewallSubnet`, and nothing is deployed into them, so a gateway or a firewall can be added without renumbering. A spoke adds a
route table on every subnet.

Peering is declared on both sides because Azure models it on both sides: a peering is a child of one virtual network and points at the
other. Declaring both in configs keeps the topology readable from the configuration tree alone, with no discovery step at deploy time.

The private DNS zones of the private-link services the workloads use live once, in the hub, and are linked to every spoke the hub lists. A
private endpoint in any spoke then resolves through the same zone, and no spoke carries a copy that could disagree.

The ranges come from `network.yml` by config address ([ADR-AZ-NETWORK-ONEIPPLAN](../azure-network-model.md#rule-adr-az-network-oneipplan),
[ADR-AZ-DATAMOD-VALUEBYADDRESS](../azure-data-model.md#rule-adr-az-datamod-valuebyaddress)): the kind, the address space, and the subnet map
of the subscription. The landing zone's config therefore holds names, never addresses, and the overlap check of the network plan
([ADR-AZ-NETWORK-NOOVERLAP](../azure-network-model.md#rule-adr-az-network-nooverlap)) guarantees that any hub can peer to any spoke.

## Guardrails

The landing zone's ten policies are Azure built-ins, so their meaning is Microsoft's, apart from one custom definition, the CAF tags.
Allowed locations keeps every resource in the landing zone's region; the required tags keep cost attributable; no public IP address on a
network interface and public network access off on storage and SQL keep workloads behind private endpoints; the data-diagnostics audit, the
allowed storage SKUs, virtual machine sizes and resource types, and the audit-only Microsoft cloud security benchmark bound the rest.

Whether the assignments enforce is a property of the repository, not of a template. `azure.yml` holds it as `policy_enforcement`; its
sensible default enforces in production and audits outside it, and a stricter repository overrides it in config
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)). The landing zone's `psub` config
reads the production mode and its `nsub` config the non-production mode, by config address.

Every resource the templates deploy carries the six CAF tags (`workload`, `environment`, `owner`, `cost-center`, `criticality`, and
`data-classification`) from its config, because the production assignment denies a resource without them. `foundation` passes the same
tags, so its resources pass the policy too. All six are required by policy: one custom definition in `landing-zone-policies.bicep`, mode
Indexed, denies a resource that misses any of them. Append and modify effects are not used: they fill a missing tag after
the fact from a value the policy holds rather than the config, and a modify policy needs a managed identity and remediation tasks for
resources that exist before it. The templates write every tag deterministically, so the policy's job is to stop a resource that skipped
them, and deny does that.

Each policy is assigned at subscription scope, the highest level the repository owns, through
`infrastructure/modules/policy-assignment.bicep`, once per subscription and named per config (`policyAssignmentNames`, one role per
assignment, two or three characters as the namer requires): allowed locations, the required CAF tags, no public IP on a network interface,
public network access off on storage and on SQL (deny), an audit of a diagnostic setting on every data resource kind (storage, SQL
database, Key Vault, Data Factory), the allowed storage SKUs, virtual machine sizes and resource types, and the benchmark initiative.
`landing-zone-policies.bicep` holds the ten ids in its `policyDefinitions` map, each with its parameters and a non-compliance message,
and the build derives `policyEnforcementMode` from `policy_enforcement` by the class of the
subscription each slot targets. No assignment sets `assignIdentity`, so no remediation identity exists. Every resource group of the
subscription inherits the assignments, those of `foundation` and `expedition` included. Production and non-production differ through the
enforcement mode, never through a narrower assignment.

Keeping the policies current is a matter of their ids. Microsoft revises a built-in definition in place under the same id, so an assignment
follows the current version with no change here. When a definition is deprecated or a better one appears, the id in `landing-zone-policies.bicep` and its
`guids.yml` entry (one `policy_*` entry per built-in) change together in one reviewed
change, and the repository never carries the old and the new definition side by side
([PDR-ONELIVE](../../principles/one-living-version.md)).

The subscription's activity log streams to `foundation`'s workspace through a diagnostic setting the landing zone deploys. A
deploy-if-not-exists policy would reach the same end through a remediation task that runs later, needs a managed identity with rights to
write the setting, and reports compliance after the fact. A diagnostic setting in the template is deterministic: it exists when the deploy
succeeds, and a failed deploy says why.

## The workload in the landing zone

`expedition` deploys into its own resource group, one per configuration slot, inside the subscription its landing zone serves. It looks up
the spoke's `private-endpoints` subnet by name (the shared platform's `shared-services` subnet in the hub) and places a private endpoint for
each data service there, each registered in the hub's matching private DNS zone. It never creates a network or a guardrail: the landing zone
owns those, so every workload of a subscription meets the same network and the same policies. Each environment in `azure.yml` names one
region (`region: westeurope`, `region_code: weu`): `discovery` creates its resource group through `resource-group.bicep` at `location`,
which defaults to `deployment().location`, and `expedition` defaults `location` to `resourceGroup().location`, which must match the region
of the network it lands in.

## The Well-Architected checklist

The five pillars are a review checklist, and each line of ADR-AZ-LZ-EVERYPILLAR is something the template does, not an aspiration. The
settings that every caller should share — public access off, TLS 1.2, zone redundancy, a managed identity — are secure defaults of the
shared Bicep modules, so `foundation` gets them too; the settings that differ by environment class — the SKU, the backup redundancy and
retention, the serverless pause — are config values.

## Governance limits

The landing zone assigns built-in definitions, which Azure publishes at tenant level and every subscription can assign, and one custom
definition, the CAF-tags rule of `landing-zone-policies.bicep`, which sits at subscription level beside its assignment, since the repository
has no rights over the tenant's hierarchy.

The example customers carry no regulatory obligation, so the policy set holds the guardrails every subscription needs and one audit-only
initiative, the Microsoft cloud security benchmark. The `data-classification` tag records how sensitive a workload's data is, but no policy
reads it. The assignment module takes an initiative id as readily as a definition id, so a regulatory initiative is one more pinned entry in
`discovery`'s set. Nothing registers or restricts a resource provider.

Policy belongs to the landing zone and a workload owns none of it
([ADR-AZ-LZ-WORKLOADOWNSNONE](../landing-zones.md#rule-adr-az-lz-workloadownsnone)). The templates grant no role to a team; the only role
assignment a module can make is the remediation role of a policy assignment's managed identity, which no assignment of the landing zone
uses. A team that needs a policy for its application proposes it for the landing zone, through review like any other change. Role
assignments for people belong to whoever administers the subscription.

The repository makes no assignment above a subscription, so it has no root-level assignment to keep few, and the subscription assignments
carry no exclusion to manage. Assignments that a tenant's administrators make at a management group above the subscriptions apply alongside
the landing zone's and are theirs to manage.

## Cost attribution

`discovery` deploys one Cost Management budget per subscription through `infrastructure/modules/budget.bicep`: a monthly amount from its
config, in the subscription's billing currency, with alerts at 50, 80, and 100 percent of actual cost to the holders of the subscription's
`Owner` role, so no address is kept in a config. The amounts are plain config values that anyone reading the repository can see and review.
`foundation` and `expedition` have no budget of their own; their cost counts against the subscription's. The CAF tags carry the metadata
cost analysis groups by: `cost-center` names the paying team, `workload` the project, and `owner` and `environment` let spend group further.
`Deploy-Bicep` creates the resource group of a resource-group template (`foundation`, `expedition`) through `Deploy-AzureResourceGroup`
with the template's CAF tags from its config, merged onto a group that exists, so cost grouped by resource group, or inherited from it,
reads the same tags as the resources. `discovery` creates its own resource group through
`infrastructure/modules/resource-group.bicep`, so its resource group and every resource in it carry the tags.
