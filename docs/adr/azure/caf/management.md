---
catzc:
  immutable:
    with_body_sha: "5bb2b8a1cdb8"
    path: docs/adr/azure/caf/management.md
    folder: docs/adr/azure/caf
    name: management
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-AZ-CAFMGMT#{1-22}
    cites:
      - ADR-AZ-CAFGOV#{4,6}
      - ADR-AZ-CAFPRIN#3
      - ADR-AZ-DATAMOD#{9,11}
      - ADR-AZ-LZ#{1,3-6}
      - ADR-AZ-NETWORK#{1,3,5,6}
      - ADR-AZ-WAFOE#{7,8,10}
      - ADR-AZ-WAFRE#{5,9,10}
      - ADR-AZ-WAFSE#{4-6}
    links:
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network1
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network3
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network5
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network6
      - docs/adr/azure/caf/design-principles.md#rule-adr-az-cafprin3
      - docs/adr/azure/caf/governance.md#rule-adr-az-cafgov4
      - docs/adr/azure/caf/governance.md#rule-adr-az-cafgov6
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz1
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz3
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz4
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz5
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz6
      - docs/adr/azure/waf/operational-excellence.md
      - docs/adr/azure/waf/operational-excellence.md#rule-adr-az-wafoe10
      - docs/adr/azure/waf/operational-excellence.md#rule-adr-az-wafoe7
      - docs/adr/azure/waf/operational-excellence.md#rule-adr-az-wafoe8
      - docs/adr/azure/waf/reliability.md#rule-adr-az-wafre10
      - docs/adr/azure/waf/reliability.md#rule-adr-az-wafre5
      - docs/adr/azure/waf/reliability.md#rule-adr-az-wafre9
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse4
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse5
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse6
      - docs/references/caf/index.md
      - "https://learn.microsoft.com/en-us/legal/termsofuse"
---

# ADR: CAF management — what the repository does about each of Microsoft's management design recommendations

Pairs with [`landing-zones`](../landing-zones.md) (the landing zone that streams the activity log and the network diagnostics) and
[`operational-excellence`](../waf/operational-excellence.md) (the monitoring stack and the incident process these rules build on).

## Rules: ADR-AZ-CAFMGMT

### Rule ADR-AZ-CAFMGMT:1

Not adopted, as a deliberate deviation: every subscription keeps its own Log Analytics workspace from `foundation`, so one customer's
telemetry stays in that customer's subscription ([ADR-AZ-CAFPRIN#3](design-principles.md#rule-adr-az-cafprin3)).

- [1 — Keep one Log Analytics workspace for the platform](#1--keep-one-log-analytics-workspace-for-the-platform)

### Rule ADR-AZ-CAFMGMT:2

Not adopted, because the workspaces keep 30 days and no example customer needs logs kept for years; retention per environment class is
planned ([ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7)).

- [2 — Archive logs beyond seven years to immutable storage](#2--archive-logs-beyond-seven-years-to-immutable-storage)

### Rule ADR-AZ-CAFMGMT:3

Realised: every landing zone assigns three built-in policies and Azure reports their compliance per subscription
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)); the policy design itself is the governance record's.

- [3 — Enforce settings and report compliance with Azure Policy](#3--enforce-settings-and-report-compliance-with-azure-policy)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFMGMT:4

Planned: virtual network flow logs with Traffic Analytics into `foundation`'s workspace, the flow logging that
[ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6) plans.

- [4 — Analyse network traffic with Traffic Analytics](#4--analyse-network-traffic-with-traffic-analytics)

### Rule ADR-AZ-CAFMGMT:5

Planned: a delete lock on the hub's virtual network and private DNS zones, the lock that
[ADR-AZ-WAFRE#5](../waf/reliability.md#rule-adr-az-wafre5) plans; no module places a lock.

- [5 — Lock critical shared resources against deletion](#5--lock-critical-shared-resources-against-deletion)

### Rule ADR-AZ-CAFMGMT:6

Realised: each subscription is deployed by its own service connection, and the landing zone's deny-effect policies limit what any identity
may deploy there, enforcing in production and auditing outside it ([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)).

- [6 — Pair role-based access with deny policies](#6--pair-role-based-access-with-deny-policies)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFMGMT:7

Partly realised: the subscription's activity log, its `ServiceHealth` and `ResourceHealth` categories included, streams to `foundation`'s
workspace; alerts on those events are planned ([ADR-AZ-WAFRE#10](../waf/reliability.md#rule-adr-az-wafre10)).

- [7 — Monitor Service Health and Resource Health events](#7--monitor-service-health-and-resource-health-events)

### Rule ADR-AZ-CAFMGMT:8

Not adopted, because the repository has no on-premises monitoring system to forward to; every log stays in Azure.

- [8 — Keep raw logs in Azure, not on premises](#8--keep-raw-logs-in-azure-not-on-premises)

### Rule ADR-AZ-CAFMGMT:9

Not adopted, because no template deploys a virtual machine and every environment maps to one region
([ADR-AZ-NETWORK#3](../azure-network-model.md#rule-adr-az-network3)).

- [9 — Replicate virtual machines with Site Recovery](#9--replicate-virtual-machines-with-site-recovery)

### Rule ADR-AZ-CAFMGMT:10

Partly realised: the workload relies on the platform's own redundancy — zone-redundant storage, and in production a zone-redundant database
with geo-redundant backups ([ADR-AZ-WAFRE#5](../waf/reliability.md#rule-adr-az-wafre5)); a policy that audits it is not adopted.

- [10 — Use the disaster recovery built into platform services](#10--use-the-disaster-recovery-built-into-platform-services)

### Rule ADR-AZ-CAFMGMT:11

Partly realised: the database's own point-in-time backups and the storage account's soft delete are the backup, set per environment class in
config; a backup vault is not adopted, because nothing deployed needs one.

- [11 — Use Azure-native backup](#11--use-azure-native-backup)

### Rule ADR-AZ-CAFMGMT:12

Not adopted, because the repository has no on-premises connectivity and no ExpressRoute circuit.

- [12 — Make hybrid connectivity redundant across regions](#12--make-hybrid-connectivity-redundant-across-regions)

### Rule ADR-AZ-CAFMGMT:13

Realised: no two networks of the IP plan overlap, which `NetworkConfig` checks when `network.yml` loads
([ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)); a recovery network added to the plan falls under the same check.

- [13 — Keep production and recovery address ranges apart](#13--keep-production-and-recovery-address-ranges-apart)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFMGMT:14

Not adopted, because no template deploys a virtual machine, so there is no operating system to patch.

- [14 — Patch virtual machines with Update Manager](#14--patch-virtual-machines-with-update-manager)

### Rule ADR-AZ-CAFMGMT:15

Not adopted, because no template deploys a virtual machine, so there is no in-guest configuration to audit.

- [15 — Audit in-guest configuration drift by policy](#15--audit-in-guest-configuration-drift-by-policy)

### Rule ADR-AZ-CAFMGMT:16

Partly realised: every resource that emits logs or metrics sends them to `foundation`'s workspace through a diagnostic setting its own
template deploys ([ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7)); `foundation`'s Key Vault sends none, which is
planned.

- [16 — Collect workload logs and metrics in a workspace](#16--collect-workload-logs-and-metrics-in-a-workspace)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFMGMT:17

Partly realised: access to each workspace follows the role-based access control of its subscription, so customers are kept apart by
subscription; role assignments as code are planned ([ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5)).

- [17 — Control workspace access with role-based access](#17--control-workspace-access-with-role-based-access)

### Rule ADR-AZ-CAFMGMT:18

Partly realised: every resource's platform metrics are in Azure Monitor and its diagnostic setting copies them to the workspace beside its
logs; metric alerts are planned.

- [18 — Use metrics for time-sensitive analysis](#18--use-metrics-for-time-sensitive-analysis)

### Rule ADR-AZ-CAFMGMT:19

Partly realised: the logs every template collects are queryable in one workspace per subscription; saved queries, workbooks, and dashboards
are planned with the health model of [ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7).

- [19 — Use logs for insight and reporting](#19--use-logs-for-insight-and-reporting)

### Rule ADR-AZ-CAFMGMT:20

Planned: an action group per subscription in `foundation` and alert rules in the templates that own the resources
([ADR-AZ-WAFOE#8](../waf/operational-excellence.md#rule-adr-az-wafoe8)); the only alerts are the budget's.

- [20 — Raise operational alerts with Azure Monitor](#20--raise-operational-alerts-with-azure-monitor)

### Rule ADR-AZ-CAFMGMT:21

Not adopted, because a workload's resources sit together: one resource group per configuration slot, named by the `workload` tag, inside one
subscription.

- [21 — Group workload resources with Service Groups](#21--group-workload-resources-with-service-groups)

### Rule ADR-AZ-CAFMGMT:22

Planned: the health model that [ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7) and
[ADR-AZ-WAFRE#10](../waf/reliability.md#rule-adr-az-wafre10) plan; whether it uses Azure Monitor health models is decided when the feature
leaves preview.

- [22 — Track workload health with health models](#22--track-workload-health-with-health-models)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation: strategy, planning, readiness,
governance, and operations. Its landing-zone guidance splits the platform an organisation builds into design areas, each with considerations
to weigh and design recommendations; the landing zone that a subscription receives here is CAF's application landing zone
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)).

The management design area sets the operations baseline: the common tools and processes that let every workload on the platform be managed
the same way. Its pages cover inventory and visibility, baseline monitoring, protection and recovery, operational compliance, and the
monitoring of workloads. Here management is the Log Analytics workspace `foundation` gives every subscription (30 days' retention), the
diagnostic settings that send the subscription's activity log (`subscription-diagnostic-setting.bicep`) and the diagnostics of the storage
account, the blob service, the database, the virtual network, and each network security group (`diagnostic-setting.bicep`) to it, and a
budget per subscription. There are no alert rules or action groups, and no virtual machine is deployed, so the agent-based parts of the area
— the monitoring agent, patching, in-guest configuration, and virtual machine replication — have nothing to act on.

These rules are vendor recommendation, not principled theory. They do not argue from first principles the way the axioms and DORA's research
do; they record what the repository does about each of Microsoft's twenty-two management recommendations, numbered in the order the area's
pages list them (inventory and visibility 1–8, protection and recovery 9–13, operational compliance 14–15, workload monitoring 16–22). Each
rule cites Microsoft's page — area, page, section, link, retrieval date — and summarises it in our own words, because the live CAF text is
published under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), which grant no licence to copy it
into a shared repository. Nothing is quoted. Much of this area is decided by the Well-Architected records
([ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7),
[ADR-AZ-WAFOE#8](../waf/operational-excellence.md#rule-adr-az-wafoe8), [ADR-AZ-WAFRE#10](../waf/reliability.md#rule-adr-az-wafre10)); the
rules here cite those and do not repeat their analysis.

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

The baseline monitoring page of the area carries no recommendations, so it is no rule here. It informs the planned alerting all the same. It
suggests deploying Microsoft's baseline alerts through a deploy-if-not-exists policy, at least one action group per subscription, and
Service Health alerts wired straight to an action group. This repository deploys monitoring in the template, never through a
deploy-if-not-exists policy ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)), so the planned alerts are template resources; one action
group per subscription in `foundation`, addressed to the subscription's `Owner` role like the budget, keeps every address out of the configs
(see [20](#20--raise-operational-alerts-with-azure-monitor)).

The example basis is the repository's three templates: `foundation` (a Log Analytics workspace and a Key Vault per subscription),
`discovery` (the landing zone), and `expedition` (a workload that lands in it, [ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)). Every
takeaway below points at what those three do, or says plainly what they do not.

### 1 — Keep one Log Analytics workspace for the platform

```text
CAF management — Inventory and visibility considerations, Inventory and visibility recommendations — recommendation 1
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (retrieved 2026-10-15)
Summary (ours): Run the platform from one central Log Analytics workspace, unless access control, data sovereignty, or retention rules
  force a split; workload teams may add workspaces of their own for workload-specific data.
```

#### What 1 means here

The repository deviates on purpose. `foundation` deploys one workspace per subscription, and the landing zone and the workload of that
subscription send everything there; there is no central workspace across subscriptions. The deviation and its cost are recorded once, in
[ADR-AZ-CAFPRIN#3](design-principles.md#rule-adr-az-cafprin3): a view across customers needs a cross-workspace query, and a platform-wide
alert is one alert per workspace. The reason is the access-control exception the recommendation itself allows: each customer's telemetry
stays in the subscription that customer's access covers, and non-production and production stay apart.

##### 1 in `foundation`

Deploys the subscription's workspace through `log-analytics.bicep`, for example `nsub-weu-zct-fnd-log` for the shared non-production
subscription and `psub-weu-zct-fnd-apex-log` for `apex` production.

##### 1 in `discovery`

Reads the workspace of its own subscription by `logAnalyticsResourceGroupName` and `logAnalyticsName` and sends its diagnostics there.

##### 1 in `expedition`

Reads the same two parameters and sends its diagnostics to the workspace of the subscription it lands in.

##### 1 status

Not adopted, because a workspace per subscription keeps each customer's telemetry inside that customer's subscription
([ADR-AZ-CAFPRIN#3](design-principles.md#rule-adr-az-cafprin3)).

### 2 — Archive logs beyond seven years to immutable storage

```text
CAF management — Inventory and visibility considerations, Inventory and visibility recommendations — recommendation 2
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (retrieved 2026-10-15)
Summary (ours): When logs must be kept for more than seven years, export them to Azure Storage under an immutable (write-once) policy.
```

#### What 2 means here

`log-analytics.bicep` takes `retentionInDays` between 30 and 730; `foundation` does not pass it, so every workspace keeps the default of 30
days. No example customer carries an obligation to keep logs for years, so no export or archive exists. A longer retention per environment
class is the config value [ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7) plans; a customer whose rules demand more
than the workspace can hold would add a data export to an immutable storage account, deployed by `foundation` beside the workspace.

##### 2 in `foundation`

Keeps 30 days in every workspace; it is where both a longer retention and an archive export would be configured.

##### 2 in `discovery`

Not applicable: it sends logs to `foundation`'s workspace and keeps none of its own.

##### 2 in `expedition`

Not applicable: it sends logs to `foundation`'s workspace and keeps none of its own.

##### 2 status

Not adopted, because no example customer needs logs kept beyond the workspace's retention.

### 3 — Enforce settings and report compliance with Azure Policy

```text
CAF management — Inventory and visibility considerations, Inventory and visibility recommendations — recommendation 3
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (retrieved 2026-10-15)
Summary (ours): Use Azure Policy to enforce the settings that must hold across the organisation and to report compliance with them.
```

#### What 3 means here

Every landing zone assigns three built-in policies at subscription scope — allowed locations, a required tag, and no public IP address on a
network interface ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)) — and Azure keeps a compliance state for every assignment, so the
report comes with the assignment. How the policies are chosen, pinned, and assigned is the governance record's
([ADR-AZ-CAFGOV#4](governance.md#rule-adr-az-cafgov4), [ADR-AZ-CAFGOV#6](governance.md#rule-adr-az-cafgov6)).

##### 3 in `foundation`

Assigns no policy; its resources fall under the subscription's assignments.

##### 3 in `discovery`

Assigns the three policies through `policy-assignment.bicep`, each with a non-compliance message, in the mode `policy_enforcement` sets.

##### 3 in `expedition`

Assigns no policy; its resources fall under the subscription's assignments.

##### 3 status

Realised — three built-in policies per subscription, with Azure's compliance reporting for each.

### 4 — Analyse network traffic with Traffic Analytics

```text
CAF management — Inventory and visibility considerations, Inventory and visibility recommendations — recommendation 4
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (retrieved 2026-10-15)
Summary (ours): Use Traffic Analytics to see the IP traffic that flows through the virtual networks.
```

#### What 4 means here

Traffic Analytics reads flow logs, and no network logs its flows: the network security groups and the virtual network send their resource
logs and metrics to the workspace, not their flows. [ADR-AZ-WAFSE#6](../waf/security.md#rule-adr-az-wafse6) plans virtual network flow logs
into `foundation`'s workspace. Turning on Traffic Analytics is part of that work: the flow log names the workspace, and it needs a storage
account for the raw flow records, which `foundation` would hold beside the workspace.

##### 4 in `foundation`

Holds the workspace Traffic Analytics would write to; the flow-log storage account would join it.

##### 4 in `discovery`

Deploys the virtual network and its network security groups, and is where the flow log with Traffic Analytics would be configured.

##### 4 in `expedition`

Not applicable: it creates no network.

##### 4 status

Planned (follow-up) — virtual network flow logs with Traffic Analytics, as part of the flow logging ADR-AZ-WAFSE#6 plans.

### 5 — Lock critical shared resources against deletion

```text
CAF management — Inventory and visibility considerations, Inventory and visibility recommendations — recommendation 5
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (retrieved 2026-10-15)
Summary (ours): Put resource locks on critical shared services so they cannot be deleted by accident.
```

#### What 5 means here

No module places a lock. The resources every spoke depends on are the hub's virtual network and its private DNS zones: deleting either
breaks name resolution or peering for every workload of the tier. [ADR-AZ-WAFRE#5](../waf/reliability.md#rule-adr-az-wafre5) plans a
`CanNotDelete` lock on them, as a lock module the hub deploys. `foundation`'s Key Vault, which holds the break-glass password every
`expedition` deploy reads ([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)), is a candidate for the same lock.

##### 5 in `foundation`

Places no lock; the vault is a candidate.

##### 5 in `discovery`

Places no lock; the hub's network and DNS zones, for example `psub-weu-zct-disco-vnet` in `psub-weu-zct-disco-rg`, are where the planned
lock goes.

##### 5 in `expedition`

Not applicable: a workload's resources are its own, rebuilt from its config, and shared by nothing else.

##### 5 status

Planned (follow-up) — a delete lock on the hub's network and private DNS zones, with the vault weighed in the same change.

### 6 — Pair role-based access with deny policies

```text
CAF management — Inventory and visibility considerations, Inventory and visibility recommendations — recommendation 6
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (retrieved 2026-10-15)
Summary (ours): Let role assignments decide who may deploy, and deny policies decide what may be deployed, so the two together act as
  guardrails.
```

#### What 6 means here

Who may deploy is the role-based access of each subscription: every subscription is deployed by its own service connection, which holds
rights there and nowhere else ([ADR-AZ-WAFSE#4](../waf/security.md#rule-adr-az-wafse4)). What may be deployed is the landing zone's three
policies, each a deny effect: a resource outside the region, without the required tag, or with a public IP address on a network interface is
refused ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)). The policies deny where `policy_enforcement` enforces, which its sensible
default does in production, and only report outside it ([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)).

##### 6 in `foundation`

Deployed by its subscription's service connection; its resources pass the policies because they carry the CAF tags.

##### 6 in `discovery`

Assigns the deny-effect policies, in the mode its `psub` or `nsub` config reads by config address.

##### 6 in `expedition`

Deployed by its subscription's service connection, and refused by the policies in production if it breaks one.

##### 6 status

Realised — a service connection per subscription decides who deploys, and deny-effect policies decide what.

### 7 — Monitor Service Health and Resource Health events

```text
CAF management — Inventory and visibility considerations, Inventory and visibility recommendations — recommendation 7
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (retrieved 2026-10-15)
Summary (ours): Include Service Health and Resource Health events in the platform's monitoring.
```

#### What 7 means here

`subscription-diagnostic-setting.bicep` sends the activity log categories `ServiceHealth` and `ResourceHealth`, with the others, to the
subscription's workspace, so the events are collected. Nothing alerts on them; the Service Health and Resource Health alerts per
subscription are planned by [ADR-AZ-WAFRE#10](../waf/reliability.md#rule-adr-az-wafre10), in the landing zone, sent to the action group of
[20](#20--raise-operational-alerts-with-azure-monitor).

##### 7 in `foundation`

Receives the events in its workspace; it would hold the action group the alerts are sent to.

##### 7 in `discovery`

Deploys the activity-log diagnostic setting; the planned Service Health and Resource Health alerts belong here.

##### 7 in `expedition`

Not applicable: the subscription's health events are the landing zone's to watch.

##### 7 status

Partly realised — the events are collected per subscription; alerts on them are planned (follow-up).

### 8 — Keep raw logs in Azure, not on premises

```text
CAF management — Inventory and visibility considerations, Inventory and visibility recommendations — recommendation 8
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-platform (retrieved 2026-10-15)
Summary (ours): Do not ship raw Azure log entries back to on-premises monitoring systems; keep them in Azure and forward only critical
  alerts to an on-premises security event system.
```

#### What 8 means here

The repository has no on-premises connectivity and no on-premises monitoring system, so every log it collects stays in a workspace in Azure.
The recommendation would apply if a customer's security operations ran on premises; the forwarding would then be an alert, not a log export.

##### 8 status

Not adopted, because there is no on-premises system to forward to.

### 9 — Replicate virtual machines with Site Recovery

```text
CAF management — Business continuity and disaster recovery, Design recommendations — recommendation 9
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery (retrieved 2026-10-15)
Summary (ours): Use Azure Site Recovery to replicate virtual machines to another region, for low recovery point and time objectives and
  drills that do not disrupt production, with policy to enable and audit the replication.
```

#### What 9 means here

No template deploys a virtual machine: `vm.bicep` exists among the shared modules, but none of the three templates uses it. Every
environment maps to one region ([ADR-AZ-NETWORK#3](../azure-network-model.md#rule-adr-az-network3)), so there is no second region to
replicate to either. A template that deploys virtual machines in production, together with a second region, would bring this recommendation
in.

##### 9 status

Not adopted, because no virtual machine is deployed and there is no second region.

### 10 — Use the disaster recovery built into platform services

```text
CAF management — Business continuity and disaster recovery, Design recommendations — recommendation 10
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery (retrieved 2026-10-15)
Summary (ours): Rely on the replication and failover that platform services provide themselves, with Azure Policy to audit and enforce
  their configuration.
```

#### What 10 means here

The workload uses only platform services, and their redundancy is a module default or a config value
([ADR-AZ-LZ#5](../landing-zones.md#rule-adr-az-lz5)): storage is zone-redundant (`Standard_ZRS`) in every environment, and a production
database is zone-redundant with geo-redundant backups, so it can be restored in another region. The redundancy analysis is
[ADR-AZ-WAFRE#5](../waf/reliability.md#rule-adr-az-wafre5) and the recovery approach — redeploy and restore — is
[ADR-AZ-WAFRE#9](../waf/reliability.md#rule-adr-az-wafre9). No policy audits these settings; the planned check over the compiled templates
that fails a production config without zone redundancy, recorded under ADR-AZ-WAFRE#5, covers the same ground at build time.

##### 10 in `foundation`

Uses the modules' defaults; the workspace and the vault carry no redundancy setting of their own.

##### 10 in `discovery`

Not applicable: it deploys network and governance resources, not data services.

##### 10 in `expedition`

Zone-redundant storage in every slot; in `apex/prod.yml` a provisioned `GP_Gen5` database with `Geo` backup storage, zone-redundant by the
template default, while `dev.yml` sets `databaseZoneRedundant` to false and keeps `Local` backups.

##### 10 status

Partly realised — the platform services' own redundancy carries recovery in production; a policy that audits it is not adopted, and the
build-time check is planned (follow-up).

### 11 — Use Azure-native backup

```text
CAF management — Business continuity and disaster recovery, Design recommendations — recommendation 11
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery (retrieved 2026-10-15)
Summary (ours): Back up with Azure Backup and the backup features built into platform services rather than third-party tools, with
  policy to enforce the backup configuration.
```

#### What 11 means here

Backup is the platform's own and nothing else: `sql-database.bicep` sets the database's short-term retention policy and its backup storage
redundancy, and `storage-account.bicep` turns on soft delete for blobs and containers (7 days by default). No third-party tool and no backup
vault is involved; a vault would protect virtual machines or other resources that keep no backup of their own, and none is deployed. No
policy enforces the backup configuration; the `@minValue`/`@maxValue` and `@allowed` bounds in `expedition` keep a config within what the
service accepts.

##### 11 in `foundation`

Not applicable: the workspace and the vault keep no backup configuration in the templates.

##### 11 in `discovery`

Not applicable: it deploys no data service.

##### 11 in `expedition`

`databaseBackupRetentionDays` is 35 in `apex/prod.yml` and 7 in `dev.yml`; `databaseBackupStorageRedundancy` is `Geo` in production and
`Local` in development.

##### 11 status

Partly realised — native backups with per-class retention; a policy that enforces them is not adopted, and a backup vault is not needed.

### 12 — Make hybrid connectivity redundant across regions

```text
CAF management — Business continuity and disaster recovery, Design recommendations — recommendation 12
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery (retrieved 2026-10-15)
Summary (ours): Connect to on-premises over ExpressRoute from several regions and peering locations, so the link survives a regional or
  provider outage.
```

#### What 12 means here

The repository has no on-premises connectivity: the hub reserves `GatewaySubnet` and deploys nothing into it
([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)). The recommendation would apply once a gateway is added, and then
together with a second region, which the repository does not have ([ADR-AZ-NETWORK#3](../azure-network-model.md#rule-adr-az-network3)).

##### 12 status

Not adopted, because there is no hybrid connectivity to make redundant.

### 13 — Keep production and recovery address ranges apart

```text
CAF management — Business continuity and disaster recovery, Design recommendations — recommendation 13
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-business-continuity-disaster-recovery (retrieved 2026-10-15)
Summary (ours): Give production and recovery networks address ranges that do not overlap, so a failover needs no re-addressing and every
  site can be connected at once.
```

#### What 13 means here

`network.yml` is the one home of every range, and no two networks in it overlap: every environment's and every subscription's address space
is disjoint from every other, which `NetworkConfig` checks when the file loads
([ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)). There is no recovery network, because every environment maps to one
region ([ADR-AZ-NETWORK#3](../azure-network-model.md#rule-adr-az-network3)); one added to the plan would get a disjoint range by the same
check, so any network can peer to any other.

##### 13 in `foundation`

Not applicable: it deploys no network.

##### 13 in `discovery`

Reads its address space and subnets from `network.yml` by config address, never as a copy
([ADR-AZ-NETWORK#1](../azure-network-model.md#rule-adr-az-network1)).

##### 13 in `expedition`

Not applicable: it creates no network; its private endpoints take addresses in the landing zone's subnet.

##### 13 status

Realised — no two ranges of the plan overlap, checked when the plan loads.

### 14 — Patch virtual machines with Update Manager

```text
CAF management — Operational compliance considerations, Operational compliance recommendations — recommendation 14
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-operational-compliance (retrieved 2026-10-15)
Summary (ours): Patch Windows and Linux virtual machines with Azure Update Manager, enforced by policy so every machine is covered, with
  workload teams setting their own schedules and the central team keeping visibility.
```

#### What 14 means here

No template deploys a virtual machine, so there is no operating system to patch: the workload is platform services whose patching is
Microsoft's. A template that deploys `vm.bicep` would bring Update Manager in, with its schedule as a config value of that template.

##### 14 status

Not adopted, because no virtual machine is deployed.

### 15 — Audit in-guest configuration drift by policy

```text
CAF management — Operational compliance considerations, Operational compliance recommendations — recommendation 15
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-operational-compliance (retrieved 2026-10-15)
Summary (ours): Audit configuration drift inside virtual machines with Machine Configuration, assigned through Azure Policy.
```

#### What 15 means here

No template deploys a virtual machine, so there is no guest configuration to drift. Drift of the Azure resources themselves is handled by
redeploying the template from its config, which restores the declared state, and by the landing zone's policies
([ADR-AZ-WAFOE#10](../waf/operational-excellence.md#rule-adr-az-wafoe10)).

##### 15 status

Not adopted, because no virtual machine is deployed.

### 16 — Collect workload logs and metrics in a workspace

```text
CAF management — Azure workload management and monitoring, Workload management and monitoring recommendations — recommendation 16
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (retrieved 2026-10-15)
Summary (ours): Collect the logs and metrics of infrastructure and platform services alike in a Log Analytics workspace.
```

#### What 16 means here

This is the monitoring stack of [ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7): each template sends the diagnostics
of the resources it deploys to `foundation`'s workspace through `diagnostic-setting.bicep`, which picks the categories of each resource kind
(logs by the `allLogs` category group, plus the kind's metrics). A diagnostic setting in the template exists when the deploy succeeds, which
a deploy-if-not-exists policy cannot promise ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)). The gap is `foundation`'s own Key Vault,
which the module supports (`keyVault`) but the template does not wire.

##### 16 in `foundation`

Deploys the workspace; its Key Vault sends no diagnostics, which is planned.

##### 16 in `discovery`

Sends the virtual network's and every network security group's diagnostics, and the subscription's activity log.

##### 16 in `expedition`

Sends the storage account's metrics, the blob service's logs and metrics, and the database's logs and metrics.

##### 16 status

Partly realised — every resource but `foundation`'s vault sends its telemetry to the workspace; the vault's diagnostics are planned
(follow-up).

### 17 — Control workspace access with role-based access

```text
CAF management — Azure workload management and monitoring, Workload management and monitoring recommendations — recommendation 17
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (retrieved 2026-10-15)
Summary (ours): Govern who can read a workspace and its logs with Azure role-based access control.
```

#### What 17 means here

A workspace per subscription makes access to telemetry a matter of the subscription's own role-based access: whoever may read a customer's
subscription may read its workspace, and nobody gains another customer's logs by reading one workspace
([ADR-AZ-CAFPRIN#3](design-principles.md#rule-adr-az-cafprin3)). `log-analytics.bicep` sets no access-control mode, so Azure's default for
the workspace applies, and the templates assign no role to people. Role assignments as code are planned by
[ADR-AZ-WAFSE#5](../waf/security.md#rule-adr-az-wafse5); a reader role on the workspace belongs among them.

##### 17 in `foundation`

Deploys the workspace with no role assignment; access is inherited from the subscription.

##### 17 in `discovery`

Not applicable: it writes to the workspace and grants no access to it.

##### 17 in `expedition`

Not applicable: it writes to the workspace and grants no access to it.

##### 17 status

Partly realised — access follows the subscription boundary; role assignments on the workspace as code are planned (follow-up).

### 18 — Use metrics for time-sensitive analysis

```text
CAF management — Azure workload management and monitoring, Workload management and monitoring recommendations — recommendation 18
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (retrieved 2026-10-15)
Summary (ours): Use Azure Monitor Metrics, a time-series store, for fast alerting and performance analysis, and correlate it with logs to
  find root causes.
```

#### What 18 means here

Every Azure resource publishes its platform metrics to Azure Monitor with no configuration, and `diagnostic-setting.bicep` also copies the
metric categories of each kind to the workspace, so metrics and logs can be read side by side there. What is missing is the fast use the
recommendation is about: no metric alert watches the database's availability or capacity, which
[ADR-AZ-WAFRE#10](../waf/reliability.md#rule-adr-az-wafre10) plans for production.

##### 18 in `foundation`

Receives the copied metrics in its workspace.

##### 18 in `discovery`

Exports the virtual network's metrics (`AllMetrics`); network security groups have none to export.

##### 18 in `expedition`

Exports the storage account's and the blob service's `Transaction` metrics and the database's metric categories; its metric alerts are
planned.

##### 18 status

Partly realised — metrics are available and copied beside the logs; metric alerts are planned (follow-up).

### 19 — Use logs for insight and reporting

```text
CAF management — Azure workload management and monitoring, Workload management and monitoring recommendations — recommendation 19
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (retrieved 2026-10-15)
Summary (ours): Use Azure Monitor Logs to analyse and report across the data of many services; shared landing-zone storage accounts may
  hold the logs of the virtual machine diagnostics extension.
```

#### What 19 means here

The logs are there to query: one workspace per subscription holds the activity log and the diagnostics of every template. The reporting on
top of them — saved queries, workbooks, a dashboard — is not in the repository; it comes with the health model and dashboards that
[ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7) plans, as template resources so they deploy with the workspace. The
diagnostics-extension storage the recommendation mentions concerns virtual machines, which are not deployed.

##### 19 in `foundation`

Holds the workspace to query; it is where shared queries and workbooks would be deployed.

##### 19 in `discovery`

Supplies the activity log and the network diagnostics to query.

##### 19 in `expedition`

Supplies the storage and database diagnostics to query.

##### 19 status

Partly realised — the logs are collected and queryable; reports as code are planned (follow-up).

### 20 — Raise operational alerts with Azure Monitor

```text
CAF management — Azure workload management and monitoring, Workload management and monitoring recommendations — recommendation 20
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (retrieved 2026-10-15)
Summary (ours): Generate operational alerts with Azure Monitor alerts across metrics and logs, with actions and smart grouping of related
  alerts.
```

#### What 20 means here

No alert rule or action group exists; the only alerts are the landing zone's budget thresholds, sent to the subscription's `Owner` role by
`budget.bicep`. Alert routing is the gap [ADR-AZ-WAFOE#8](../waf/operational-excellence.md#rule-adr-az-wafoe8) records, and the alerts
themselves are planned by [ADR-AZ-WAFRE#10](../waf/reliability.md#rule-adr-az-wafre10). The shape follows the rest of the design: one action
group per subscription in `foundation`, addressed to the subscription's `Owner` role as the budget is, so no address lives in a config; each
later template points the alert rules for its own resources at it. Microsoft's baseline alerts deployed by policy are not the route, for the
reason of [ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3).

##### 20 in `foundation`

Deploys no action group; one per subscription is planned here.

##### 20 in `discovery`

Deploys the budget and its alerts; Service Health and Resource Health alerts are planned here (see
[7](#7--monitor-service-health-and-resource-health-events)).

##### 20 in `expedition`

Deploys no alert rule; database availability and capacity alerts in production are planned.

##### 20 status

Planned (follow-up) — an action group per subscription and alert rules in the templates that own the resources.

### 21 — Group workload resources with Service Groups

```text
CAF management — Azure workload management and monitoring, Workload management and monitoring recommendations — recommendation 21
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (retrieved 2026-10-15)
Summary (ours): Group a workload's resources across subscriptions and resource groups with Azure Service Groups, to make monitoring them
  simpler.
```

#### What 21 means here

A workload here does not spread across subscriptions: `expedition` deploys one resource group per configuration slot inside the subscription
its landing zone serves, and every resource carries the `workload` tag. The resource group and the tag give the grouping a Service Group
would add. The recommendation would apply to a workload that spans subscriptions, which no template deploys.

##### 21 status

Not adopted, because each workload deployment sits in one resource group of one subscription.

### 22 — Track workload health with health models

```text
CAF management — Azure workload management and monitoring, Workload management and monitoring recommendations — recommendation 22
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/management-workloads (retrieved 2026-10-15)
Summary (ours): Model the health of a service group's resources and their dependencies with Azure Monitor health models (in preview).
```

#### What 22 means here

There is no health model. [ADR-AZ-WAFOE#7](../waf/operational-excellence.md#rule-adr-az-wafoe7) and
[ADR-AZ-WAFRE#10](../waf/reliability.md#rule-adr-az-wafre10) plan one, so that an alert points at real impact on the workload rather than at
one resource. Azure Monitor health models are one way to build it; the feature is in preview and builds on Service Groups, which are not
adopted (see [21](#21--group-workload-resources-with-service-groups)), so the choice of tool is made when that work begins.

##### 22 in `foundation`

Holds the workspace a health model would read.

##### 22 in `discovery`

Supplies the network and health signals a model would roll up.

##### 22 in `expedition`

Its storage account and database are the resources the first model would cover.

##### 22 status

Planned (follow-up) — a health model per workload; the tool is chosen when the work begins.

## Decision

The repository answers each of Microsoft's management recommendations with what it does, what it plans, or why it does not adopt it.
Management is one Log Analytics workspace per subscription, a deliberate deviation from one central workspace
([ADR-AZ-CAFPRIN#3](design-principles.md#rule-adr-az-cafprin3)); diagnostic settings deployed by each template, never by policy, send the
activity log and every resource's telemetry there; the landing zone's policies and a budget per subscription complete the baseline. The
recommendations that assume virtual machines (Site Recovery, Update Manager, Machine Configuration) or on-premises connectivity
(ExpressRoute, on-premises monitoring) are not adopted, because nothing deployed needs them. The planned items are alerting (an action group
per subscription, health and metric alerts), the vault's diagnostics, flow logs with Traffic Analytics, delete locks on the hub, reports and
a health model, and workspace role assignments as code.

### How this is enforced

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `foundation`, `discovery`, and `expedition` on every change
  under `infrastructure/`, and the parameter-model test checks every rendered parameters file against the compiled template
  ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)), so a template that loses its workspace parameters, or a config whose
  backup values fall outside the declared bounds, fails the build.
- `diagnostic-setting.bicep` accepts only the resource kinds it knows, by its `@allowed` decorator, so every diagnostic setting picks the
  categories of its kind.
- The landing zone's assignments deny a non-compliant resource where `policy_enforcement` enforces and report it where it audits
  ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)); Azure keeps their compliance state.
- `NetworkConfig` rejects overlapping ranges when `network.yml` loads, and `Test-AzureNetworkPlan` keeps the plan in step with `azure.yml`
  ([ADR-AZ-NETWORK#6](../azure-network-model.md#rule-adr-az-network6)).
- Planned (follow-up), not existing: a check over the compiled templates (`main.json`) that fails a resource kind with no diagnostic
  setting, citing ADR-AZ-CAFMGMT#16 and ADR-AZ-WAFRE#10; the action group and alert modules; and a lock module.

## Consequences

- Each customer's telemetry stays in that customer's subscription, at the cost of a cross-workspace query for any view across customers.
- Monitoring exists when a deploy succeeds, because the templates deploy it; no remediation task runs later to add it.
- Without alerts, a failure or a health event is found by a person looking, not by the system, until the planned alerting lands.
- The agent-based half of the area — patching, in-guest configuration, virtual machine replication — costs nothing to run here, and returns
  as a decision the day a template deploys a virtual machine.
- Logs live 30 days; a customer with longer obligations needs the planned retention value in `foundation`'s config, or an archive export
  beside the workspace.
