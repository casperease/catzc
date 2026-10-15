---
catzc:
  derived:
    path: docs/adr/azure/caf/network-topology.md
    kind: adr
    body_sha: d686931f9aad
    defines:
      - ADR-AZ-CAFNETTOP#1
      - ADR-AZ-CAFNETTOP#2
      - ADR-AZ-CAFNETTOP#3
      - ADR-AZ-CAFNETTOP#4
      - ADR-AZ-CAFNETTOP#5
      - ADR-AZ-CAFNETTOP#6
      - ADR-AZ-CAFNETTOP#7
      - ADR-AZ-CAFNETTOP#8
      - ADR-AZ-CAFNETTOP#9
      - ADR-AZ-CAFNETTOP#10
      - ADR-AZ-CAFNETTOP#11
      - ADR-AZ-CAFNETTOP#12
      - ADR-AZ-CAFNETTOP#13
      - ADR-AZ-CAFNETTOP#14
      - ADR-AZ-CAFNETTOP#15
      - ADR-AZ-CAFNETTOP#16
      - ADR-AZ-CAFNETTOP#17
      - ADR-AZ-CAFNETTOP#18
      - ADR-AZ-CAFNETTOP#19
      - ADR-AZ-CAFNETTOP#20
      - ADR-AZ-CAFNETTOP#21
      - ADR-AZ-CAFNETTOP#22
      - ADR-AZ-CAFNETTOP#23
      - ADR-AZ-CAFNETTOP#24
      - ADR-AZ-CAFNETTOP#25
      - ADR-AZ-CAFNETTOP#26
      - ADR-AZ-CAFNETTOP#27
      - ADR-AZ-CAFNETTOP#28
      - ADR-AZ-CAFNETTOP#29
      - ADR-AZ-CAFNETTOP#30
      - ADR-AZ-CAFNETTOP#31
      - ADR-AZ-CAFNETTOP#32
      - ADR-AZ-CAFNETTOP#33
      - ADR-AZ-CAFNETTOP#34
      - ADR-AZ-CAFNETTOP#35
      - ADR-AZ-CAFNETTOP#36
      - ADR-AZ-CAFNETTOP#37
      - ADR-AZ-CAFNETTOP#38
      - ADR-AZ-CAFNETTOP#39
      - ADR-AZ-CAFNETTOP#40
      - ADR-AZ-CAFNETTOP#41
      - ADR-AZ-CAFNETTOP#42
      - ADR-AZ-CAFNETTOP#43
      - ADR-AZ-CAFNETTOP#44
      - ADR-AZ-CAFNETTOP#45
      - ADR-AZ-CAFNETTOP#46
      - ADR-AZ-CAFNETTOP#47
      - ADR-AZ-CAFNETTOP#48
      - ADR-AZ-CAFNETTOP#49
      - ADR-AZ-CAFNETTOP#50
      - ADR-AZ-CAFNETTOP#51
      - ADR-AZ-CAFNETTOP#52
      - ADR-AZ-CAFNETTOP#53
      - ADR-AZ-CAFNETTOP#54
      - ADR-AZ-CAFNETTOP#55
      - ADR-AZ-CAFNETTOP#56
      - ADR-AZ-CAFNETTOP#57
      - ADR-AZ-CAFNETTOP#58
      - ADR-AZ-CAFNETTOP#59
      - ADR-AZ-CAFNETTOP#60
      - ADR-AZ-CAFNETTOP#61
      - ADR-AZ-CAFNETTOP#62
      - ADR-AZ-CAFNETTOP#63
      - ADR-AZ-CAFNETTOP#64
      - ADR-AZ-CAFNETTOP#65
    adrs:
      - ADR-AZ-CAFMGMT#4
      - ADR-AZ-DATAMOD#9
      - ADR-AZ-LZ#1
      - ADR-AZ-LZ#2
      - ADR-AZ-LZ#3
      - ADR-AZ-LZ#4
      - ADR-AZ-LZ#7
      - ADR-AZ-NETWORK#1
      - ADR-AZ-NETWORK#3
      - ADR-AZ-NETWORK#5
      - ADR-AZ-NETWORK#6
      - ADR-AZ-WAFSE#4
      - ADR-AZ-WAFSE#6
    links:
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/azure-naming-standard.md
      - docs/adr/azure/azure-network-model.md
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network1
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network3
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network5
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network6
      - docs/adr/azure/caf/management.md#rule-adr-az-cafmgmt4
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz1
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz2
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz3
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz4
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz7
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse4
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse6
      - docs/references/caf/index.md
      - "https://learn.microsoft.com/en-us/legal/termsofuse"
---

# ADR: CAF network topology — what the repository does about each topology, IP addressing, segmentation, and Virtual Network Manager recommendation

Pairs with [`landing-zones`](../landing-zones.md) (the hub-and-spoke landing zone these recommendations are weighed against) and
[`network-model`](../azure-network-model.md) (the IP plan in `network.yml` that answers the addressing recommendations).

## Rules: ADR-AZ-CAFNETTOP

### Rule ADR-AZ-CAFNETTOP:1

Adopted: the network is hub-and-spoke — one hub per shared subscription, one spoke per customer subscription peered to the hub of its tier
([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)).

- [1 — Hub and spoke as the network design](#1--hub-and-spoke-as-the-network-design)

### Rule ADR-AZ-CAFNETTOP:2

Partly adopted: each tier has one hub in the one region with its spokes peered to it; the gateway and the firewall a hub would carry are
reserved subnets with nothing deployed, so there is no hybrid link, no spoke-to-spoke transit, and no filtered egress.

- [2 — A regional hub with spokes peered to it](#2--a-regional-hub-with-spokes-peered-to-it)

### Rule ADR-AZ-CAFNETTOP:3

Adopted: the topology Microsoft's diagram shows is the one of rule 1; the diagram adds no recommendation of its own.

- [3 — The hub-and-spoke diagram](#3--the-hub-and-spoke-diagram)

### Rule ADR-AZ-CAFNETTOP:4

Not adopted: there is no ExpressRoute circuit; customers are isolated by subscription and spoke, not by circuit.

- [4 — Several networks on several ExpressRoute circuits](#4--several-networks-on-several-expressroute-circuits)

### Rule ADR-AZ-CAFNETTOP:5

Not adopted: the diagram of rule 4 shows a topology the repository does not use.

- [5 — The multi-circuit diagram](#5--the-multi-circuit-diagram)

### Rule ADR-AZ-CAFNETTOP:6

Not adopted: there is no ExpressRoute circuit to dual-home.

- [6 — ExpressRoute Metro for dual-homed peering](#6--expressroute-metro-for-dual-homed-peering)

### Rule ADR-AZ-CAFNETTOP:7

Planned: a firewall in the hub's reserved `AzureFirewallSubnet`, with the spoke route tables sending traffic to it — the egress filtering
[ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6) plans.

- [7 — A firewall or network appliance in the hub](#7--a-firewall-or-network-appliance-in-the-hub)

### Rule ADR-AZ-CAFNETTOP:8

Partly adopted: the hub carries only the two reserved subnets, `shared-services`, and the private DNS zones; the shared platform's own
workload also lands in `shared-services`, which is more than the minimal set.

- [8 — A minimal set of shared services in the hub](#8--a-minimal-set-of-shared-services-in-the-hub)

### Rule ADR-AZ-CAFNETTOP:9

Not adopted: no workload has a public endpoint, so a DDoS Protection plan has nothing to protect.

- [9 — One DDoS Protection plan in the connectivity subscription](#9--one-ddos-protection-plan-in-the-connectivity-subscription)

### Rule ADR-AZ-CAFNETTOP:10

Not adopted: there is no on-premises network and no branch to connect.

- [10 — Branches over the existing wide-area network](#10--branches-over-the-existing-wide-area-network)

### Rule ADR-AZ-CAFNETTOP:11

Planned: the same recommendation as rule 7, which decides it.

- [11 — A firewall or network appliance in the hub, repeated](#11--a-firewall-or-network-appliance-in-the-hub-repeated)

### Rule ADR-AZ-CAFNETTOP:12

Not adopted: no partner network appliance is deployed.

- [12 — Partner appliances deployed to their vendor guidance](#12--partner-appliances-deployed-to-their-vendor-guidance)

### Rule ADR-AZ-CAFNETTOP:13

Adopted: the hub holds no Application Gateway or other inbound application proxy; a workload that needs one carries it in its own template.

- [13 — No shared inbound application proxy in the hub](#13--no-shared-inbound-application-proxy-in-the-hub)

### Rule ADR-AZ-CAFNETTOP:14

Not adopted: the same recommendation as rule 9, which decides it.

- [14 — One DDoS Protection plan, repeated](#14--one-ddos-protection-plan-repeated)

### Rule ADR-AZ-CAFNETTOP:15

Not adopted: the same recommendation as rule 10, which decides it.

- [15 — Branches over the existing network, repeated](#15--branches-over-the-existing-network-repeated)

### Rule ADR-AZ-CAFNETTOP:16

Not adopted: there is no ExpressRoute or VPN gateway to carry traffic between.

- [16 — Route Server for transit between ExpressRoute and VPN](#16--route-server-for-transit-between-expressroute-and-vpn)

### Rule ADR-AZ-CAFNETTOP:17

Not adopted: every environment deploys to one region ([ADR-AZ-NETWORK#3](../azure-network-model.md#rule-adr-az-network3)), so no spoke needs
a cross-region link.

- [17 — Global peering for a few cross-region spokes](#17--global-peering-for-a-few-cross-region-spokes)

### Rule ADR-AZ-CAFNETTOP:18

Not adopted: one region, so there is no hub-to-hub routing across regions.

- [18 — Hub-to-hub routing for most cross-region traffic](#18--hub-to-hub-routing-for-most-cross-region-traffic)

### Rule ADR-AZ-CAFNETTOP:19

Not adopted: one region; its non-production and production hubs are deliberately not peered.

- [19 — Two regions with peered hubs](#19--two-regions-with-peered-hubs)

### Rule ADR-AZ-CAFNETTOP:20

Not adopted: one region, so Virtual WAN's global transit has nothing to connect.

- [20 — Virtual WAN for global transit](#20--virtual-wan-for-global-transit)

### Rule ADR-AZ-CAFNETTOP:21

Not adopted: one region and no ExpressRoute circuit.

- [21 — Every regional hub on the same ExpressRoute circuits](#21--every-regional-hub-on-the-same-expressroute-circuits)

### Rule ADR-AZ-CAFNETTOP:22

Not adopted: no route is learned over BGP; the spoke route tables are empty.

- [22 — Inspection of cross-region traffic learned over BGP](#22--inspection-of-cross-region-traffic-learned-over-bgp)

### Rule ADR-AZ-CAFNETTOP:23

Not adopted: the same recommendation as rule 20, which decides it.

- [23 — Virtual WAN for global transit, repeated](#23--virtual-wan-for-global-transit-repeated)

### Rule ADR-AZ-CAFNETTOP:24

Adopted: each hub's resources sit in one resource group of its region, named with the region code (`nsub-weu-zct-disco-rg`).

- [24 — One resource group per region for hub resources](#24--one-resource-group-per-region-for-hub-resources)

### Rule ADR-AZ-CAFNETTOP:25

Not adopted: peerings and security rules are declared in config and deployed by `discovery`, not managed by Azure Virtual Network Manager
(rules 59 to 65).

- [25 — Virtual Network Manager for connectivity and security](#25--virtual-network-manager-for-connectivity-and-security)

### Rule ADR-AZ-CAFNETTOP:26

Planned: network monitoring through Network Watcher arrives with the flow logs of rule 54; the virtual network and its security groups send
their logs and metrics to `foundation`'s workspace.

- [26 — Network Watcher network insights](#26--network-watcher-network-insights)

### Rule ADR-AZ-CAFNETTOP:27

Adopted: each hub lists a handful of spokes, far below the peering limit of a virtual network, and there is no ExpressRoute prefix to
advertise.

- [27 — Peering and route-advertisement limits](#27--peering-and-route-advertisement-limits)

### Rule ADR-AZ-CAFNETTOP:28

Adopted: `network.yml` is the one IP plan and `NetworkConfig` rejects any overlap between its networks
([ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)); there is no on-premises range to avoid.

- [28 — Non-overlapping address spaces](#28--non-overlapping-address-spaces)

### Rule ADR-AZ-CAFNETTOP:29

Partly adopted: every range in the plan lies inside the private block 10.0.0.0/8, but no check requires a private range.

- [29 — Private address ranges](#29--private-address-ranges)

### Rule ADR-AZ-CAFNETTOP:30

Partly adopted: no range in the plan touches a reserved block, but no check rejects one; the private-range check of rule 29 would.

- [30 — No reserved address ranges](#30--no-reserved-address-ranges)

### Rule ADR-AZ-CAFNETTOP:31

Not adopted: the private IPv4 plan has room to spare, and the plan is IPv4 only.

- [31 — IPv6 where private IPv4 is scarce](#31--ipv6-where-private-ipv4-is-scarce)

### Rule ADR-AZ-CAFNETTOP:32

Not adopted: every network in the plan is a /16, one even step per subscription, and the private block 10.0.0.0/8 holds 256 of them.

- [32 — No oversized virtual networks](#32--no-oversized-virtual-networks)

### Rule ADR-AZ-CAFNETTOP:33

Adopted: a virtual network takes its address space only from `network.yml` by config address
([ADR-AZ-NETWORK#1](../azure-network-model.md#rule-adr-az-network1)), so no network exists without a planned range.

- [33 — Address space planned before the network](#33--address-space-planned-before-the-network)

### Rule ADR-AZ-CAFNETTOP:34

Partly adopted: no network uses a public range, but no check rejects one; the private-range check of rule 29 would.

- [34 — No public ranges for virtual networks](#34--no-public-ranges-for-virtual-networks)

### Rule ADR-AZ-CAFNETTOP:35

Adopted: the hub reserves `GatewaySubnet` and `AzureFirewallSubnet` at the sizes those services need, and no template deploys another
service that reserves addresses.

- [35 — Ranges reserved by services](#35--ranges-reserved-by-services)

### Rule ADR-AZ-CAFNETTOP:36

Not adopted: the private IPv4 plan is far from exhausted, so every spoke keeps a unique, routable range.

- [36 — Private Link service against IPv4 exhaustion](#36--private-link-service-against-ipv4-exhaustion)

### Rule ADR-AZ-CAFNETTOP:37

Not adopted: the network is IPv4 only and no workload has IPv6 clients.

- [37 — Dual-stack appliances for IPv6 clients](#37--dual-stack-appliances-for-ipv6-clients)

### Rule ADR-AZ-CAFNETTOP:38

Not adopted: the network is IPv4 only, and no workload has web clients reaching it through Front Door.

- [38 — Front Door for IPv6 web clients](#38--front-door-for-ipv6-web-clients)

### Rule ADR-AZ-CAFNETTOP:39

Not adopted: no virtual network carries an IPv6 block.

- [39 — One IPv6 block per virtual network](#39--one-ipv6-block-per-virtual-network)

### Rule ADR-AZ-CAFNETTOP:40

Not adopted: no network is made dual-stack.

- [40 — Dual stack on an existing IPv4 network](#40--dual-stack-on-an-existing-ipv4-network)

### Rule ADR-AZ-CAFNETTOP:41

Not adopted: the statement holds by construction, since every network is IPv4 only.

- [41 — IPv4 cannot be turned off](#41--ipv4-cannot-be-turned-off)

### Rule ADR-AZ-CAFNETTOP:42

Not adopted: no network or subnet takes an IPv6 block.

- [42 — An IPv6 block for network and subnet](#42--an-ipv6-block-for-network-and-subnet)

### Rule ADR-AZ-CAFNETTOP:43

Not adopted: the route tables carry no IPv6 route, because there is no IPv6 traffic.

- [43 — IPv6 routes in the route tables](#43--ipv6-routes-in-the-route-tables)

### Rule ADR-AZ-CAFNETTOP:44

Not adopted: the security groups carry no IPv6 rule, because there is no IPv6 traffic.

- [44 — IPv6 rules in the security groups](#44--ipv6-rules-in-the-security-groups)

### Rule ADR-AZ-CAFNETTOP:45

Not adopted: no resource needs IPv6.

- [45 — Dual stack or translation where IPv6 is missing](#45--dual-stack-or-translation-where-ipv6-is-missing)

### Rule ADR-AZ-CAFNETTOP:46

Not adopted: every subscription's network takes one /16, so the plan has no sizes to request.

- [46 — Ranges in several sizes](#46--ranges-in-several-sizes)

### Rule ADR-AZ-CAFNETTOP:47

Partly adopted: `network.yml` is the IP address management — templates read their ranges by config address and a new subscription reserves
its range by pull request, validated on load — but no API reserves a range automatically.

- [47 — An IPAM API for infrastructure as code](#47--an-ipam-api-for-infrastructure-as-code)

### Rule ADR-AZ-CAFNETTOP:48

Adopted: the plan is arranged by archetype — hubs in 10.0 and 10.1, spokes from 10.100 upward, the environment networks in 10.10 to 10.40 —
in its one region.

- [48 — A systematic address plan](#48--a-systematic-address-plan)

### Rule ADR-AZ-CAFNETTOP:49

Adopted: a subscription removed from `azure.yml` makes `Test-AzureNetworkPlan` fail until its network leaves `network.yml`, which frees its
range.

- [49 — Ranges returned at decommissioning](#49--ranges-returned-at-decommissioning)

### Rule ADR-AZ-CAFNETTOP:50

Partly adopted: `discovery` gives every workload subnet a security group that denies inbound internet traffic; the subnets are planned
centrally in `network.yml`, not by the landing zone's owner, and no policy requires a security group.

- [50 — Subnets designed by the landing zone owner](#50--subnets-designed-by-the-landing-zone-owner)

### Rule ADR-AZ-CAFNETTOP:51

Partly adopted: every workload subnet has a network security group, but its rules allow all traffic among the peered networks
([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)).

- [51 — Security groups between subnets](#51--security-groups-between-subnets)

### Rule ADR-AZ-CAFNETTOP:52

Not adopted: no template deploys a virtual machine, so an application security group has nothing to group.

- [52 — Application security groups for tiered VMs](#52--application-security-groups-for-tiered-vms)

### Rule ADR-AZ-CAFNETTOP:53

Partly adopted: segmentation is a security group per subnet with no central appliance between them, but the rules are no finer than the
virtual network boundary.

- [53 — Micro-segmentation without a central appliance](#53--micro-segmentation-without-a-central-appliance)

### Rule ADR-AZ-CAFNETTOP:54

Planned: virtual network flow logs with traffic analytics into `foundation`'s workspace, the flow logging
[ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6) and [ADR-AZ-CAFMGMT#4](management.md#rule-adr-az-cafmgmt4) plan.

- [54 — Virtual network flow logs with traffic analytics](#54--virtual-network-flow-logs-with-traffic-analytics)

### Rule ADR-AZ-CAFNETTOP:55

Not adopted: there is no security-group flow log to migrate; the flow logs rule 54 plans are virtual network flow logs from the start.

- [55 — Flow logs moved from security groups to virtual networks](#55--flow-logs-moved-from-security-groups-to-virtual-networks)

### Rule ADR-AZ-CAFNETTOP:56

Partly adopted: a spoke peers only to its hub and no traffic is forwarded, so one spoke cannot reach another; between hub and spoke the
security groups allow all virtual network traffic rather than selected flows.

- [56 — Selective connectivity between landing zones](#56--selective-connectivity-between-landing-zones)

### Rule ADR-AZ-CAFNETTOP:57

Not adopted: there is no Virtual WAN.

- [57 — Firewall routing between landing zones in Virtual WAN](#57--firewall-routing-between-landing-zones-in-virtual-wan)

### Rule ADR-AZ-CAFNETTOP:58

Not adopted: no traffic is force-tunnelled, because no gateway advertises a default route; the security groups carry inbound rules only.

- [58 — Outbound security rules under forced tunnelling](#58--outbound-security-rules-under-forced-tunnelling)

### Rule ADR-AZ-CAFNETTOP:59

Not adopted: there is no Virtual Network Manager, and no management group or tenant for one to reach.

- [59 — Where Virtual Network Manager applies](#59--where-virtual-network-manager-applies)

### Rule ADR-AZ-CAFNETTOP:60

Not adopted: there is no Virtual Network Manager instance and no connectivity subscription apart from the shared ones.

- [60 — A Virtual Network Manager instance in the connectivity subscription](#60--a-virtual-network-manager-instance-in-the-connectivity-subscription)

### Rule ADR-AZ-CAFNETTOP:61

Not adopted: networks are grouped statically by the hub's spoke list in config, not by Virtual Network Manager network groups.

- [61 — Network groups for segmentation](#61--network-groups-for-segmentation)

### Rule ADR-AZ-CAFNETTOP:62

Not adopted: spokes do not talk to each other, so none needs a direct connection.

- [62 — Direct connectivity between spokes](#62--direct-connectivity-between-spokes)

### Rule ADR-AZ-CAFNETTOP:63

Not adopted: one region and no need for every network to reach every other.

- [63 — Global mesh](#63--global-mesh)

### Rule ADR-AZ-CAFNETTOP:64

Not adopted: there are no security admin rules to give a priority.

- [64 — A priority for each security admin rule](#64--a-priority-for-each-security-admin-rule)

### Rule ADR-AZ-CAFNETTOP:65

Not adopted: the flows that must hold are the security group rules `discovery` deploys, owned by the landing zone, not security admin rules
above them.

- [65 — Security admin rules for flows that must hold](#65--security-admin-rules-for-flows-that-must-hold)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation onto Azure, from strategy and planning to running the
estate. Its "Ready" methodology describes the Azure landing zone: the platform an organisation prepares before workloads arrive, built from
a set of design areas, each with its own design considerations and recommendations.

Network topology and connectivity is the design area that decides how the landing zones' networks are laid out and joined. This record
covers its topology half: the traditional hub-and-spoke topology and the Virtual WAN alternative, the IP address plan (IPv6 and IP address
management tools among it), the segmentation inside and between landing zones, and Azure Virtual Network Manager. The connectivity to
on-premises, other clouds, and the internet, and the private access to platform services and its DNS, have records of their own.

These rules are vendor recommendation, not principled theory: they record what Microsoft advises for Azure and what this repository does
about each of the 65 topology recommendations, and they carry no more authority than that. CAF recommendations carry no vendor codes, so a
rule's number is its order across the area's pages: rules 1 to 27 are the traditional topology page, 28 to 49 the IP addressing page (28 to
36 general, 37 and 38 IPv6, 39 to 45 the IPv6 address blocks, 46 to 49 IP address management tools), 50 to 58 the segmentation page, and 59
to 65 the Virtual Network Manager page — the area's recommendations 1 to 49, 97 to 105, and 134 to 140 in page order. The seven items under
the IPv6 address-block heading sit after the IPv6 recommendations and are not labelled as recommendations on the page; they are kept as
rules so that nothing on the page is dropped. The Virtual WAN page and the page on choosing a topology carry no recommendations section, so
they give no rule; Virtual WAN enters through rules 20, 23, and 57. The traditional topology page repeats four of its items (7 and 11, 9 and
14, 10 and 15, 20 and 23); each repeat stays its own rule, and the second points at the first.

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

Each recommendation below cites Microsoft's page — its title, section, link, and retrieval date — and summarises it in our own words.
Nothing is quoted, because the live CAF text is published under the
[Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), not under a reuse licence. The example basis of every
takeaway is the three templates `foundation`, `discovery` (the landing zone), and `expedition` (the workload), deployed in that order
([landing-zones](../landing-zones.md)).

One design answers most of this record. The landing zones form a hub-and-spoke network per subscription: a hub in each shared subscription
(`shared_nonprod`, `shared_prod`), a spoke in each customer subscription, each spoke peered statically and on both sides to the hub of its
tier ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2), [ADR-AZ-LZ#7](../landing-zones.md#rule-adr-az-lz7)). Every range lives in
`automation/Catzc.Azure/configs/network.yml` — hubs 10.0.0.0/16 and 10.1.0.0/16, spokes 10.100.0.0/16 to 10.103.0.0/16 — validated by
`NetworkConfig` and its range arithmetic `NetworkCidr`, and joined to `azure.yml` by `Test-AzureNetworkPlan`
([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5), [ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)).
That file is the repository's IP address management. Each workload subnet has a network security group that allows traffic inside the
virtual networks and denies inbound internet traffic; each spoke subnet has a route table with no routes; the hub's `GatewaySubnet` and
`AzureFirewallSubnet` are reserved and empty. There is no Virtual WAN, no Virtual Network Manager, no IPv6, no on-premises network, and one
region.

### 1 — Hub and spoke as the network design

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 1
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Choose a traditional hub-and-spoke design when the network is regional, or multi-region without much
cross-region transit between landing zones, when no transit between VPN and ExpressRoute is needed, when hybrid links are
mostly ExpressRoute with few VPN connections, and when central appliances and fine-grained routing are relied on.
```

#### What 1 means here

Every condition holds: one region, no VPN, no ExpressRoute, and no transit between landing zones. The repository's topology is hub-and-spoke
by design ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)): the hub of a tier is the landing zone of a shared subscription, each spoke
the landing zone of a customer subscription, and `network.yml` declares the kind of each (`kind: hub`, `kind: spoke`) so a template reads it
from the plan alone ([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)). The network is a segmentation boundary as
[ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4) decides: one spoke per customer and tier.

##### 1 in `foundation`

Not applicable: `foundation` deploys the workspace and the Key Vault of a subscription and no network.

##### 1 in `discovery`

Deploys the hub or the spoke of its subscription, chosen by `networkKind` from `global.network.subscriptions.<name>.kind`; a spoke peers to
its `hub`, a hub peers to every entry of its `spokes` list (`vnet-peering.bicep`).

##### 1 in `expedition`

Lands in a spoke's `private-endpoints` subnet, or the shared platform's in the hub's `shared-services` subnet, and creates no network
([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)).

##### 1 status

realised — the landing zones form a hub-and-spoke network declared in `network.yml` and deployed by `discovery`.

### 2 — A regional hub with spokes peered to it

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 2
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): For a regional deployment, put one hub in each region and peer the spokes to it. The hub serves ExpressRoute
through two peering locations, branch VPN, spoke-to-spoke traffic through appliances and user-defined routes, and protects
outbound internet traffic with Azure Firewall or a partner appliance.
```

#### What 2 means here

The repository has one region and a hub per tier, not per region: `shared_nonprod` for the non-production spokes, `shared_prod` for the
production ones. The hub's services are reserved, not deployed: `GatewaySubnet` (for a VPN or ExpressRoute gateway) and
`AzureFirewallSubnet` exist in the plan so either can be added without renumbering, and nothing is deployed into them
([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)). There is no hybrid link to serve and no spoke-to-spoke traffic to
route; filtered egress is the firewall of rule 7.

##### 2 in `foundation`

Not applicable: `foundation` deploys no network.

##### 2 in `discovery`

The hub configs (`nsub.yml`, `psub.yml`) list the spokes of their tier; each spoke config names its hub. The reserved subnets get no network
security group and no route table. The peerings use the module defaults of `vnet-peering.bicep`: no gateway transit and no forwarded
traffic, which a gateway or a firewall in the hub would change.

##### 2 in `expedition`

Not applicable: the workload uses the spoke and creates no network.

##### 2 status

partly realised — a hub per tier with its spokes peered; the hub's gateway and firewall are reserved, and the firewall is planned
(follow-up) under rule 7.

### 3 — The hub-and-spoke diagram

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 3
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): A diagram of the hub-and-spoke topology, offered as the configuration that meets most segmentation and
inspection needs.
```

#### What 3 means here

The diagram illustrates rules 1 and 2 and adds nothing to decide. The repository's topology is the one it shows, without the gateway and the
firewall in the hub.

##### 3 status

realised — the topology is the one of rule 1.

### 4 — Several networks on several ExpressRoute circuits

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 4
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Connect several hub networks over several ExpressRoute circuits at different peering locations when business
units need strong isolation, dedicated bandwidth, or more connections than one gateway allows.
```

#### What 4 means here

The repository has no ExpressRoute circuit and no on-premises network. Customers are isolated by subscription and by spoke, not by a circuit
of their own. A customer that brings its own private link to Azure would be the trigger; its circuit would then decide whether its spoke
needs a hub apart from the shared one.

##### 4 status

not adopted, because there is no ExpressRoute circuit.

### 5 — The multi-circuit diagram

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 5
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): A diagram of the topology of recommendation 4, with several hubs on several ExpressRoute circuits.
```

#### What 5 means here

The diagram illustrates rule 4 and follows its answer.

##### 5 status

not adopted, because rule 4 is not adopted.

### 6 — ExpressRoute Metro for dual-homed peering

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 6
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): For dual-homed peering within one city, consider ExpressRoute Metro.
```

#### What 6 means here

There is no ExpressRoute circuit, so there is nothing to dual-home. The connectivity record decides how the repository reaches on-premises
networks.

##### 6 status

not adopted, because there is no ExpressRoute circuit.

### 7 — A firewall or network appliance in the hub

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 7
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Put Azure Firewall or a partner network appliance in the hub to filter traffic between spokes and traffic to
and from the internet.
```

#### What 7 means here

The hub reserves `AzureFirewallSubnet` in `network.yml` and deploys nothing into it, so egress is not filtered: the spoke route tables carry
no routes and traffic leaves through Azure's default route. [ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6) plans egress through a
firewall. Spoke-to-spoke traffic needs no filter, because no spoke reaches another (rule 56).

##### 7 in `foundation`

Not applicable: `foundation` deploys no network.

##### 7 in `discovery`

Should deploy Azure Firewall into the hub's `AzureFirewallSubnet`, and pass the spoke's route table (`route-table.bicep`, `routes`) a
default route to the firewall's private address. The spoke-side peering then needs `allowForwardedTraffic` in `vnet-peering.bicep`.

##### 7 in `expedition`

Not applicable: the workload's traffic follows its spoke's route table and needs no change of its own.

##### 7 status

planned (follow-up) — a firewall in the hub and a default route to it in every spoke.

### 8 — A minimal set of shared services in the hub

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 8
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Keep the hub to a minimal set of shared services: the ExpressRoute and VPN gateways, the firewall or
appliances, and where needed domain controllers and DNS servers.
```

#### What 8 means here

A hub carries exactly `GatewaySubnet`, `AzureFirewallSubnet`, and `shared-services`
([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)), and holds the private DNS zones every spoke resolves through. That is
the minimal set, with one addition: the shared platform's own workload places its private endpoints in `shared-services`, so the hub
subscription also runs a workload. That keeps the shared platform's workloads in the shared subscriptions; the cost is that the hub's
subscription carries a workload's resources beside the connectivity.

##### 8 in `foundation`

Not applicable: `foundation` deploys no network.

##### 8 in `discovery`

The hub deploys the virtual network, a security group on `shared-services`, the private DNS zones for SQL Database and Blob Storage, and its
peerings — nothing else of the network.

##### 8 in `expedition`

The shared platform's configs at the configuration root (`dev.yml`, `test.yml`) place their private endpoints in the hub's `shared-services`
subnet. A customer's configs land in its spoke.

##### 8 status

partly realised — the hub holds only shared network services and DNS, plus the shared platform's own workload in `shared-services`.

### 9 — One DDoS Protection plan in the connectivity subscription

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 9
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Deploy one DDoS Protection plan in the connectivity subscription and use it for every landing zone and
platform virtual network.
```

#### What 9 means here

No workload has a public endpoint: data services take private endpoints only, and the landing zone's policy denies a public IP address on a
network interface ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)). A DDoS Protection plan protects public addresses, so it has nothing
to protect ([ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6)). The first public ingress — a gateway, a firewall, or an inbound
application proxy — would make it apply, as one plan per hub subscription that the hub and its spokes reference.

##### 9 status

not adopted, because no network has a public address to protect.

### 10 — Branches over the existing wide-area network

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 10
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Connect branches to headquarters over the existing private wide-area or SD-WAN network; without Route Server, Azure does
not carry traffic between ExpressRoute and VPN.
```

#### What 10 means here

The repository connects no on-premises site or branch to Azure. The connectivity record decides hybrid links.

##### 10 status

not adopted, because there is no on-premises network or branch.

### 11 — A firewall or network appliance in the hub, repeated

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 11
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Repeats recommendation 7: filter traffic between spokes and to and from the internet with Azure Firewall
or partner appliances in the hub.
```

#### What 11 means here

The page states recommendation 7 a second time. Rule 7 decides it: a firewall in the reserved `AzureFirewallSubnet` is planned.

##### 11 status

planned (follow-up) — as rule 7.

### 12 — Partner appliances deployed to their vendor guidance

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 12
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Deploy partner networking appliances as their vendor advises, so the deployment is supported, highly
available, and performs well, and does not conflict with Azure networking.
```

#### What 12 means here

No partner appliance is deployed. The planned firewall of rule 7 is Azure Firewall, a managed service, so this recommendation would apply
only if a partner appliance replaced it.

##### 12 status

not adopted, because no partner appliance is deployed.

### 13 — No shared inbound application proxy in the hub

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 13
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Do not run Application Gateway or a similar inbound application-level device as a shared service in the
hub; it belongs in the landing zone of the application it serves.
```

#### What 13 means here

The hub deploys no inbound application proxy, and no workload has inbound web traffic. A workload that needs one deploys it with its own
resources, as `expedition` deploys its own storage and database, and the landing zone owns only the network
([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)). The connectivity record decides application delivery itself.

##### 13 status

realised — the hub holds no inbound application proxy.

### 14 — One DDoS Protection plan, repeated

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 14
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Repeats recommendation 9: one DDoS Protection plan in the connectivity subscription.
```

#### What 14 means here

The page states recommendation 9 a second time. Rule 9 decides it.

##### 14 status

not adopted, because no network has a public address to protect (rule 9).

### 15 — Branches over the existing network, repeated

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 15
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Repeats recommendation 10: connect branches over the existing private wide-area or SD-WAN network.
```

#### What 15 means here

The page states recommendation 10 a second time. Rule 10 decides it.

##### 15 status

not adopted, because there is no on-premises network or branch (rule 10).

### 16 — Route Server for transit between ExpressRoute and VPN

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 16
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): When traffic must pass between ExpressRoute and VPN gateways in a hub-and-spoke network, use Azure Route
Server.
```

#### What 16 means here

The hub reserves `GatewaySubnet` but deploys no gateway of either kind, so there is no transit to provide.

##### 16 status

not adopted, because there is no ExpressRoute or VPN gateway.

### 17 — Global peering for a few cross-region spokes

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 17
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): With hubs in several regions and only a few landing zones that must talk across regions, peer those spokes
directly with global peering; it is fast but bypasses the hub appliances.
```

#### What 17 means here

Every environment maps to one region ([ADR-AZ-NETWORK#3](../azure-network-model.md#rule-adr-az-network3)), and every environment of the
repository deploys to West Europe, so there is no second region to reach. A second region would be a new environment with its own range in
`network.yml`, and this rule would then decide how its spokes reach the first region's.

##### 17 status

not adopted, because there is one region.

### 18 — Hub-to-hub routing for most cross-region traffic

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 18
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): When most landing zones talk across regions, or bypassing the hub appliances is unacceptable, route between
hubs through their appliances, over global peering (fast, billed by traffic) or ExpressRoute (more latency, bound by the
gateway size).
```

#### What 18 means here

One region, so there is no cross-region traffic to route. See rule 17 for what would change it.

##### 18 status

not adopted, because there is one region.

### 19 — Two regions with peered hubs

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 19
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): To connect two regions, peer their two hubs with global peering.
```

#### What 19 means here

The two hubs of the repository share one region and serve two tiers, not two regions. They are not peered on purpose: production and
non-production are separated by subscription ([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)), and a peering between their hubs
would join the two tiers' networks.

##### 19 status

not adopted, because there is one region and the two hubs separate the tiers.

### 20 — Virtual WAN for global transit

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 20
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Move to a managed global transit network based on Virtual WAN when hub-and-spoke must span more than two
regions, landing zones need global transit between them, and management overhead must stay low.
```

#### What 20 means here

None of the three conditions holds: one region, no transit between landing zones, and a topology small enough to declare in config. A
Virtual WAN hub would replace `discovery`'s hub virtual network, its static peerings, and the reserved subnets. Microsoft's Virtual WAN
topology page carries no recommendations section, so this rule, rule 23, and rule 57 are the record's whole answer to it.

##### 20 status

not adopted, because the network spans one region and needs no global transit.

### 21 — Every regional hub on the same ExpressRoute circuits

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 21
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Beyond two regions, connect every regional hub to the same ExpressRoute circuits instead of maintaining a
mesh of peerings and user-defined routes.
```

#### What 21 means here

There is one region and no ExpressRoute circuit.

##### 21 status

not adopted, because there is one region and no ExpressRoute circuit.

### 22 — Inspection of cross-region traffic learned over BGP

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 22
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): When ExpressRoute carries cross-region traffic, spokes learn each other's routes over BGP and skip the
firewall; to force inspection, add specific routes to the local hub firewall or stop BGP propagation on the spoke route
tables.
```

#### What 22 means here

No gateway exists, so no route is learned over BGP. The spoke route tables are empty, and `route-table.bicep` exposes
`disableBgpRoutePropagation` for the day a gateway arrives; the firewall of rule 7 would bring the routes this recommendation describes.

##### 22 status

not adopted, because there is no ExpressRoute and no learned route.

### 23 — Virtual WAN for global transit, repeated

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 23
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Repeats recommendation 20: Virtual WAN for hub-and-spoke across more than two regions with global transit
and low management overhead.
```

#### What 23 means here

The page states recommendation 20 a second time. Rule 20 decides it.

##### 23 status

not adopted, because the network spans one region and needs no global transit (rule 20).

### 24 — One resource group per region for hub resources

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 24
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Deploy each region's hub network resources into a resource group of their own.
```

#### What 24 means here

Each hub deploys into one resource group, created by `discovery` in the hub's region and named with its region code by the naming standard
([naming-standard](../azure-naming-standard.md)): `nsub-weu-zct-disco-rg` for the non-production hub, `psub-weu-zct-disco-rg` for the
production one. A hub in a second region would get its own config and therefore its own resource group.

##### 24 in `foundation`

Not applicable: `foundation`'s resource group holds the workspace and the vault, apart from the hub's.

##### 24 in `discovery`

`resourceGroupName` in each hub config names the one resource group that holds the hub's virtual network, security group, peerings, and
private DNS zones.

##### 24 in `expedition`

Not applicable: the workload deploys into its own resource group per configuration slot.

##### 24 status

realised — one resource group per hub, in its region.

### 25 — Virtual Network Manager for connectivity and security

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 25
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Manage connectivity and security configuration across subscriptions with Azure Virtual Network Manager.
```

#### What 25 means here

The repository manages connectivity in config: each spoke names its hub and each hub lists its spokes, and `discovery` deploys both sides of
every peering ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)). The security rules are the same per subnet, deployed by the same
template. Virtual Network Manager would move both into a service that reaches across subscriptions from above them; rules 59 to 65 weigh it
in detail.

##### 25 status

not adopted, because connectivity and security rules are declared in config and deployed per subscription.

### 26 — Network Watcher network insights

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 26
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Monitor the end-to-end state of the network with Network Watcher's network insights.
```

#### What 26 means here

`discovery` sends the virtual network's and every security group's logs and metrics to `foundation`'s Log Analytics workspace
(`diagnostic-setting.bicep`), but the templates deploy no Network Watcher resource and configure no flow log or connection monitor. The flow
logs of rule 54 run on Network Watcher, so the network view this recommendation asks for arrives with them.

##### 26 in `foundation`

The workspace receives the network diagnostics and would receive the flow logs.

##### 26 in `discovery`

Should declare the subscription's Network Watcher in the network's resource group together with the flow logs of rule 54.

##### 26 in `expedition`

Not applicable: the workload deploys no network resource.

##### 26 status

planned (follow-up) — with the flow logs of rule 54.

### 27 — Peering and route-advertisement limits

```text
CAF Network topology and connectivity — Traditional Azure networking topology — recommendation 27
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology
  (retrieved 2026-10-15)
Summary (ours): Keep the number of spokes per hub within the peering limit of a virtual network and within the number of
prefixes ExpressRoute private peering can advertise.
```

#### What 27 means here

A hub peers to every spoke of its tier, so the hub's `spokes` list is the number that meets the peering limit. The non-production hub lists
three spokes and the production hub one, far below the limit. There is no ExpressRoute, so no prefix is advertised. No check counts a hub's
spokes; a tier that grows towards the limit would need a second hub, which `network.yml` can hold as another shared subscription.

##### 27 in `foundation`

Not applicable: `foundation` deploys no network.

##### 27 in `discovery`

The `spokes` list in `nsub.yml` and `psub.yml` holds the peerings that count.

##### 27 in `expedition`

Not applicable: the workload creates no peering.

##### 27 status

realised — each hub's peerings are far below the limit, and there is no ExpressRoute prefix.

### 28 — Non-overlapping address spaces

```text
CAF Network topology and connectivity — Plan for IP addressing — recommendation 28
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Plan the address spaces in advance so that no two Azure regions or on-premises locations overlap.
```

#### What 28 means here

`network.yml` is the one home of every range ([ADR-AZ-NETWORK#1](../azure-network-model.md#rule-adr-az-network1)), and `NetworkConfig`
rejects the file when any two of its networks overlap, environment or subscription, or a subnet leaves its network
([ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)). Any hub can therefore peer to any spoke. There is no on-premises range
to keep clear of; one would enter the plan as a further entry so the same check covers it.

##### 28 in `foundation`

Not applicable: `foundation` deploys no network.

##### 28 in `discovery`

Reads `vnetAddressSpace` and `subnetPrefixes` from `global.network.subscriptions.<name>` by config address, so it deploys only ranges the
check has passed.

##### 28 in `expedition`

Not applicable: the workload uses the spoke's subnets by name and holds no range.

##### 28 status

realised — the plan rejects any overlap when it loads.

### 29 — Private address ranges

```text
CAF Network topology and connectivity — Plan for IP addressing — recommendation 29
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Take addresses from the private ranges set aside for private networks (RFC 1918).
```

#### What 29 means here

Every network in `network.yml` lies inside 10.0.0.0/8: hubs at 10.0 and 10.1, spokes from 10.100, the environment networks from 10.10 to
10.40. `NetworkCidr` checks that each range is an aligned IPv4 range, but nothing checks that it is private, so a public range would load. A
private-range check in `NetworkConfig` would make this rule, rule 30, and rule 34 hold by construction.

##### 29 in `foundation`

Not applicable: `foundation` deploys no network.

##### 29 in `discovery`

Deploys whatever range the plan holds, so the check belongs to the plan, not the template.

##### 29 in `expedition`

Not applicable: the workload holds no range.

##### 29 status

partly realised — every range is private; a check that rejects a non-private range is planned (follow-up).

### 30 — No reserved address ranges

```text
CAF Network topology and connectivity — Plan for IP addressing — recommendation 30
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Do not use multicast, broadcast, loopback, or link-local ranges, or the address Azure reserves for its own
DNS.
```

#### What 30 means here

None of these ranges is inside 10.0.0.0/8, so the plan avoids them all. Nothing rejects them either; the private-range check of rule 29
would, since every one of them lies outside the private ranges.

##### 30 in `foundation`

Not applicable: `foundation` deploys no network.

##### 30 in `discovery`

As rule 29: the template deploys the plan's ranges.

##### 30 in `expedition`

Not applicable: the workload holds no range.

##### 30 status

partly realised — no reserved range is used; the check of rule 29 is planned (follow-up).

### 31 — IPv6 where private IPv4 is scarce

```text
CAF Network topology and connectivity — Plan for IP addressing — recommendation 31
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Where private IPv4 addresses are scarce, consider IPv6; a virtual network can be IPv4 only or dual-stack.
```

#### What 31 means here

Six /16 subscription networks and four /16 environment networks use a small part of 10.0.0.0/8, so private IPv4 is not scarce. The plan is
IPv4 only: `NetworkCidr` parses IPv4 ranges and nothing else. Exhaustion of the private block would be the trigger, and the plan, its type,
and `virtual-network.bicep` would then take an IPv6 range beside each IPv4 one.

##### 31 status

not adopted, because private IPv4 is plentiful and the plan is IPv4 only.

### 32 — No oversized virtual networks

```text
CAF Network topology and connectivity — Plan for IP addressing — recommendation 32
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Avoid large virtual networks such as a /16, so addresses are not wasted; IPv4 subnets range from /29 to /2,
and IPv6 subnets are exactly /64.
```

#### What 32 means here

Every network in the plan is a /16, and its subnets are /24 (the reserved `GatewaySubnet` a /27 and `AzureFirewallSubnet` a /26). That
spends address space for a simple, even plan: one second octet per network, so a range reads its owner at a glance, and a spoke can grow
subnets without renumbering. The cost is waste — a spoke uses three /24s of its 256 — which matters only if the private block runs short or
the plan meets on-premises ranges. Either would be the trigger for smaller networks, sized as rule 46 describes.

##### 32 in `foundation`

Not applicable: `foundation` deploys no network.

##### 32 in `discovery`

Deploys the /16 of its subscription from `network.yml`.

##### 32 in `expedition`

Not applicable: the workload holds no range.

##### 32 status

not adopted, because a /16 per network keeps the plan simple and the private block far from full.

### 33 — Address space planned before the network

```text
CAF Network topology and connectivity — Plan for IP addressing — recommendation 33
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Do not create a virtual network before its address space is planned.
```

#### What 33 means here

A virtual network gets its address space only from `network.yml`, through a config address in the template's parameter file
([ADR-AZ-NETWORK#1](../azure-network-model.md#rule-adr-az-network1)), and `Test-AzureNetworkPlan` requires a network entry for every
subscription in `azure.yml` ([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)). A network without a planned range cannot
be deployed: its config address does not resolve and the build fails.

##### 33 in `foundation`

Not applicable: `foundation` deploys no network.

##### 33 in `discovery`

`vnetAddressSpace` and `subnetPrefixes` are config addresses (`global.network.subscriptions.apex_nonprod.vnet_address_space`), never literal
ranges.

##### 33 in `expedition`

Not applicable: the workload holds no range.

##### 33 status

realised — every network's range is planned in `network.yml` before the network exists.

### 34 — No public ranges for virtual networks

```text
CAF Network topology and connectivity — Plan for IP addressing — recommendation 34
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Do not address virtual networks from public ranges, least of all from public ranges the organisation does not
own.
```

#### What 34 means here

No network in the plan uses a public range, but nothing rejects one. The private-range check of rule 29 would.

##### 34 in `foundation`

Not applicable: `foundation` deploys no network.

##### 34 in `discovery`

As rule 29: the template deploys the plan's ranges.

##### 34 in `expedition`

Not applicable: the workload holds no range.

##### 34 status

partly realised — no public range is used; the check of rule 29 is planned (follow-up).

### 35 — Ranges reserved by services

```text
CAF Network topology and connectivity — Plan for IP addressing — recommendation 35
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Account for the services that reserve address ranges of their own, such as Kubernetes with Azure CNI.
```

#### What 35 means here

The services that need dedicated subnets are the ones the hub reserves: `GatewaySubnet` (a /27) for a VPN or ExpressRoute gateway and
`AzureFirewallSubnet` (a /26) for Azure Firewall, each at the size the service requires and under the name Azure requires
([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)). The workload's services — storage and SQL Database behind private
endpoints — take one address per endpoint in `private-endpoints`, and no template deploys Kubernetes or another service that reserves a
range.

##### 35 in `foundation`

Not applicable: `foundation` deploys no network.

##### 35 in `discovery`

Deploys both reserved subnets in the hub with no security group and no route table, so a gateway or a firewall can take them as they are.

##### 35 in `expedition`

Places one private endpoint per data service in its subnet.

##### 35 status

realised — the reserved subnets are sized for their services, and no deployed service reserves more.

### 36 — Private Link service against IPv4 exhaustion

```text
CAF Network topology and connectivity — Plan for IP addressing — recommendation 36
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Counter IPv4 exhaustion with spoke networks that are not routed to the rest of the estate, reached through
Azure Private Link service.
```

#### What 36 means here

The private block is far from exhausted (rule 31), so every spoke keeps a unique range and is routable to its hub. Spokes that reuse a range
would break the overlap check that guarantees any hub can peer to any spoke
([ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)).

##### 36 status

not adopted, because private IPv4 is plentiful and every spoke has a unique range.

### 37 — Dual-stack appliances for IPv6 clients

```text
CAF Network topology and connectivity — Plan for IP addressing — IPv6 considerations — recommendation 37
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): To serve IPv6 clients from an IPv4-only back end, run dual-stack network appliances in a flexible virtual
machine scale set behind a public Standard Load Balancer, translating to IPv4 for the application subnet.
```

#### What 37 means here

No workload has a client on the internet, IPv6 or otherwise, and the network is IPv4 only.

##### 37 status

not adopted, because there are no IPv6 clients.

### 38 — Front Door for IPv6 web clients

```text
CAF Network topology and connectivity — Plan for IP addressing — IPv6 considerations — recommendation 38
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Alternatively, let Front Door take IPv6 web clients and proxy them to an IPv4 back end; appliances inside the
network and a global Front Door can also be combined.
```

#### What 38 means here

No workload serves web clients, and the connectivity record decides application delivery.

##### 38 status

not adopted, because there are no IPv6 web clients.

### 39 — One IPv6 block per virtual network

```text
CAF Network topology and connectivity — Plan for IP addressing — IPv6 virtual network CIDR blocks — recommendation 39
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): A virtual network takes one IPv6 block; give subnets a /64, which also keeps routing to on-premises
networks possible.
```

#### What 39 means here

The network is IPv4 only (rule 31). If IPv6 were adopted, `network.yml` would carry one IPv6 block per network beside its IPv4 range, and
the subnet sizes would follow this rule.

##### 39 status

not adopted, because the network is IPv4 only.

### 40 — Dual stack on an existing IPv4 network

```text
CAF Network topology and connectivity — Plan for IP addressing — IPv6 virtual network CIDR blocks — recommendation 40
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): An IPv4-only virtual network can be made dual-stack; the two protocols then work independently.
```

#### What 40 means here

This is what makes rule 31 cheap to revisit: the existing networks could take IPv6 without being rebuilt. The network is IPv4 only.

##### 40 status

not adopted, because the network is IPv4 only.

### 41 — IPv4 cannot be turned off

```text
CAF Network topology and connectivity — Plan for IP addressing — IPv6 virtual network CIDR blocks — recommendation 41
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): IPv4 support cannot be removed from a virtual network.
```

#### What 41 means here

A statement about Azure, not a choice. Every network carries IPv4 and nothing else, so it asks nothing of the repository.

##### 41 status

not adopted, because the network is IPv4 only and the statement asks for no action.

### 42 — An IPv6 block for network and subnet

```text
CAF Network topology and connectivity — Plan for IP addressing — IPv6 virtual network CIDR blocks — recommendation 42
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Give the virtual network and its subnets an IPv6 block, Azure-assigned or brought by the organisation; the
item also explains IPv4 and IPv6 address notation.
```

#### What 42 means here

The network is IPv4 only (rule 31).

##### 42 status

not adopted, because the network is IPv4 only.

### 43 — IPv6 routes in the route tables

```text
CAF Network topology and connectivity — Plan for IP addressing — IPv6 virtual network CIDR blocks — recommendation 43
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Add IPv6 routes to the route tables, sending public IPv6 traffic to the VPN or ExpressRoute gateway.
```

#### What 43 means here

The spoke route tables carry no routes at all, and there is no IPv6 traffic and no gateway.

##### 43 status

not adopted, because the network is IPv4 only.

### 44 — IPv6 rules in the security groups

```text
CAF Network topology and connectivity — Plan for IP addressing — IPv6 virtual network CIDR blocks — recommendation 44
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Add explicit IPv6 rules to the network security groups.
```

#### What 44 means here

The security group rules in `discovery` use service tags (`VirtualNetwork`, `Internet`), not address ranges, so they would cover IPv6
traffic as well if the network carried any. The network is IPv4 only.

##### 44 status

not adopted, because the network is IPv4 only.

### 45 — Dual stack or translation where IPv6 is missing

```text
CAF Network topology and connectivity — Plan for IP addressing — IPv6 virtual network CIDR blocks — recommendation 45
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Where a resource does not support IPv6, use dual stack or an appliance that translates.
```

#### What 45 means here

No resource needs IPv6, so none needs a fallback.

##### 45 status

not adopted, because the network is IPv4 only.

### 46 — Ranges in several sizes

```text
CAF Network topology and connectivity — Plan for IP addressing — IP address management tools — recommendation 46
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Let landing zones request ranges of different sizes, for example small, medium, and large ranges of /24,
/22, and /20.
```

#### What 46 means here

Every subscription's network is a /16 (rule 32), so there is one size and nothing to choose. A plan with sizes would let `network.yml`
declare a size per subscription and `NetworkConfig` check it; it becomes worth having when rule 32 changes.

##### 46 in `foundation`

Not applicable: `foundation` deploys no network.

##### 46 in `discovery`

Deploys the size the plan gives; nothing in the template depends on it being a /16.

##### 46 in `expedition`

Not applicable: the workload holds no range.

##### 46 status

not adopted, because every network takes one /16.

### 47 — An IPAM API for infrastructure as code

```text
CAF Network topology and connectivity — Plan for IP addressing — IP address management tools — recommendation 47
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): The IP address management tool needs an API, so that infrastructure as code and subscription vending can
reserve non-overlapping ranges automatically.
```

#### What 47 means here

`network.yml` is the repository's IP address management. Infrastructure as code reads it directly: a template's parameter file names a range
by config address and the build resolves it ([ADR-AZ-NETWORK#1](../azure-network-model.md#rule-adr-az-network1)). A range is reserved by
pull request — the same pull request that adds the subscription to `azure.yml` and gives it its configs — and `NetworkConfig` and
`Test-AzureNetworkPlan` validate it on load. What is missing is an API that picks the next free range: the author chooses it, and the
overlap check catches a clash. With a handful of subscriptions a person choosing the next second octet is enough.

##### 47 in `foundation`

Not applicable: `foundation` deploys no network.

##### 47 in `discovery`

Reads every range from the plan by config address.

##### 47 in `expedition`

Not applicable: the workload holds no range.

##### 47 status

partly realised — the plan is read by config address and validated on load; no API reserves a range.

### 48 — A systematic address plan

```text
CAF Network topology and connectivity — Plan for IP addressing — IP address management tools — recommendation 48
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Arrange the address spaces systematically, by region and by workload archetype.
```

#### What 48 means here

The plan is arranged by archetype: hubs take 10.0 and 10.1, spokes take 10.100 upward one /16 each, and the per-environment networks take
10.10 to 10.40, as the header of `network.yml` describes. Within a spoke, `private-endpoints` is the first /24 and the workload subnets
follow in environment order. Region is not a dimension, because every environment maps to one region
([ADR-AZ-NETWORK#3](../azure-network-model.md#rule-adr-az-network3)).

##### 48 in `foundation`

Not applicable: `foundation` deploys no network.

##### 48 in `discovery`

Deploys the arrangement as the plan gives it.

##### 48 in `expedition`

Finds its subnet by name (`private-endpoints`, or `shared-services` for the shared platform), never by range.

##### 48 status

realised — the plan is arranged by hub and spoke in its one region.

### 49 — Ranges returned at decommissioning

```text
CAF Network topology and connectivity — Plan for IP addressing — IP address management tools — recommendation 49
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing
  (retrieved 2026-10-15)
Summary (ours): Decommissioning a workload includes returning its address ranges to the pool for reuse.
```

#### What 49 means here

The plan follows the subscriptions: `Test-AzureNetworkPlan` fails a network whose subscription is not in `azure.yml`, and a spoke subnet for
an environment the subscription does not serve ([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)). Removing a subscription
or an environment therefore forces its range out of `network.yml` in the same pull request, and the range is free for the next entry.

##### 49 in `foundation`

Not applicable: `foundation` deploys no network.

##### 49 in `discovery`

The hub's `spokes` list loses the decommissioned spoke in the same change, so the hub drops its peering and zone links.

##### 49 in `expedition`

Not applicable: the workload holds no range.

##### 49 status

realised — a range leaves the plan with its subscription or environment.

### 50 — Subnets designed by the landing zone owner

```text
CAF Network topology and connectivity — Plan for landing zone network segmentation — recommendation 50
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation
  (retrieved 2026-10-15)
Summary (ours): Let landing zone owners design their own subnets, and have the platform team use policy to guarantee every
subnet a network security group with baseline deny rules, such as no SSH or RDP from the internet.
```

#### What 50 means here

The repository plans subnets centrally: a spoke's subnets are fixed by its kind — `private-endpoints` and one per environment it serves —
and live in `network.yml` ([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)). One repository owns every landing zone, so
there is no separate owner to delegate to. The guarantee CAF asks of policy, the template gives: `discovery` attaches a security group to
every subnet named in `networkSecurityGroupNames`, and its rules deny all inbound internet traffic, SSH and RDP among it. No policy requires
a security group, so a subnet created outside the template would have none; the segmentation
[ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4) decides holds for what the repository deploys.

##### 50 in `foundation`

Not applicable: `foundation` deploys no network.

##### 50 in `discovery`

Every workload subnet in a spoke and `shared-services` in the hub have a security group; the reserved subnets have none. A built-in policy
that requires a security group on every subnet, assigned beside the three of [ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3) with the
reserved subnets exempt, is the planned addition.

##### 50 in `expedition`

Not applicable: the workload creates no subnet.

##### 50 status

partly realised — every workload subnet gets a security group denying inbound internet traffic from the template; a policy that requires one
is planned (follow-up).

### 51 — Security groups between subnets

```text
CAF Network topology and connectivity — Plan for landing zone network segmentation — recommendation 51
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation
  (retrieved 2026-10-15)
Summary (ours): Use network security groups to control traffic between subnets and between landing zones.
```

#### What 51 means here

Every workload subnet has a security group ([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)), but its inbound rules allow any
traffic tagged `VirtualNetwork` — every address of the local network and of the networks peered to it — and deny the internet. Traffic
between subnets of one spoke, and between a spoke and its hub, is therefore allowed in full. A spoke's `dev` and `test` subnets can reach
each other, which separates the environments by subnet but not by rule.

##### 51 in `foundation`

Not applicable: `foundation` deploys no network.

##### 51 in `discovery`

The `securityRules` of `main.bicep` are the same for every subnet. Rules per subnet — for example `private-endpoints` reachable only from
the workload subnets of the same spoke, and the environment subnets not from each other — would make this rule hold.

##### 51 in `expedition`

Not applicable: the workload's private endpoints sit behind the spoke's security group (`privateEndpointNetworkPolicies` is `Enabled` by
default in `virtual-network.bicep`).

##### 51 status

partly realised — a security group on every workload subnet; rules per subnet are planned (follow-up).

### 52 — Application security groups for tiered VMs

```text
CAF Network topology and connectivity — Plan for landing zone network segmentation — recommendation 52
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation
  (retrieved 2026-10-15)
Summary (ours): Workload teams protect virtual machines in tiers with application security groups inside the subnet's
network security group rules.
```

#### What 52 means here

No template deploys a virtual machine; the workload is platform services behind private endpoints. A workload with virtual machines in tiers
would bring application security groups in its own template and rules naming them in the spoke's security group.

##### 52 status

not adopted, because no template deploys a virtual machine.

### 53 — Micro-segmentation without a central appliance

```text
CAF Network topology and connectivity — Plan for landing zone network segmentation — recommendation 53
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation
  (retrieved 2026-10-15)
Summary (ours): Segment traffic inside a landing zone with network security groups and application security groups rather
than sending it through a central appliance.
```

#### What 53 means here

The shape is the recommended one: segmentation inside a spoke is a security group per subnet, and no central appliance filters traffic
between subnets ([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)). The rules are coarse, as rule 51 describes, so the segments are
drawn but not separated by rule.

##### 53 in `foundation`

Not applicable: `foundation` deploys no network.

##### 53 in `discovery`

Holds the security groups, and the rules per subnet of rule 51 would complete it.

##### 53 in `expedition`

Not applicable: the workload creates no security group.

##### 53 status

partly realised — segmentation by security group per subnet, with no central appliance; finer rules are planned (follow-up) under rule 51.

### 54 — Virtual network flow logs with traffic analytics

```text
CAF Network topology and connectivity — Plan for landing zone network segmentation — recommendation 54
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation
  (retrieved 2026-10-15)
Summary (ours): Turn on virtual network flow logs with traffic analytics, at least on the critical networks, for insight
into traffic, investigation, and compliance.
```

#### What 54 means here

No network logs its flows. The security groups and the virtual network send their resource logs and metrics to `foundation`'s workspace, not
their flows. [ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6) and [ADR-AZ-CAFMGMT#4](management.md#rule-adr-az-cafmgmt4) plan virtual
network flow logs with traffic analytics into that workspace; this rule is the same plan, seen from segmentation.

##### 54 in `foundation`

The workspace would receive the traffic analytics.

##### 54 in `discovery`

Should deploy a virtual network flow log on its network with traffic analytics pointing at `foundation`'s workspace, together with the
Network Watcher of rule 26 and a storage account for the raw flow records.

##### 54 in `expedition`

Not applicable: the workload deploys no network.

##### 54 status

planned (follow-up) — virtual network flow logs with traffic analytics in `discovery`.

### 55 — Flow logs moved from security groups to virtual networks

```text
CAF Network topology and connectivity — Plan for landing zone network segmentation — recommendation 55
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation
  (retrieved 2026-10-15)
Summary (ours): Plan the migration of existing network security group flow logs to virtual network flow logs.
```

#### What 55 means here

No security group logs its flows, so there is nothing to migrate. The flow logs rule 54 plans are virtual network flow logs from the start.

##### 55 status

not adopted, because there is no security group flow log to migrate.

### 56 — Selective connectivity between landing zones

```text
CAF Network topology and connectivity — Plan for landing zone network segmentation — recommendation 56
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation
  (retrieved 2026-10-15)
Summary (ours): Use network security groups to allow connectivity between landing zones selectively.
```

#### What 56 means here

The topology does most of this work. A spoke peers only to its hub, and peering does not carry traffic onward: with no appliance in the hub
and no forwarded traffic on the peerings (`allowForwardedTraffic` is off in `vnet-peering.bicep`), one customer's spoke cannot reach
another's. Hub and spoke can reach each other fully, because the security groups allow all `VirtualNetwork` traffic, which includes the
peered network. Selective rules — the hub's `shared-services` reachable from a spoke only on the ports a shared service needs — are the
rules per subnet of rule 51.

##### 56 in `foundation`

Not applicable: `foundation` deploys no network.

##### 56 in `discovery`

The peerings (`hub`, `spokes`) draw the connectivity; the security group rules allow all of it.

##### 56 in `expedition`

Not applicable: the workload creates no network.

##### 56 status

partly realised — spokes are isolated from each other by the topology; selective hub-to-spoke rules are planned (follow-up) under rule 51.

### 57 — Firewall routing between landing zones in Virtual WAN

```text
CAF Network topology and connectivity — Plan for landing zone network segmentation — recommendation 57
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation
  (retrieved 2026-10-15)
Summary (ours): In a Virtual WAN topology, send traffic between landing zones through Azure Firewall when it must be filtered
or logged.
```

#### What 57 means here

There is no Virtual WAN (rule 20). In the repository's hub-and-spoke network, landing zones do not reach each other at all (rule 56).

##### 57 status

not adopted, because there is no Virtual WAN.

### 58 — Outbound security rules under forced tunnelling

```text
CAF Network topology and connectivity — Plan for landing zone network segmentation — recommendation 58
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation
  (retrieved 2026-10-15)
Summary (ours): With forced tunnelling, add outbound security rules that allow traffic to the virtual network and deny it
to the internet, so traffic cannot leak straight to the internet if the default route learned over BGP drops; adjust the
priorities to the rule set, and exempt subnets of services injected into the network where their control traffic needs it.
```

#### What 58 means here

No traffic is force-tunnelled: no gateway advertises a default route, and the spoke route tables are empty. The security groups carry
inbound rules only, so outbound internet traffic follows Azure's defaults. The firewall of rule 7 would bring a default route, and with it
the question this recommendation answers; the outbound deny rule would then belong in the same `securityRules`.

##### 58 status

not adopted, because there is no forced tunnelling.

### 59 — Where Virtual Network Manager applies

```text
CAF Network topology and connectivity — Azure Virtual Network Manager in an Azure landing zone — recommendation 59
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager
  (retrieved 2026-10-15)
Summary (ours): Set Virtual Network Manager to cover the root management group or the tenant, so security admin rules for
the whole organisation reach every existing and future resource.
```

#### What 59 means here

The repository owns no management group and deploys nothing at tenant level ([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)), so there
is nothing above a subscription for Virtual Network Manager to cover. A tenant administrator may run one above the repository's
subscriptions; its rules would then apply beneath the security groups `discovery` deploys, outside what the configuration tree shows.

##### 59 status

not adopted, because the repository deploys nothing above a subscription.

### 60 — A Virtual Network Manager instance in the connectivity subscription

```text
CAF Network topology and connectivity — Azure Virtual Network Manager in an Azure landing zone — recommendation 60
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager
  (retrieved 2026-10-15)
Summary (ours): Create the Virtual Network Manager instance in the connectivity subscription, covering the intermediate root
management group, with security admin turned on, so security groups can be handed to the landing zone owners.
```

#### What 60 means here

The shared subscriptions play the connectivity role — they hold the hubs — but there is no intermediate root management group for an
instance to cover (rule 59).

##### 60 status

not adopted, because there is no management group for the instance to cover.

### 61 — Network groups for segmentation

```text
CAF Network topology and connectivity — Azure Virtual Network Manager in an Azure landing zone — recommendation 61
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager
  (retrieved 2026-10-15)
Summary (ours): Segment networks by grouping them, statically or dynamically through policy.
```

#### What 61 means here

The repository's grouping is static and lives in config: a hub's `spokes` list is the group of networks it connects, and the tier
(non-production, production) is the segment ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)). A Virtual Network Manager network group
would duplicate that list in another service.

##### 61 status

not adopted, because the static spoke list in config is the grouping.

### 62 — Direct connectivity between spokes

```text
CAF Network topology and connectivity — Azure Virtual Network Manager in an Azure landing zone — recommendation 62
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager
  (retrieved 2026-10-15)
Summary (ours): Turn on direct connectivity between spokes that talk often and need low latency, while they keep using the
hub's services.
```

#### What 62 means here

Spokes are customers, and isolating them from each other is the point of the topology (rule 56). No spoke needs to reach another.

##### 62 status

not adopted, because spokes must not reach each other.

### 63 — Global mesh

```text
CAF Network topology and connectivity — Azure Virtual Network Manager in an Azure landing zone — recommendation 63
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager
  (retrieved 2026-10-15)
Summary (ours): Use a global mesh when every network in every region must reach every other.
```

#### What 63 means here

One region, and networks are meant not to reach each other beyond their hub.

##### 63 status

not adopted, because no network needs to reach every other.

### 64 — A priority for each security admin rule

```text
CAF Network topology and connectivity — Azure Virtual Network Manager in an Azure landing zone — recommendation 64
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager
  (retrieved 2026-10-15)
Summary (ours): Give every security admin rule a priority; a lower number wins.
```

#### What 64 means here

There are no security admin rules. The security group rules `discovery` deploys carry their own priorities (100 for the virtual network
allow, 4000 for the internet deny).

##### 64 status

not adopted, because there are no security admin rules.

### 65 — Security admin rules for flows that must hold

```text
CAF Network topology and connectivity — Azure Virtual Network Manager in an Azure landing zone — recommendation 65
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager
  (retrieved 2026-10-15)
Summary (ours): Enforce the flows that must always be allowed or denied with security admin rules, which security groups
cannot override, and hand the security groups fully to the workload teams.
```

#### What 65 means here

The landing zone, not the workload, owns the security groups ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)): the rules that must hold
— deny inbound internet traffic — are deployed by `discovery` on every workload subnet, and no workload template can change them. The split
this recommendation makes between rules the platform enforces and groups the workloads own has no counterpart here, because one repository
deploys both.

##### 65 status

not adopted, because the landing zone owns the security groups and their must-hold rules.

## Decision

The repository answers each of Microsoft's topology recommendations with what it does, what it plans, or why it does not adopt it. The
traditional hub-and-spoke topology is realised: a hub per tier and a spoke per customer subscription, peered statically on both sides, each
hub in one resource group of its one region, with the gateway and firewall subnets reserved. The IP address plan is realised in
`network.yml`, which serves as the repository's IP address management: every range is planned there before its network exists, no two
overlap, the plan is arranged by hub and spoke, and a range leaves it with its subscription. Segmentation is a security group per workload
subnet that denies inbound internet traffic, with spokes isolated from each other by the topology
([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4), [ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6)).

The gaps are planned (follow-up): a firewall in the hub with a default route from every spoke, a check that every range is private, security
group rules per subnet, a policy that requires a security group on every subnet, and virtual network flow logs with traffic analytics on
Network Watcher. Everything that needs more than one region, an on-premises network, ExpressRoute, Virtual WAN, Virtual Network Manager,
IPv6, or virtual machines is not adopted, each for its stated reason.

### How this is enforced

- `NetworkConfig`, with `NetworkCidr` for the range arithmetic, validates `network.yml` when it loads: aligned IPv4 ranges, every subnet
  inside its network, no overlap between any two networks, and the subnet set of each kind
  ([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5), [ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)).
- `Test-AzureNetworkPlan` joins the plan to `azure.yml`: every subscription has a network of the right kind, every network a subscription,
  and every spoke exactly the workload subnets of the environments its subscription serves.
- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `discovery` and `expedition`, so a config address into
  `network.yml` that does not resolve fails the build, and the parameter-model test checks each rendered parameters file against the
  compiled template ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)).
- The landing zone's policy against a public IP address on a network interface keeps the network without public addresses where
  `policy_enforcement` enforces ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).
- Planned (follow-up), not existing: a private-range check in `NetworkConfig`; Azure Firewall in `AzureFirewallSubnet` and a default route
  in the spoke route tables; security group rules per subnet; a built-in policy requiring a security group on every subnet; Network Watcher
  and virtual network flow logs with traffic analytics in `discovery`.

## Consequences

- The network is a config file: a new customer's spoke is a range in `network.yml`, a config of `discovery`, and an entry in its hub's spoke
  list, all reviewed in one pull request.
- `network.yml` is the IP address management, so no external tool needs to agree with it, at the cost of choosing each new range by hand.
- Each network takes a /16, which wastes addresses for a plan that reads at a glance and lets a spoke grow without renumbering.
- Customers are isolated from each other by the topology, but within a tier the hub and its spokes reach each other fully until the rules
  per subnet exist.
- Egress is unfiltered and flows are not logged until the planned firewall and flow logs exist; the reserved subnets mean adding them needs
  no renumbering.
- One region, no hybrid link, and no IPv6 keep most of Microsoft's topology recommendations out of reach; each of those would reopen the
  rules that name it.
