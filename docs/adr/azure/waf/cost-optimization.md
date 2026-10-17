---
catzc:
  immutable:
    repo_status: clean
    path: docs/adr/azure/waf/cost-optimization.md
    folder: docs/adr/azure/waf
    name: cost-optimization
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-AZ-WAFCO#{1-14}
    cites:
      - ADR-AZ-DATAMOD#{2,9-11}
      - ADR-AZ-LZ#{1-5}
      - ADR-AZ-NAMING#1
    links:
      - docs/adr/azure/azure-data-model.md
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod10
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming1
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz1
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz2
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz3
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz4
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz5
      - docs/adr/flow/durable-sha-globs.md
      - docs/adr/principles/reduce-waste.md
      - docs/references/waf/index.md
---

# ADR: Well-Architected cost optimization — what the repository does about each item of Microsoft's checklist

Pairs with [`landing-zones`](../landing-zones.md) (the landing zone that carries the budget and the guardrails) and
[`data-model`](../azure-data-model.md) (the configuration tree every cost value lives in).

## Rules: ADR-AZ-WAFCO

### Rule ADR-AZ-WAFCO:1

Cost information is open to the team: every budget amount is a config value in the repository and every resource names its paying team in
its `cost-center` tag; training, cost champions, and recognition belong to the organisation, not to the repository.

- [CO:01 — Create a culture of financial responsibility](#co01--create-a-culture-of-financial-responsibility)

### Rule ADR-AZ-WAFCO:2

Each template gets a written cost model per environment class, and each landing zone's budget amount is derived from the models of the
templates its subscription runs; until then a budget amount is a bare config value.

- [CO:02 — Create and maintain a cost model](#co02--create-and-maintain-a-cost-model)

### Rule ADR-AZ-WAFCO:3

Cost is attributable and watched per subscription: every resource carries the CAF tags with `cost-center` and `owner`, and every landing
zone's budget alerts the subscription's `Owner` role at 50, 80, and 100 percent of actual cost; cost exports, forecast alerts, and anomaly
alerts are planned.

- [CO:03 — Collect and review cost data](#co03--collect-and-review-cost-data)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-WAFCO:4

Spending guardrails are platform controls in the landing zone: the allowed-locations and required-tag policies, a budget per subscription,
`@allowed` and bound decorators on the SKU tier, size, and retention parameters, and a `--what-if` preview before a deploy; an allowed-SKU
policy and a pre-deploy cost estimate are planned.

- [CO:04 — Set spending guardrails](#co04--set-spending-guardrails)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-WAFCO:5

Every resource is billed pay-as-you-go; reservations, savings plans, licence benefits, and dev/test offers are not adopted, because they are
bought at the billing account and the subscription offer, above the subscription the repository deploys into.

- [CO:05 — Get the best rates from providers](#co05--get-the-best-rates-from-providers)

### Rule ADR-AZ-WAFCO:6

Each resource is configured to its meter: a serverless database billed per second of use where usage is intermittent, a provisioned one
where it is steady, a per-GB workspace fed only the log and metric categories each resource kind needs.

- [CO:06 — Align usage to billing increments](#co06--align-usage-to-billing-increments)

### Rule ADR-AZ-WAFCO:7

The configuration tree is the inventory of every resource group the repository deploys, every resource names its `owner`, and disaster
recovery is a redeploy from the templates, never an idle standby; finding orphaned resources is planned.

- [CO:07 — Optimize component costs](#co07--optimize-component-costs)

### Rule ADR-AZ-WAFCO:8

Non-production spends less by config, not by a different design: the same SKU family and tier as production, but serverless with auto-pause,
no zone redundancy, locally redundant backups, a 7-day restore window, an audit-only policy mode, and a smaller budget.

- [CO:08 — Optimize environment costs](#co08--optimize-environment-costs)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-WAFCO:9

Not adopted, because each example workload carries one flow; a workload with flows of different value records them, and their tiers, in its
own template.

- [CO:09 — Optimize flow costs](#co09--optimize-flow-costs)

### Rule ADR-AZ-WAFCO:10

Data is kept for as long as it earns its cost: workspace retention at the 30-day minimum, blob soft delete for 7 days, backup redundancy and
retention per environment class; storage lifecycle tiering is planned.

- [CO:10 — Optimize data costs](#co10--optimize-data-costs)

### Rule ADR-AZ-WAFCO:11

Not adopted, because the templates deploy infrastructure with no application code; a workload that ships code optimises it in its own
repository.

- [CO:11 — Optimize code costs](#co11--optimize-code-costs)

### Rule ADR-AZ-WAFCO:12

A component that scales does so within a ceiling set in config: the serverless database moves between `databaseMinCapacity` and
`databaseSkuCapacity` vCores, and no other component of the examples scales.

- [CO:12 — Optimize scaling costs](#co12--optimize-scaling-costs)

### Rule ADR-AZ-WAFCO:13

People's time goes to decisions, not repetition: templates compose shared modules, configs read shared values by config address, a CD
pipeline deploys only the units a change touches, and budget alerts go to a role rather than to a kept address list.

- [CO:13 — Optimize personnel time](#co13--optimize-personnel-time)

### Rule ADR-AZ-WAFCO:14

Shared services exist once per tier and are consumed, never copied: one hub with the private DNS zones per tier, one workspace and one Key
Vault per subscription, and the shared platform's workload in the hub; production and non-production are never consolidated.

- [CO:14 — Consolidate resources and responsibility](#co14--consolidate-resources-and-responsibility)

## Context

The Azure Well-Architected Framework (WAF) is Microsoft's guidance for designing and running a workload on Azure. It groups its advice into
five pillars — reliability, security, cost optimization, operational excellence, and performance efficiency — and gives each pillar a
checklist of numbered recommendations, each with its own guide. The cost optimization pillar asks a workload to get, and keep, a good return
on what it costs: spend weighed against the value it delivers, as an ongoing practice rather than a one-off review.

These rules are vendor recommendation, not principled theory. They do not argue from first principles the way the axioms and DORA's research
do; they record what the repository does about each of Microsoft's fourteen cost items (CO:01 to CO:14). Each rule cites Microsoft's page —
code, title, link, retrieval date — and summarises it in our own words, because the current WAF text is published under the Microsoft Learn
Terms of Use, which grant no licence to copy it into a shared repository. Nothing is quoted.

The [WAF reference](../../../references/waf/index.md) lists the five pillar records in this repository and the Microsoft checklist each one
cites.

The example basis is the repository's three templates: `foundation` (a Log Analytics workspace and a Key Vault per subscription),
`discovery` (the landing zone, [ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)), and `expedition` (a workload that lands in it,
[ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)). Every takeaway below points at what those three do, or say plainly what they do not.

### CO:01 — Create a culture of financial responsibility

```text
CO:01 — Create a culture of financial responsibility
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/create-culture-financial-responsibility (retrieved 2026-10-15)
Summary (ours): The workload team shares ownership of what the workload costs and has the skills and figures to spend well. Open budgets
  and cost data, ongoing training, room to propose savings, and clearly stated financial goals build that ownership.
```

#### What CO:01 means here

The repository makes cost visible where the team works. A landing zone's budget is the `budgetAmount` value in its `discovery` config, so
anyone who reads the repository reads every budget, and a change to one goes through review like any other change. The CAF tags name the
paying team (`cost-center`) and the accountable one (`owner`) on every resource. Training, workshops, cost champions, and recognition are
practices of the organisation that runs the repository; nothing in the repository can realise them.

##### CO:01 in `foundation`

Every resource carries the CAF tags from its config, for example `owner: platform` and `cost-center: platform` in `nsub.yml`, and
`owner: apex` and `cost-center: apex` in `apex/psub.yml`.

##### CO:01 in `discovery`

Each config holds the subscription's budget in plain sight: 500 (shared non-production), 1000 (shared production), 300 for each customer's
non-production subscription, and 800 for `apex` production, per month in the subscription's billing currency.

##### CO:01 in `expedition`

The CAF tags carry the paying team per configuration slot, for example `cost-center: platform` in `dev.yml` and `cost-center: apex` in
`apex/prod.yml`. The workload has no budget of its own; its cost counts against its subscription's budget.

##### CO:01 status

Partly realised — budgets and cost ownership are open in config; the people practices belong to the organisation.

### CO:02 — Create and maintain a cost model

```text
CO:02 — Create and maintain a cost model
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/cost-model (retrieved 2026-10-15)
Summary (ours): Forecast what the workload costs up front, at its running rate, and over time, covering services, licences, reliability,
  operations, and supporting services such as monitoring and security. The model is the basis for a budget with a buffer for unplanned
  spend, and it is kept current with usage data and design changes.
```

#### What CO:02 means here

The repository has no cost model. The budget amounts in the `discovery` configs are round numbers with no estimate behind them, so nothing
says whether 300 a month covers a customer's non-production workloads or why production gets 800. A cost model per template belongs beside
the template's reference article in `docs/references/infrastructure/`: an estimate per environment class (production and non-production),
from the SKUs in the configs, with the cost drivers named — the database's vCores, the workspace's ingested gigabytes, the storage
transactions. A landing zone's budget is then the sum of the estimates of the templates its subscription runs, plus a buffer.

##### CO:02 in `foundation`

Not modelled. Its drivers are the workspace's ingestion (`PerGB2018`) and retention, and the Key Vault's operations.

##### CO:02 in `discovery`

Not modelled. Its own drivers are small (the virtual network, the peerings' data transfer, the private DNS zones); its budget covers the
whole subscription, so its amount should come from the other templates' models.

##### CO:02 in `expedition`

Not modelled. Its drivers are the database SKU (`GP_S_Gen5` at up to 2 vCores in non-production, `GP_Gen5` at 2 vCores in production), the
backup redundancy, and the storage account.

##### CO:02 status

Planned (follow-up) — a cost model per template, and budget amounts derived from it.

### CO:03 — Collect and review cost data

```text
CO:03 — Collect and review cost data
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/collect-review-cost-data (retrieved 2026-10-15)
Summary (ours): Gather daily cost data, actual and amortized, into one central place where it can be grouped and reported. Stakeholders
  review spend regularly against the budget and the cost model, and automated alerts flag threshold crossings and deviations from the
  trend.
```

#### What CO:03 means here

Grouping cost needs tags, and the repository puts the CAF tags (`workload`, `environment`, `owner`, `cost-center`, `criticality`,
`data-classification`) on every resource that takes tags. The landing zone's required-tag policy makes `cost-center` mandatory
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)), so Cost Management can group a subscription's spend by team. The budget module
(`infrastructure/modules/budget.bicep`) alerts the holders of the subscription's `Owner` role at each threshold.

Three parts are missing. No cost export writes the daily data to storage. The budget compares against actual cost only, so there is no
forecast alert, and there is no anomaly alert. And the resource groups that `Deploy-Bicep` creates for `foundation` and `expedition` carry
the deployment-provenance tags (`Set-BicepTrackingTagSet`) but not the CAF tags, so tag inheritance in Cost Management has nothing to pass
down from them.

##### CO:03 in `foundation`

Its workspace and vault carry the CAF tags; its resource group does not.

##### CO:03 in `discovery`

Its resource group and every tagged resource carry the CAF tags. The budget alerts at 50, 80, and 100 percent of actual cost (the
`budgetThresholds` default). It should add a forecast alert — `budget.bicep` takes one `thresholdType` per budget, so the module needs to
accept both — and a cost export and an anomaly alert at subscription scope.

##### CO:03 in `expedition`

Every resource carries the CAF tags; its resource group does not.

##### CO:03 status

Partly realised — tags and actual-cost budget alerts exist; cost exports, forecast and anomaly alerts, and tagged resource groups are
planned (follow-up).

### CO:04 — Set spending guardrails

```text
CO:04 — Set spending guardrails
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/set-spending-guardrails (retrieved 2026-10-15)
Summary (ours): Use automated controls, enforced by the platform rather than by manual review, to keep the workload within its budget and
  away from what it should not use. Guardrails span governance policies, access control, release gates, alerts, and infrastructure as
  code.
```

#### What CO:04 means here

The landing zone carries the platform guardrails: allowed locations keeps every resource in its region, the required tag keeps every
resource attributable, and the budget alerts before the money runs out ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)). Whether the
policies deny or only audit is `policy_enforcement` in `azure.yml`, enforcing in production and auditing outside it by default
([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)). A budget alerts; it never stops a resource.

In code, the cost-bearing settings are typed parameters: `databaseTier` is `@allowed`, `databaseBackupRetentionDays` is bounded 1 to 35,
`budgetAmount` has a minimum of 1, and every rendered parameters file is checked against those bounds
([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)). `Deploy-Bicep -DryRun` runs Azure's `--what-if` preview of a change. A CD
pipeline deploys with one service connection per subscription and asserts the target with `-SubscriptionIdAssertIs`, so a deployment
identity reaches only the subscription it is for.

Missing: no policy restricts resource types or SKUs, no check estimates the cost of a change before it deploys, and no release gate weighs a
change against a cost model (CO:02 has none to weigh against).

##### CO:04 in `foundation`

Deploys into a subscription whose landing zone carries the guardrails; its own parameters are names and tags, and its SKUs are module
defaults (`PerGB2018`, `standard`).

##### CO:04 in `discovery`

Assigns the allowed-locations and required-tag policies (`requiredTagName` defaults to `cost-center`) and the budget. It should add an
allowed-SKU policy (for example allowed SQL Database and storage SKUs) beside the three it assigns.

##### CO:04 in `expedition`

Its database SKU, tier, capacity, and backup settings are config values bounded by the template's decorators; `databaseSkuName` is a free
string, which an allowed-SKU policy or an `@allowed` list would close.

##### CO:04 status

Partly realised — policies, budgets, typed parameters, and the what-if preview exist; an allowed-SKU policy and a pre-deploy cost estimate
are planned (follow-up).

### CO:05 — Get the best rates from providers

```text
CO:05 — Get the best rates from providers
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/get-best-rates (retrieved 2026-10-15)
Summary (ours): Lower the unit price of what the workload uses, without changing its design, by choosing the right billing model and using
  discounts and licence benefits. Start with the most expensive items and revisit the rates regularly.
```

#### What CO:05 means here

Reservations, savings plans, enterprise agreements, and dev/test pricing are bought or chosen at the billing account and in the subscription
offer. The landing zone stops at the subscription and the repository holds no rights above it
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)), so the rate is whoever owns the billing account's decision. What the templates choose
is the billing model per resource, and every one is pay-as-you-go. The SQL database module exposes no licence type, so Azure Hybrid Benefit
cannot be selected.

##### CO:05 in `foundation`

Pay-as-you-go: the workspace on `PerGB2018`, the vault on `standard`.

##### CO:05 in `discovery`

Not applicable: the network, the DNS zones, and the policies carry no commitment-based pricing the template could choose.

##### CO:05 in `expedition`

Pay-as-you-go. A provisioned production database at 2 vCores is the one candidate for a reservation, and that purchase belongs to the
billing account.

##### CO:05 status

Not adopted, because rates and commitments are set at the billing account, above the subscription the repository deploys into.

### CO:06 — Align usage to billing increments

```text
CO:06 — Align usage to billing increments
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/align-usage-to-billing-increments (retrieved 2026-10-15)
Summary (ours): Learn how each service is metered — time, requests, data transferred, storage — and shape the service choice or the usage
  so consumption matches the meter. A short proof of concept confirms the billing assumptions for the main cost drivers before the design
  is committed.
```

#### What CO:06 means here

The choices the templates make follow the meter. A serverless SQL database bills compute per second while it runs and only storage while it
is paused, so it suits a database that idles; a provisioned one bills a steady rate, so it suits steady production use. A Log Analytics
workspace bills per ingested gigabyte, so the diagnostic module (`infrastructure/modules/diagnostic-setting.bicep`) picks the categories
each resource kind needs — a storage account sends only its `Transaction` metrics and no logs. The repository keeps no catalogue of each
service's meter and runs no billing proof of concept.

##### CO:06 in `foundation`

The workspace is on `PerGB2018`, the per-gigabyte meter. Its ingestion is set by what the other templates send to it.

##### CO:06 in `discovery`

Sends the activity log, the virtual network's diagnostics, and each network security group's logs to `foundation`'s workspace; each is a
per-gigabyte cost there.

##### CO:06 in `expedition`

Non-production configs use `GP_S_Gen5` with `databaseAutoPauseDelay: 60` and `databaseMinCapacity: "0.5"`: after an idle hour the database
pauses and bills storage only. Production uses provisioned `GP_Gen5` at `databaseSkuCapacity: 2`.

##### CO:06 status

Partly realised — the SKUs and diagnostic categories follow the meter; a per-service billing catalogue in the module reference is planned
(follow-up).

### CO:07 — Optimize component costs

```text
CO:07 — Optimize component costs
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/optimize-component-costs (retrieved 2026-10-15)
Summary (ours): Review the running workload for application features, platform features, and resources that cost more than they return,
  and remove, right-size, or rework them. Avoid new waste by finding the root cause before changing a solution and by keeping every
  resource tracked.
```

#### What CO:07 means here

Tracking is structural: one config file is one resource group, and listing the configuration tree lists every resource group the repository
deploys ([ADR-AZ-DATAMOD#2](../azure-data-model.md#rule-adr-az-datamod2)). Names are deterministic
([ADR-AZ-NAMING#1](../azure-naming-standard.md#rule-adr-az-naming1)) and every resource carries an `owner` tag, so a resource found in a
subscription is traceable to its template and its team. Disaster recovery is a redeploy from the templates plus the database's backups,
never a warm standby that idles. The deployment mode defaults to `Incremental`, so a resource removed from a template stays in Azure until
someone deletes it; nothing finds such an orphan or a resource group with no config.

##### CO:07 in `foundation`

Two resources, both used by every workload of the subscription; nothing to trim.

##### CO:07 in `discovery`

Reserves `GatewaySubnet` and `AzureFirewallSubnet` in the hub as address space only — no gateway or firewall runs, so no cost accrues for
them until one is needed.

##### CO:07 in `expedition`

One storage account and one database per configuration slot, with no secondary region. A special slot (`apex/dev-blu.yml`) is a second full
copy of the workload; it should be removed when its work is done, and nothing reminds anyone to.

##### CO:07 status

Partly realised — the inventory, owners, and redeploy-based recovery exist; an orphan check against the configuration tree is planned
(follow-up).

### CO:08 — Optimize environment costs

```text
CO:08 — Optimize environment costs
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/optimize-environment-costs (retrieved 2026-10-15)
Summary (ours): Spend on each environment — production, pre-production, recovery, operations — in proportion to its value and risk instead
  of making them all alike. Non-production stays close enough to production to catch problems, with deliberate, governed reductions in
  scale, tier, and running hours.
```

#### What CO:08 means here

Environment class is a config decision. The modules hold the production-grade defaults ([ADR-AZ-LZ#5](../landing-zones.md#rule-adr-az-lz5)),
and a non-production config turns them down where a fault would cost less. The SKU family and tier stay the same, so a database behaves
alike in both classes and a problem shows before production. Policy enforcement audits outside production by default
([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)). Off-hours shutdown is not needed for the database, because auto-pause
stops its compute when idle; no environment is ephemeral.

##### CO:08 in `foundation`

Identical in both classes: the workspace keeps 30 days in production and non-production alike, which is the minimum.

##### CO:08 in `discovery`

Non-production budgets are smaller (500 shared, 300 per customer) than production ones (1000 shared, 800 for `apex`), and its policies audit
instead of deny.

##### CO:08 in `expedition`

Non-production configs (`dev.yml`, `test.yml`, `apex/dev.yml`, `apex/dev-blu.yml`, `nova/dev.yml`) set `GP_S_Gen5` with auto-pause,
`databaseZoneRedundant: false`, `databaseBackupStorageRedundancy: Local`, and `databaseBackupRetentionDays: 7`; `apex/prod.yml` sets
`GP_Gen5`, zone redundancy by default, `Geo`, and 35 days. The storage account takes the module's `Standard_ZRS` in every class, because
`expedition` exposes no storage SKU; a non-production config could use `Standard_LRS` once the template passes one through.

##### CO:08 status

Partly realised — the database, backups, budgets, and policy mode differ by class; a storage SKU per class is planned (follow-up).

### CO:09 — Optimize flow costs

```text
CO:09 — Optimize flow costs
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/optimize-flow-costs (retrieved 2026-10-15)
Summary (ours): Match what each user or system flow costs to how much it matters, putting money into critical flows and running lower-
  priority ones on cheaper configurations. That can mean separating flows with different needs onto different resources, or combining
  similar flows onto shared ones.
```

#### What CO:09 means here

A flow inventory needs a workload with more than one flow. The examples have none: `expedition` is one database and one storage account
serving one purpose, so there is nothing to separate or combine. A workload template with flows of different value names them in its own
reference article and sets their tiers in its own configs.

##### CO:09 in `foundation`

Not applicable: it hosts shared services, not user flows.

##### CO:09 in `discovery`

Not applicable: it carries the network, not a workload.

##### CO:09 in `expedition`

Not applicable: one flow, one database, one storage account.

##### CO:09 status

Not adopted, because the example workloads carry one flow each.

### CO:10 — Optimize data costs

```text
CO:10 — Optimize data costs
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/optimize-data-costs (retrieved 2026-10-15)
Summary (ours): Spend on storing and handling data according to how important it is and how often it is read. That covers lifecycle
  management (tiering and retention), how much data is kept, how it is replicated and backed up, which file formats are used, and which
  storage service holds it.
```

#### What CO:10 means here

Retention and redundancy are bounded by default and widened only where the environment class needs it. The workspace keeps 30 days, the
module's minimum (`infrastructure/modules/log-analytics.bicep`). Deleted blobs and containers are kept for 7 days. Backup redundancy and
point-in-time retention are config values per class (CO:08). The storage account is fixed on the `Hot` access tier and carries no lifecycle
management policy, so data never moves to the cool or archive tier.

##### CO:10 in `foundation`

The workspace's `retentionInDays` takes the default of 30; no config raises it.

##### CO:10 in `discovery`

Not applicable: it stores no data of its own; its diagnostics land in `foundation`'s workspace under that retention.

##### CO:10 in `expedition`

Non-production keeps 7 days of locally redundant backups, production 35 days of geo-redundant ones. The blob service keeps 7 days of soft
delete. A lifecycle policy, with the access tier and the cool and archive ages as parameters of `storage-account.bicep`, would let a
workload tier its blobs.

##### CO:10 status

Partly realised — retention and redundancy are bounded per class; blob lifecycle tiering is planned (follow-up).

### CO:11 — Optimize code costs

```text
CO:11 — Optimize code costs
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/optimize-code-costs (retrieved 2026-10-15)
Summary (ours): Change application code so it gives the same functional and nonfunctional results with fewer or cheaper resources, once
  scaling and sizing are in place. Instrumentation shows hot paths and waste that autoscaling or serverless can otherwise hide.
```

#### What CO:11 means here

The templates deploy infrastructure only. None runs application code, so there is no hot path to profile and no call to trim. A workload
that ships code optimises it where the code lives.

##### CO:11 in `foundation`

Not applicable: no application code.

##### CO:11 in `discovery`

Not applicable: no application code.

##### CO:11 in `expedition`

Not applicable: the database and the storage account are deployed empty; the code that would use them is outside the repository.

##### CO:11 status

Not adopted, because the templates carry no application code.

### CO:12 — Optimize scaling costs

```text
CO:12 — Optimize scaling costs
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/optimize-scaling-costs (retrieved 2026-10-15)
Summary (ours): Scale out or up only when needed and back down as soon as practical, choosing the scaling approach that is cheapest for the
  required result. Compare options against the cost model and the service limits, and manage both demand and supply.
```

#### What CO:12 means here

The supply side is capped in config. The one component of the examples that scales on its own is the serverless database, and it moves
between a floor and a ceiling the config sets; every other component is fixed in size. A workload that adds compute that scales sets its
maximum in its config the same way.

##### CO:12 in `foundation`

Not applicable: the workspace and the vault do not scale by configuration.

##### CO:12 in `discovery`

Not applicable: nothing it deploys scales.

##### CO:12 in `expedition`

In non-production the database scales between `databaseMinCapacity: "0.5"` and `databaseSkuCapacity: 2` vCores and pauses at zero use. In
production it is provisioned at 2 vCores, a fixed size.

##### CO:12 status

Realised — the one component that scales does so between a floor and a ceiling set in config.

### CO:13 — Optimize personnel time

```text
CO:13 — Optimize personnel time
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/optimize-personnel-time (retrieved 2026-10-15)
Summary (ours): People are usually a workload's largest cost, so spend each hour by the priority of the task without lowering the quality
  of the outcome: faster feedback in development, smoother collaboration and processes, and less noise in operations.
```

#### What CO:13 means here

The repository spends people's time on decisions and lets the tooling do the repetition. Every template composes the shared modules in
`infrastructure/modules/`, so a secure or cheap default is written once. A config reads a shared value — a network range, a subscription id,
the policy mode — by config address instead of a copy that must be kept in step
([ADR-AZ-DATAMOD#10](../azure-data-model.md#rule-adr-az-datamod10)). A change triggers only the CD pipelines whose deployable units it
touches ([durable-sha-globs](../../flow/durable-sha-globs.md)), and `ci-infrastructure.yaml` compiles every template and checks every
parameters file before a deploy can fail on it. Budget alerts go to the `Owner` role, so no address list is maintained. This is the
repository's general stance on waste ([reduce-waste](../../principles/reduce-waste.md)) applied to infrastructure.

##### CO:13 in `foundation`

Two module calls and a config of names and tags per subscription.

##### CO:13 in `discovery`

One template serves both hubs and spokes; a new customer subscription is a config file, not a design
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)).

##### CO:13 in `expedition`

A new configuration slot is a config file; the template and the modules are shared by every slot.

##### CO:13 status

Realised — shared modules, config addresses, change-scoped pipelines, and compile checks keep repeated work out of people's hands.

### CO:14 — Consolidate resources and responsibility

```text
CO:14 — Consolidate resources and responsibility
Source: https://learn.microsoft.com/en-us/azure/well-architected/cost-optimization/consolidation (retrieved 2026-10-15)
Summary (ours): Run more on fewer resources inside the workload, and use shared resources and specialist teams the organisation has instead
  of duplicating them. Weigh every consolidation against its effect on isolation, security, compliance, and redundancy.
```

#### What CO:14 means here

The landing zone is a consolidation: what every workload of a subscription needs is deployed once for the subscription, not once per
workload ([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)). Across subscriptions, each tier's hub holds the private DNS zones once and
links them to every spoke ([ADR-AZ-LZ#2](../landing-zones.md#rule-adr-az-lz2)), and it reserves the subnets a shared gateway or firewall
would use. Production and non-production are never consolidated: each tier has its own hub, and each customer has a subscription per class.

##### CO:14 in `foundation`

One workspace and one Key Vault per subscription, shared by every workload in it: `discovery` and `expedition` send their diagnostics to the
workspace, and `expedition` reads its break-glass password from the vault.

##### CO:14 in `discovery`

One hub per tier serves every spoke of that tier, with the SQL and blob private DNS zones held once in the hub.

##### CO:14 in `expedition`

The shared platform's workload (`dev.yml`, `test.yml`) places its private endpoints in the hub's `shared-services` subnet instead of a
network of its own. Each configuration slot has its own SQL server with one database; denser hosting (several databases per server, an
elastic pool) is not used, because each slot is its own resource group.

##### CO:14 status

Realised — shared services exist once per subscription and per tier, and production stays apart from non-production.

## Decision

The repository answers each of Microsoft's cost items with what it does, what it plans, or why it does not adopt it. The adopted practices
are the cost features of the landing zone and the templates: the CAF tags with `cost-center` on every resource, a budget per subscription,
the policy guardrails, serverless databases that pause outside production, short retention, environment-class configs, and shared services
held once. The planned ones close the gaps those leave: a cost model, cost exports and forecast alerts, an allowed-SKU policy, an orphan
check, lifecycle tiering, and a storage SKU per class. The items about rates, flows, and code are not adopted, each for its stated reason.

### How this is enforced

- The landing zone's required-tag policy denies a resource without `cost-center` where `policy_enforcement` enforces, and reports it where
  it audits ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).
- The budget's alerts reach the subscription's `Owner` role at each threshold.
- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for every template, and the parameter-model test checks each
  rendered parameters file against the template's `@allowed` values and bounds
  ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)), so an out-of-range SKU tier or retention fails the build.
- `Deploy-Bicep -DryRun` runs Azure's `--what-if` preview of a deploy.
- Planned (follow-up), not existing: a check over the compiled templates (`main.json`) that fails a missing tag or a production-grade
  setting in a non-production config, an allowed-SKU policy in `discovery`, a pre-deploy cost estimate, and an orphan check against the
  configuration tree.

## Consequences

- Every resource's cost is attributable to a team from its tags, and every subscription's spend is watched against a budget without anyone
  keeping an address list.
- Non-production costs less through config values on the same templates, so a cheaper environment never needs a separate design.
- Budget amounts carry no estimate until each template has a cost model, so a budget alert says spend is high but not which assumption
  broke.
- Rates and commitments stay with whoever owns the billing account; the repository leaves them alone.
- An orphaned resource or a forgotten special slot keeps costing until someone notices, until the orphan check exists.
