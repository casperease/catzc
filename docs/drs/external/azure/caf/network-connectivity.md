# EDR: CAF network connectivity — Microsoft's recommendations on reaching, leaving, and protecting networks, as the repository reads them

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the hub-and-spoke network these recommendations apply to),
[`waf-security`](../waf/security.md) (the workload view of network isolation and encryption; its rules are cited here, not repeated), and
[`caf-security`](landing-zone-security.md) (the landing-zone security design area).

## Rules: EDR-AZ-CAF-NETCON

Each rule is one of the area's 62 connectivity recommendations, numbered in the order of the area's pages: 1 to 12 connectivity to Azure, 13
to 21 application delivery, 22 to 41 inbound and outbound internet connectivity, 42 to 51 virtual machine remote access, 52 to 57 network
encryption, and 58 to 62 traffic inspection. Every source line names the page under `https://learn.microsoft.com/en-us` and the retrieval
date; the sentence is the repository's own summary, never a quotation. The repository's decision on each recommendation is in the rule it
binds to.

### Rule EDR-AZ-CAF-NETCON-R01

Connect on-premises networks to Azure through ExpressRoute first, and keep a VPN connection as the backup path.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 1, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R02

Use two ExpressRoute circuits from two different peering locations, so no single location is a point of failure.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 2, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R03

With several ExpressRoute circuits, choose the preferred paths with BGP local preference and AS-path prepending.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 3, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R04

Choose the ExpressRoute or VPN gateway SKU that matches the bandwidth and performance the connection needs.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 4, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R05

Deploy the ExpressRoute gateway zone-redundant in regions that offer availability zones.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 5, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R06

Use ExpressRoute Direct when a connection needs more than 10 Gbps or dedicated 10 or 100 Gbps ports.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 6, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R07

Enable FastPath so traffic bypasses the ExpressRoute gateway when low latency or more than 10 Gbps is needed.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 7, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R08

Connect branches and remote sites through VPN gateways, zone-redundant for resilience, since the SKUs without availability-zone support are being retired.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 8, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R09

Connect large offices and data centres that each use ExpressRoute to one another through Global Reach.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 9, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R10

Use separate ExpressRoute circuits, for example for production and non-production, when traffic must be isolated or needs dedicated bandwidth.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 10, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R11

Watch ExpressRoute peerings, connections, and gateways with network insights, and measure the paths between Azure and on-premises sites with Connection Monitor.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 11, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R12

Do not rely on ExpressRoute circuits from a single peering location, which is a single point of failure.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure (recommendation 12, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R13

Deliver internal and external applications from the landing zone of the application: an Application Gateway is part of the application in its spoke, not a shared hub service, because tuning its firewall alerts needs knowledge of the application, and a shared instance mixes teams' configuration and reaches its limits.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (recommendation 13, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R14

Deliver HTTP and HTTPS applications through Application Gateway v2 with web application firewall policies turned on.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (recommendation 14, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R15

Use a partner network virtual appliance for inbound web traffic only when Application Gateway v2 cannot be used.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (recommendation 15, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R16

Deploy the Application Gateway v2 or partner appliance for inbound web traffic inside the landing-zone virtual network, beside the applications it protects.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (recommendation 16, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R17

Protect every public IP address in a landing zone with a DDoS Protection plan.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (recommendation 17, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R18

Deliver global HTTP and HTTPS applications that span regions through Azure Front Door with web application firewall policies.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (recommendation 18, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R19

Read Microsoft's guidance on global routing redundancy before making Front Door the only entry to a critical application.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (recommendation 19, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R20

When both are used, put the web application firewall policies on Front Door and lock the Application Gateway so it accepts traffic from Front Door only.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (recommendation 20, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R21

Deliver global applications that use protocols other than HTTP and HTTPS through Traffic Manager.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-app-delivery (recommendation 21, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R22

Make NAT Gateway the default for outbound internet traffic that leaves directly: it scales source network address translation, gives static outbound addresses, relieves port exhaustion on load balancers, firewalls, and App Service, and allows outbound traffic only.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 22, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R23

Use Azure Firewall to control outbound internet traffic, inbound traffic that is not HTTP or HTTPS, and traffic between networks inside Azure where that needs filtering.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 23, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R24

Enable the firewall's management NIC: create AzureFirewallManagementSubnet (at least /26) in advance, give it a public IP address, and keep gateway route propagation off on its route table.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 24, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R25

Use Azure Firewall Premium where TLS inspection, intrusion detection and prevention, URL filtering, or web categories are needed; Standard and Premium need the management NIC enabled when they are created, while Basic always has it.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 25, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R26

Manage the firewalls of Virtual WAN hubs and of hub virtual networks through Azure Firewall Manager.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 26, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R27

Where the same addresses and ranges recur in firewall rules, collect them in IP Groups and reuse them across rules, firewalls, regions, and subscriptions.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 27, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEIPPLAN](../../../azure/azure-network-model.md#rule-adr-az-network-oneipplan), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R28

In user-defined routes that steer traffic to Azure platform services, use service tags as the prefixes so Azure keeps the addresses current; do not attach a custom route table to the firewall's management subnet, or keep a default route to the internet on it if one is needed.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 28, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R29

Create one global Azure Firewall policy, assigned to every firewall, as the organisation's baseline security posture.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 29, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R30

Let regional security teams own child firewall policies for regional needs, delegated through role-based access control.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 30, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R31

Protect inbound HTTP and HTTPS traffic from the internet with a web application firewall inside the landing-zone virtual network.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 31, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R32

Protect global inbound HTTP and HTTPS traffic with Front Door and web application firewall policies, after reading the global routing redundancy guidance.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 32, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R33

When Front Door and Application Gateway protect web applications together, put the firewall policies on Front Door and let Application Gateway accept traffic from Front Door only.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 33, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R34

When partner network virtual appliances handle inbound web traffic, deploy them in the landing-zone network beside the applications they expose.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 34, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R35

Never depend on Azure's default outbound internet access: it risks port exhaustion, is open by default, and uses addresses the organisation does not own and that can change.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 35, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R36

Landing zones that are not connected to the hub use NAT Gateway for outbound traffic when no firewall or appliance has to inspect it.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 36, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R37

Where the organisation uses software-as-a-service security providers for outbound protection, connect them through Firewall Manager.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 37, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R38

With partner appliances protecting traffic between networks or to and from the internet, place them in a separate appliance network connected to the hub in a Virtual WAN design, or in the central hub otherwise.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 38, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R39

Expose no management port of a virtual machine to the internet: block virtual machines with public IP addresses by policy and reach jump hosts through Bastion.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 39, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R40

Protect the public endpoints in virtual networks with Azure DDoS Protection plans.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 40, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R41

Do not rebuild on-premises perimeter network and demilitarised-zone designs in Azure; use patterns made for the cloud.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-inbound-and-outbound-internet-connectivity (recommendation 41, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R42

Use the Standard or Premium Bastion SKU for production workloads, and the free Developer SKU for sandbox and test where the region offers it.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (recommendation 42, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R43

Reach virtual machines from on-premises over the ExpressRoute or VPN connectivity that already exists.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (recommendation 43, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R44

In a Virtual WAN topology, deploy Bastion in each spoke, or one central Bastion in a spoke, which needs fewer instances but gives users Reader on Bastion and on that spoke's network.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (recommendation 44, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R45

In a hub-and-spoke topology, one Bastion in the hub serves the peered spokes, with users given Reader on Bastion and on the hub network; where that grant is not allowed, deploy a Bastion in each spoke that needs one.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (recommendation 45, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R46

Protect Bastion and the virtual machines it reaches with the network security group rules Microsoft documents.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (recommendation 46, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R47

Send Bastion's diagnostic logs to the central Log Analytics workspace.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (recommendation 47, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R48

Create the role assignments that let the users and groups who connect through Bastion do so.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (recommendation 48, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R49

Connect to Linux virtual machines over SSH with private keys kept in Key Vault.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (recommendation 49, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R50

Keep both Bastion and ExpressRoute or VPN access where specific needs, such as break-glass access, call for both.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (recommendation 50, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R51

Do not allow remote access to Windows or Linux virtual machines through public IP addresses, and never allow remote access without strict network security groups and firewalling.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-virtual-machine-remote-access (recommendation 51, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R52

Connections from on-premises through a VPN gateway are encrypted with IPsec.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (recommendation 52, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R53

Where traffic between virtual machines must be encrypted, inside a network or across peered networks, use virtual network encryption.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (recommendation 53, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R54

Encrypt ExpressRoute Direct links at layer 2 with MACsec.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (recommendation 54, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R55

In Virtual WAN where MACsec is not an option, run IPsec over ExpressRoute private peering through the Virtual WAN VPN gateway.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (recommendation 55, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R56

Outside Virtual WAN and where MACsec is not an option, encrypt with partner appliances over private peering, a VPN over Microsoft peering, or a site-to-site VPN over private peering.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (recommendation 56, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R57

If the native options do not meet the requirements, encrypt traffic over private peering with partner appliances.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/define-network-encryption-requirements (recommendation 57, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R58

Record traffic with virtual network flow logs and move away from network security group flow logs: they are simpler to set up, cover a whole network, and add encryption status and Virtual Network Manager rule details. Network security group flow logs are being retired.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-traffic-inspection (recommendation 58, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R59

Turn on traffic analytics, for ready-made views of the traffic and security analysis over the flow logs.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-traffic-inspection (recommendation 59, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement), [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R60

If traffic analytics does not offer enough, add a partner solution from the Marketplace.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-traffic-inspection (recommendation 60, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R61

Run Network Watcher packet captures at different times through the week to learn which traffic flows.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-traffic-inspection (recommendation 61, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

### Rule EDR-AZ-CAF-NETCON-R62

Do not build a custom traffic-mirroring solution for a large estate; it is hard to support.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/plan-for-traffic-inspection (recommendation 62, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFCONNECTIVITY](../../../azure/azure-network-model.md#rule-adr-az-network-cafconnectivity).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation onto Azure. Network topology and connectivity is the
design area that decides how the landing zones' networks are laid out and joined. This record covers its connectivity half: reaching Azure
from on-premises, delivering applications, inbound and outbound internet traffic, remote access to virtual machines, network encryption,
and traffic inspection. The topology half and the private access to platform services have records of their own. The live text is published
under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it into a
shared repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
