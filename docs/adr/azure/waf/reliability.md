# ADR: Well-Architected reliability — Microsoft's reliability checklist, cited, and what the templates do about each item

Pairs with [`landing-zones`](../landing-zones.md) (the landing zone and the workload these rules review) and
[`network-model`](../azure-network-model.md) (the one region per environment that bounds every redundancy rule here).

## Rules: ADR-AZ-WAF-RE

### Rule ADR-AZ-WAF-RE-RE01

Every resource a template deploys is a managed platform service built from a shared module with secure, redundant defaults, and each
template deploys only what its stated purpose needs; no template runs self-managed compute.

- [RE:01 — Focus your workload design on simplicity and efficiency](#re01--focus-your-workload-design-on-simplicity-and-efficiency)

### Rule ADR-AZ-WAF-RE-RE02

Every deployment rates its business criticality in the CAF `criticality` tag (`low`, `medium`, `high`) of its config; a catalogue of user
and system flows belongs to a workload that has users, and the example templates carry none.

- [RE:02 — Identify and rate user and system flows](#re02--identify-and-rate-user-and-system-flows)

### Rule ADR-AZ-WAF-RE-RE03

This record classes each template's dependencies as strong or weak; a failure mode analysis per user flow is not adopted, because the
example templates carry no user flows to analyse.

- [RE:03 — Use failure mode analysis (FMA) to identify potential failures in your workload](#re03--use-failure-mode-analysis-fma-to-identify-potential-failures-in-your-workload)

### Rule ADR-AZ-WAF-RE-RE04

The recovery targets of each environment class — the recovery point objective (RPO) and the recovery time objective (RTO) — are planned as
stated values beside the `expedition` settings that realise them; availability SLOs are not adopted, because the example deployments serve
no users to measure.

- [RE:04 — Define reliability and recovery targets](#re04--define-reliability-and-recovery-targets)

### Rule ADR-AZ-WAF-RE-RE05

Redundancy stays inside one region: storage is zone-redundant in every environment, and a production database is zone-redundant with
geo-redundant backups. A second region is not adopted ([ADR-AZ-NETWORK-ONEADDRESSSPACE](../azure-network-model.md#rule-adr-az-network-oneaddressspace)); delete locks on
the resources every spoke depends on are planned.

- [RE:05 — Add redundancy at different levels, especially for critical flows](#re05--add-redundancy-at-different-levels-especially-for-critical-flows)

### Rule ADR-AZ-WAF-RE-RE06

The templates deploy no compute to scale. A non-production database scales itself inside a serverless range capped by `databaseSkuCapacity`;
a production database scales by a config change and a deploy.

- [RE:06 — Implement a timely and reliable scaling strategy at the application, data, and infrastructure levels](#re06--implement-a-timely-and-reliable-scaling-strategy-at-the-application-data-and-infrastructure-levels)

### Rule ADR-AZ-WAF-RE-RE07

A failure stays contained by isolation and platform failover: each customer subscription holds its own `foundation`, landing zone and
workload, zone-redundant services fail over inside Azure, and soft delete keeps a deleted blob or container recoverable. Automated
remediation is planned.

- [RE:07 — Strengthen the resiliency of your workload by implementing self-preservation and self-healing measures](#re07--strengthen-the-resiliency-of-your-workload-by-implementing-self-preservation-and-self-healing-measures)

### Rule ADR-AZ-WAF-RE-RE08

Resiliency testing by fault injection, failover drills and restore tests is not adopted, because the example deployments target placeholder
subscriptions; the CI pipeline tests what needs no Azure: that every template and config compiles and binds.

- [RE:08 — Test for resiliency and availability scenarios by applying the principles of chaos engineering](#re08--test-for-resiliency-and-availability-scenarios-by-applying-the-principles-of-chaos-engineering)

### Rule ADR-AZ-WAF-RE-RE09

Recovery is a redeploy and a restore: the templates are idempotent and rebuild a subscription in the order `foundation`, `discovery`,
`expedition`, and a production database restores from its geo-redundant backups. A written disaster recovery plan is planned; a prepared
secondary region is not adopted ([ADR-AZ-NETWORK-ONEADDRESSSPACE](../azure-network-model.md#rule-adr-az-network-oneaddressspace)).

- [RE:09 — Implement structured, tested, and documented disaster recovery (DR) plans](#re09--implement-structured-tested-and-documented-disaster-recovery-dr-plans)

### Rule ADR-AZ-WAF-RE-RE10

The landing zone and the workload send their diagnostics to `foundation`'s Log Analytics workspace, and the subscription's activity log, its
Service Health and Resource Health events included, streams there too. Alerts on those signals, a health model, and diagnostics for
`foundation`'s own Key Vault are planned.

- [RE:10 — Continuously measure and track system health using uptime and reliability indicators](#re10--continuously-measure-and-track-system-health-using-uptime-and-reliability-indicators)

## Context

Microsoft's Azure Well-Architected Framework (WAF) reviews a workload against five pillars: reliability, security, cost optimisation,
operational excellence, and performance efficiency. Each pillar publishes a design review checklist of numbered recommendations, and each
recommendation links to a guide that explains it. The reliability pillar asks whether a workload keeps working when parts of it fail and how
it returns to full function afterwards, starting from the availability and recovery targets the business sets.

These rules are vendor recommendation, not principled theory: they record what Microsoft advises for Azure and what this repository does
about each item, and they carry no more authority than that. Each item below cites Microsoft's page — its code, title, link, and retrieval
date — and summarises it in our own words. Nothing is quoted, because the current WAF text is published under the
[Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), not under a reuse licence. The example basis of every
takeaway is the three templates `foundation`, `discovery` (the landing zone), and `expedition` (the workload), deployed in that order
([landing-zones](../landing-zones.md)).

The [WAF reference](../../../references/waf/index.md) lists the five pillar records in this repository and the Microsoft checklist each one
cites.

### RE:01 — Focus your workload design on simplicity and efficiency

```text
RE:01 — Focus your workload design on simplicity and efficiency
Source: https://learn.microsoft.com/en-us/azure/well-architected/reliability/simplify (retrieved 2026-10-15)
Summary (ours): Trace every component and design choice back to a business requirement, because each extra moving part adds
coordination and new ways to fail. Working out flows, requirements and targets with stakeholders shows what the design needs; managed
platform services take building and running work off the team; loose coupling stops one failure from cascading; cross-cutting concerns
such as authentication belong in one shared service; and code nothing uses is removed.
```

#### What RE:01 means here

Simplicity is the shape of the templates. Every resource comes from one of the shared modules in `infrastructure/modules/`, and the settings
every caller shares — zone redundancy, public access off, TLS 1.2, a managed identity — are module defaults, so a template states only what
differs ([ADR-AZ-LZ-EVERYPILLAR](../landing-zones.md#rule-adr-az-lz-everypillar)). Cross-cutting concerns live once: secrets in `foundation`'s Key Vault, logs in
its workspace, the network and the private DNS zones in the landing zone ([ADR-AZ-LZ-WORKLOADOWNSNONE](../landing-zones.md#rule-adr-az-lz-workloadownsnone)), and SQL
access through an Entra ID group ([ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins)).

##### RE:01 in `foundation`

Two managed services, `log-analytics.bicep` and `key-vault.bicep`, and nothing else; the template passes names and tags and keeps every
module default.

##### RE:01 in `discovery`

Only platform networking and governance resources: a resource group, a virtual network with inline subnets, a network security group per
workload subnet, a route table on a spoke, peerings, the hub's two private DNS zones, three built-in policy assignments, the activity-log
diagnostic setting, and a budget. The policies are Azure built-in definitions, so there is no custom definition to maintain.

##### RE:01 in `expedition`

Platform services only: a `Standard_ZRS` storage account (`storage-account.bicep`) and an Azure SQL logical server with one database
(`sql-server.bicep`, `sql-database.bicep`), reached through two private endpoints. No virtual machine and no self-managed database.

##### RE:01 status

realised — every template builds from managed services and shared modules, with no self-managed compute.

### RE:02 — Identify and rate user and system flows

```text
RE:02 — Identify and rate user and system flows
Source: https://learn.microsoft.com/en-us/azure/well-architected/reliability/identify-flows (retrieved 2026-10-15)
Summary (ours): Early in design, list every user flow and system flow with its start, end, steps and dependencies, and tie each to the
business process it serves, its owner and its business impact. Rate each flow's criticality (high, medium, low) so reliability investment
goes to the most critical first, write down each flow's capacity, availability and recovery assumptions, and revisit the rating as
priorities and usage change.
```

#### What RE:02 means here

The example templates have no users, so there is no flow to catalogue; the unit the repository rates is the deployment. Every config carries
the CAF tags, and one of them is `criticality`, rated per config. The rating follows dependency, not environment: the shared non-production
hub is `high`, because every non-production spoke resolves its private endpoints through its DNS zones. No check or template reads the tag;
it is a label for people and for cost and inventory queries.

##### RE:02 in `foundation`

`criticality: high` for the shared platform's `nsub` and `psub`, and for each customer's `psub`; `medium` for a customer's `nsub`.

##### RE:02 in `discovery`

The same split: `high` for both hubs and for a production spoke (`apex/psub.yml`), `medium` for the non-production spokes (`apex`, `nova`,
`flux`).

##### RE:02 in `expedition`

`criticality: low` for every non-production config (`dev.yml`, `test.yml`, `apex/dev.yml`, the special slot `apex/dev-blu.yml`,
`nova/dev.yml`) and `high` for `apex/prod.yml`. A workload with real users adds its flow catalogue to its own documentation; the template
has no place for it.

##### RE:02 status

partly realised — criticality is rated per deployment in its tags, and no flow catalogue exists because the examples have no flows.

### RE:03 — Use failure mode analysis (FMA) to identify potential failures in your workload

```text
RE:03 — Use failure mode analysis (FMA) to identify potential failures in your workload
Source: https://learn.microsoft.com/en-us/azure/well-architected/reliability/failure-mode-analysis (retrieved 2026-10-15)
Summary (ours): Failures happen however much resiliency is built in, so walk each critical flow step by step, list the components and
the internal and external dependencies it uses, class each dependency as strong or weak, and ask how each failure mode — a region, zone
or service outage, an attack, a misconfiguration, an operator error, maintenance, overload — would affect it. For each relevant failure,
decide the mitigation and how it is detected, and keep the analysis current from tests and incidents.
```

#### What RE:03 means here

A per-flow analysis needs flows, and the examples have none. What the repository can state is the dependency list of its templates, which is
the input a workload owner's analysis starts from. A strong dependency stops the dependent from working when it fails; a weak one degrades
it.

##### RE:03 in `foundation`

No dependency on the other templates. Its Key Vault is a strong dependency of every `expedition` deploy, because the break-glass password is
a Key Vault reference resolved at deploy time; it is no dependency of the running database. Its workspace is a weak dependency of everything
that sends diagnostics: a workspace outage loses telemetry, not function.

##### RE:03 in `discovery`

A spoke depends strongly on its hub for name resolution: the private DNS zones live only in the hub
([ADR-AZ-LZ-HUBANDSPOKE](../landing-zones.md#rule-adr-az-lz-hubandspoke)), so a deleted or broken DNS zone breaks every private endpoint of that tier. The
peering is a strong dependency of anything in a spoke that calls the hub's `shared-services` subnet. The region is a strong dependency of
all of it ([ADR-AZ-NETWORK-ONEADDRESSSPACE](../azure-network-model.md#rule-adr-az-network-oneaddressspace)).

##### RE:03 in `expedition`

At run time the workload depends strongly on its spoke's `private-endpoints` subnet (the hub's `shared-services` subnet for the shared
platform) and on the hub's `privatelink` DNS zones, and weakly on the workspace. At deploy time it depends strongly on `discovery` and on
`foundation`'s vault.

##### RE:03 status

partly realised — the templates' dependencies are classed here; a failure mode analysis per flow is not adopted, because there are no flows.

### RE:04 — Define reliability and recovery targets

```text
RE:04 — Define reliability and recovery targets
Source: https://learn.microsoft.com/en-us/azure/well-architected/reliability/metrics (retrieved 2026-10-15)
Summary (ours): Agree realistic availability, correctness and recovery targets with the business and use them both to drive the design
and to build the workload's health model. Measure each SLO through SLIs over a window, compose the SLOs of every dependency together with
code, configuration and deployment risk, treat a provider SLA as an input whose real coverage has to be understood, and set RTO, RPO and
MTTR targets that recovery testing confirms.
```

#### What RE:04 means here

The production settings of `expedition` imply recovery points without stating them: a point-in-time restore window of 35 days, backups in
geo-redundant storage, blobs recoverable for 7 days after deletion. Nothing writes down the RPO and RTO those settings are meant to meet, so
a reviewer cannot tell whether a config change weakens a target. The plan is to state the targets per environment class beside the settings
that realise them. An availability SLO needs measured traffic, which the example deployments do not have.

##### RE:04 in `foundation`

Not applicable: it holds no business data. The vault's secrets are recreated by whoever owns them.

##### RE:04 in `discovery`

Not applicable to recovery points: the landing zone holds configuration, not data, and recovers by redeploying (RE:09).

##### RE:04 in `expedition`

Production (`apex/prod.yml`): `databaseBackupRetentionDays: 35`, `databaseBackupStorageRedundancy: Geo`. Non-production:
`databaseBackupRetentionDays: 7`, `databaseBackupStorageRedundancy: Local`. The stated RPO and RTO per class belong in
`docs/references/infrastructure/expedition.md`, next to these values.

##### RE:04 status

planned (follow-up) — the recovery targets the `expedition` settings imply are stated per environment class; SLOs wait for a workload with
users.

### RE:05 — Add redundancy at different levels, especially for critical flows

```text
RE:05 — Add redundancy at different levels, especially for critical flows
Source: https://learn.microsoft.com/en-us/azure/well-architected/reliability/redundancy (retrieved 2026-10-15)
Summary (ours): Run several instances of each component, and where the targets demand it whole copies of the workload, so that one
failing resource does not stop a critical flow. Decide the amount and placement per flow from its targets, weighed against cost and
latency: managed services with built-in redundancy first, zone-redundant deployment, data replicated across zones or regions, deployment
stamps for whole-workload copies, and a resilient network with room to grow and delete locks on the resources that carry redundancy.
```

#### What RE:05 means here

The shared modules make zone-redundant deployment the default: `storage-account.bicep` defaults `skuName` to `Standard_ZRS`, and
`sql-database.bicep` turns `zoneRedundant` on for every tier that supports it and defaults `backupStorageRedundancy` to `Geo`. A template
weakens that only by a config value, and only outside production, where the cost saving outweighs a zone outage
([ADR-AZ-LZ-EVERYPILLAR](../landing-zones.md#rule-adr-az-lz-everypillar)).

Every environment maps to one region ([ADR-AZ-NETWORK-ONEADDRESSSPACE](../azure-network-model.md#rule-adr-az-network-oneaddressspace),
[ADR-AZ-NAMING](../azure-naming-standard.md)), so a second active region is not adopted; geo-redundant backups are the only copy outside the
region. The network follows the recommended hub-and-spoke shape, and each hub reserves `GatewaySubnet` and `AzureFirewallSubnet` so a
gateway or firewall is added without renumbering. No module places a resource lock, so the hub's DNS zones and network can be deleted by
anyone with the rights to do it.

##### RE:05 in `foundation`

The workspace and the vault rely on the redundancy Azure builds into them; `log-analytics.bicep` and `key-vault.bicep` expose no redundancy
setting.

##### RE:05 in `discovery`

One hub per tier, holding the only copy of the private DNS zones. A `CanNotDelete` lock on the hub's virtual network and its private DNS
zones is planned, as a lock module the hub deploys.

##### RE:05 in `expedition`

Storage is `Standard_ZRS` in every config. Production (`apex/prod.yml`) omits `databaseZoneRedundant`, so the template default `true`
applies, and sets `databaseBackupStorageRedundancy: Geo`. Every non-production config sets `databaseZoneRedundant: false` and
`databaseBackupStorageRedundancy: Local`.

##### RE:05 status

partly realised — zone redundancy and geo backups are in place for production in one region; locks are planned and a second region is out of
scope.

### RE:06 — Implement a timely and reliable scaling strategy at the application, data, and infrastructure levels

```text
RE:06 — Implement a timely and reliable scaling strategy at the application, data, and infrastructure levels
Source: https://learn.microsoft.com/en-us/azure/well-architected/reliability/scaling (retrieved 2026-10-15)
Summary (ours): Scaling must keep up with demand without operator effort, so design it from the observed or expected load of each flow
and component. Keep components stateless and free of instance affinity so they scale out, scale on a schedule for predictable load and
on thresholds for spikes, keep the autoscale settings in infrastructure as code with a cap on scale units, account for slow-scaling
services and data stores, and log every scaling event.
```

#### What RE:06 means here

None of the templates deploys compute, so application scaling does not arise; storage scales inside the platform. The one scaling choice is
the database, and it is a config value per environment class ([ADR-AZ-LZ-EVERYPILLAR](../landing-zones.md#rule-adr-az-lz-everypillar)). Outside production the
serverless SKU scales automatically between `databaseMinCapacity` and `databaseSkuCapacity`, which is the cap the recommendation asks for,
kept in the config. In production the database is provisioned at a fixed capacity, so more capacity is a config change and a deploy, and
nothing signals that one is needed.

##### RE:06 in `foundation`

Not applicable: a Log Analytics workspace and a Key Vault scale inside the platform.

##### RE:06 in `discovery`

Not applicable to scaling; the network's room to grow is the address plan. Each spoke has a `/16` with `/24` subnets
([ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../azure-network-model.md#rule-adr-az-network-networkpersubscription)), so its `private-endpoints` subnet has room for many more private
endpoints and the address space for more subnets.

##### RE:06 in `expedition`

Non-production: `databaseSkuName: GP_S_Gen5`, `databaseMinCapacity: "0.5"`, `databaseSkuCapacity: 2`, `databaseAutoPauseDelay: 60`.
Production: `databaseSkuName: GP_Gen5`, `databaseSkuCapacity: 2`. A capacity alert on the production database is planned (RE:10).

##### RE:06 status

partly realised — the database scales automatically inside a capped range outside production and by config in production, with no signal for
when to scale.

### RE:07 — Strengthen the resiliency of your workload by implementing self-preservation and self-healing measures

```text
RE:07 — Strengthen the resiliency of your workload by implementing self-preservation and self-healing measures
Source: https://learn.microsoft.com/en-us/azure/well-architected/reliability/self-preservation (retrieved 2026-10-15)
Summary (ours): Design so a failing component neither takes the whole workload down (self-preservation) nor needs a person to recover
(self-healing). Limit the blast radius with bulkheads and deployment stamps, turn on automatic failover where a service offers it, let
monitoring trigger automated remediation, make long work resumable with checkpoints, retries and dead-letter queues, and plan a degraded
mode that keeps the essential functions running.
```

#### What RE:07 means here

The repository's isolation unit is the customer subscription. Each customer subscription gets its own `foundation`, its own spoke from
`discovery`, and its own `expedition` deployments, so a fault or a bad deploy in one customer's subscription does not reach another's; this
is the bulkhead the recommendation describes, drawn at the subscription boundary ([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)). The
hub is the one shared part of a tier (RE:03). Failover inside a region is the platform's: zone-redundant storage and a zone-redundant
database fail over without a deploy. No template deploys an alert, an action group, or a runbook, so no failure triggers an automated
action; retries, checkpoints and a degraded mode belong to application code, which the examples do not have.

##### RE:07 in `foundation`

Nothing beyond the platform's own resilience; the vault module sets no purge protection.

##### RE:07 in `discovery`

Isolation per customer: a spoke, its network security groups, and its policies are deployed per subscription, and a broken spoke deploy
leaves the hub and the other spokes untouched.

##### RE:07 in `expedition`

`storage-account.bicep` turns on soft delete for blobs and containers (`deleteRetentionDays`, 7 by default, which `expedition` keeps), so an
accidental delete is recoverable. Production fails over across zones; non-production does not. Automated remediation — an action group that
receives the alerts of RE:10 — is planned as a shared module.

##### RE:07 status

partly realised — isolation per customer subscription and platform failover are in place; automated remediation is planned.

### RE:08 — Test for resiliency and availability scenarios by applying the principles of chaos engineering

```text
RE:08 — Test for resiliency and availability scenarios by applying the principles of chaos engineering
Source: https://learn.microsoft.com/en-us/azure/well-architected/reliability/reliability-test (retrieved 2026-10-15)
Summary (ours): A resiliency mechanism is trusted only once tested, so test critical flows end to end against their SLO, RTO and RPO,
with scenarios taken from the failure mode analysis. Restore backups regularly and time it, check retries, timeouts and the switch to a
fallback, load-test scaling with faults injected, test dependency failures, run contained chaos experiments and full failover drills,
start outside production, and feed the results back into the analysis and the recovery plans.
```

#### What RE:08 means here

Fault injection needs a running deployment, and the example deployments target the placeholder subscriptions in `azure.yml`. What the
repository tests is what can be tested without Azure: `ci-infrastructure.yaml` compiles every template, renders every config, and checks
each rendered parameters file against the compiled parameter model ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)), so a
reliability setting outside its `@allowed` values or bounds — a `databaseBackupStorageRedundancy` that is not `Geo`, `GeoZone`, `Zone` or
`Local`, a `databaseBackupRetentionDays` above 35 — fails the build. `Deploy-Bicep -DryRun` runs Azure's `--what-if` preview against a real
subscription. A deployment that adopts the templates for real starts with a timed restore of its production database.

##### RE:08 in `foundation`

Not applicable: no recovery mechanism to exercise beyond the platform's.

##### RE:08 in `discovery`

Not applicable until real subscriptions exist; the first drill would be deleting and restoring a hub DNS zone in a non-production tier.

##### RE:08 in `expedition`

The point-in-time restore of the production database and the zone failover are the mechanisms to test; neither is exercised.

##### RE:08 status

not adopted, because the example deployments target placeholder subscriptions with nothing running to test.

### RE:09 — Implement structured, tested, and documented disaster recovery (DR) plans

```text
RE:09 — Implement structured, tested, and documented disaster recovery (DR) plans
Source: https://learn.microsoft.com/en-us/azure/well-architected/reliability/disaster-recovery (retrieved 2026-10-15)
Summary (ours): Write a disaster recovery plan, derived from business criticality, that says when an event counts as a disaster, who
decides and communicates, and the ordered steps that recover components, data and the whole workload. Prepare the secondary region,
replicate data to match the RPO, plan the return to the primary region separately, automate recovery as idempotent deployments, drill the plan regularly,
keep it in step with the architecture, and store it where a regional outage cannot reach it.
```

#### What RE:09 means here

The means of recovery exist; the plan does not. Every template is infrastructure as code with its full configuration in the repository, and
an incremental deploy is idempotent, so a lost subscription is rebuilt by deploying `foundation`, `discovery`, and `expedition` in that
order — the order the customer CD pipelines encode ([ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../landing-zones.md#rule-adr-az-lz-linksneedbothnetworks) adds the hub-spoke-hub order for
peerings). Data comes back from backups: a production database restores from its geo-redundant backups, into another region when its own is
down. Because every environment maps to one region ([ADR-AZ-NETWORK-ONEADDRESSSPACE](../azure-network-model.md#rule-adr-az-network-oneaddressspace)), there is no
prepared secondary region: a regional recovery means changing the environment's `region` and `region_code` in `azure.yml`, re-spelling the
region-coded resource names written in every config ([ADR-AZ-DATAMOD-STATICRESOURCENAMES](../azure-data-model.md#rule-adr-az-datamod-staticresourcenames)), and redeploying. A
written plan, with the recovery order, the decision roles, and the restore steps, is planned.

##### RE:09 in `foundation`

Rebuilt by deploying its config again. The secrets in the vault are not in the repository by design
([ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins)), so the plan names who restores the break-glass password.

##### RE:09 in `discovery`

Rebuilt by deploying its configs again, hubs first; peerings and DNS zone links follow the three-step order of
[ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../landing-zones.md#rule-adr-az-lz-linksneedbothnetworks).

##### RE:09 in `expedition`

Rebuilt by deploying its configs again; the production database restores from `Geo` backups kept 35 days. Non-production backups are
`Local`, so a regional loss loses non-production data, which is the accepted cost trade.

##### RE:09 status

partly realised — idempotent redeploys and geo-redundant production backups exist; a written plan is planned and a secondary region is out
of scope.

### RE:10 — Continuously measure and track system health using uptime and reliability indicators

```text
RE:10 — Continuously measure and track system health using uptime and reliability indicators
Source: https://learn.microsoft.com/en-us/azure/well-architected/reliability/monitoring (retrieved 2026-10-15)
Summary (ours): Monitor whether the workload delivers correct results to users and meets its availability and recovery targets, from the
application, its data stores and its network. Roll the signals up into a health model so an alert points at real user impact, add
functional and synthetic checks, track capacity and recovery metrics, alert on Service Health and Resource Health, and keep telemetry long
enough for incident analysis.
```

#### What RE:10 means here

Telemetry collection is in place; detection is not. Diagnostics flow to `foundation`'s workspace through `diagnostic-setting.bicep` (logs by
the `allLogs` category group plus the metrics each resource kind exposes), and the subscription's activity log flows there through
`subscription-diagnostic-setting.bicep`, whose categories include `ServiceHealth` and `ResourceHealth`
([ADR-AZ-LZ-THREEBUILTINPOLICIES](../landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)). Nothing turns those signals into an alert, there is no health model, and the workspace
keeps data for the module default of 30 days. The planned work is an alert module and an action group, Service Health and Resource Health
alerts per subscription, and diagnostics for the vault.

##### RE:10 in `foundation`

The workspace (`log-analytics.bicep`, `retentionInDays` 30 by default) receives everything. The template deploys no diagnostic setting for
its own Key Vault, though `diagnostic-setting.bicep` supports the `keyVault` kind; adding it is planned.

##### RE:10 in `discovery`

Diagnostics from the virtual network and from every network security group, and the subscription's activity log with its health categories.
Service Health and Resource Health alerts per subscription are planned here, since the landing zone owns the subscription's monitoring.

##### RE:10 in `expedition`

Diagnostics from the storage account, its blob service, and the database. Alerts on database availability and capacity in production are
planned.

##### RE:10 status

partly realised — the landing zone and the workload send their telemetry to one workspace; alerts, a health model and the vault's
diagnostics are planned.

## Decision

The repository adopts the reliability checklist as a review list for its templates, with one status per item. Redundancy, scaling, and
failover inside one region are realised through the shared modules' defaults and the per-environment-class config values of
[ADR-AZ-LZ-EVERYPILLAR](../landing-zones.md#rule-adr-az-lz-everypillar): zone redundancy is the default, and only a non-production config turns it off. Items
that need a running workload with users — flow catalogues, failure mode analysis per flow, SLOs, chaos testing — are not adopted while the
examples target placeholder subscriptions. The items a template or module can carry — delete locks on the hub, stated recovery targets,
alerts and an action group, the vault's diagnostics, a written recovery plan — are planned. A second region is not adopted, because every
environment maps to one region ([ADR-AZ-NETWORK-ONEADDRESSSPACE](../azure-network-model.md#rule-adr-az-network-oneaddressspace)).

### How this is enforced

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `foundation`, `discovery`, and `expedition` on every change
  under `infrastructure/`, and the parameter-model test checks every rendered parameters file against the compiled template
  ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)). The `@allowed` and range bounds on `databaseBackupStorageRedundancy`,
  `databaseBackupRetentionDays`, and `databaseTier` are therefore checked; the values a production config chooses are not.
- The module defaults (`Standard_ZRS`, `zoneRedundant`, `backupStorageRedundancy: Geo`, blob soft delete) hold for every caller that does
  not override them; a pull request that overrides one shows in review, not in a check.
- Planned (follow-up): a quality gate that reads the compiled templates and their rendered parameters and fails a production config without
  zone redundancy or with `Local` backups, citing ADR-AZ-WAF-RE-RE05; and a check that the vault, the virtual network, and every data resource
  carries a diagnostic setting, citing ADR-AZ-WAF-RE-RE10. Neither exists.

## Consequences

- A production deployment survives a zone outage and can restore its database from another region with no extra design, because the defaults
  carry it.
- A non-production deployment saves the cost of zone redundancy and geo backups, and accepts losing its data in a regional outage.
- A regional outage takes an environment down until it is redeployed in another region, with its region-coded names re-spelled; this is the
  largest reliability gap, and it is a deliberate limit on what the repository covers.
- Telemetry is collected but nobody is told: without alerts, a failure is found by a person looking, not by the system.
- Each "planned" status above is a follow-up item, and each "not adopted" status is revisited once a real workload with users runs on the
  templates.
