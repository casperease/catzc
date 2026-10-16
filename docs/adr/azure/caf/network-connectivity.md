---
catzc:
  derived:
    path: docs/adr/azure/caf/network-connectivity.md
    folder: docs/adr/azure/caf
    name: network-connectivity
    filetype: md
    kind: adr
    language: markdown
    track: docs
    body_sha: "1bb977ab38e6"
    defines:
      - ADR-AZ-CAFNETCON#{1-62}
    adrs:
      - ADR-AZ-CAFSEC#{41,42}
      - ADR-AZ-DATAMOD#11
      - ADR-AZ-LZ#{1-6}
      - ADR-AZ-NETWORK#{1,5,6}
      - ADR-AZ-WAFSE#{4-10}
    links:
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network1
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network5
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network6
      - docs/adr/azure/caf/landing-zone-security.md
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec41
      - docs/adr/azure/caf/landing-zone-security.md#rule-adr-az-cafsec42
      - docs/adr/azure/caf/network-private-access.md
      - docs/adr/azure/caf/network-topology.md
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz1
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz2
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz3
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz4
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz5
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz6
      - docs/adr/azure/waf/security.md
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse10
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse4
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse5
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse6
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse7
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse8
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse9
      - docs/references/caf/index.md
---

# ADR: CAF network connectivity — what the repository does about each recommendation on reaching, leaving, and protecting its networks

Pairs with [`landing-zones`](../landing-zones.md) (the hub-and-spoke network these recommendations apply to),
[`waf-security`](../waf/security.md) (the workload view of network isolation and encryption; its rules are cited here, not repeated), and
[`caf-security`](landing-zone-security.md) (the landing-zone security design area).

## Rules: ADR-AZ-CAFNETCON

### Rule ADR-AZ-CAFNETCON:1

Not adopted, because the repository connects no on-premises site; the hub reserves `GatewaySubnet` so a gateway can be added without
renumbering.

- [1 — Make ExpressRoute the primary link with VPN as backup](#1--make-expressroute-the-primary-link-with-vpn-as-backup)

### Rule ADR-AZ-CAFNETCON:2

Not adopted, because there is no ExpressRoute circuit.

- [2 — Use two ExpressRoute circuits from different peering locations](#2--use-two-expressroute-circuits-from-different-peering-locations)

### Rule ADR-AZ-CAFNETCON:3

Not adopted, because there is no ExpressRoute circuit to route across.

- [3 — Steer routing across several circuits](#3--steer-routing-across-several-circuits)

### Rule ADR-AZ-CAFNETCON:4

Not adopted, because no ExpressRoute or VPN gateway is deployed.

- [4 — Size the gateway SKU to the bandwidth](#4--size-the-gateway-sku-to-the-bandwidth)

### Rule ADR-AZ-CAFNETCON:5

Not adopted, because no ExpressRoute gateway is deployed.

- [5 — Deploy a zone-redundant ExpressRoute gateway](#5--deploy-a-zone-redundant-expressroute-gateway)

### Rule ADR-AZ-CAFNETCON:6

Not adopted, because there is no ExpressRoute connection of any bandwidth.

- [6 — Use ExpressRoute Direct above 10 Gbps](#6--use-expressroute-direct-above-10-gbps)

### Rule ADR-AZ-CAFNETCON:7

Not adopted, because no ExpressRoute gateway sits in any data path.

- [7 — Use FastPath for low latency](#7--use-fastpath-for-low-latency)

### Rule ADR-AZ-CAFNETCON:8

Not adopted, because no branch or remote site connects to the networks.

- [8 — Connect branches through zone-redundant VPN gateways](#8--connect-branches-through-zone-redundant-vpn-gateways)

### Rule ADR-AZ-CAFNETCON:9

Not adopted, because no site uses ExpressRoute.

- [9 — Link large sites through ExpressRoute Global Reach](#9--link-large-sites-through-expressroute-global-reach)

### Rule ADR-AZ-CAFNETCON:10

Not adopted, because there is no circuit to separate; the production and non-production hubs would each take their own.

- [10 — Separate circuits where isolation is required](#10--separate-circuits-where-isolation-is-required)

### Rule ADR-AZ-CAFNETCON:11

Not adopted, because there is no ExpressRoute connection or on-premises site to monitor.

- [11 — Monitor ExpressRoute with network insights](#11--monitor-expressroute-with-network-insights)

### Rule ADR-AZ-CAFNETCON:12

Not adopted, because there is no ExpressRoute circuit (the concern is the one of rule 2).

- [12 — Avoid a single peering location](#12--avoid-a-single-peering-location)

### Rule ADR-AZ-CAFNETCON:13

Not adopted, because no workload is reached from the internet; the first ingress gateway belongs to the workload template in its spoke.

- [13 — Deliver applications from their own landing zone](#13--deliver-applications-from-their-own-landing-zone)

### Rule ADR-AZ-CAFNETCON:14

Not adopted, because no workload serves HTTP traffic to the internet.

- [14 — Use Application Gateway v2 with a web application firewall](#14--use-application-gateway-v2-with-a-web-application-firewall)

### Rule ADR-AZ-CAFNETCON:15

Not adopted, because there is no inbound web traffic to put an appliance in front of.

- [15 — Fall back to a partner appliance only when needed](#15--fall-back-to-a-partner-appliance-only-when-needed)

### Rule ADR-AZ-CAFNETCON:16

Not adopted, because no inbound gateway exists (the placement is the one of rule 13).

- [16 — Place inbound gateways in the landing-zone network](#16--place-inbound-gateways-in-the-landing-zone-network)

### Rule ADR-AZ-CAFNETCON:17

Not adopted, because no template deploys a public IP address; the landing zone's policy keeps them off network interfaces, and the unused
`vm.bicep`, which creates one, is planned to lose it.

- [17 — Cover every public IP address with DDoS Protection](#17--cover-every-public-ip-address-with-ddos-protection)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFNETCON:18

Not adopted, because no workload is global or reached from the internet.

- [18 — Use Front Door with a web application firewall for global applications](#18--use-front-door-with-a-web-application-firewall-for-global-applications)

### Rule ADR-AZ-CAFNETCON:19

Not adopted, because Front Door is not used.

- [19 — Review global routing redundancy before relying on Front Door](#19--review-global-routing-redundancy-before-relying-on-front-door)

### Rule ADR-AZ-CAFNETCON:20

Not adopted, because neither Front Door nor Application Gateway is used.

- [20 — Combine Front Door and Application Gateway with the firewall at Front Door](#20--combine-front-door-and-application-gateway-with-the-firewall-at-front-door)

### Rule ADR-AZ-CAFNETCON:21

Not adopted, because no workload is global.

- [21 — Use Traffic Manager for global non-HTTP applications](#21--use-traffic-manager-for-global-non-http-applications)

### Rule ADR-AZ-CAFNETCON:22

Not adopted, because the planned egress path of every spoke is the hub firewall of rule 23, and no workload subnet hosts compute that
reaches the internet.

- [22 — Use NAT Gateway for direct outbound traffic](#22--use-nat-gateway-for-direct-outbound-traffic)

### Rule ADR-AZ-CAFNETCON:23

Planned: the hub reserves `AzureFirewallSubnet` and deploys nothing into it, so egress is unfiltered; a firewall there with spoke routes to
it is the follow-up ADR-AZ-WAFSE#6 plans.

- [23 — Govern outbound and east-west traffic with Azure Firewall](#23--govern-outbound-and-east-west-traffic-with-azure-firewall)

### Rule ADR-AZ-CAFNETCON:24

Planned with rule 23: the hub reserves no `AzureFirewallManagementSubnet`, so the firewall follow-up adds it to the hub's subnet set in
`network.yml` and to ADR-AZ-NETWORK#5.

- [24 — Deploy Azure Firewall with its management NIC](#24--deploy-azure-firewall-with-its-management-nic)

### Rule ADR-AZ-CAFNETCON:25

Not adopted, because no firewall is deployed; the follow-up of rule 23 picks the firewall SKU.

- [25 — Use Azure Firewall Premium for advanced inspection](#25--use-azure-firewall-premium-for-advanced-inspection)

### Rule ADR-AZ-CAFNETCON:26

Not adopted, because no firewall is deployed, and one firewall per hub is declared in a template, not managed centrally.

- [26 — Manage firewalls through Firewall Manager](#26--manage-firewalls-through-firewall-manager)

### Rule ADR-AZ-CAFNETCON:27

Not adopted, because no firewall rule exists; `network.yml` is the one home of every range a rule would name.

- [27 — Reuse address sets through IP Groups](#27--reuse-address-sets-through-ip-groups)

### Rule ADR-AZ-CAFNETCON:28

Not adopted, because the spoke route tables carry no routes and platform services are reached through private endpoints, not routed to their
public addresses.

- [28 — Use service tags in routes toward platform services](#28--use-service-tags-in-routes-toward-platform-services)

### Rule ADR-AZ-CAFNETCON:29

Not adopted, because no firewall is deployed to take a policy.

- [29 — Set a global firewall policy as the baseline](#29--set-a-global-firewall-policy-as-the-baseline)

### Rule ADR-AZ-CAFNETCON:30

Not adopted, because there is no firewall policy, and every landing zone deploys to one region.

- [30 — Delegate regional child policies](#30--delegate-regional-child-policies)

### Rule ADR-AZ-CAFNETCON:31

Not adopted, because no workload takes inbound web traffic (the placement is the one of rule 13).

- [31 — Protect inbound web traffic inside the landing-zone network](#31--protect-inbound-web-traffic-inside-the-landing-zone-network)

### Rule ADR-AZ-CAFNETCON:32

Not adopted, because no workload is global or reached from the internet (the same item as rule 18).

- [32 — Protect global inbound web traffic with Front Door](#32--protect-global-inbound-web-traffic-with-front-door)

### Rule ADR-AZ-CAFNETCON:33

Not adopted, because neither Front Door nor Application Gateway is used (the same item as rule 20).

- [33 — Restrict Application Gateway to Front Door traffic](#33--restrict-application-gateway-to-front-door-traffic)

### Rule ADR-AZ-CAFNETCON:34

Not adopted, because no inbound appliance exists (the placement is the one of rule 13).

- [34 — Keep inbound partner appliances beside their applications](#34--keep-inbound-partner-appliances-beside-their-applications)

### Rule ADR-AZ-CAFNETCON:35

Planned: no subnet hosts compute that uses Azure's default outbound access, and turning it off on every subnet becomes a secure default of
`virtual-network.bicep`.

- [35 — Do not rely on default outbound access](#35--do-not-rely-on-default-outbound-access)

### Rule ADR-AZ-CAFNETCON:36

Not adopted, because every landing zone is connected: each spoke peers to the hub of its tier (ADR-AZ-LZ#2).

- [36 — Use NAT Gateway in online landing zones](#36--use-nat-gateway-in-online-landing-zones)

### Rule ADR-AZ-CAFNETCON:37

Not adopted, because there is no firewall or Firewall Manager to integrate a provider with.

- [37 — Integrate SaaS security providers through Firewall Manager](#37--integrate-saas-security-providers-through-firewall-manager)

### Rule ADR-AZ-CAFNETCON:38

Not adopted, because the planned filtering device is Azure Firewall in the hub (rule 23), not a partner appliance.

- [38 — Place partner appliances for east-west and north-south traffic](#38--place-partner-appliances-for-east-west-and-north-south-traffic)

### Rule ADR-AZ-CAFNETCON:39

Partly realised: every workload subnet denies inbound internet traffic and the landing zone's policy keeps public IP addresses off network
interfaces, but the unused `vm.bicep` creates one and is planned to lose it.

- [39 — Expose no virtual machine management port to the internet](#39--expose-no-virtual-machine-management-port-to-the-internet)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFNETCON:40

Not adopted, because no network holds a public endpoint (the same item as rule 17).

- [40 — Protect public endpoints with DDoS Protection plans](#40--protect-public-endpoints-with-ddos-protection-plans)

### Rule ADR-AZ-CAFNETCON:41

Realised: the landing zone has no perimeter network; each workload subnet carries its own network security group and data is reached through
private endpoints.

- [41 — Do not copy an on-premises perimeter into Azure](#41--do-not-copy-an-on-premises-perimeter-into-azure)

### Rule ADR-AZ-CAFNETCON:42

Not adopted, because no template deploys a virtual machine, so there is nothing for Bastion to reach.

- [42 — Use the Standard or Premium Bastion SKU in production](#42--use-the-standard-or-premium-bastion-sku-in-production)

### Rule ADR-AZ-CAFNETCON:43

Not adopted, because there is neither a virtual machine nor private connectivity from on-premises.

- [43 — Reach virtual machines over existing private connectivity](#43--reach-virtual-machines-over-existing-private-connectivity)

### Rule ADR-AZ-CAFNETCON:44

Not adopted, because the topology is a traditional hub and spoke, not Virtual WAN.

- [44 — Place Bastion in a Virtual WAN topology](#44--place-bastion-in-a-virtual-wan-topology)

### Rule ADR-AZ-CAFNETCON:45

Not adopted, because no template deploys a virtual machine; a hub Bastion would need an `AzureBastionSubnet` the hub does not reserve.

- [45 — Place Bastion in a hub-and-spoke topology](#45--place-bastion-in-a-hub-and-spoke-topology)

### Rule ADR-AZ-CAFNETCON:46

Not adopted, because no Bastion is deployed.

- [46 — Protect Bastion with network security group rules](#46--protect-bastion-with-network-security-group-rules)

### Rule ADR-AZ-CAFNETCON:47

Not adopted, because no Bastion is deployed; its diagnostics would follow every other resource's to `foundation`'s workspace.

- [47 — Send Bastion diagnostics to the central workspace](#47--send-bastion-diagnostics-to-the-central-workspace)

### Rule ADR-AZ-CAFNETCON:48

Not adopted, because no Bastion is deployed and the templates grant no role to people.

- [48 — Grant the roles Bastion needs](#48--grant-the-roles-bastion-needs)

### Rule ADR-AZ-CAFNETCON:49

Not adopted, because no Linux virtual machine is deployed.

- [49 — Keep SSH keys for Bastion in Key Vault](#49--keep-ssh-keys-for-bastion-in-key-vault)

### Rule ADR-AZ-CAFNETCON:50

Not adopted, because there is neither a Bastion nor private connectivity to keep beside it.

- [50 — Keep Bastion beside private connectivity for special cases](#50--keep-bastion-beside-private-connectivity-for-special-cases)

### Rule ADR-AZ-CAFNETCON:51

Partly realised, as rule 39: no template gives a virtual machine a public IP address, but the unused `vm.bicep` does.

- [51 — Allow no remote access to virtual machines over public IP addresses](#51--allow-no-remote-access-to-virtual-machines-over-public-ip-addresses)

### Rule ADR-AZ-CAFNETCON:52

Not adopted, because no VPN connection exists.

- [52 — Rely on IPsec for VPN connections](#52--rely-on-ipsec-for-vpn-connections)

### Rule ADR-AZ-CAFNETCON:53

Not adopted, because no traffic flows between virtual machines; every flow to data is encrypted by TLS 1.2 at minimum (ADR-AZ-WAFSE#7).

- [53 — Encrypt traffic between virtual machines](#53--encrypt-traffic-between-virtual-machines)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFNETCON:54

Not adopted, because there is no ExpressRoute Direct port.

- [54 — Encrypt ExpressRoute Direct with MACsec](#54--encrypt-expressroute-direct-with-macsec)

### Rule ADR-AZ-CAFNETCON:55

Not adopted, because there is neither Virtual WAN nor ExpressRoute.

- [55 — Run IPsec over ExpressRoute in Virtual WAN](#55--run-ipsec-over-expressroute-in-virtual-wan)

### Rule ADR-AZ-CAFNETCON:56

Not adopted, because there is no ExpressRoute connection to encrypt.

- [56 — Choose an encryption option over ExpressRoute outside Virtual WAN](#56--choose-an-encryption-option-over-expressroute-outside-virtual-wan)

### Rule ADR-AZ-CAFNETCON:57

Not adopted, because there is no private connection to encrypt.

- [57 — Fall back to partner appliances for encryption](#57--fall-back-to-partner-appliances-for-encryption)

### Rule ADR-AZ-CAFNETCON:58

Planned: the network security groups and the virtual networks send their diagnostics to `foundation`'s workspace, but no flow log is
recorded; virtual network flow logs are the follow-up ADR-AZ-WAFSE#6 plans.

- [58 — Use virtual network flow logs](#58--use-virtual-network-flow-logs)

### Rule ADR-AZ-CAFNETCON:59

Planned with rule 58: traffic analytics over the flow logs, in `foundation`'s workspace.

- [59 — Enable traffic analytics](#59--enable-traffic-analytics)

### Rule ADR-AZ-CAFNETCON:60

Not adopted, because traffic analytics is planned, not deployed, so it cannot fall short; a partner solution is weighed only after rule 59.

- [60 — Add a partner solution when traffic analytics falls short](#60--add-a-partner-solution-when-traffic-analytics-falls-short)

### Rule ADR-AZ-CAFNETCON:61

Not adopted, because packet capture runs on virtual machines and no template deploys one.

- [61 — Run packet captures regularly](#61--run-packet-captures-regularly)

### Rule ADR-AZ-CAFNETCON:62

Realised: the repository builds no traffic mirroring of its own.

- [62 — Build no custom traffic mirroring](#62--build-no-custom-traffic-mirroring)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation: strategy, planning, readiness,
governance, and operations. Its landing-zone guidance splits the platform an organisation builds into design areas, each with considerations
to weigh and design recommendations; the landing zone a subscription receives here is CAF's application landing zone
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)).

The network topology and connectivity design area is the largest of them, so the repository records it in three ADRs. This one covers how
traffic reaches and leaves the networks and how it is protected on the way: connectivity to Azure from other sites, inbound and outbound
internet traffic, application delivery, remote access to virtual machines through Bastion, network encryption, and traffic inspection. The
topology, the IP addressing, segmentation, and Virtual Network Manager are in [network-topology](network-topology.md); connectivity to
platform services and DNS are in [network-private-access](network-private-access.md). The network itself is a hub and spoke per
subscription, one hub per tier of shared subscriptions and one spoke per customer subscription
([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)), with its ranges in `network.yml`.

These rules are vendor recommendation, not principled theory. They do not argue from first principles the way the axioms and DORA's research
do; they record what the repository does about each of Microsoft's recommendations. Each rule cites Microsoft's page — area, page, link,
retrieval date — and summarises it in our own words, because the live CAF text is published under the Microsoft Learn Terms of Use, which
grant no licence to copy it into a shared repository. Nothing is quoted.

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

The rules are numbered 1 to 62 in the order of our import of the design area, which numbers its recommendations across every sub-page. They
cover import items 50–61 (connectivity to Azure, rules 1–12), 68–76 (application delivery, rules 13–21), 77–96 (inbound and outbound
internet connectivity, rules 22–41), 106–115 (Bastion, rules 42–51), 116–121 (network encryption, rules 52–57), and 122–126 (traffic
inspection, rules 58–62). The pages on connectivity to other cloud providers and to Oracle Cloud Infrastructure are written as numbered
guidance with no recommendations section, so they carry no rule here. They would apply once a workload exchanged traffic with another cloud;
the repository connects none, and such a link would land at the hub's `GatewaySubnet` like any other site-to-site connection.

Much of the area assumes things the repository does not have: an on-premises network, an ExpressRoute or VPN gateway, a hub firewall, a
virtual machine, or a workload reached from the internet. Those recommendations take the compact form — the citation, why the item does not
apply, what would make it apply, and the status — so each stays its own rule without a per-template account of nothing. The full form is
kept for the items that bear on a template, a module, a config, or a check.

The example basis is the repository's three templates: `foundation` (a Log Analytics workspace and a Key Vault per subscription),
`discovery` (the landing zone, with the network), and `expedition` (a workload that lands in it,
[ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)). Every takeaway below points at what those three do, or says plainly what they do not.

### 1 — Make ExpressRoute the primary link with VPN as backup

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 1
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Connect on-premises networks to Azure through ExpressRoute first, and keep a VPN connection as the backup path.
```

#### What 1 means here

The repository connects no on-premises site: workloads reach their data through private endpoints inside Azure, and the people who operate
them work through Azure Resource Manager. The hub reserves `GatewaySubnet` in `network.yml` and deploys nothing into it
([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)), and `vnet-peering.bicep` exposes gateway transit for both sides, so a
gateway in each hub could serve its spokes without renumbering. A customer that needs a link from its own sites makes this rule and the
eleven after it apply.

##### 1 status

Not adopted, because the repository connects no on-premises site.

### 2 — Use two ExpressRoute circuits from different peering locations

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 2
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Use two ExpressRoute circuits from two different peering locations, so no single location is a point of failure.
```

#### What 2 means here

There is no ExpressRoute circuit (see [1](#1--make-expressroute-the-primary-link-with-vpn-as-backup)). With one, the two circuits would
connect to the hub's gateway, and the circuits themselves would be the tenant's or the connectivity provider's, not a template's.

##### 2 status

Not adopted, because there is no ExpressRoute circuit.

### 3 — Steer routing across several circuits

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 3
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): With several ExpressRoute circuits, choose the preferred paths with BGP local preference and AS-path prepending.
```

#### What 3 means here

Routing across circuits is configured on the customer's edge routers and the circuits, neither of which the repository holds. It would apply
only with two or more circuits (see [2](#2--use-two-expressroute-circuits-from-different-peering-locations)).

##### 3 status

Not adopted, because there is no ExpressRoute circuit to route across.

### 4 — Size the gateway SKU to the bandwidth

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 4
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Choose the ExpressRoute or VPN gateway SKU that matches the bandwidth and performance the connection needs.
```

#### What 4 means here

No gateway is deployed. A gateway module would take its SKU as a config value per hub, the way `expedition` takes its database SKU per
environment class, so the production hub can be sized apart from the non-production one.

##### 4 status

Not adopted, because no ExpressRoute or VPN gateway is deployed.

### 5 — Deploy a zone-redundant ExpressRoute gateway

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 5
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Deploy the ExpressRoute gateway zone-redundant in regions that offer availability zones.
```

#### What 5 means here

No gateway is deployed. Zone redundancy is the repository's default for the resources it does deploy (zone-redundant storage, and a
zone-redundant database in production, [ADR-AZ-LZ#5](../landing-zones.md#rule-adr-az-lz5)), so a gateway module would take a zone-redundant
SKU by default.

##### 5 status

Not adopted, because no ExpressRoute gateway is deployed.

### 6 — Use ExpressRoute Direct above 10 Gbps

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 6
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Use ExpressRoute Direct when a connection needs more than 10 Gbps or dedicated 10 or 100 Gbps ports.
```

#### What 6 means here

The workloads move data between services inside one region, through private endpoints; no traffic crosses to another site at any bandwidth.

##### 6 status

Not adopted, because there is no ExpressRoute connection of any bandwidth.

### 7 — Use FastPath for low latency

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 7
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Enable FastPath so traffic bypasses the ExpressRoute gateway when low latency or more than 10 Gbps is needed.
```

#### What 7 means here

FastPath takes the gateway out of the data path between a site and virtual machines; there is neither a gateway nor a virtual machine here.

##### 7 status

Not adopted, because no ExpressRoute gateway sits in any data path.

### 8 — Connect branches through zone-redundant VPN gateways

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 8
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Connect branches and remote sites through VPN gateways, zone-redundant for resilience, since the SKUs without
  availability-zone support are being retired.
```

#### What 8 means here

No branch connects to the networks. A VPN gateway would sit in the hub's reserved `GatewaySubnet`; a zone-redundant SKU follows from the
same default as [5](#5--deploy-a-zone-redundant-expressroute-gateway).

##### 8 status

Not adopted, because no branch or remote site connects to the networks.

### 9 — Link large sites through ExpressRoute Global Reach

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 9
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Connect large offices and data centres that each use ExpressRoute to one another through Global Reach.
```

#### What 9 means here

Global Reach joins a customer's own sites through Microsoft's backbone; it concerns the customer's network, not the landing zone, and no
site here uses ExpressRoute.

##### 9 status

Not adopted, because no site uses ExpressRoute.

### 10 — Separate circuits where isolation is required

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 10
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Use separate ExpressRoute circuits, for example for production and non-production, when traffic must be isolated or
  needs dedicated bandwidth.
```

#### What 10 means here

There is no circuit. The network is split the way the recommendation assumes: production and non-production subscriptions have their own
hubs (`shared_prod` and `shared_nonprod` in `network.yml`), and no spoke peers across tiers
([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)). A connection per hub would therefore isolate the tiers with no further design.

##### 10 status

Not adopted, because there is no circuit to separate.

### 11 — Monitor ExpressRoute with network insights

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 11
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Watch ExpressRoute peerings, connections, and gateways with network insights, and measure the paths between Azure
  and on-premises sites with Connection Monitor.
```

#### What 11 means here

There is nothing to monitor. A gateway would send its diagnostics to `foundation`'s workspace like every other network resource, through a
new kind in `diagnostic-setting.bicep`.

##### 11 status

Not adopted, because there is no ExpressRoute connection or on-premises site to monitor.

### 12 — Avoid a single peering location

```text
CAF network topology and connectivity — Connectivity to Azure — recommendation 12
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (retrieved 2026-10-15)
Summary (ours): Do not rely on ExpressRoute circuits from a single peering location, which is a single point of failure.
```

#### What 12 means here

The page states the advice of [2](#2--use-two-expressroute-circuits-from-different-peering-locations) as a prohibition; it applies when that
one does.

##### 12 status

Not adopted, because there is no ExpressRoute circuit.

### 13 — Deliver applications from their own landing zone

```text
CAF network topology and connectivity — Plan for application delivery — recommendation 13
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (retrieved 2026-10-15)
Summary (ours): Deliver internal and external applications from the landing zone of the application: an Application Gateway is part
  of the application in its spoke, not a shared hub service, because tuning its firewall alerts needs knowledge of the application,
  and a shared instance mixes teams' configuration and reaches its limits.
```

#### What 13 means here

No workload is reached from the internet: `expedition`'s storage account and SQL server have public network access off and are reached only
through private endpoints ([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6)). The recommendation's placement agrees with how the
repository divides work: a workload lands in its landing zone and owns its own resources, and the landing zone owns only the shared network
([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)). So the first ingress gateway would be a resource of the workload template, in a subnet
of its customer's spoke, and the hub would stay free of application components.

##### 13 status

Not adopted, because no workload is reached from the internet.

### 14 — Use Application Gateway v2 with a web application firewall

```text
CAF network topology and connectivity — Plan for application delivery — recommendation 14
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (retrieved 2026-10-15)
Summary (ours): Deliver HTTP and HTTPS applications through Application Gateway v2 with web application firewall policies turned on.
```

#### What 14 means here

No workload serves web traffic to the internet, so there is no web application firewall either; ADR-AZ-WAFSE#6 and
[ADR-AZ-CAFSEC#41](landing-zone-security.md#rule-adr-az-cafsec41) reach the same conclusion. The first web workload would add a gateway
module with its firewall policy on by default, placed as [13](#13--deliver-applications-from-their-own-landing-zone) says.

##### 14 status

Not adopted, because no workload serves HTTP traffic to the internet.

### 15 — Fall back to a partner appliance only when needed

```text
CAF network topology and connectivity — Plan for application delivery — recommendation 15
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (retrieved 2026-10-15)
Summary (ours): Use a partner network virtual appliance for inbound web traffic only when Application Gateway v2 cannot be used.
```

#### What 15 means here

There is no inbound web traffic, so neither the native gateway nor an appliance is in play. The repository prefers the platform's own
services over third-party appliances for the same reason it prefers built-in policies: Microsoft maintains them.

##### 15 status

Not adopted, because there is no inbound web traffic to put an appliance in front of.

### 16 — Place inbound gateways in the landing-zone network

```text
CAF network topology and connectivity — Plan for application delivery — recommendation 16
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (retrieved 2026-10-15)
Summary (ours): Deploy the Application Gateway v2 or partner appliance for inbound web traffic inside the landing-zone virtual
  network, beside the applications it protects.
```

#### What 16 means here

The same placement as [13](#13--deliver-applications-from-their-own-landing-zone): a customer's spoke, not the hub. A gateway needs a subnet
of its own, which the spoke's subnet map in `network.yml` would gain.

##### 16 status

Not adopted, because no inbound gateway exists.

### 17 — Cover every public IP address with DDoS Protection

```text
CAF network topology and connectivity — Plan for application delivery — recommendation 17
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (retrieved 2026-10-15)
Summary (ours): Protect every public IP address in a landing zone with a DDoS Protection plan.
```

#### What 17 means here

No template deploys a public IP address, so there is nothing for a DDoS Protection plan to cover. The landing zone keeps it that way: it
assigns the built-in policy against public IP addresses on network interfaces, which denies one where `policy_enforcement` enforces
(production, by default) and reports it where it audits ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3),
[ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)).

One module contradicts the posture: `infrastructure/modules/vm.bicep` creates a Basic-SKU dynamic public IP address and attaches it to the
virtual machine's network interface. No template uses the module; its hardening is planned under
[ADR-AZ-WAFSE#8](../waf/security.md#rule-adr-az-wafse8), and the follow-up here is the same: the module takes no public IP address. A plan
becomes relevant with the first public endpoint, and it would be bought once for the tenant rather than per landing zone, since a plan
covers many virtual networks.

##### 17 in `foundation`

Not applicable: its workspace and Key Vault are platform services with no public IP address resource.

##### 17 in `discovery`

Deploys no public IP address, and its no-public-IP assignment (for example `psub-weu-zct-disco-pip-pa`) guards the networks it builds.

##### 17 in `expedition`

Deploys no public IP address; its storage account and SQL server are reached through private endpoints only.

##### 17 status

Not adopted, because no template deploys a public IP address; removing the public IP address from `vm.bicep` is planned (follow-up).

### 18 — Use Front Door with a web application firewall for global applications

```text
CAF network topology and connectivity — Plan for application delivery — recommendation 18
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (retrieved 2026-10-15)
Summary (ours): Deliver global HTTP and HTTPS applications that span regions through Azure Front Door with web application firewall
  policies.
```

#### What 18 means here

Every landing zone and workload deploys to one region, and no workload is reached from the internet. A workload that served users in several
regions would make this apply, with Front Door as a resource of that workload, not of the landing zone.

##### 18 status

Not adopted, because no workload is global or reached from the internet.

### 19 — Review global routing redundancy before relying on Front Door

```text
CAF network topology and connectivity — Plan for application delivery — recommendation 19
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (retrieved 2026-10-15)
Summary (ours): Read Microsoft's guidance on global routing redundancy before making Front Door the only entry to a critical application.
```

#### What 19 means here

The advice follows [18](#18--use-front-door-with-a-web-application-firewall-for-global-applications) and applies when it does.

##### 19 status

Not adopted, because Front Door is not used.

### 20 — Combine Front Door and Application Gateway with the firewall at Front Door

```text
CAF network topology and connectivity — Plan for application delivery — recommendation 20
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (retrieved 2026-10-15)
Summary (ours): When both are used, put the web application firewall policies on Front Door and lock the Application Gateway so it
  accepts traffic from Front Door only.
```

#### What 20 means here

Neither service is used (see [14](#14--use-application-gateway-v2-with-a-web-application-firewall) and
[18](#18--use-front-door-with-a-web-application-firewall-for-global-applications)).

##### 20 status

Not adopted, because neither Front Door nor Application Gateway is used.

### 21 — Use Traffic Manager for global non-HTTP applications

```text
CAF network topology and connectivity — Plan for application delivery — recommendation 21
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (retrieved 2026-10-15)
Summary (ours): Deliver global applications that use protocols other than HTTP and HTTPS through Traffic Manager.
```

#### What 21 means here

No workload spans regions or serves the internet on any protocol.

##### 21 status

Not adopted, because no workload is global.

### 22 — Use NAT Gateway for direct outbound traffic

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 22
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Make NAT Gateway the default for outbound internet traffic that leaves directly: it scales source network address
  translation, gives static outbound addresses, relieves port exhaustion on load balancers, firewalls, and App Service, and allows
  outbound traffic only.
```

#### What 22 means here

The workload subnets hold private endpoints and nothing that starts outbound connections: `expedition`'s services are platform services
whose own outbound traffic does not leave through the spoke. Egress therefore has no current user, and the repository has chosen its path
for when it does: through a firewall in the hub's `AzureFirewallSubnet`, with spoke routes towards it
([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6), and [23](#23--govern-outbound-and-east-west-traffic-with-azure-firewall)). A NAT
gateway on a spoke subnet would give that subnet a direct, unfiltered path instead. It can have a place behind the firewall, to give the
firewall's own outbound traffic more ports and stable addresses; that choice belongs to the firewall follow-up.

##### 22 in `foundation`

Not applicable: it deploys no network.

##### 22 in `discovery`

Attaches no NAT gateway to any subnet; the spoke's route table (`routeTableName`, for example `psub-weu-zct-disco-apex-rt`) carries no
routes.

##### 22 in `expedition`

Not applicable: a workload creates no network resource ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)), and its private endpoints make
no outbound connections.

##### 22 status

Not adopted, because the planned egress path is the hub firewall, and no workload subnet hosts compute that reaches the internet.

### 23 — Govern outbound and east-west traffic with Azure Firewall

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 23
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Use Azure Firewall to control outbound internet traffic, inbound traffic that is not HTTP or HTTPS, and traffic
  between networks inside Azure where that needs filtering.
```

#### What 23 means here

The hub reserves `AzureFirewallSubnet` (a /26 in each hub of `network.yml`) and deploys nothing into it, so a firewall can be added without
renumbering ([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)). Until it is, egress is unfiltered and traffic between the
hub and its spokes passes the peerings with only the network security groups between them. The decision to filter egress through the hub is
ADR-AZ-WAFSE#6's, and the zero-trust view of the same gap is [ADR-AZ-CAFSEC#42](landing-zone-security.md#rule-adr-az-cafsec42); this rule
records where the pieces go.

The follow-up touches three places. The hub deploys a firewall into `AzureFirewallSubnet` from a new shared module. Each spoke's route table
gains a default route to the firewall's private address, and its peering to the hub accepts forwarded traffic (`allowForwardedTraffic` in
`vnet-peering.bicep`, off by default). The firewall sends its diagnostics to `foundation`'s workspace, through a new kind in
`diagnostic-setting.bicep`.

##### 23 in `foundation`

Not applicable: it deploys no network; its diagnostics workspace receives the firewall's logs once one exists.

##### 23 in `discovery`

Reserves `AzureFirewallSubnet` in every hub and gives it no network security group; the spoke's route table exists but carries no routes. It
should deploy the firewall in each hub and route each spoke's egress to it.

##### 23 in `expedition`

Not applicable: a workload creates no network resource; its subnets' egress follows the landing zone's routes.

##### 23 status

Planned (follow-up) — a firewall in each hub with spoke routes to it, the egress filtering ADR-AZ-WAFSE#6 plans.

### 24 — Deploy Azure Firewall with its management NIC

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 24
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Enable the firewall's management NIC: create AzureFirewallManagementSubnet (at least /26) in advance, give it a
  public IP address, and keep gateway route propagation off on its route table.
```

#### What 24 means here

The hub reserves exactly `GatewaySubnet`, `AzureFirewallSubnet`, and `shared-services`, and `NetworkConfig` holds it to that set
([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)); there is no `AzureFirewallManagementSubnet`. Because the management
NIC can only be enabled when a firewall is created, the subnet belongs in the plan before the firewall of
[23](#23--govern-outbound-and-east-west-traffic-with-azure-firewall) is deployed. Each hub's address space has room for it beside the
reserved ranges (for example `10.1.0.128/26` in `shared_prod`).

The management NIC also needs a public IP address. The no-public-IP policy targets network interfaces, not a firewall's management
configuration, so the two do not collide, but the public address is the first in the landing zone and makes
[17](#17--cover-every-public-ip-address-with-ddos-protection) relevant for it.

##### 24 in `foundation`

Not applicable: it deploys no network.

##### 24 in `discovery`

Deploys the hub's subnets from `network.yml`; the management subnet would be one more entry there and in `NetworkConfig`'s required hub set.

##### 24 in `expedition`

Not applicable: a workload creates no network resource.

##### 24 status

Planned (follow-up) with the firewall of rule 23: `AzureFirewallManagementSubnet` in every hub, in `network.yml`, `NetworkConfig`, and
ADR-AZ-NETWORK#5.

### 25 — Use Azure Firewall Premium for advanced inspection

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 25
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Use Azure Firewall Premium where TLS inspection, intrusion detection and prevention, URL filtering, or web categories are
  needed; Standard and Premium need the management NIC enabled when they are created, while Basic always has it.
```

#### What 25 means here

No firewall is deployed. The SKU is a choice for the follow-up of [23](#23--govern-outbound-and-east-west-traffic-with-azure-firewall),
weighed against the `data-classification` of the workloads behind it (`confidential` for `apex`) and against cost; it would be a config
value per hub, so the production hub can differ from the non-production one.

##### 25 status

Not adopted, because no firewall is deployed; the firewall follow-up picks the SKU.

### 26 — Manage firewalls through Firewall Manager

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 26
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Manage the firewalls of Virtual WAN hubs and of hub virtual networks through Azure Firewall Manager.
```

#### What 26 means here

No firewall is deployed. With one per hub, the firewalls and their policy would be declared in `discovery` and changed through review, like
every other resource; central management through Firewall Manager adds most where firewalls are many and managed by hand.

##### 26 status

Not adopted, because no firewall is deployed.

### 27 — Reuse address sets through IP Groups

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 27
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Where the same addresses and ranges recur in firewall rules, collect them in IP Groups and reuse them across rules,
  firewalls, regions, and subscriptions.
```

#### What 27 means here

There are no firewall rules. When there are, the ranges they name have one home, `network.yml`
([ADR-AZ-NETWORK#1](../azure-network-model.md#rule-adr-az-network1)), and a rule would read them by config address rather than repeat them;
an IP Group would be built from the same addresses, never typed by hand.

##### 27 status

Not adopted, because no firewall rule exists.

### 28 — Use service tags in routes toward platform services

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 28
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): In user-defined routes that steer traffic to Azure platform services, use service tags as the prefixes so Azure keeps
  the addresses current; do not attach a custom route table to the firewall's management subnet, or keep a default route to the
  internet on it if one is needed.
```

#### What 28 means here

`route-table.bicep` takes its routes as a parameter, and the spoke's route table passes none. Platform services are reached through private
endpoints, whose addresses lie inside the spoke, so no route points at a service's public addresses
([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6)). The recommendation would apply if a workload reached a service on its public
endpoint through a firewall, which the private-only design rules out. The note on the management subnet matters for the follow-up of
[24](#24--deploy-azure-firewall-with-its-management-nic): `discovery` attaches its route table to spoke subnets only, never to a hub subnet,
and that stays so.

##### 28 in `foundation`

Not applicable: it deploys no network.

##### 28 in `discovery`

Attaches a route table with no routes to every spoke subnet, and none to a hub subnet.

##### 28 in `expedition`

Not applicable: it reaches its services through private endpoints and creates no route.

##### 28 status

Not adopted, because platform services are reached through private endpoints, not routed to their public addresses.

### 29 — Set a global firewall policy as the baseline

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 29
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Create one global Azure Firewall policy, assigned to every firewall, as the organisation's baseline security posture.
```

#### What 29 means here

No firewall is deployed. With the follow-up of [23](#23--govern-outbound-and-east-west-traffic-with-azure-firewall), one policy declared in
`discovery` and applied to each hub's firewall is the repository's way of having one baseline, configured once and deployed everywhere.

##### 29 status

Not adopted, because no firewall is deployed to take a policy.

### 30 — Delegate regional child policies

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 30
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Let regional security teams own child firewall policies for regional needs, delegated through role-based access control.
```

#### What 30 means here

There is no firewall policy, every landing zone deploys to one region, and the templates grant no role to people. Regional delegation would
apply to a repository spread across regions with separate security teams.

##### 30 status

Not adopted, because there is no firewall policy and every landing zone deploys to one region.

### 31 — Protect inbound web traffic inside the landing-zone network

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 31
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Protect inbound HTTP and HTTPS traffic from the internet with a web application firewall inside the landing-zone
  virtual network.
```

#### What 31 means here

The same advice as [14](#14--use-application-gateway-v2-with-a-web-application-firewall) and
[16](#16--place-inbound-gateways-in-the-landing-zone-network), from the internet-connectivity page. No workload takes inbound web traffic.

##### 31 status

Not adopted, because no workload takes inbound web traffic.

### 32 — Protect global inbound web traffic with Front Door

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 32
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Protect global inbound HTTP and HTTPS traffic with Front Door and web application firewall policies, after reading the
  global routing redundancy guidance.
```

#### What 32 means here

The same item as [18](#18--use-front-door-with-a-web-application-firewall-for-global-applications) and
[19](#19--review-global-routing-redundancy-before-relying-on-front-door), repeated on this page.

##### 32 status

Not adopted, because no workload is global or reached from the internet.

### 33 — Restrict Application Gateway to Front Door traffic

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 33
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): When Front Door and Application Gateway protect web applications together, put the firewall policies on Front Door and
  let Application Gateway accept traffic from Front Door only.
```

#### What 33 means here

The same item as [20](#20--combine-front-door-and-application-gateway-with-the-firewall-at-front-door).

##### 33 status

Not adopted, because neither Front Door nor Application Gateway is used.

### 34 — Keep inbound partner appliances beside their applications

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 34
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): When partner network virtual appliances handle inbound web traffic, deploy them in the landing-zone network beside the
  applications they expose.
```

#### What 34 means here

The placement of [16](#16--place-inbound-gateways-in-the-landing-zone-network), for a partner appliance instead of Application Gateway; see
[15](#15--fall-back-to-a-partner-appliance-only-when-needed) for why the repository would not start there.

##### 34 status

Not adopted, because no inbound appliance exists.

### 35 — Do not rely on default outbound access

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 35
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Never depend on Azure's default outbound internet access: it risks port exhaustion, is open by default, and uses
  addresses the organisation does not own and that can change.
```

#### What 35 means here

Default outbound access is what a virtual machine in a subnet gets when nothing else gives it a way out. No subnet here hosts one, so no
traffic relies on it. The subnets do not switch it off either: `virtual-network.bicep` sets no `defaultOutboundAccess` on its subnets, and
the spoke's route table carries no routes, so the first compute placed in a spoke would reach the internet directly. Turning default
outbound access off on every subnet is a secure default the module should carry ([ADR-AZ-WAFSE#8](../waf/security.md#rule-adr-az-wafse8));
egress then exists only where the firewall of [23](#23--govern-outbound-and-east-west-traffic-with-azure-firewall) provides it.

##### 35 in `foundation`

Not applicable: it deploys no network.

##### 35 in `discovery`

Deploys every subnet through `virtual-network.bicep` and inherits whatever the module sets; it should get subnets without default outbound
access from the module's default.

##### 35 in `expedition`

Not applicable: its private endpoints make no outbound connections and it creates no subnet.

##### 35 status

Planned (follow-up) — default outbound access off on every subnet, as a secure default of `virtual-network.bicep`.

### 36 — Use NAT Gateway in online landing zones

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 36
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Landing zones that are not connected to the hub use NAT Gateway for outbound traffic when no firewall or appliance has
  to inspect it.
```

#### What 36 means here

CAF's online landing zone stands apart from the hub. Here every customer spoke peers to the hub of its tier
([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)), and `NetworkConfig` gives every subscription a hub or a spoke network, so there is no
unconnected landing zone to apply this to. A workload that had to stand apart would make it apply.

##### 36 status

Not adopted, because every landing zone is connected to a hub.

### 37 — Integrate SaaS security providers through Firewall Manager

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 37
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Where the organisation uses software-as-a-service security providers for outbound protection, connect them through
  Firewall Manager.
```

#### What 37 means here

There is neither a firewall nor Firewall Manager, and no such provider is in use. The choice of a provider belongs to the tenant's security
operations, not to a template.

##### 37 status

Not adopted, because there is no firewall or Firewall Manager to integrate a provider with.

### 38 — Place partner appliances for east-west and north-south traffic

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 38
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): With partner appliances protecting traffic between networks or to and from the internet, place them in a separate
  appliance network connected to the hub in a Virtual WAN design, or in the central hub otherwise.
```

#### What 38 means here

The planned filtering device is Azure Firewall in the hub's reserved subnet
([23](#23--govern-outbound-and-east-west-traffic-with-azure-firewall)). Were a partner appliance chosen instead, the recommendation's
placement for a traditional hub — the central hub — is where that subnet sits.

##### 38 status

Not adopted, because the planned filtering device is Azure Firewall, not a partner appliance.

### 39 — Expose no virtual machine management port to the internet

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 39
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Expose no management port of a virtual machine to the internet: block virtual machines with public IP addresses by policy
  and reach jump hosts through Bastion.
```

#### What 39 means here

Two controls of the landing zone close the way in. Every workload subnet carries a network security group whose rules allow traffic inside
the virtual networks and deny all inbound traffic from the internet, management ports included; the reserved hub subnets carry none and hold
nothing ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)). And the built-in "Network interfaces should not have public IPs" policy, the
one the recommendation names, is assigned in every landing zone ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)): it denies such an
interface where `policy_enforcement` enforces, by default in production, and reports it where it audits.

No template deploys a virtual machine, so there is no jump host and no Bastion (see [45](#45--place-bastion-in-a-hub-and-spoke-topology)).
The one gap is `vm.bicep`: an unused module that gives its virtual machine a public IP address, so a non-production deploy that used it
would expose the machine, with only an audit record from the policy. Its hardening is planned under
[ADR-AZ-WAFSE#8](../waf/security.md#rule-adr-az-wafse8).

##### 39 in `foundation`

Not applicable: it deploys no network and no virtual machine.

##### 39 in `discovery`

Gives every workload subnet a network security group from its `networkSecurityGroupNames` (for example `private-endpoints`, `preprod`, and
`prod` in `apex/psub.yml`, `shared-services` in `psub.yml`), each with the `deny-internet-inbound` rule, and assigns the no-public-IP
policy.

##### 39 in `expedition`

Deploys no virtual machine and no public IP address.

##### 39 status

Partly realised — inbound internet traffic is denied and the no-public-IP policy is assigned in every landing zone; removing the public IP
address from `vm.bicep` is planned (follow-up).

### 40 — Protect public endpoints with DDoS Protection plans

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 40
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Protect the public endpoints in virtual networks with Azure DDoS Protection plans.
```

#### What 40 means here

The same item as [17](#17--cover-every-public-ip-address-with-ddos-protection), from the internet-connectivity page: no network holds a
public endpoint, so there is nothing to protect.

##### 40 status

Not adopted, because no network holds a public endpoint.

### 41 — Do not copy an on-premises perimeter into Azure

```text
CAF network topology and connectivity — Plan for inbound and outbound internet connectivity — recommendation 41
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (retrieved 2026-10-15)
Summary (ours): Do not rebuild on-premises perimeter network and demilitarised-zone designs in Azure; use patterns made for the cloud.
```

#### What 41 means here

The landing zone has no perimeter network and no tier of shared appliances that every flow passes. Its controls sit at each resource
instead: a network security group per workload subnet, public network access off on each data service, and a private endpoint per service in
the customer's own spoke ([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6), [ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)).
The planned hub firewall ([23](#23--govern-outbound-and-east-west-traffic-with-azure-firewall)) filters egress; it is not a perimeter
network that workloads live behind.

##### 41 in `foundation`

Not applicable: it deploys no network.

##### 41 in `discovery`

Deploys hubs and spokes with no perimeter subnet; the hub's subnets are the reserved gateway and firewall subnets and `shared-services`.

##### 41 in `expedition`

Places its private endpoints in its customer's spoke, with public access off on each service.

##### 41 status

Realised — no perimeter network; each subnet and each service carries its own control.

### 42 — Use the Standard or Premium Bastion SKU in production

```text
CAF network topology and connectivity — Use Azure Bastion for virtual machine remote access — recommendation 42
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (retrieved 2026-10-15)
Summary (ours): Use the Standard or Premium Bastion SKU for production workloads, and the free Developer SKU for sandbox and test where
  the region offers it.
```

#### What 42 means here

No template deploys a virtual machine: `expedition`'s compute is the platform's (a storage account and a SQL database), and operators reach
it through Azure Resource Manager and Entra ID, not a remote desktop. The ten Bastion recommendations (this rule to
[51](#51--allow-no-remote-access-to-virtual-machines-over-public-ip-addresses)) apply with the first workload that runs a virtual machine.

##### 42 status

Not adopted, because no template deploys a virtual machine.

### 43 — Reach virtual machines over existing private connectivity

```text
CAF network topology and connectivity — Use Azure Bastion for virtual machine remote access — recommendation 43
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (retrieved 2026-10-15)
Summary (ours): Reach virtual machines from on-premises over the ExpressRoute or VPN connectivity that already exists.
```

#### What 43 means here

There is neither a virtual machine nor a link from on-premises (see [1](#1--make-expressroute-the-primary-link-with-vpn-as-backup)).

##### 43 status

Not adopted, because there is neither a virtual machine nor private connectivity from on-premises.

### 44 — Place Bastion in a Virtual WAN topology

```text
CAF network topology and connectivity — Use Azure Bastion for virtual machine remote access — recommendation 44
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (retrieved 2026-10-15)
Summary (ours): In a Virtual WAN topology, deploy Bastion in each spoke, or one central Bastion in a spoke, which needs fewer instances
  but gives users Reader on Bastion and on that spoke's network.
```

#### What 44 means here

The topology is a traditional hub and spoke, not Virtual WAN ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)); see
[45](#45--place-bastion-in-a-hub-and-spoke-topology) for the hub-and-spoke placement.

##### 44 status

Not adopted, because the topology is not Virtual WAN.

### 45 — Place Bastion in a hub-and-spoke topology

```text
CAF network topology and connectivity — Use Azure Bastion for virtual machine remote access — recommendation 45
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (retrieved 2026-10-15)
Summary (ours): In a hub-and-spoke topology, one Bastion in the hub serves the peered spokes, with users given Reader on Bastion and on
  the hub network; where that grant is not allowed, deploy a Bastion in each spoke that needs one.
```

#### What 45 means here

No template deploys a virtual machine. The placement would fit the network: one Bastion per hub, serving the spokes peered to it. It would
need an `AzureBastionSubnet` in each hub, which the hub does not reserve — the reserved set is fixed by
[ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5) and `NetworkConfig` — so the first virtual-machine workload would add it
there, in the same way as the firewall's management subnet of [24](#24--deploy-azure-firewall-with-its-management-nic).

##### 45 status

Not adopted, because no template deploys a virtual machine.

### 46 — Protect Bastion with network security group rules

```text
CAF network topology and connectivity — Use Azure Bastion for virtual machine remote access — recommendation 46
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (retrieved 2026-10-15)
Summary (ours): Protect Bastion and the virtual machines it reaches with the network security group rules Microsoft documents.
```

#### What 46 means here

No Bastion is deployed. Its subnet would need rules that differ from the landing zone's one rule set (inbound HTTPS from the internet to
Bastion), so `discovery` would pass that subnet its own rules through `nsg.bicep`.

##### 46 status

Not adopted, because no Bastion is deployed.

### 47 — Send Bastion diagnostics to the central workspace

```text
CAF network topology and connectivity — Use Azure Bastion for virtual machine remote access — recommendation 47
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (retrieved 2026-10-15)
Summary (ours): Send Bastion's diagnostic logs to the central Log Analytics workspace.
```

#### What 47 means here

No Bastion is deployed. Every network resource the landing zone deploys sends its diagnostics to `foundation`'s workspace through
`diagnostic-setting.bicep` ([ADR-AZ-WAFSE#10](../waf/security.md#rule-adr-az-wafse10)); a Bastion would be one more kind there.

##### 47 status

Not adopted, because no Bastion is deployed.

### 48 — Grant the roles Bastion needs

```text
CAF network topology and connectivity — Use Azure Bastion for virtual machine remote access — recommendation 48
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (retrieved 2026-10-15)
Summary (ours): Create the role assignments that let the users and groups who connect through Bastion do so.
```

#### What 48 means here

No Bastion is deployed, and the templates grant no role to people; role assignments as code are planned under
[ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5), which is where Bastion's would go.

##### 48 status

Not adopted, because no Bastion is deployed and the templates grant no role to people.

### 49 — Keep SSH keys for Bastion in Key Vault

```text
CAF network topology and connectivity — Use Azure Bastion for virtual machine remote access — recommendation 49
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (retrieved 2026-10-15)
Summary (ours): Connect to Linux virtual machines over SSH with private keys kept in Key Vault.
```

#### What 49 means here

No Linux virtual machine is deployed. The recommendation fits the repository's handling of secrets: every secret lives in `foundation`'s
vault and the repository holds none ([ADR-AZ-WAFSE#9](../waf/security.md#rule-adr-az-wafse9)).

##### 49 status

Not adopted, because no Linux virtual machine is deployed.

### 50 — Keep Bastion beside private connectivity for special cases

```text
CAF network topology and connectivity — Use Azure Bastion for virtual machine remote access — recommendation 50
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (retrieved 2026-10-15)
Summary (ours): Keep both Bastion and ExpressRoute or VPN access where specific needs, such as break-glass access, call for both.
```

#### What 50 means here

There is neither a Bastion nor private connectivity. The repository's break-glass path is to data, not to machines: the SQL login of
[ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6).

##### 50 status

Not adopted, because there is neither a Bastion nor private connectivity.

### 51 — Allow no remote access to virtual machines over public IP addresses

```text
CAF network topology and connectivity — Use Azure Bastion for virtual machine remote access — recommendation 51
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (retrieved 2026-10-15)
Summary (ours): Do not allow remote access to Windows or Linux virtual machines through public IP addresses, and never allow remote access
  without strict network security groups and firewalling.
```

#### What 51 means here

The same posture as [39](#39--expose-no-virtual-machine-management-port-to-the-internet), from the Bastion page: the network security groups
deny inbound internet traffic and the landing zone's policy keeps public IP addresses off network interfaces. The gap is the same too —
`vm.bicep` attaches a public IP address to its virtual machine.

##### 51 status

Partly realised — as rule 39; removing the public IP address from `vm.bicep` is planned (follow-up).

### 52 — Rely on IPsec for VPN connections

```text
CAF network topology and connectivity — Define network encryption requirements — recommendation 52
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (retrieved 2026-10-15)
Summary (ours): Connections from on-premises through a VPN gateway are encrypted with IPsec.
```

#### What 52 means here

No VPN connection exists (see [8](#8--connect-branches-through-zone-redundant-vpn-gateways)).

##### 52 status

Not adopted, because no VPN connection exists.

### 53 — Encrypt traffic between virtual machines

```text
CAF network topology and connectivity — Define network encryption requirements — recommendation 53
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (retrieved 2026-10-15)
Summary (ours): Where traffic between virtual machines must be encrypted, inside a network or across peered networks, use virtual network
  encryption.
```

#### What 53 means here

Virtual network encryption protects traffic between virtual machines, and no template deploys one. The traffic that does cross the networks
runs from a client to a data service's private endpoint, and the services encrypt it themselves: `storage-account.bicep` sets
`minimumTlsVersion: 'TLS1_2'` and `supportsHttpsTrafficOnly: true`, and `sql-server.bicep` sets `minimalTlsVersion: '1.2'`, both fixed in
the modules rather than offered as parameters ([ADR-AZ-WAFSE#7](../waf/security.md#rule-adr-az-wafse7)). Encryption in transit is therefore
a property of each service, independent of the network it travels.

Virtual network encryption would become relevant with virtual machines that talk to each other over a protocol without its own encryption.
It would be a property of the virtual network, set by `virtual-network.bicep`.

##### 53 in `foundation`

Not applicable to its network, which it has none of; its Key Vault and workspace are reached over HTTPS by the platform's design, with no
TLS minimum set by their modules.

##### 53 in `discovery`

Deploys the virtual networks without virtual network encryption; no virtual machine runs in them.

##### 53 in `expedition`

Encrypts every connection to its storage account and SQL server with TLS 1.2 at minimum, through the module defaults.

##### 53 status

Not adopted, because no traffic flows between virtual machines; every connection to data is encrypted with TLS 1.2 at minimum.

### 54 — Encrypt ExpressRoute Direct with MACsec

```text
CAF network topology and connectivity — Define network encryption requirements — recommendation 54
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (retrieved 2026-10-15)
Summary (ours): Encrypt ExpressRoute Direct links at layer 2 with MACsec.
```

#### What 54 means here

There is no ExpressRoute Direct port (see [6](#6--use-expressroute-direct-above-10-gbps)).

##### 54 status

Not adopted, because there is no ExpressRoute Direct port.

### 55 — Run IPsec over ExpressRoute in Virtual WAN

```text
CAF network topology and connectivity — Define network encryption requirements — recommendation 55
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (retrieved 2026-10-15)
Summary (ours): In Virtual WAN where MACsec is not an option, run IPsec over ExpressRoute private peering through the Virtual WAN VPN
  gateway.
```

#### What 55 means here

The topology is not Virtual WAN, and there is no ExpressRoute.

##### 55 status

Not adopted, because there is neither Virtual WAN nor ExpressRoute.

### 56 — Choose an encryption option over ExpressRoute outside Virtual WAN

```text
CAF network topology and connectivity — Define network encryption requirements — recommendation 56
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (retrieved 2026-10-15)
Summary (ours): Outside Virtual WAN and where MACsec is not an option, encrypt with partner appliances over private peering, a VPN over
  Microsoft peering, or a site-to-site VPN over private peering.
```

#### What 56 means here

There is no ExpressRoute connection to encrypt. Should one be added to the hub's `GatewaySubnet`, the choice among these options would
follow the classification of the data crossing it.

##### 56 status

Not adopted, because there is no ExpressRoute connection to encrypt.

### 57 — Fall back to partner appliances for encryption

```text
CAF network topology and connectivity — Define network encryption requirements — recommendation 57
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (retrieved 2026-10-15)
Summary (ours): If the native options do not meet the requirements, encrypt traffic over private peering with partner appliances.
```

#### What 57 means here

There is no private connection to encrypt, and the native options of [54](#54--encrypt-expressroute-direct-with-macsec) and
[55](#55--run-ipsec-over-expressroute-in-virtual-wan) are not in play either.

##### 57 status

Not adopted, because there is no private connection to encrypt.

### 58 — Use virtual network flow logs

```text
CAF network topology and connectivity — Plan for traffic inspection — recommendation 58
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-traffic-inspection (retrieved 2026-10-15)
Summary (ours): Record traffic with virtual network flow logs and move away from network security group flow logs: they are simpler to
  set up, cover a whole network, and add encryption status and Virtual Network Manager rule details. Network security group flow logs
  are being retired.
```

#### What 58 means here

The landing zone sends diagnostics, not flows. Each virtual network and each network security group has a diagnostic setting to
`foundation`'s workspace through `diagnostic-setting.bicep` (the `virtualNetwork` and `networkSecurityGroup` kinds); for a security group
that records rule events and counters, not the connections that passed. No flow log of either kind is recorded, which is the flow-logging
gap ADR-AZ-WAFSE#6 plans to close.

Virtual network flow logs are the kind to adopt, never the retiring security-group kind. One per virtual network, deployed by `discovery`
beside the network it watches, covers every subnet, whichever security group it carries. A flow log is a Network Watcher resource that
writes to a storage account, so the follow-up decides where that account lives — `foundation` holds the subscription's shared monitoring
resources, which makes it the natural home — and keeps the account private like every other store.

##### 58 in `foundation`

Holds the Log Analytics workspace that receives the network diagnostics; it has no storage account for flow logs.

##### 58 in `discovery`

Sends the virtual network's and every network security group's diagnostics to `foundation`'s workspace; deploys no flow log. It should
deploy a virtual network flow log for its network.

##### 58 in `expedition`

Not applicable: a workload creates no network resource; its private endpoints' traffic is recorded by the flow log of the spoke it lands in.

##### 58 status

Planned (follow-up) — a virtual network flow log per landing-zone network, the flow logging ADR-AZ-WAFSE#6 plans.

### 59 — Enable traffic analytics

```text
CAF network topology and connectivity — Plan for traffic inspection — recommendation 59
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-traffic-inspection (retrieved 2026-10-15)
Summary (ours): Turn on traffic analytics, for ready-made views of the traffic and security analysis over the flow logs.
```

#### What 59 means here

Traffic analytics processes flow logs into a Log Analytics workspace, so it follows [58](#58--use-virtual-network-flow-logs): the same flow
log turns it on and names `foundation`'s workspace, where every other diagnostic of the subscription lands.

##### 59 in `foundation`

Its workspace is the one traffic analytics would write to.

##### 59 in `discovery`

Deploys no flow log, so no traffic analytics; the follow-up of rule 58 enables it on the flow log.

##### 59 in `expedition`

Not applicable: a workload creates no network resource.

##### 59 status

Planned (follow-up) with rule 58 — traffic analytics on the flow log, into `foundation`'s workspace.

### 60 — Add a partner solution when traffic analytics falls short

```text
CAF network topology and connectivity — Plan for traffic inspection — recommendation 60
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-traffic-inspection (retrieved 2026-10-15)
Summary (ours): If traffic analytics does not offer enough, add a partner solution from the Marketplace.
```

#### What 60 means here

Traffic analytics is planned, not deployed (see [59](#59--enable-traffic-analytics)); whether it falls short can only be judged once it
runs.

##### 60 status

Not adopted, because traffic analytics is planned, not deployed.

### 61 — Run packet captures regularly

```text
CAF network topology and connectivity — Plan for traffic inspection — recommendation 61
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-traffic-inspection (retrieved 2026-10-15)
Summary (ours): Run Network Watcher packet captures at different times through the week to learn which traffic flows.
```

#### What 61 means here

Packet capture runs on virtual machines and scale sets, and no template deploys one. The flow logs of
[58](#58--use-virtual-network-flow-logs) are the repository's planned view of which traffic flows.

##### 61 status

Not adopted, because no template deploys a virtual machine to capture on.

### 62 — Build no custom traffic mirroring

```text
CAF network topology and connectivity — Plan for traffic inspection — recommendation 62
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-traffic-inspection (retrieved 2026-10-15)
Summary (ours): Do not build a custom traffic-mirroring solution for a large estate; it is hard to support.
```

#### What 62 means here

The repository mirrors no traffic and builds no tooling for it; the planned inspection is the platform's own flow logs and traffic analytics
([58](#58--use-virtual-network-flow-logs), [59](#59--enable-traffic-analytics)).

##### 62 status

Realised — no custom mirroring exists or is planned.

## Decision

The repository answers each of Microsoft's network connectivity recommendations with what it does, what it plans, or why it does not adopt
it. Its networks are private and self-contained: no on-premises site, other cloud, or branch connects to them; no workload is reached from
the internet; data services are reached through private endpoints and encrypt every connection with TLS 1.2 at minimum; every workload
subnet denies inbound internet traffic; and no network interface takes a public IP address. The hub reserves `GatewaySubnet` and
`AzureFirewallSubnet` so that a gateway or a firewall can be added without renumbering.

Most of the area therefore does not apply, and each such rule says what would make it apply: a link from a customer's sites (rules 1–12 and
52–57), a workload served to the internet (rules 13–21, 31–34, 40), or a virtual machine (rules 42–51, 61). The planned items close the gaps
the repository does have: egress filtered through a firewall in each hub, with its management subnet in the plan (rules 23 and 24, the
follow-up of ADR-AZ-WAFSE#6); default outbound access off on every subnet (rule 35); virtual network flow logs with traffic analytics (rules
58 and 59); and no public IP address in `vm.bicep` (rules 17, 39, 51).

### How this is enforced

- The landing zone's no-public-IP assignment is the enforcement for public addresses on network interfaces: Azure denies one where
  `policy_enforcement` enforces and reports it where it audits ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).
- `discovery/main.bicep` gives every subnet named in `networkSecurityGroupNames` a network security group with the `deny-internet-inbound`
  rule, and `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` on every change under `infrastructure/`, so the template
  that carries the rule compiles before it deploys.
- `storage-account.bicep` and `sql-server.bicep` fix TLS 1.2 and public network access off as module defaults
  ([ADR-AZ-WAFSE#7](../waf/security.md#rule-adr-az-wafse7)).
- `NetworkConfig` and `Test-AzureNetworkPlan` keep the reserved hub subnets in the plan and every range private and free of overlap
  ([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5), [ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)).
- Planned (follow-up), not existing: a check over the compiled templates (`main.json`) that fails a public IP address, public network
  access, a TLS minimum below 1.2, or a subnet with default outbound access; the hub firewall with spoke routes; and virtual network flow
  logs.

## Consequences

- No traffic enters a workload from the internet and no data service has a public endpoint, so most inbound protections — web application
  firewalls, DDoS Protection, Bastion — have nothing to protect until the first public endpoint or virtual machine appears.
- Encryption in transit rests on each data service's TLS settings, not on the network, so it holds whatever path the traffic takes.
- Egress stays unfiltered until the hub firewall is deployed; with no compute in the workload subnets, no workload uses that path.
- A link from a customer's sites, a firewall, or a Bastion lands in a reserved or planned hub subnet without renumbering any network.
- Every planned network control lives in `discovery`, so a workload template stays free of network resources.
