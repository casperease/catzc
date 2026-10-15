---
catzc:
  derived:
    path: docs/adr/azure/waf/performance-efficiency.md
    kind: adr
    body_sha: "5442f36725bb"
    defines:
      - ADR-AZ-WAFPE#1
      - ADR-AZ-WAFPE#2
      - ADR-AZ-WAFPE#3
      - ADR-AZ-WAFPE#4
      - ADR-AZ-WAFPE#5
      - ADR-AZ-WAFPE#6
      - ADR-AZ-WAFPE#7
      - ADR-AZ-WAFPE#8
      - ADR-AZ-WAFPE#9
      - ADR-AZ-WAFPE#10
      - ADR-AZ-WAFPE#11
      - ADR-AZ-WAFPE#12
    adrs:
      - ADR-AUTO-TEST#41
      - ADR-AZ-DATAMOD#10
      - ADR-AZ-DATAMOD#2
      - ADR-AZ-DATAMOD#9
      - ADR-AZ-LZ#1
      - ADR-AZ-LZ#2
      - ADR-AZ-LZ#3
      - ADR-AZ-LZ#4
      - ADR-AZ-LZ#5
      - ADR-AZ-LZ#6
      - ADR-AZ-LZ#7
    links:
      - docs/adr/automation/test-automation.md#rule-adr-auto-test41
      - docs/adr/azure/azure-data-model.md
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod10
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/landing-zones.md
      - docs/references/waf/index.md
      - "https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/checklist"
---

# ADR: Performance efficiency — the Well-Architected checklist PE:01 to PE:12, rule by rule, against foundation, discovery and expedition

Pairs with [`landing-zones`](../landing-zones.md) (ADR-AZ-LZ#5 names the performance-efficiency line of the workload) and
[`data-model`](../azure-data-model.md) (the configuration tree that carries every SKU and capacity per environment class).

## Rules: ADR-AZ-WAFPE

### Rule ADR-AZ-WAFPE:1

Not adopted: the example templates set no numeric performance targets, because they deploy no application with users or flows to measure; a
workload built on them sets its own targets before it is deployed.

- [PE:01 — Define performance targets](#pe01--define-performance-targets)

### Rule ADR-AZ-WAFPE:2

Capacity is a config value per environment class — the database SKU, vCore count, and serverless floor in each `expedition` config, the
budget per subscription in each `discovery` config — and no demand forecast or service-limit check stands behind it.

- [PE:02 — Conduct capacity planning](#pe02--conduct-capacity-planning)

### Rule ADR-AZ-WAFPE:3

The templates choose platform services over custom builds — Azure SQL Database and StorageV2 behind private endpoints, a Log Analytics
workspace, a Key Vault — in one region, with zone-redundant storage and the database tier per environment class from the config.

- [PE:03 — Select the right services](#pe03--select-the-right-services)

### Rule ADR-AZ-WAFPE:4

The workload's data services and the landing zone's network send their logs and metrics through a diagnostic setting to `foundation`'s Log
Analytics workspace of the same subscription, so production and non-production signals never mix; baselines, alerts, and dashboards are not
part of the templates.

- [PE:04 — Establish consistent performance measurement](#pe04--establish-consistent-performance-measurement)

### Rule ADR-AZ-WAFPE:5

Outside production the database scales itself between a serverless floor and ceiling from the config and pauses when idle; in production it
is provisioned at a fixed capacity. The unit of scale-out is a configuration slot, a whole deployment of the workload in its own resource
group; no autoscale rule and no data partitioning exist.

- [PE:05 — Optimize scaling and partitioning](#pe05--optimize-scaling-and-partitioning)

### Rule ADR-AZ-WAFPE:6

Not adopted: no load, stress, or soak test runs against a deployment, because the example workload carries no application or traffic to
load; the test tiers verify the code and the compiled templates, not a deployment's performance.

- [PE:06 — Optimize your workload's performance by regularly testing in a production-like environment](#pe06--optimize-your-workloads-performance-by-regularly-testing-in-a-production-like-environment)

### Rule ADR-AZ-WAFPE:7

Not adopted for code, because the templates deploy no application code; on the infrastructure side the templates hand transport security,
identity, and backups to the platform rather than building them.

- [PE:07 — Optimize code and infrastructure](#pe07--optimize-code-and-infrastructure)

### Rule ADR-AZ-WAFPE:8

Not adopted: the example database holds no schema, data, or queries to tune; the database's query and wait signals reach the workspace
through its diagnostic setting (ADR-AZ-WAFPE#4), ready for the workload that owns a schema.

- [PE:08 — Optimize data usage](#pe08--optimize-data-usage)

### Rule ADR-AZ-WAFPE:9

Not adopted at the level of flows, because the workload has none; each deployment carries a `criticality` tag, and each customer gets its
own subscription, landing zone, and workload resources, which isolates customers from one another.

- [PE:09 — Prioritize the performance of critical flows](#pe09--prioritize-the-performance-of-critical-flows)

### Rule ADR-AZ-WAFPE:10

The routine tasks the templates carry run on the platform: deployments are declarative and incremental, backups are the database's automated
backups and the storage account's soft delete, and the break-glass password lives in Key Vault. No task is scheduled off-peak.

- [PE:10 — Optimize operational tasks](#pe10--optimize-operational-tasks)

### Rule ADR-AZ-WAFPE:11

Not adopted: no performance alert, triage plan, or on-call rota exists, because there is no baseline to deviate from (ADR-AZ-WAFPE#1,
ADR-AZ-WAFPE#4); the activity log's service-health and resource-health records reach the workspace through the landing zone.

- [PE:11 — Respond to live performance issues](#pe11--respond-to-live-performance-issues)

### Rule ADR-AZ-WAFPE:12

Not adopted: no continuous performance review runs, because it needs the targets and baselines the templates do not set; changes to the
templates go through the same build and verification as every other change.

- [PE:12 — Continuously optimize performance](#pe12--continuously-optimize-performance)

## Context

The Azure Well-Architected Framework (WAF) is Microsoft's guidance for reviewing a cloud workload against five pillars: reliability,
security, cost optimisation, operational excellence, and performance efficiency. Each pillar has a checklist of numbered recommendations,
and each recommendation has a guide page that explains it. Performance efficiency is about a workload meeting its demand efficiently: it
stays responsive as load rises and falls, without paying for capacity it does not use.

These rules are vendor recommendation, not principled theory: they record what Microsoft advises and what this repository does about each
item, not a conclusion the repository reaches from its own research. Each rule cites Microsoft's page — the code, the title, the link, and
the retrieval date — and summarises it in our words. Nothing is quoted, because the current WAF text is published under the Microsoft Learn
Terms of Use, which carry no reuse licence for a shared repository. The checklist lives at
[learn.microsoft.com](https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/checklist).

The [WAF reference](../../../references/waf/index.md) lists the five pillar records in this repository and the Microsoft checklist each one
cites.

The examples are the three templates under `infrastructure/templates/`: `foundation` (the Log Analytics workspace and Key Vault of each
subscription), `discovery` (the landing zone, ADR-AZ-LZ#1), and `expedition` (the workload that lands in it, ADR-AZ-LZ#4). Every takeaway
below points at one of them.

### PE:01 — Define performance targets

```text
PE:01 — Define performance targets
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/performance-targets (retrieved 2026-10-15)
Summary (ours): Before a workload is deployed, give every flow numeric performance targets tied to business and user requirements:
error rate, throughput, concurrency, and latency, stated as percentiles rather than averages. Numbers instead of words like "fast" make
performance measurable, give the team shared goals, and show where resources should go. Record the targets centrally, show them on
dashboards, and revisit them with customer feedback.
```

#### What PE:01 means here

A performance target belongs to a workload with users, and the three templates deploy infrastructure without an application on it. No
config, module, or document in the repository holds a latency, throughput, or error-rate number. The place a workload's targets would sit is
beside its template, in its reference article under `docs/references/infrastructure/`, so the numbers travel with the template that has to
meet them.

##### PE:01 in `foundation`

Not applicable: the workspace and the vault serve the other templates, not users, and their performance is Azure's service level.

##### PE:01 in `discovery`

Not applicable: the landing zone carries no traffic of its own; the network's throughput is the platform's.

##### PE:01 in `expedition`

No targets. A real workload built from it would state targets for its database queries and blob reads per environment class before its first
production deploy.

##### PE:01 status

Not adopted, because the example templates serve no users and so have no flow to set a number for.

### PE:02 — Conduct capacity planning

```text
PE:02 — Conduct capacity planning
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/capacity-planning (retrieved 2026-10-15)
Summary (ours): Work out the compute, memory, storage, network, and staff a workload needs to meet its targets, ahead of expected changes
in demand such as seasonal peaks, launches, or campaigns. Base it on historical use or, for a new workload, on research and pilots;
forecast demand; check the forecast against objectives and provider service levels; and know each service's limits before the design
reaches them. Good planning avoids both under-provisioning, which hurts performance, and over-provisioning, which wastes money.
```

#### What PE:02 means here

Capacity is configuration, not code: every capacity a template uses is a parameter, and its value per environment class is written in the
per-slot config ([ADR-AZ-DATAMOD#2](../azure-data-model.md#rule-adr-az-datamod2)). That makes the capacity of every deployment readable from
the configuration tree. What stands behind those values is a choice, not a plan: no utilisation history, forecast, or record of service
limits backs them.

##### PE:02 in `foundation`

The workspace uses the `PerGB2018` pay-as-you-go tier and a 30-day retention, the defaults of `log-analytics.bicep`; the vault uses the
`standard` SKU, the default of `key-vault.bicep`. Both bill by use, so neither has a capacity to plan.

##### PE:02 in `discovery`

The network's ranges come from `network.yml` by config address ([ADR-AZ-DATAMOD#10](../azure-data-model.md#rule-adr-az-datamod10)): one
`/16` per subscription, and a `/24` for the private endpoints and for each environment, which caps the private endpoints a spoke can hold.
The budget per subscription is the one capacity-like number in the configs: 1000 for the production hub, 300 for the apex non-production
spoke.

##### PE:02 in `expedition`

Every config names the database capacity: `GP_S_Gen5` with a ceiling of 2 vCores and a floor of 0.5 outside production, `GP_Gen5` with 2
vCores in production. The storage account is `Standard_ZRS` from the module default and has no capacity setting. A workload that outgrows 2
vCores changes the config, not the template.

##### PE:02 status

Partly realised: capacity is a per-environment config value, but no forecast or service-limit check supports it.

### PE:03 — Select the right services

```text
PE:03 — Select the right services
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/select-services (retrieved 2026-10-15)
Summary (ours): Choose services, infrastructure, and tiers that can meet the performance targets and absorb expected growth, preferring
platform features and managed services over custom builds. Check limits, quotas, and region availability early; choose the region and
availability zones for latency and features, keeping services that talk often close together; pick compute, database, storage, and cache
per requirement; use private networking for latency; and set a sensible tier and minimum instance count per service.
```

#### What PE:03 means here

The templates use managed services throughout and no virtual machine. Every resource is in one region, `westeurope`, for every environment
in `azure.yml`, and the landing zone's allowed-locations policy keeps it there (ADR-AZ-LZ#3), so the workload, its private endpoints, and
its workspace never cross a region. The settings every caller should share are module defaults (zone-redundant storage, a zone-redundant
database where its tier supports it); the settings that differ by environment class are config values (ADR-AZ-LZ#5).

##### PE:03 in `foundation`

A managed Log Analytics workspace and a Key Vault, from `log-analytics.bicep` and `key-vault.bicep`, in the subscription's region.

##### PE:03 in `discovery`

Virtual network peering on the Azure backbone between each spoke and its hub, and private DNS zones in the hub, so a workload reaches its
data services over private addresses (ADR-AZ-LZ#2). The hub reserves `GatewaySubnet` and `AzureFirewallSubnet`, so a gateway or firewall can
join later without renumbering.

##### PE:03 in `expedition`

Azure SQL Database (General Purpose, Gen5) and a StorageV2 account with the `Hot` access tier, both reached only through private endpoints
in the same region. Outside production the database is serverless (`GP_S_Gen5`) and pays only for what it uses; in production it is
provisioned (`GP_Gen5`) and zone-redundant by the template default. The storage account is `Standard_ZRS`. `vm.bicep` exists as a module but
no template uses it.

##### PE:03 status

Realised: managed services, one region, zone redundancy, and a tier per environment class are what the templates deploy.

### PE:04 — Establish consistent performance measurement

```text
PE:04 — Establish consistent performance measurement
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/monitoring (retrieved 2026-10-15)
Summary (ours): Measure performance the same way over time, so behaviour can be compared with a baseline and slowdowns, waste, or scaling
gaps show early. Collect latency, throughput, and resource signals from the application, the resources, the data stores, and the operating
system; keep production and non-production data apart, and performance data apart from business data. Put a diagnostic setting on every
resource, alert on the end-to-end experience, annotate baselines with deployments, and use synthetic transactions when real traffic is
thin.
```

#### What PE:04 means here

Measurement is a diagnostic setting per resource, from the shared `diagnostic-setting.bicep` module, which picks the log and metric
categories each resource kind exposes, into the workspace `foundation` deploys in the same subscription. Since each subscription has its own
workspace and production and non-production run in different subscriptions (`azure.yml`), production and non-production signals land in
different workspaces by construction. The subscription's activity log arrives through `subscription-diagnostic-setting.bicep` (ADR-AZ-LZ#3).
No alert, dashboard, baseline, or synthetic transaction is deployed.

##### PE:04 in `foundation`

The workspace receives everything; the vault has no diagnostic setting of its own, although `diagnostic-setting.bicep` supports the
`keyVault` kind. The workspace's 30-day retention bounds how far back a comparison can reach.

##### PE:04 in `discovery`

The virtual network (all logs and `AllMetrics`) and every network security group (all logs) send to the workspace, and the activity log
streams there with its `ServiceHealth`, `ResourceHealth`, and `Autoscale` categories among the eight it sends.

##### PE:04 in `expedition`

The storage account sends its `Transaction` metrics, the blob service its logs and `Transaction` metrics, and the database its logs and its
`Basic`, `InstanceAndAppAdvanced`, and `WorkloadManagement` metrics. The SQL server and the private endpoints have no diagnostic setting.

##### PE:04 status

Partly realised: every workload resource that carries data is measured into a per-subscription workspace, but the vault is not, and no
baseline, alert, or dashboard reads the data.

### PE:05 — Optimize scaling and partitioning

```text
PE:05 — Optimize scaling and partitioning
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/scale-partition (retrieved 2026-10-15)
Summary (ours): Make scaling and partitioning deliberate and dependable, built on a defined scale unit, so the workload keeps up as demand
rises and stops paying when it falls. Choose vertical or horizontal scaling per component; avoid singletons and client affinity; keep the
application stateless; autoscale managed services with upper limits, meaningful metrics, and thresholds that do not flap; add scale units
as stamps; and plan data partitioning early, testing it for skew.
```

#### What PE:05 means here

Two scaling mechanisms exist, both by configuration. The first is the serverless database outside production: Azure scales its vCores
between the `databaseMinCapacity` floor and the `databaseSkuCapacity` ceiling and pauses it after `databaseAutoPauseDelay` minutes idle, so
the ceiling is the upper limit the checklist asks for. The second is the configuration slot: a special slot deploys a whole second copy of
the workload into its own resource group beside the base slot ([ADR-AZ-DATAMOD#2](../azure-data-model.md#rule-adr-az-datamod2)), and a new
customer gets its own subscription and landing zone, so the templates scale out by deployment unit, much as the Deployment Stamps pattern
does. Production capacity is fixed, no autoscale rule exists, and there is no data to partition.

##### PE:05 in `foundation`

Not applicable: the workspace and the vault scale with use on the platform side and have no setting for it.

##### PE:05 in `discovery`

Each new customer subscription gets its own spoke, peered to its tier's hub through the three-step rollout of ADR-AZ-LZ#7; the address plan
in `network.yml` reserves a `/16` per spoke, so the number of spokes, not their size, is what grows.

##### PE:05 in `expedition`

The non-production configs (`dev.yml`, `test.yml`, `apex/dev.yml`, `apex/dev-blu.yml`, `nova/dev.yml`) scale serverless between 0.5 and 2
vCores and pause after 60 minutes. `apex/prod.yml` is provisioned at 2 vCores with no scaling. `apex/dev-blu.yml` is the special slot that
shows scaling out by deployment.

##### PE:05 status

Partly realised: the non-production database scales within config bounds and the slot is the unit of scale-out, but production does not
scale and no autoscale rule exists.

### PE:06 — Optimize your workload's performance by regularly testing in a production-like environment

```text
PE:06 — Optimize your workload's performance by regularly testing in a production-like environment
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/performance-test (retrieved 2026-10-15)
Summary (ours): Test performance early and regularly, in an environment close enough to production that the results mean something.
Derive pass and fail criteria from the targets, run performance tests in deployment pipelines and on a schedule to catch regressions,
use load, stress, spike, and soak tests with realistic data, compare a baseline with each variant, and record and refresh the baselines.
```

#### What PE:06 means here

The repository's tests verify code, configs, and compiled templates; testing in production, the L4 tier
([ADR-AUTO-TEST#41](../../automation/test-automation.md#rule-adr-auto-test41)), observes a released system but measures no performance. A
production-like place to test exists in the model: `azure.yml` gives each production subscription a `preprod` environment, and `network.yml`
gives the apex production spoke a `preprod` subnet. No `expedition` config targets `preprod`, so nothing is deployed there to test.

##### PE:06 in `foundation`

Not applicable: it serves no traffic to load.

##### PE:06 in `discovery`

Not applicable: the network's performance is the platform's, and the landing zone carries no traffic of its own.

##### PE:06 in `expedition`

No performance test. A workload built from it would deploy to `preprod` with the production SKU and run its load tests there before
promotion.

##### PE:06 status

Not adopted, because the example workload has no application or traffic to load.

### PE:07 — Optimize code and infrastructure

```text
PE:07 — Optimize code and infrastructure
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-code-infrastructure (retrieved 2026-10-15)
Summary (ours): Make code efficient and hand responsibilities to the platform, using code and infrastructure only for their core purpose
and only where needed. Profile to find hot paths and fix them at the root instead of adding capacity; use asynchronous work, queues, and
connection pooling; set resource limits; keep infrastructure simple and offload work such as security filtering; and tune the network with
batching, lean queries, compression, and a CDN for static content.
```

#### What PE:07 means here

The code half does not apply: no template deploys application code. The infrastructure half follows from ADR-AZ-WAFPE#3: the templates build
no service the platform offers. TLS ends at the managed services, identity is a managed identity and Entra ID rather than stored credentials
(ADR-AZ-LZ#6), and backups are platform features, so no component of ours does that work.

##### PE:07 in `foundation`

Not applicable: no code; two managed services.

##### PE:07 in `discovery`

The network is as simple as the landing zone allows: one virtual network, a network security group per workload subnet, and no appliance in
the traffic path; the reserved firewall subnet stays empty.

##### PE:07 in `expedition`

No code. The storage account and database expose only private endpoints, so traffic takes the shortest private path from the spoke.

##### PE:07 status

Not adopted, because the templates deploy no application code; the infrastructure half is realised through ADR-AZ-WAFPE#3.

### PE:08 — Optimize data usage

```text
PE:08 — Optimize data usage
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-data-performance (retrieved 2026-10-15)
Summary (ours): Tune data stores, partitions, and indexes to how the workload is meant to use its data and how it actually does, so
reading, writing, and processing data does not become the bottleneck. Profile the data and its access patterns, watch data-specific metrics
such as query time and I/O, partition with a chosen key, rewrite slow queries and avoid N+1 patterns, maintain indexes, cache and use read
replicas, archive and purge, place data near its users, and keep transactional and analytical stores apart.
```

#### What PE:08 means here

Data tuning needs data, and the example database is empty. What the templates provide is the signal a tuning effort reads: the database's
diagnostic setting sends the `allLogs` category group, which carries its query-store and wait statistics, to the workspace (ADR-AZ-WAFPE#4).
Index design, query rewriting, and partitioning belong to the workload that owns the schema.

##### PE:08 in `foundation`

Not applicable: the workspace's own data use is the platform's; its retention is 30 days.

##### PE:08 in `discovery`

Not applicable: no data store.

##### PE:08 in `expedition`

One empty database and one storage account with the `Hot` access tier and a 7-day soft delete. No schema, index, cache, read replica, or
lifecycle rule.

##### PE:08 status

Not adopted, because the example database has no schema, data, or queries to tune.

### PE:09 — Prioritize the performance of critical flows

```text
PE:09 — Prioritize the performance of critical flows
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/prioritize-critical-flows (retrieved 2026-10-15)
Summary (ours): Give the flows that carry the most important business processes, users, and operations first claim on resources and on
optimisation effort, and let lower-priority flows give way when capacity is short. Inventory every flow with its metrics, rate each one
high, medium, or low by business impact, isolate critical flows with dedicated resources or reserved capacity, rate-limit the rest, and
use priority queues.
```

#### What PE:09 means here

The CAF tags on every resource include `criticality` (ADR-AZ-LZ#5), and the configs rate each deployment with it: `high` for the shared
subscriptions and for production, `medium` for `foundation` and `discovery` in a customer's non-production subscription, and `low` for the
non-production workload. That is a rating per deployment, not per flow, and nothing reserves capacity or limits traffic by it. Isolation
comes from the customer model: each customer has its own subscriptions, spokes, and workload resources, so one customer's load never shares
a database with another's.

##### PE:09 in `foundation`

Rated `high` in the shared and production subscriptions and `medium` in a customer's non-production one; one workspace and one vault per
subscription, so each customer's signals and secrets are its own.

##### PE:09 in `discovery`

Rated `high` for the hubs and the production spoke and `medium` for the non-production spokes; each customer's spoke is its own network.

##### PE:09 in `expedition`

Rated `high` in `apex/prod.yml`, `low` elsewhere. No flows, no rate limit, no queue.

##### PE:09 status

Not adopted, because the example workload has no flows to rate; customers are isolated by subscription.

### PE:10 — Optimize operational tasks

```text
PE:10 — Optimize operational tasks
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/optimize-operational-tasks (retrieved 2026-10-15)
Summary (ours): Routine operations — deployments, backups, secret rotation, virus scans, index rebuilds — share resources with the workload,
so measure their effect on performance, keep it small, and count it in the performance targets. Deploy blue-green or canary with gradual
traffic shift and without dropping instance counts; test in-place upgrades first and schedule them off-peak; tune security tooling; and use
incremental or platform backups and lightweight logging.
```

#### What PE:10 means here

The operational tasks the templates carry are all the platform's. A deployment is `Deploy-Bicep`, an `az deployment group create` (or
`sub create` for `discovery`) in Azure's default incremental mode, so a redeploy changes only what differs and removes nothing. Backups are
the database's automated backups and the storage account's soft delete, which run inside the services. The break-glass password is a Key
Vault reference resolved at deploy time (ADR-AZ-LZ#6), so rotating it touches no running resource. A special slot can run a second copy of
the workload beside the base slot, but no traffic shifts between them. No maintenance window or off-peak schedule is set.

##### PE:10 in `foundation`

The vault holds the password every `expedition` config references; the workspace has no task of its own beyond retention.

##### PE:10 in `discovery`

Each deploy reapplies the network, the policies, and the budget; adding a spoke takes three deploys in a fixed order (ADR-AZ-LZ#7).

##### PE:10 in `expedition`

Point-in-time restore keeps 7 days with locally redundant backups outside production, 35 days with geo-redundant backups in production. The
blob soft delete keeps 7 days. The database has no maintenance window.

##### PE:10 status

Partly realised: every operational task runs on the platform, but none is measured or scheduled off-peak.

### PE:11 — Respond to live performance issues

```text
PE:11 — Respond to live performance issues
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/respond-live-performance-issues (retrieved 2026-10-15)
Summary (ours): Prepare to handle production performance problems quickly and precisely, with clear lines of communication, roles, and
access to data. Keep architecture diagrams current, grant time-limited least-privilege access to monitoring data, alert on deviation from
baselines, follow a documented triage plan, find the root cause from correlated data, and turn each finding into automation or a sharper
alert.
```

#### What PE:11 means here

The data an investigation would read is collected (ADR-AZ-WAFPE#4), and the activity log's `ServiceHealth` and `ResourceHealth` records
reach the workspace, so a platform incident is visible beside the workload's own signals. The architecture is documented in the reference
articles under `docs/references/infrastructure/`. No alert, triage plan, or on-call rota exists, and access to the workspace is whatever
role the subscription grants.

##### PE:11 in `foundation`

The workspace is where an investigation starts; no saved query or workbook ships with it.

##### PE:11 in `discovery`

The activity log and the network's logs give the network side of an incident.

##### PE:11 in `expedition`

The database and blob logs give the data side; nothing alerts on them.

##### PE:11 status

Not adopted, because without targets and baselines there is nothing to alert on.

### PE:12 — Continuously optimize performance

```text
PE:12 — Continuously optimize performance
Source: https://learn.microsoft.com/en-us/azure/well-architected/performance-efficiency/continuous-performance-optimize (retrieved 2026-10-15)
Summary (ours): Keep optimising performance for the workload's whole life, because usage, data volume, features, and technical debt change
how it behaves. Make targets, baselines, and thresholds visible and give the work time; evaluate new platform features; focus on parts that
tend to degrade, such as databases and networking, and on critical flows; automate testing, monitoring, and remediation; and keep tuning
the database and tiering its data.
```

#### What PE:12 means here

Continuous optimisation measures against targets and baselines, which the templates do not set (ADR-AZ-WAFPE#1). What the repository does
continuously is change the templates through the same build and verification as any code: `ci-infrastructure.yaml` compiles and verifies
every template on every change under `infrastructure/`, and `azure.yml` pins the minimum Bicep version (`bicep_min_version`), so a newer
platform feature arrives as a reviewed template change.

##### PE:12 in `foundation`

Not applicable on its own: its two services have no performance setting to revisit.

##### PE:12 in `discovery`

Not applicable on its own: the network has no performance setting to revisit.

##### PE:12 in `expedition`

The SKU, capacity, and serverless settings per environment class are the knobs a review would turn, each a one-line config change.

##### PE:12 status

Not adopted, because no target or baseline exists to optimise against.

## Decision

Each checklist item above carries Microsoft's citation and our summary, then what it means for this repository and for each of the three
templates, then its status. The status is one of realised, partly realised, planned, or not adopted with the reason.

### How this is enforced

These checks exist:

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `foundation`, `discovery`, and `expedition` on every change
  under `infrastructure/`, so a template or config that does not compile, or whose config address does not resolve, fails the build.
- The parameter-model test checks every rendered parameters file against the compiled template
  ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)): a database tier outside the `@allowed` list or a retention outside 1 to
  35 days fails.
- The landing zone's allowed-locations policy keeps every resource in its region (ADR-AZ-LZ#3).

The follow-up to the CAF and WAF work plans these checks; they are not part of the repository:

- A check over the compiled templates (`main.json`) that every resource kind `diagnostic-setting.bicep` supports carries a diagnostic
  setting, citing ADR-AZ-WAFPE#4.
- An integrity test over the `expedition` configs that a production-class config names a provisioned SKU and an explicit capacity, citing
  ADR-AZ-WAFPE#2.

## Consequences

- The capacity of every deployment is readable from the configuration tree, and changing it is a config edit, not a template change.
- Production and non-production signals never share a workspace, because each subscription has its own.
- A workload built on the templates inherits measurement and isolation, but sets its own targets, tests, alerts, and tuning; the templates
  give it nowhere to fall short of a number, because they set none.
- Several items stay not adopted until a workload with users exists; each says why, so a reader sees the gap instead of assuming it is
  covered.
