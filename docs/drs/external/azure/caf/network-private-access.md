# EDR: CAF network private access — Microsoft's recommendations on PaaS connectivity and DNS, as the repository reads them

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the hub that holds the private DNS zones and the workload that registers in
them), [`azure-network-model`](../../../azure/azure-network-model.md) (the address plan), and [`caf-security`](landing-zone-security.md)
(the vault's private access).

## Rules: EDR-AZ-CAF-NETPRV

The network design area is large, so the repository records it in three records: topology, IP addressing, segmentation, and Virtual Network
Manager (EDR-AZ-CAF-NETTOP); connectivity, internet traffic, application delivery, Bastion, encryption, and traffic inspection
(EDR-AZ-CAF-NETCON); and this record, private access to PaaS services and name resolution. It covers two CAF pages: "Connectivity to Azure
PaaS services" (rules 1–6) and "DNS for on-premises and Azure resources" (rules 7–13). Every source line names the page under
`https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the repository's own summary, never a quotation. The
repository's decision on each recommendation is in the rule it binds to.

### Rule EDR-AZ-CAF-NETPRV-R01

Inject a PaaS service into the virtual network when it must reach private resources, but keep its management-plane traffic to the service's
public addresses working, restricted with user-defined routes, network security groups, and service tags.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (recommendation 1, retrieved
2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess).

### Rule EDR-AZ-CAF-NETPRV-R02

Use Private Link where protection against data exfiltration and private-only addressing are firm requirements.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (recommendation 2, retrieved
2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess) and
[ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone).

### Rule EDR-AZ-CAF-NETPRV-R03

Consider service endpoints where exfiltration is a lesser concern, where Private Link is not available, or for large volumes of ingest,
because service endpoints are free while Private Link is charged per gigabyte.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (recommendation 3, retrieved
2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess).

### Rule EDR-AZ-CAF-NETPRV-R04

From on-premises, use a service's public endpoint when private access is not needed and the bandwidth suffices; otherwise use ExpressRoute
private peering or a site-to-site VPN, with injection or Private Link.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (recommendation 4, retrieved
2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess).

### Rule EDR-AZ-CAF-NETPRV-R05

Enable service endpoints case by case, never on every subnet by default.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (recommendation 5, retrieved
2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess).

### Rule EDR-AZ-CAF-NETPRV-R06

Avoid forcing internet-bound traffic back to on-premises through a default route; it breaks the control-plane traffic some PaaS services
need, such as Application Gateway v2.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/connectivity-to-azure-paas-services (recommendation 6, retrieved
2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess).

### Rule EDR-AZ-CAF-NETPRV-R07

Where resolution is needed only inside Azure, use Azure Private DNS zones, with a delegated DNS zone for the organisation's own names and
automatic registration of virtual machine records.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (recommendation 7,
retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess) and
[ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke).

### Rule EDR-AZ-CAF-NETPRV-R08

Where names must resolve across Azure and on-premises, use DNS Private Resolver with Private DNS zones, which is cheaper, highly available,
and scalable compared with DNS on virtual machines; if Active Directory-integrated DNS stays, run it on at least two virtual machines and
point the virtual networks at them.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (recommendation 8,
retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess).

### Rule EDR-AZ-CAF-NETPRV-R09

Where Azure Firewall exists, consider it as a DNS proxy.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (recommendation 9,
retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess).

### Rule EDR-AZ-CAF-NETPRV-R10

Link the private DNS zones to the virtual networks, and use a resolver forwarding ruleset so that Azure queries for on-premises names go to
on-premises DNS, while on-premises servers forward the Azure DNS zones to the resolver's inbound endpoint.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (recommendation 10,
retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess) and
[ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke).

### Rule EDR-AZ-CAF-NETPRV-R11

Give DNS Private Resolver two dedicated subnets in the connectivity hub, one inbound and one outbound, each at least a /28, with up to five
endpoints each and rulesets for the on-premises namespaces; where it sits beside the ExpressRoute gateway, make sure public names still
resolve.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (recommendation 11,
retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess).

### Rule EDR-AZ-CAF-NETPRV-R12

A workload that requires and deploys its own DNS, such as Red Hat OpenShift, keeps it.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (recommendation 12,
retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess).

### Rule EDR-AZ-CAF-NETPRV-R13

Host the Private DNS zones, including the `privatelink` DNS zones of private endpoints such as the one for blob storage, in a global
connectivity subscription.

Source: learn /azure/cloud-adoption-framework/ready/azure-best-practices/dns-for-on-premises-and-azure-resources (recommendation 13,
retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-CAFPRIVATEACCESS](../../../azure/azure-network-model.md#rule-adr-az-network-cafprivateaccess) and
[ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation. Its landing-zone part splits the
platform that workloads land in into design areas, each with considerations and design recommendations: billing and tenant, identity and
access, resource organisation, network, security, management, governance, and platform automation. Two further CAF pages bear on this record
without recommendations of their own: "Private Link and DNS integration at scale" and "Limit cross-tenant private endpoint connections". The
live text falls under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no right to copy
it into a shared repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
