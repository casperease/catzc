---
catzc:
  immutable:
    with_body_sha: ddae9ec7174a
    repo_status: clean
    path: docs/adr/azure/landing-zones.md
    folder: docs/adr/azure
    name: landing-zones
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-AZ-LZ#{1-7}
    cites:
      - ADR-AZ-DATAMOD#{9-11}
      - ADR-AZ-NETWORK#{1,5,6}
    links:
      - docs/adr/azure/azure-data-model.md
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod10
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/azure-network-model.md
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network1
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network5
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network6
      - docs/adr/flow/durable-sha-globs.md
---

# ADR: Landing zones — a CAF landing zone per subscription and the Well-Architected workload in it

Pairs with [`network-model`](azure-network-model.md) (the IP plan the landing zone deploys) and [`data-model`](azure-data-model.md) (the
configuration tree and the config-addressed parameters it reads).

## Rules: ADR-AZ-LZ

### Rule ADR-AZ-LZ:1

A **landing zone** is the network, the guardrails, and the cost control a workload lands in, deployed once per subscription at subscription
scope by the `discovery` template, the **Cloud Adoption Framework** (CAF) application landing zone. Its boundary is the subscription: it
owns no **management group** and deploys nothing at management-group or tenant level, and it holds no workload of its own.

- [The subscription landing zone](#the-subscription-landing-zone)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-LZ:2

The landing zones form a hub-and-spoke network. A **hub** is the landing zone of a shared subscription; a **spoke** is the landing zone of a
customer subscription, peered to the hub of its tier. Peering is static and two-sided: a spoke's config names its hub, and a hub's config
lists its spokes. The private DNS zones live in the hub and are linked to the hub and to every spoke it lists. `network.yml` is the one home
of every range, and the landing zone reads the kind, the address space, and the subnets by config address, never as a copy.

- [Hub and spoke](#hub-and-spoke)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-LZ:3

Every landing zone assigns three built-in policies: allowed locations (its region), a required tag on resources, and no public IP address on
a network interface. Whether they enforce or only audit is the repository-wide setting `policy_enforcement`, read by config address, with
its sensible default declared once ([ADR-AZ-DATAMOD#11](azure-data-model.md#rule-adr-az-datamod11)). The subscription's activity log streams
to `foundation`'s Log Analytics workspace through a diagnostic setting the landing zone deploys, never through a deploy-if-not-exists
policy.

- [Guardrails](#guardrails)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-LZ:4

A workload lands in its landing zone and owns none of it. `expedition` places its private endpoints in the `private-endpoints` subnet of its
customer's spoke (the shared platform's in the hub's `shared-services` subnet) and registers them in the hub's private DNS zones; it creates
no network, peering, DNS zone, or policy.

- [The workload in the landing zone](#the-workload-in-the-landing-zone)

### Rule ADR-AZ-LZ:5

The workload realises every **pillar** of the Azure **Well-Architected Framework**, each as a module default or a config value. Reliability:
zone-redundant storage, and in production a zone-redundant database with geo-redundant backups. Security: no public network access, private
endpoints only, TLS 1.2 minimum, a managed identity, and Entra ID authentication (ADR-AZ-LZ#6). Cost optimisation: a serverless database
that pauses when idle outside production, a provisioned one in production. Operational excellence: diagnostics from every resource to
`foundation`'s workspace, and the CAF tags on every resource. Performance efficiency: the database SKU, tier, and capacity per environment
class, from the config.

- [The Well-Architected checklist](#the-well-architected-checklist)

### Rule ADR-AZ-LZ:6

A SQL server authenticates its administrators through an Entra ID group first. Beside it sits one **break-glass login**, a SQL login whose
password is a Key Vault reference to `foundation`'s vault in the same subscription, so the repository holds no secret.

- [SQL authentication](#sql-authentication)

### Rule ADR-AZ-LZ:7

A peering and a DNS zone link need both virtual networks to exist. So a spoke is added in three steps: the hub deploys without listing the
new spoke, the spoke deploys and peers to the hub, then the hub's config lists the spoke and the hub deploys again, adding its peering and
its zone links. A hub that lists a spoke whose virtual network does not exist fails its deploy. A new set of landing zones rolls out the
same way: hubs, then spokes, then hubs again.

- [Adding a spoke](#adding-a-spoke)

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
its tier ([ADR-AZ-NETWORK#5](azure-network-model.md#rule-adr-az-network5)). The hub reserves `GatewaySubnet` and `AzureFirewallSubnet`, and
nothing is deployed into them, so a gateway or a firewall can be added without renumbering. A spoke adds a route table on every subnet.

Peering is declared on both sides because Azure models it on both sides: a peering is a child of one virtual network and points at the
other. Declaring both in configs keeps the topology readable from the configuration tree alone, with no discovery step at deploy time.

The private DNS zones of the private-link services the workloads use live once, in the hub, and are linked to every spoke the hub lists. A
private endpoint in any spoke then resolves through the same zone, and no spoke carries a copy that could disagree.

The ranges come from `network.yml` by config address ([ADR-AZ-NETWORK#1](azure-network-model.md#rule-adr-az-network1),
[ADR-AZ-DATAMOD#10](azure-data-model.md#rule-adr-az-datamod10)): the kind, the address space, and the subnet map of the subscription. The
landing zone's config therefore holds names, never addresses, and the overlap check of the network plan
([ADR-AZ-NETWORK#6](azure-network-model.md#rule-adr-az-network6)) guarantees that any hub can peer to any spoke.

### Guardrails

The three policies are Azure built-in definitions, so their meaning is Microsoft's and needs no custom definition to maintain. Allowed
locations keeps every resource in the landing zone's region; the required tag keeps cost attributable; no public IP address on a network
interface keeps workloads behind private endpoints.

Whether the assignments enforce is a property of the repository, not of a template. `azure.yml` holds it as `policy_enforcement`; its
sensible default enforces in production and audits outside it, and a stricter repository overrides it in config
([ADR-AZ-DATAMOD#11](azure-data-model.md#rule-adr-az-datamod11)). The landing zone's `psub` config reads the production mode and its `nsub`
config the non-production mode, by config address.

Every resource the templates deploy carries the CAF tags, the required one among them, because the production assignment denies a resource
without it. `foundation` passes the same tags, so its resources pass the policy too.

The subscription's activity log streams to `foundation`'s workspace through a diagnostic setting the landing zone deploys. A
deploy-if-not-exists policy would reach the same end through a remediation task that runs later, needs a managed identity with rights to
write the setting, and reports compliance after the fact. A diagnostic setting in the template is deterministic: it exists when the deploy
succeeds, and a failed deploy says why.

### The workload in the landing zone

`expedition` deploys into its own resource group, one per configuration slot, inside the subscription its landing zone serves. It looks up
the spoke's `private-endpoints` subnet by name (the shared platform's `shared-services` subnet in the hub) and places a private endpoint for
each data service there, each registered in the hub's matching private DNS zone. It never creates a network or a guardrail: the landing zone
owns those, so every workload of a subscription meets the same network and the same policies.

### The Well-Architected checklist

The five pillars are a review checklist, and each line of ADR-AZ-LZ#5 is something the template does, not an aspiration. The settings that
every caller should share — public access off, TLS 1.2, zone redundancy, a managed identity — are secure defaults of the shared Bicep
modules, so `foundation` gets them too; the settings that differ by environment class — the SKU, the backup redundancy and retention, the
serverless pause — are config values.

### SQL authentication

An Entra ID group as the server's administrator ties database access to the directory: joining or leaving the group grants or revokes it,
and no password is shared. A break-glass SQL login stays beside it, so the server stays reachable when the directory or the group is
unavailable. Its password is a Key Vault reference to `foundation`'s vault, resolved by Azure Resource Manager at deploy time, so the
repository never holds it ([data-model](azure-data-model.md)).

### Adding a spoke

A peering points at a remote virtual network, and a DNS zone link names one, so both networks must exist before either is created. The hub
lists its spokes, so the order is fixed by ADR-AZ-LZ#7: the hub first without the new spoke, then the spoke, which peers to the existing
hub, then the hub again with the spoke listed. A hub deploy that lists a spoke whose network does not exist fails, naming the missing
network; once the spoke is deployed, the next hub deploy completes it.

### How this is enforced

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `discovery` and `expedition` on every change under
  `infrastructure/`, so a template or config that does not compile, or a config address that does not resolve, fails the build.
- The parameter-model test binds every template `Get-BicepTemplates` finds and checks each rendered parameters file against the compiled
  parameter model ([ADR-AZ-DATAMOD#9](azure-data-model.md#rule-adr-az-datamod9)).
- `NetworkConfig` and `Test-AzureNetworkPlan` hold the network plan: the kind of each subscription's network, its subnets, and no overlap
  ([network-model](azure-network-model.md)).
- `AzureConfig` declares the default of `policy_enforcement` and rejects an unknown key or mode.
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
