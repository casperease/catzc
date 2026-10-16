---
catzc:
  immutable:
    with_body_sha: afa53038a9df
    repo_status: clean
    path: docs/adr/azure/caf/network-private-access.md
    folder: docs/adr/azure/caf
    name: network-private-access
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-AZ-CAFNETPRV#{1-13}
    cites:
      - ADR-AZ-CAFSEC#21
      - ADR-AZ-LZ#{2-4,7}
      - ADR-AZ-NETWORK#{1,5,6}
      - ADR-AZ-WAFSE#6
    links:
      - docs/adr/azure/azure-network-model.md
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network1
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network5
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network6
      - docs/adr/azure/caf/landing-zone-security.md
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec21
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz2
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz3
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz4
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz7
      - docs/adr/azure/waf/cost-optimization.md
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse6
      - docs/references/caf/index.md
---

# ADR: CAF network private access — what the repository does about each recommendation on PaaS connectivity and DNS

Pairs with [`landing-zones`](../landing-zones.md) (the hub that holds the private DNS zones and the workload that registers in them),
[`azure-network-model`](../azure-network-model.md) (the address plan), and [`caf-security`](landing-zone-security.md) (the vault's private
access).

## Rules: ADR-AZ-CAFNETPRV

### Rule ADR-AZ-CAFNETPRV:1

Virtual network injection is not adopted, because no template deploys a service that is injected into a subnet; the data services are
reached through private endpoints instead.

- [1 — Virtual network injection for PaaS services](#1--virtual-network-injection-for-paas-services)

### Rule ADR-AZ-CAFNETPRV:2

Every data service is reached through Private Link: storage and SQL have public network access off and a private endpoint registered in the
hub's private DNS zones; the vault's private endpoint is planned (ADR-AZ-CAFSEC#21).

- [2 — Private Link for private-only access](#2--private-link-for-private-only-access)

### Rule ADR-AZ-CAFNETPRV:3

Virtual network service endpoints are not adopted, because every data service takes a private endpoint, which keeps one way of reaching data
for every workload.

- [3 — Service endpoints where Private Link is not needed](#3--service-endpoints-where-private-link-is-not-needed)

### Rule ADR-AZ-CAFNETPRV:4

Access to PaaS services from on-premises is not adopted, because the repository has no on-premises connectivity.

- [4 — PaaS access from on-premises](#4--paas-access-from-on-premises)

### Rule ADR-AZ-CAFNETPRV:5

No subnet carries a service endpoint, so none is enabled by default.

- [5 — No service endpoints by default on every subnet](#5--no-service-endpoints-by-default-on-every-subnet)

### Rule ADR-AZ-CAFNETPRV:6

No network forces internet traffic back to on-premises: the spoke route tables carry no default route, and no gateway exists to tunnel
through.

- [6 — No forced tunnelling](#6--no-forced-tunnelling)

### Rule ADR-AZ-CAFNETPRV:7

Name resolution is Azure-only, through Azure-provided DNS and the hub's `privatelink` zones; a custom DNS zone with automatic registration
is not adopted, because no template deploys a virtual machine.

- [7 — Private DNS zones for Azure-only resolution](#7--private-dns-zones-for-azure-only-resolution)

### Rule ADR-AZ-CAFNETPRV:8

Hybrid name resolution through DNS Private Resolver or Active Directory DNS is not adopted, because the repository has no on-premises
network to resolve with.

- [8 — Hybrid resolution with DNS Private Resolver](#8--hybrid-resolution-with-dns-private-resolver)

### Rule ADR-AZ-CAFNETPRV:9

Azure Firewall as a DNS proxy is not adopted, because the hub deploys no firewall.

- [9 — Azure Firewall as a DNS proxy](#9--azure-firewall-as-a-dns-proxy)

### Rule ADR-AZ-CAFNETPRV:10

Every private DNS zone is linked to the hub and to every spoke the hub lists; a forwarding ruleset is not adopted, because no on-premises
name needs forwarding.

- [10 — Zone links and a forwarding ruleset](#10--zone-links-and-a-forwarding-ruleset)

### Rule ADR-AZ-CAFNETPRV:11

Dedicated DNS Private Resolver subnets are not adopted, because no resolver is deployed; the hub's address space leaves room for them.

- [11 — Dedicated resolver subnets in the hub](#11--dedicated-resolver-subnets-in-the-hub)

### Rule ADR-AZ-CAFNETPRV:12

Workload-owned DNS is not adopted, because no workload runs a DNS service of its own.

- [12 — Workloads that bring their own DNS](#12--workloads-that-bring-their-own-dns)

### Rule ADR-AZ-CAFNETPRV:13

The private DNS zones live in the hub of each tier's shared subscription, one set per tier rather than one global set, and workloads
register in them by template, never by policy.

- [13 — Private DNS zones in the connectivity subscription](#13--private-dns-zones-in-the-connectivity-subscription)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation. Its landing-zone part splits the
platform that workloads land in into design areas, each with considerations and design recommendations: billing and tenant, identity and
access, resource organisation, network, security, management, governance, and platform automation.

The network design area is large, so this repository records it in three ADRs: topology, IP addressing, segmentation, and Virtual Network
Manager (ADR-AZ-CAFNETTOP); connectivity, internet traffic, application delivery, Bastion, encryption, and traffic inspection
(ADR-AZ-CAFNETCON); and this record, private access to PaaS services and name resolution. It covers the recommendations of two CAF pages:
"Connectivity to Azure PaaS services" (items 62–67 of our import, rules 1–6 here) and "DNS for on-premises and Azure resources" (items
127–133 of our import, rules 7–13 here), numbered here in the import's order.

These rules are vendor recommendation, not principled theory: they record what one platform vendor advises for its own cloud, and what this
repository does about each item. CAF items carry no codes, so each rule's number is the item's order within this record. Each rule cites
Microsoft's page — the page title, the section, the link, and the retrieval date — and summarises the item in our words. The live CAF text
falls under the Microsoft Learn Terms of Use, which grant no right to copy it into a shared repository, so nothing here is quoted.

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

Two further CAF pages bear on this record without recommendations of their own: "Private Link and DNS integration at scale" and "Limit
cross-tenant private endpoint connections". They are read as context in the takeaways of rules 2 and 13. The examples are the three
templates the [landing-zones](../landing-zones.md) record describes: `foundation` (the Log Analytics workspace and the Key Vault of each
subscription), `discovery` (the landing zone: the hub or spoke network, its private DNS zones, policies, and budget), and `expedition` (the
workload: a storage account and a SQL database behind private endpoints).

### 1 — Virtual network injection for PaaS services

```text
CAF network — Connectivity to Azure PaaS services — recommendation 1 (import item 62)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (retrieved 2026-10-15)
Summary (ours): Inject a PaaS service into the virtual network when it must reach private resources, but keep its management-plane traffic
to the service's public addresses working, restricted with user-defined routes, network security groups, and service tags.
```

#### What 1 means here

Injection puts a service's own instances into a subnet, which only some services support (an App Service environment, a managed instance, a
container platform). The templates deploy none of them: Azure SQL Database and a StorageV2 account are not injected, and they reach no
private resource of their own. They are reached instead, through private endpoints (rule 2). A first injected service would need its own
delegated subnet in `network.yml` ([ADR-AZ-NETWORK#1](../azure-network-model.md#rule-adr-az-network1)) and the management-plane rules this
item names.

##### 1 status

**Not adopted**, because no template deploys a service that supports injection.

### 2 — Private Link for private-only access

```text
CAF network — Connectivity to Azure PaaS services — recommendation 2 (import item 63)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (retrieved 2026-10-15)
Summary (ours): Use Private Link where protection against data exfiltration and private-only addressing are firm requirements.
```

#### What 2 means here

Private-only access to data is the repository's default, not an exception. `storage-account.bicep` and `sql-server.bicep` default
`publicNetworkAccess` to `'Disabled'`, the storage network rules deny by default, and `private-endpoint.bicep` gives each service a private
endpoint with a DNS zone group that registers its address in the hub's zone ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4),
[ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6)). A private endpoint maps one resource, not a whole service, into the network, so a
workload that is breached can reach its own storage account and database, and nothing else of the service.

CAF's page on limiting cross-tenant private endpoint connections adds the other direction: an endpoint in our network that connects to a
resource in a foreign tenant is an exfiltration path, and CAF proposes deny policies against it. Here every private endpoint targets a
resource the same template deploys (`storage.outputs.id`, `sqlServer.outputs.id` in `expedition`), so a connection to a foreign resource is
a template change that review sees. No policy denies it in Azure.

##### 2 in `foundation`

The Key Vault and the Log Analytics workspace accept public network traffic. The vault's private endpoint (group id `vault`) and public
access off are planned by [ADR-AZ-CAFSEC#21](landing-zone-security.md#rule-adr-az-cafsec21) and ADR-AZ-WAFSE#6; that makes `foundation`
depend on a subnet of `discovery` and on a zone in the hub.

##### 2 in `discovery`

The hub deploys the zones the endpoints register in (rule 13) and the subnets they sit in: `private-endpoints` in every spoke and
`shared-services` in the hub. `privateEndpointNetworkPolicies` defaults to `Enabled` in `virtual-network.bicep`, so each subnet's network
security group applies to its private endpoints too.

##### 2 in `expedition`

Two private endpoints, `blob` on the storage account and `sqlServer` on the SQL server, in the subnet named by `privateEndpointSubnetName`:
the customer spoke's `private-endpoints`, or the hub's `shared-services` for the root expedition configs of the shared platform. Both
services keep public network access off.

##### 2 status

**Realised** for storage and SQL; the vault's private endpoint is planned (ADR-AZ-CAFSEC#21).

### 3 — Service endpoints where Private Link is not needed

```text
CAF network — Connectivity to Azure PaaS services — recommendation 3 (import item 64)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (retrieved 2026-10-15)
Summary (ours): Consider service endpoints where exfiltration is a lesser concern, where Private Link is not available, or for large
volumes of ingest, because service endpoints are free while Private Link is charged per gigabyte.
```

#### What 3 means here

A service endpoint lets a subnet reach a whole service over the backbone while the service keeps its public address; a private endpoint
gives one resource a private address. The repository uses private endpoints for every data service, so there is one way to reach data and
one DNS design behind it. The per-gigabyte charge is small at the workloads' volume, and the cost view of the endpoints belongs to
[waf-cost-optimization](../waf/cost-optimization.md) (ADR-AZ-WAFCO).

##### 3 in `foundation`

Not applicable: its vault and workspace are planned to take private endpoints, not service endpoints (ADR-AZ-CAFSEC#21).

##### 3 in `discovery`

No subnet carries a service endpoint (`virtual-network.bicep` has no field for one).

##### 3 in `expedition`

Private endpoints only, for both data services.

##### 3 status

**Not adopted**, because private endpoints serve every data service the templates deploy.

### 4 — PaaS access from on-premises

```text
CAF network — Connectivity to Azure PaaS services — recommendation 4 (import item 65)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (retrieved 2026-10-15)
Summary (ours): From on-premises, use a service's public endpoint when private access is not needed and the bandwidth suffices;
otherwise use ExpressRoute private peering or a site-to-site VPN, with injection or Private Link.
```

#### What 4 means here

The repository has no on-premises network and no gateway: the hub reserves `GatewaySubnet` and deploys nothing into it
([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)). Hybrid connectivity is decided by ADR-AZ-CAFNETCON. Once a gateway exists, an
on-premises client reaches the data services through the same private endpoints, which needs on-premises DNS to resolve the `privatelink`
zones (rules 8 and 10).

##### 4 status

**Not adopted**, because the repository has no on-premises connectivity.

### 5 — No service endpoints by default on every subnet

```text
CAF network — Connectivity to Azure PaaS services — recommendation 5 (import item 66)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (retrieved 2026-10-15)
Summary (ours): Enable service endpoints case by case, never on every subnet by default.
```

#### What 5 means here

`virtual-network.bicep` declares every subnet inline from `network.yml`, with a network security group, a route table, and the private
endpoint network policies, and no service endpoint. A subnet cannot receive one by default, because the module has no field for it; adding
one would be a module change, reviewed as such.

##### 5 in `foundation`

Not applicable: it deploys no network.

##### 5 in `discovery`

No hub or spoke subnet carries a service endpoint.

##### 5 in `expedition`

Not applicable: it creates no subnet ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)).

##### 5 status

**Realised.** No subnet carries a service endpoint.

### 6 — No forced tunnelling

```text
CAF network — Connectivity to Azure PaaS services — recommendation 6 (import item 67)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (retrieved 2026-10-15)
Summary (ours): Avoid forcing internet-bound traffic back to on-premises through a default route; it breaks the control-plane traffic
some PaaS services need, such as Application Gateway v2.
```

#### What 6 means here

Forced tunnelling advertises a default route from on-premises over a gateway. There is no gateway, and the spoke route table that
`route-table.bicep` deploys carries no routes, so internet-bound traffic takes Azure's default path. The planned egress through a firewall
in the hub's `AzureFirewallSubnet` ([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6)) stays inside Azure and is not forced
tunnelling; egress and inspection are decided by ADR-AZ-CAFNETCON.

##### 6 in `foundation`

Not applicable: it deploys no network.

##### 6 in `discovery`

Each spoke subnet takes the route table named by `routeTableName`, with no routes; `disableBgpRoutePropagation` keeps its default, which
matters only once a gateway learns routes.

##### 6 in `expedition`

Not applicable: it creates no route.

##### 6 status

**Realised.** No route sends internet traffic to on-premises.

### 7 — Private DNS zones for Azure-only resolution

```text
CAF network — DNS for on-premises and Azure resources — recommendation 7 (import item 127)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (retrieved 2026-10-15)
Summary (ours): Where resolution is needed only inside Azure, use Azure Private DNS zones, with a delegated zone for the organisation's
own names and automatic registration of virtual machine records.
```

#### What 7 means here

Resolution is Azure-only. No virtual network sets custom DNS servers, so every network uses Azure-provided DNS, which answers from the
private DNS zones linked to it. `private-dns-zone.bicep` deploys a zone with its links and `registrationEnabled` off by default, as the
`privatelink` zones require. The repository has no names of its own to resolve: its only private records are the private endpoints'.

##### 7 in `foundation`

Not applicable: it deploys no network and resolves nothing privately until its vault takes a private endpoint (rule 2).

##### 7 in `discovery`

The hub deploys `privatelink<sqlServerHostname suffix>` and `privatelink.blob.<storage suffix>`, built from `environment().suffixes`, so the
names fit the cloud the template deploys to. A custom DNS zone with automatic registration would need a virtual machine to register.

##### 7 in `expedition`

Its endpoints register in the hub's zones through their DNS zone groups; it adds no zone of its own.

##### 7 status

**Partly realised.** Azure-only resolution through the hub's `privatelink` zones; a custom DNS zone with automatic registration is not
adopted, because no template deploys a virtual machine.

### 8 — Hybrid resolution with DNS Private Resolver

```text
CAF network — DNS for on-premises and Azure resources — recommendation 8 (import item 128)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (retrieved 2026-10-15)
Summary (ours): Where names must resolve across Azure and on-premises, use DNS Private Resolver with Private DNS zones, which is cheaper,
highly available, and scalable compared with DNS on virtual machines; if Active Directory-integrated DNS stays, run it on at least two
virtual machines and point the virtual networks at them.
```

#### What 8 means here

Nothing on-premises resolves Azure names, and nothing in Azure resolves on-premises names. A DNS Private Resolver becomes the first DNS
resource to add once a gateway connects an on-premises network (ADR-AZ-CAFNETCON), and it goes in the hub (rule 11).

##### 8 status

**Not adopted**, because the repository has no on-premises network to resolve with.

### 9 — Azure Firewall as a DNS proxy

```text
CAF network — DNS for on-premises and Azure resources — recommendation 9 (import item 129)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (retrieved 2026-10-15)
Summary (ours): Where Azure Firewall exists, consider it as a DNS proxy.
```

#### What 9 means here

The hub reserves `AzureFirewallSubnet` and deploys nothing into it ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)). When a firewall
lands (ADR-AZ-CAFNETCON), the proxy lets its network rules filter by name, and the spokes would point their DNS at it; this item is
revisited with that change.

##### 9 status

**Not adopted**, because the hub deploys no firewall.

### 10 — Zone links and a forwarding ruleset

```text
CAF network — DNS for on-premises and Azure resources — recommendation 10 (import item 130)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (retrieved 2026-10-15)
Summary (ours): Link the private DNS zones to the virtual networks, and use a resolver forwarding ruleset so that Azure queries for
on-premises names go to on-premises DNS, while on-premises servers forward the Azure zones to the resolver's inbound endpoint.
```

#### What 10 means here

The link half is the landing zone's design: each zone in the hub is linked to the hub and to every spoke the hub lists
([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)), so a private endpoint resolves from any network of its tier. A link names an existing
network, so a new spoke is linked on the hub's second deploy ([ADR-AZ-LZ#7](../landing-zones.md#rule-adr-az-lz7)). The forwarding half needs
a resolver and an on-premises DNS service, and neither exists (rule 8).

##### 10 in `foundation`

Not applicable: it deploys no network.

##### 10 in `discovery`

`private-dns-zone.bicep` links each zone to the hub's network and to every entry of `spokes`, one link per network named after it.

##### 10 in `expedition`

Not applicable: it uses the zones and links nothing.

##### 10 status

**Partly realised.** Every zone is linked to the hub and to every listed spoke; a forwarding ruleset is not adopted, because no on-premises
name needs forwarding.

### 11 — Dedicated resolver subnets in the hub

```text
CAF network — DNS for on-premises and Azure resources — recommendation 11 (import item 131)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (retrieved 2026-10-15)
Summary (ours): Give DNS Private Resolver two dedicated subnets in the connectivity hub, one inbound and one outbound, each at least a /28,
with up to five endpoints each and rulesets for the on-premises namespaces; where it sits beside the ExpressRoute gateway, make sure
public names still resolve.
```

#### What 11 means here

No resolver is deployed (rule 8). Each hub's `/16` in `network.yml` uses a few small ranges for `GatewaySubnet`, `AzureFirewallSubnet`, and
`shared-services`, so the two resolver subnets fit without renumbering, and the network plan's overlap check
([ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)) proves them when they are added. The hub's subnets are decided by
ADR-AZ-CAFNETTOP.

##### 11 status

**Not adopted**, because no resolver is deployed.

### 12 — Workloads that bring their own DNS

```text
CAF network — DNS for on-premises and Azure resources — recommendation 12 (import item 132)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (retrieved 2026-10-15)
Summary (ours): A workload that requires and deploys its own DNS, such as Red Hat OpenShift, keeps it.
```

#### What 12 means here

`expedition` resolves its endpoints through the hub's zones and deploys no DNS service. A workload that brings its own would set custom DNS
servers on its subnet's network, which `virtual-network.bicep` does not offer; it would be a module and `discovery` change.

##### 12 status

**Not adopted**, because no workload runs a DNS service of its own.

### 13 — Private DNS zones in the connectivity subscription

```text
CAF network — DNS for on-premises and Azure resources — recommendation 13 (import item 133)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (retrieved 2026-10-15)
Summary (ours): Host the Private DNS zones, including the privatelink zones of private endpoints such as the blob zone, in a global
connectivity subscription.
```

#### What 13 means here

The connectivity subscription of CAF is the hub here: each tier's shared subscription holds a hub, and the hub holds the private DNS zones
([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2), [ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)). There are two
sets, one per tier, not one global set, so non-production and production records never share a zone, and a broken non-production DNS zone
cannot stop production resolution.

CAF's page on Private Link and DNS integration at scale describes the same central DNS zones, kept central by policy: deny public network
access, deny a `privatelink` zone created anywhere but the connectivity subscription, and deploy-if-not-exists policies that write each
endpoint's record into the central DNS zone through a remediation identity holding Private DNS Zone Contributor. The repository reaches the
same end by template. The modules turn public access off by default; `expedition` creates no zone and looks up the hub's zones as `existing`
resources ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)); and `private-endpoint.bicep` registers each endpoint through its DNS zone
group in the same deploy. A record written by the template exists when the deploy succeeds, and a missing DNS zone fails the deploy with its
name; a remediation task writes it later, needs an identity with rights in the hub, and reports after the fact. This is the argument of
[ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3) for the activity log, applied to DNS records.

##### 13 in `foundation`

Not applicable until its vault takes a private endpoint; the hub then hosts `privatelink.vaultcore.azure.net` beside the two zones
(ADR-AZ-CAFSEC#21).

##### 13 in `discovery`

A hub (`networkKind: hub`) deploys `privatelink<sqlServerHostname suffix>` and `privatelink.blob.<storage suffix>` in its resource group and
outputs their ids; a spoke deploys none. No `privatelink.vaultcore` zone exists.

##### 13 in `expedition`

Reads the hub's subscription by config address (`privateDnsZoneSubscriptionId`) and its resource group (`privateDnsZoneResourceGroupName`),
and registers both endpoints in the zones there.

##### 13 status

**Partly realised.** The zones are central in the hub of each tier, one set per tier rather than one global set, and records are written by
template rather than by policy.

## Decision

The repository adopts the CAF recommendations on private access and DNS as a review list for `discovery` and `expedition`, item by item, and
records for each what it does, what it plans, and what it does not adopt and why. Data services are reached only through private endpoints,
with public network access off; the `privatelink` zones live once per tier, in the hub, linked to the hub and every spoke it lists; and
every record is written by the template that deploys the endpoint, never by a deploy-if-not-exists policy. Recommendations that need
on-premises connectivity, a firewall, a resolver, or a virtual machine are not adopted, because the repository deploys none of them; the
network topology and connectivity records (ADR-AZ-CAFNETTOP, ADR-AZ-CAFNETCON) decide when those arrive.

### How this is enforced

- `storage-account.bicep` and `sql-server.bicep` default `publicNetworkAccess` to `'Disabled'`, and `virtual-network.bicep` offers no
  service endpoint or custom DNS server field (rules 2, 3, 5, 12).
- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `discovery` and `expedition`, so a template or config that does
  not compile, or a config address that does not resolve, fails the build ([landing-zones](../landing-zones.md)).
- `expedition` reads the hub's zones and its subnet as `existing` resources, so a deploy against a missing DNS zone or subnet fails, naming
  it.
- In Azure, the landing zone's policy against public IP addresses on network interfaces audits or denies by `policy_enforcement`
  ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).
- **Planned (follow-up):** the quality gate over the compiled templates of ADR-AZ-WAFSE, which fails a resource with public network access;
  and the vault's private endpoint with its `privatelink.vaultcore.azure.net` zone (ADR-AZ-CAFSEC#21). These are plans, not checks that run.

## Consequences

- One way of reaching data — a private endpoint and a record in the hub's zone — serves every workload, so a new workload needs no network
  or DNS work of its own.
- Every spoke depends on its hub's zones for resolving its own data services; the hub of each tier is a shared dependency of every spoke in
  that tier.
- Records written by template are exact at deploy time and need no remediation identity, at the cost of no guard in Azure against a workload
  that creates its own `privatelink` zone outside a template; review and the planned quality gate over the compiled templates carry that
  guard.
- Every on-premises and firewall DNS item waits for a gateway or a firewall; the hub reserves their subnets and its address space leaves
  room for a resolver.
- Each item cites Microsoft's page and a retrieval date; when the vendor guidance changes, the summary and the takeaways are revisited
  together.
