# EDR: CAF management — Microsoft's management design recommendations, as the repository reads them

Binds to [`landing-zones`](../../../azure/landing-zones.md) (the landing zone that streams the activity log and the network diagnostics) and
[`operational-excellence`](../waf/operational-excellence.md) (the monitoring stack and the incident process these rules build on).

## Rules: EDR-AZ-CAF-MGMT

Each rule is one of Microsoft's twenty-two management recommendations, numbered in the order the area's pages list them (inventory and
visibility 1–8, protection and recovery 9–13, operational compliance 14–15, workload monitoring 16–22). Every source line names the page
under `https://learn.microsoft.com/en-us` and the retrieval date; the sentence is the repository's own summary, never a quotation. The
repository's decision on each recommendation is in the rule it binds to.

### Rule EDR-AZ-CAF-MGMT-R01

Run the platform from one central Log Analytics workspace, unless access control, data sovereignty, or retention rules force a split;
workload teams may add workspaces of their own for workload-specific data.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (recommendation 1, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement) and
[ADR-AZ-LZ-CAFPRINCIPLES](../../../azure/landing-zones.md#rule-adr-az-lz-cafprinciples).

### Rule EDR-AZ-CAF-MGMT-R02

When logs must be kept for more than seven years, export them to Azure Storage under an immutable (write-once) policy.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (recommendation 2, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R03

Use Azure Policy to enforce the settings that must hold across the organisation and to report compliance with them.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (recommendation 3, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-LANDINGZONEPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-landingzonepolicies).

### Rule EDR-AZ-CAF-MGMT-R04

Use Traffic Analytics to see the IP traffic that flows through the virtual networks.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (recommendation 4, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R05

Put resource locks on critical shared services so they cannot be deleted by accident.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (recommendation 5, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R06

Let role assignments decide who may deploy and deny policies decide what may be deployed, so the two together act as guardrails.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (recommendation 6, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-LANDINGZONEPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-landingzonepolicies) and
[ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode).

### Rule EDR-AZ-CAF-MGMT-R07

Include Service Health and Resource Health events in the platform's monitoring.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (recommendation 7, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R08

Do not ship raw Azure log entries back to on-premises monitoring systems; keep them in Azure and forward only critical alerts to an
on-premises security event system.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (recommendation 8, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R09

Use Azure Site Recovery to replicate virtual machines to another region, for low recovery point and time objectives and drills that do not
disrupt production, with policy to enable and audit the replication.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery
(recommendation 9, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement) and
[ADR-AZ-NETWORK-ONEADDRESSSPACE](../../../azure/azure-network-model.md#rule-adr-az-network-oneaddressspace).

### Rule EDR-AZ-CAF-MGMT-R10

Rely on the replication and failover that platform services provide themselves, with Azure Policy to audit and enforce their configuration.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery
(recommendation 10, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar) and
[ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R11

Back up with Azure Backup and the backup features built into platform services rather than third-party tools, with policy to enforce the
backup configuration.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery
(recommendation 11, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R12

Connect to on-premises over ExpressRoute from several regions and peering locations, so the link survives a regional or provider outage.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery
(recommendation 12, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement) and
[ADR-AZ-NETWORK-PERSUBSCRIPTION](../../../azure/azure-network-model.md#rule-adr-az-network-persubscription).

### Rule EDR-AZ-CAF-MGMT-R13

Give production and recovery networks address ranges that do not overlap, so a failover needs no re-addressing and every site can be
connected at once.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery
(recommendation 13, retrieved 2026-10-15)

Binds to [ADR-AZ-NETWORK-NOOVERLAP](../../../azure/azure-network-model.md#rule-adr-az-network-nooverlap) and
[ADR-AZ-NETWORK-ONEIPPLAN](../../../azure/azure-network-model.md#rule-adr-az-network-oneipplan).

### Rule EDR-AZ-CAF-MGMT-R14

Patch Windows and Linux virtual machines with Azure Update Manager, enforced by policy so every machine is covered, with workload teams
setting their own schedules and the central team keeping visibility.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-operational-compliance (recommendation 14, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R15

Audit configuration drift inside virtual machines with Machine Configuration, assigned through Azure Policy.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-operational-compliance (recommendation 15, retrieved
2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R16

Collect the logs and metrics of infrastructure and platform services alike in a Log Analytics workspace.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (recommendation 16, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement) and
[ADR-AZ-LZ-EVERYPILLAR](../../../azure/landing-zones.md#rule-adr-az-lz-everypillar).

### Rule EDR-AZ-CAF-MGMT-R17

Govern who can read a workspace and its logs with Azure role-based access control.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (recommendation 17, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R18

Use Azure Monitor Metrics, a time-series store, for fast alerting and performance analysis, and correlate it with logs to find root causes.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (recommendation 18, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R19

Use Azure Monitor Logs to analyse and report across the data of many services; shared landing-zone storage accounts may hold the logs of the
virtual machine diagnostics extension.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (recommendation 19, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R20

Generate operational alerts with Azure Monitor alerts across metrics and logs, with actions and smart grouping of related alerts.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (recommendation 20, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement) and
[ADR-AZ-LZ-COSTATTRIBUTION](../../../azure/landing-zones.md#rule-adr-az-lz-costattribution).

### Rule EDR-AZ-CAF-MGMT-R21

Group a workload's resources across subscriptions and resource groups with Azure Service Groups, to make monitoring them simpler.

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (recommendation 21, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

### Rule EDR-AZ-CAF-MGMT-R22

Model the health of a service group's resources and their dependencies with Azure Monitor health models (in preview).

Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (recommendation 22, retrieved 2026-10-15)

Binds to [ADR-AZ-LZ-CAFMANAGEMENT](../../../azure/landing-zones.md#rule-adr-az-lz-cafmanagement).

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation: strategy, planning, readiness,
governance, and operations. Its landing-zone guidance splits the platform into design areas, each with considerations to weigh and numbered
design recommendations. The management area sets the operations baseline: the common tools and processes that let every workload on the
platform be managed the same way, covering inventory and visibility, baseline monitoring, protection and recovery, operational compliance,
and the monitoring of workloads. Its baseline monitoring page carries no recommendations, so it is no rule. The live text is published under
the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it into a shared
repository, so nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.
