# EDR: CAF network topology — Microsoft's topology, addressing, segmentation and Network Manager recommendations, as the repository reads them

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the hub-and-spoke landing zone these recommendations are weighed against) and
[`network-model`](../../../azure/azure-network-model.md) (the IP plan in `network.yml` that answers the addressing recommendations).

## Rules: EDR-AZ-CAF-NETTOP

Each rule is one of the area's 65 topology recommendations, numbered in the order of the area's pages: 1 to 27 the traditional topology
page, 28 to 49 the IP addressing page (28 to 36 general, 37 and 38 IPv6, 39 to 45 the IPv6 address blocks, 46 to 49 IP address management
tools), 50 to 58 the segmentation page, and 59 to 65 the Virtual Network Manager page. The seven items under the IPv6 address-block heading
are not labelled as recommendations on the page; they are kept as rules so that nothing on the page is dropped. The traditional topology page
repeats four of its items (7 and 11, 9 and 14, 10 and 15, 20 and 23); each repeat stays its own rule. Every source line names the page under
`https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the repository's own summary, never a quotation. The repository's
decision on each recommendation is in the rule it binds to.

### Rule EDR-AZ-CAF-NETTOP-R01

Choose a traditional hub-and-spoke design when the network is regional, or multi-region without much cross-region transit between landing zones, when no transit between VPN and ExpressRoute is needed, when hybrid links are mostly ExpressRoute with few VPN connections, and when central appliances and fine-grained routing are relied on.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 1, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R02

For a regional deployment, put one hub in each region and peer the spokes to it. The hub serves ExpressRoute through two peering locations, branch VPN, spoke-to-spoke traffic through appliances and user-defined routes, and protects outbound internet traffic with Azure Firewall or a partner appliance.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 2, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke), [ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R03

A diagram of the hub-and-spoke topology, offered as the configuration that meets most segmentation and inspection needs.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 3, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R04

Connect several hub networks over several ExpressRoute circuits at different peering locations when business units need strong isolation, dedicated bandwidth, or more connections than one gateway allows.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 4, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R05

A diagram of the topology of recommendation 4, with several hubs on several ExpressRoute circuits.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 5, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R06

For dual-homed peering within one city, consider ExpressRoute Metro.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 6, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R07

Put Azure Firewall or a partner network appliance in the hub to filter traffic between spokes and traffic to and from the internet.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 7, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R08

Keep the hub to a minimal set of shared services: the ExpressRoute and VPN gateways, the firewall or appliances, and where needed domain controllers and DNS servers.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 8, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R09

Deploy one DDoS Protection plan in the connectivity subscription and use it for every landing zone and platform virtual network.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 9, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R10

Connect branches to headquarters over the existing private wide-area or SD-WAN network; without Route Server, Azure does not carry traffic between ExpressRoute and VPN.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 10, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R11

Repeats recommendation 7: filter traffic between spokes and to and from the internet with Azure Firewall or partner appliances in the hub.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 11, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R12

Deploy partner networking appliances as their vendor advises, so the deployment is supported, highly available, and performs well, and does not conflict with Azure networking.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 12, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R13

Do not run Application Gateway or a similar inbound application-level device as a shared service in the hub; it belongs in the landing zone of the application it serves.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 13, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R14

Repeats recommendation 9: one DDoS Protection plan in the connectivity subscription.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 14, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R15

Repeats recommendation 10: connect branches over the existing private wide-area or SD-WAN network.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 15, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R16

When traffic must pass between ExpressRoute and VPN gateways in a hub-and-spoke network, use Azure Route Server.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 16, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R17

With hubs in several regions and only a few landing zones that must talk across regions, peer those spokes directly with global peering; it is fast but bypasses the hub appliances.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 17, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R18

When most landing zones talk across regions, or bypassing the hub appliances is unacceptable, route between hubs through their appliances, over global peering (fast, billed by traffic) or ExpressRoute (more latency, bound by the gateway size).

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 18, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R19

To connect two regions, peer their two hubs with global peering.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 19, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R20

Move to a managed global transit network based on Virtual WAN when hub-and-spoke must span more than two regions, landing zones need global transit between them, and management overhead must stay low.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 20, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R21

Beyond two regions, connect every regional hub to the same ExpressRoute circuits instead of maintaining a mesh of peerings and user-defined routes.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 21, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R22

When ExpressRoute carries cross-region traffic, spokes learn each other's routes over BGP and skip the firewall; to force inspection, add specific routes to the local hub firewall or stop BGP propagation on the spoke route tables.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 22, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R23

Repeats recommendation 20: Virtual WAN for hub-and-spoke across more than two regions with global transit and low management overhead.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 23, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R24

Deploy each region's hub network resources into a resource group of their own.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 24, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R25

Manage connectivity and security configuration across subscriptions with Azure Virtual Network Manager.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 25, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R26

Monitor the end-to-end state of the network with Network Watcher's network insights.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 26, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R27

Keep the number of spokes per hub within the peering limit of a virtual network and within the number of prefixes ExpressRoute private peering can advertise.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/traditional-azure-networking-topology (recommendation 27, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R28

Plan the address spaces in advance so that no two Azure regions or on-premises locations overlap.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 28, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEIPPLAN](../../../azure/azure-network-model.md#rule-adr-az-network-oneipplan), [ADR-AZ-NETWORK-NOOVERLAP](../../../azure/azure-network-model.md#rule-adr-az-network-nooverlap), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R29

Take addresses from the private ranges set aside for private networks (RFC 1918).

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 29, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R30

Do not use multicast, broadcast, loopback, or link-local ranges, or the address Azure reserves for its own DNS.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 30, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R31

Where private IPv4 addresses are scarce, consider IPv6; a virtual network can be IPv4 only or dual-stack.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 31, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R32

Avoid large virtual networks such as a /16, so addresses are not wasted; IPv4 subnets range from /29 to /2, and IPv6 subnets are exactly /64.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 32, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R33

Do not create a virtual network before its address space is planned.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 33, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEIPPLAN](../../../azure/azure-network-model.md#rule-adr-az-network-oneipplan), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R34

Do not address virtual networks from public ranges, least of all from public ranges the organisation does not own.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 34, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R35

Account for the services that reserve address ranges of their own, such as Kubernetes with Azure CNI.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 35, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R36

Counter IPv4 exhaustion with spoke networks that are not routed to the rest of the estate, reached through Azure Private Link service.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 36, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R37

To serve IPv6 clients from an IPv4-only back end, run dual-stack network appliances in a flexible virtual machine scale set behind a public Standard Load Balancer, translating to IPv4 for the application subnet.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 37, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R38

Alternatively, let Front Door take IPv6 web clients and proxy them to an IPv4 back end; appliances inside the network and a global Front Door can also be combined.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 38, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R39

A virtual network takes one IPv6 block; give subnets a /64, which also keeps routing to on-premises networks possible.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 39, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R40

An IPv4-only virtual network can be made dual-stack; the two protocols then work independently.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 40, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R41

IPv4 support cannot be removed from a virtual network.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 41, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R42

Give the virtual network and its subnets an IPv6 block, Azure-assigned or brought by the organisation; the item also explains IPv4 and IPv6 address notation.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 42, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R43

Add IPv6 routes to the route tables, sending public IPv6 traffic to the VPN or ExpressRoute gateway.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 43, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R44

Add explicit IPv6 rules to the network security groups.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 44, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R45

Where a resource does not support IPv6, use dual stack or an appliance that translates.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 45, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R46

Let landing zones request ranges of different sizes, for example small, medium, and large ranges of /24, /22, and /20.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 46, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEIPPLAN](../../../azure/azure-network-model.md#rule-adr-az-network-oneipplan), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R47

The IP address management tool needs an API, so that infrastructure as code and subscription vending can reserve non-overlapping ranges automatically.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 47, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEIPPLAN](../../../azure/azure-network-model.md#rule-adr-az-network-oneipplan), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R48

Arrange the address spaces systematically, by region and by workload archetype.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 48, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEIPPLAN](../../../azure/azure-network-model.md#rule-adr-az-network-oneipplan), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R49

Decommissioning a workload includes returning its address ranges to the pool for reuse.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-ip-addressing (recommendation 49, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R50

Let landing zone owners design their own subnets, and have the platform team use policy to guarantee every subnet a network security group with baseline deny rules, such as no SSH or RDP from the internet.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation (recommendation 50, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription), [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R51

Use network security groups to control traffic between subnets and between landing zones.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation (recommendation 51, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R52

Workload teams protect virtual machines in tiers with application security groups inside the subnet's network security group rules.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation (recommendation 52, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R53

Segment traffic inside a landing zone with network security groups and application security groups rather than sending it through a central appliance.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation (recommendation 53, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R54

Turn on virtual network flow logs with traffic analytics, at least on the critical networks, for insight into traffic, investigation, and compliance.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation (recommendation 54, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R55

Plan the migration of existing network security group flow logs to virtual network flow logs.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation (recommendation 55, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R56

Use network security groups to allow connectivity between landing zones selectively.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation (recommendation 56, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R57

In a Virtual WAN topology, send traffic between landing zones through Azure Firewall when it must be filtered or logged.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation (recommendation 57, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R58

With forced tunnelling, add outbound security rules that allow traffic to the virtual network and deny it to the internet, so traffic cannot leak straight to the internet if the default route learned over BGP drops; adjust the priorities to the rule set, and exempt subnets of services injected into the network where their control traffic needs it.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-landing-zone-network-segmentation (recommendation 58, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R59

Set Virtual Network Manager to cover the root management group or the tenant, so security admin rules for the whole organisation reach every existing and future resource.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager (recommendation 59, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R60

Create the Virtual Network Manager instance in the connectivity subscription, covering the intermediate root management group, with security admin turned on, so security groups can be handed to the landing zone owners.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager (recommendation 60, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R61

Segment networks by grouping them, statically or dynamically through policy.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager (recommendation 61, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R62

Turn on direct connectivity between spokes that talk often and need low latency, while they keep using the hub's services.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager (recommendation 62, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R63

Use a global mesh when every network in every region must reach every other.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager (recommendation 63, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace), [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R64

Give every security admin rule a priority; a lower number wins.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager (recommendation 64, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

### Rule EDR-AZ-CAF-NETTOP-R65

Enforce the flows that must always be allowed or denied with security admin rules, which security groups cannot override, and hand the security groups fully to the workload teams.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/azure-virtual-network-manager (recommendation 65, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFTOPOLOGY](../../../azure/azure-network-model.md#rule-adr-az-network-caftopology).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation onto Azure. Network topology and connectivity is the
design area that decides how the landing zones' networks are laid out and joined. This record covers its topology half: the traditional
hub-and-spoke topology and the Virtual WAN alternative, the IP address plan (IPv6 and IP address management tools among it), the
segmentation inside and between landing zones, and Azure Virtual Network Manager. The Virtual WAN page and the page on choosing a topology
carry no recommendations section, so they give no rule. The live text is published under the
[Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it into a shared
repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
