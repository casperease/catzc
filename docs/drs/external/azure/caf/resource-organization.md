# EDR: CAF resource organization — Microsoft's management group and subscription recommendations, as the repository reads them

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the subscription landing zone that stops below the management groups) and
[`data-model`](../../../azure/azure-data-model.md) (the subscriptions, environments, and customers every recommendation here is weighed
against).

## Rules: EDR-AZ-CAF-RESORG

Each rule is one of the area's 35 recommendations, numbered in the order Microsoft's pages list them (13 on management groups, then 22 on
subscriptions). Every source line names the page under `https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the
repository's own summary, never a quotation. The repository's decision on each recommendation is in the rule it binds to.

### Rule EDR-AZ-CAF-RESORG-R01

Keep the management group hierarchy shallow, three to four levels at most, so that inheritance stays easy to follow.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 1, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit) and
[ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone).

### Rule EDR-AZ-CAF-RESORG-R02

A management group exists to apply policy to workloads that share security and compliance needs. Do not shape the hierarchy after the
organisation chart, and do not use it for billing or for access control.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 2, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R03

Give workload teams their roles at subscription or resource group level, normally through the vending process, never at a management group,
where inheritance grants more than intended. Platform teams may hold rights at management-group level only through just-in-time elevation
(PIM).

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 3, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits) and
[ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R04

For cross-cutting questions, query by tags enforced through policy rather than adding levels to the hierarchy.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 4, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFTAGS](../../../azure/landing-zones.md#rule-adr-az-lz-caftags).

### Rule EDR-AZ-CAF-RESORG-R05

Keep a sandbox management group where users can experiment, isolated from development, test, and production.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 5, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R06

Under the root, a platform management group holds the policies and role assignments common to the platform and gathers the foundational
subscriptions, and with them their billing.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 6, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R07

Under the landing zones management group, add one child per kind of workload (such as online, corp, or local) whose members share their
security, compliance, connectivity, and feature needs.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 7, retrieved
2026-10-15)

Binds to [ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription) and
[ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R08

Assign as little as possible at the root management group, so that what is inherited further down stays easy to debug.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 8, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-GOVERNANCELIMITS](../../../azure/landing-zones.md#rule-adr-az-lz-governancelimits).

### Rule EDR-AZ-CAF-RESORG-R09

Enforce compliance requirements through Azure Policy assigned at management group or subscription level.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 9, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies) and
[ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode).

### Rule EDR-AZ-CAF-RESORG-R10

Turn on the hierarchy setting that requires a role to create management groups; by default any user may create one under the root.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 10, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R11

Set a default management group, the sandbox being a good choice, so that a newly created subscription (a Visual Studio one, for example)
never lands under the root.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 11, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R12

Do not create management groups for production, test, and development; separate the environments by subscription inside one management
group.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 12, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../../../azure/azure-data-model.md#rule-adr-az-datamod-onefileonesubscription) and
[ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R13

Use the standard hierarchy for deployments across several regions too; only a regulatory need tied to location, such as data residency or
sovereignty, justifies management groups by location.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups (recommendation 13, retrieved
2026-10-15)

Binds to [ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace) and
[ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R14

Treat the subscription as the unit of management, cut to fit the needs of the business.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 14, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone) and
[ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R15

Make sure subscription owners know what they are responsible for: reviewing privileged access periodically, owning the budget and the
resources, and keeping the subscription compliant with policy, remediating where it is not.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 15, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution) and
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies).

### Rule EDR-AZ-CAF-RESORG-R16

Decide whether a requirement needs a new subscription by four tests: scale limits (a large, specialised workload gets its own), a
management boundary, a policy boundary (a regulated workload such as one under PCI), and network topology (a virtual network cannot span
subscriptions).

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 16, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit) and
[ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription).

### Rule EDR-AZ-CAF-RESORG-R17

Subscriptions that need the same policies and role assignments sit under the same management group.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 17, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R18

Run the platform in four separate subscriptions — management, security, connectivity, and identity — and never merge them, so that each
gets its own policies, roles, and billing.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 18, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit) and
[ADR-AZ-LZ-HUBANDSPOKE](../../../azure/landing-zones.md#rule-adr-az-lz-hubandspoke).

### Rule EDR-AZ-CAF-RESORG-R19

Automate creating subscriptions for workload teams behind a self-service request.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 19, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFPRINCIPLES](../../../azure/landing-zones.md#rule-adr-az-lz-cafprinciples) and
[ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R20

Avoid a rigid subscription model; group subscriptions by criteria that can change with the organisation. Some applications share a landing
zone subscription, others need their own.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 20, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit) and
[ADR-AZ-DATAMOD-TWOCONFIGLAYERS](../../../azure/azure-data-model.md#rule-adr-az-datamod-twoconfiglayers).

### Rule EDR-AZ-CAF-RESORG-R21

Give every subscription Service Health alerts, so that a platform incident affecting its resources reaches the people who run them.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 21, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-RESORG-R22

Add subscriptions per region only when a region needs its own governance, such as sovereignty, or to get past a quota limit.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 22, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit) and
[ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace).

### Rule EDR-AZ-CAF-RESORG-R23

Where scale is no concern, a primary and secondary disaster-recovery pair may share one subscription (some recovery tools require it);
deployments that run active-active and are managed independently belong in separate subscriptions.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 23, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R24

Create a resource group in the same region as the resources it contains.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 24, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R25

Do not put resources from different regions in one resource group.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 25, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit) and
[ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies).

### Rule EDR-AZ-CAF-RESORG-R26

Scale out across subscriptions rather than running into one subscription's platform limits.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 26, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R27

In regions where capacity is constrained, reserve capacity for the resources the workload depends on.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 27, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R28

Build a dashboard with views of how much capacity is used, and alert as use approaches critical thresholds, such as 90 percent CPU.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 28, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-RESORG-R29

Request quota increases, such as virtual machine cores, while the subscription is provisioned, before workloads exceed the defaults.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 29, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R30

Confirm that the services and features the workload needs are available in the regions it will run in.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 30, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R31

Share quota across subscriptions by putting them in a Quota Group.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 31, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R32

Automate quota requests through the Azure Quota REST API.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 32, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R33

Alert subscription owners as their usage approaches a quota limit.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 33, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-SUBSCRIPTIONUNIT](../../../azure/azure-data-model.md#rule-adr-az-datamod-subscriptionunit).

### Rule EDR-AZ-CAF-RESORG-R34

Set the subscription policy so that no one may move a subscription out of the Entra directory or into it.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 34, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

### Rule EDR-AZ-CAF-RESORG-R35

Exempt only a few users from the transfer policy: members of platform operations and the break-glass accounts.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions (recommendation 35, retrieved
2026-10-15)

Binds to [ADR-AZ-DATAMOD-ONETENANT](../../../azure/azure-data-model.md#rule-adr-az-datamod-onetenant).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation onto Azure. Resource organization is the design area
that decides how resources are grouped and governed: the management group hierarchy that carries policy and access by inheritance, the
subscriptions that bound management, policy, cost, and scale, and the naming and tagging that make resources findable (the naming and
tagging recommendations have their own record). Microsoft's reference design keeps platform subscriptions apart from workload
subscriptions, groups them in a management group hierarchy under the tenant root, and gives each workload its own subscription through a
vending process. The live text is published under the
[Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it into a shared
repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
