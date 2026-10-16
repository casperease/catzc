---
catzc:
  derived:
    path: docs/adr/azure/caf/design-principles.md
    kind: adr
    language: markdown
    filetype: md
    track: docs
    body_sha: b891f6ab0cc2
    defines:
      - ADR-AZ-CAFPRIN#{1-5}
    adrs:
      - ADR-AZ-CLI#1
      - ADR-AZ-CUSTOMER#2
      - ADR-AZ-DATAMOD#{1-3,8,9,11}
      - ADR-AZ-LZ#{1,3-6}
      - ADR-AZ-NETWORK#5
      - ADR-DSGN-SELFSERV#{1,2}
      - ADR-DSGN-THINPLAT#2
    links:
      - docs/adr/azure/azure-customer-model.md#rule-adr-az-customer2
      - docs/adr/azure/azure-data-model.md
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod1
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod3
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod8
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/azure-network-model.md#rule-adr-az-network5
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz1
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz3
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz4
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz5
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz6
      - docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1
      - docs/adr/design/self-service.md#rule-adr-dsgn-selfserv1
      - docs/adr/design/self-service.md#rule-adr-dsgn-selfserv2
      - docs/adr/design/thin-platforms.md#rule-adr-dsgn-thinplat2
      - docs/references/caf/index.md
      - "https://learn.microsoft.com/en-us/legal/termsofuse"
---

# ADR: CAF landing zone design principles — Microsoft's five principles, cited, and where this repository follows or deviates from each

Pairs with [`landing-zones`](../landing-zones.md) (the landing zone these principles frame) and [`data-model`](../azure-data-model.md) (the
subscriptions, the configuration tree, and the policy enforcement setting the principles are weighed against).

## Rules: ADR-AZ-CAFPRIN

### Rule ADR-AZ-CAFPRIN:1

Partly adopted: the subscription is the unit of management, each customer holds its own non-production and production subscription pair
declared in `azure.yml`, and a new subscription's landing zone is a config file reviewed as a pull request; subscription vending and a
management group hierarchy are not adopted, because the repository deploys into subscriptions it is given
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)).

- [1 — Subscription democratization](#1--subscription-democratization)

### Rule ADR-AZ-CAFPRIN:2

Partly adopted: every landing zone assigns three built-in Azure Policy guardrails at subscription scope
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)), enforced or audited by the repository-wide `policy_enforcement` setting
([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)); policies inherited from a management group are not adopted.

- [2 — Policy-driven governance](#2--policy-driven-governance)

### Rule ADR-AZ-CAFPRIN:3

Adopted for the control plane, deviated for the management plane: every change is an Azure Resource Manager deployment through Bicep and the
az CLI, with catzc as a thin command line over it, never a portal in front of it; monitoring goes to one Log Analytics workspace per
subscription (`foundation`), not to one central workspace.

- [3 — Single control and management plane](#3--single-control-and-management-plane)

### Rule ADR-AZ-CAFPRIN:4

Adopted: a workload is a template that lands in the landing zone of its subscription and owns none of it
([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)); workloads are segmented by customer subscription and environment class, not by a
management group archetype.

- [4 — Application-centric service model](#4--application-centric-service-model)

### Rule ADR-AZ-CAFPRIN:5

Adopted: the templates use Azure-native services only, written in Bicep from the shared modules in `infrastructure/modules/`, with Azure
built-in policies and a pinned minimum Bicep CLI version; tracking new service capabilities and API versions is a manual review.

- [5 — Alignment with Azure-native design and roadmaps](#5--alignment-with-azure-native-design-and-roadmaps)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation onto Azure, from strategy and planning to running the
estate. Its "Ready" methodology describes the Azure landing zone: the platform an organisation prepares before workloads arrive, built from
a set of design areas (billing and tenant, identity, resource organisation, network, security, management, governance, platform automation).

Above the design areas stand five design principles. They are aspirational: Microsoft states them as the targets every landing zone design
decision should serve, allows a design to deviate, and names for each the cost of deviating. This record is therefore the frame the other
CAF records sit in: each rule says how this repository's design follows or deviates from one principle, cites the decision that makes it so,
and records what the deviation costs here.

These rules are vendor recommendation, not principled theory: they record what Microsoft advises for Azure and what this repository does
about each principle, and they carry no more authority than that. Each principle below cites Microsoft's page — its title, section, link,
and retrieval date — and summarises it, and its impact of deviation, in our own words. Nothing is quoted, because the live CAF text is
published under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), not under a reuse licence. The
example basis of every takeaway is the three templates `foundation`, `discovery` (the landing zone), and `expedition` (the workload),
deployed in that order ([landing-zones](../landing-zones.md)).

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

### 1 — Subscription democratization

```text
CAF Design principles — Azure landing zone design principles — recommendation 1
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-principles#subscription-democratization
        (retrieved 2026-10-14)
Summary (ours): Workload teams own and run their own subscriptions inside the guardrails of the platform, so that migration and new
development scale. The subscription is the unit of management, assigned to business units; development, test and production are
separated by subscription; subscriptions come from a self-service (or near self-service) vending process; several subscription
"product lines" serve different workload needs; and subscriptions sit in a scalable management group hierarchy that follows the
landing zone reference hierarchy.
Impact of deviation (ours): An organisation that runs operations centrally may keep production control with a central team and must
adapt its resource organisation. The reference hierarchy may not fit the operating model, and moving resources between subscriptions
later is costly. Without a vending process and its automation, teams wait for subscriptions or create ungoverned ones elsewhere.
```

#### What 1 means here

The subscription is the unit of management. `azure.yml` declares every subscription by name, and a customer subscription carries a
`customer` key ([ADR-AZ-DATAMOD#1](../azure-data-model.md#rule-adr-az-datamod1),
[ADR-AZ-CUSTOMER#2](../azure-customer-model.md#rule-adr-az-customer2)): the shared platform holds `shared_nonprod` and `shared_prod`, and
each customer holds its own pair (`apex_nonprod`, `apex_prod`) or a non-production subscription alone (`nova_nonprod`, `flux_nonprod`). The
unit of ownership is the customer, not a workload team: one customer subscription serves every workload of that customer and environment
class.

Environments are separated by subscription at the production boundary only. A non-production subscription serves `dev`, `test` and `nsub`, a
production one `preprod`, `prod` and `psub`; `dev` and `test` share a subscription and are kept apart by resource group, one per
configuration slot ([ADR-AZ-DATAMOD#2](../azure-data-model.md#rule-adr-az-datamod2)).

Self-service is a pull request, not a vending machine ([ADR-DSGN-SELFSERV#1](../../design/self-service.md#rule-adr-dsgn-selfserv1)). A team
adds a subscription entry to `azure.yml`, a network to `network.yml`, and one config per template; the CD pipeline of the customer then
deploys `foundation`, `discovery` and `expedition` into it. Creating the subscription itself and placing it in a management group are not
adopted: the repository deploys into subscriptions it is given and needs no rights above them
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)). The two kinds of landing zone, a hub for a shared subscription and a spoke for a
customer subscription ([ADR-AZ-NETWORK#5](../azure-network-model.md#rule-adr-az-network5)), are the repository's two product lines.

The impact of deviation, here: subscriptions arrive from whoever administers the tenant, so a new customer waits for that person before its
first deploy, and the subscription's place in a management group hierarchy is outside the configuration tree. Sharing one non-production
subscription between `dev` and `test` means a guardrail or a budget of that subscription governs both environments alike.

##### 1 in `foundation`

One config per subscription, keyed by its per-subscription environment: `nsub.yml` and `psub.yml` at the configuration root for the shared
platform, and `apex/nsub.yml`, `apex/psub.yml`, `nova/nsub.yml` and `flux/nsub.yml` for the customers. Each gives its subscription its own
Log Analytics workspace and Key Vault.

##### 1 in `discovery`

The same six configs, one landing zone per subscription: a hub in each shared subscription, a spoke in each customer subscription. The
budget of each (`budgetAmount`, alerts to the subscription's `Owner` role) makes the subscription the unit of cost too.

##### 1 in `expedition`

Not a subscription owner: its configs are per environment and slot (`dev.yml`, `test.yml`, `apex/dev.yml`, `apex/dev-blu.yml`,
`apex/prod.yml`, `nova/dev.yml`), each a resource group inside the subscription its coordinate resolves to
([ADR-AZ-DATAMOD#3](../azure-data-model.md#rule-adr-az-datamod3)).

##### 1 status

partly realised — subscriptions per customer and per environment class with a self-service landing zone by pull request; subscription
vending, per-environment subscriptions below production, and management groups are not adopted, because the repository deploys only into
subscriptions it is given.

### 2 — Policy-driven governance

```text
CAF Design principles — Azure landing zone design principles — recommendation 2
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-principles#policy-driven-governance
        (retrieved 2026-10-14)
Summary (ours): Azure Policy provides tool-agnostic guardrails that keep deployments within security, governance and regulatory
controls. Policy lets the platform team enforce and audit control-plane and data-plane configuration, which is what makes it safe to
hand subscriptions to teams through self-service.
Impact of deviation (ours): Without policy guardrails, keeping the estate compliant takes more operational and management effort.
```

#### What 2 means here

Every landing zone assigns three Azure built-in policies at subscription scope: allowed locations, a required tag on resources, and no
public IP address on a network interface ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)). Whether they deny or only audit is one
repository-wide setting, `policy_enforcement` in `azure.yml`, whose sensible default enforces in production and audits outside it
([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)). Because the policies are built-in definitions, they hold for any tool
that writes to the subscription, which is the tool-agnostic property the principle asks for.

The repository adds guardrails before deploy that Azure Policy cannot give: the CI pipeline compiles every template and checks every
rendered parameters file against the compiled parameter model ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)), and the
shared modules carry secure defaults ([ADR-AZ-LZ#5](../landing-zones.md#rule-adr-az-lz5)). These guard what the repository deploys; the
policies guard the subscription against everything else.

The deviation is in breadth and in inheritance. Three policies cover location, tagging and public IP addresses, but not, for example, public
network access on a data service, a missing diagnostic setting, or a TLS minimum; the modules set those, and nothing stops another tool from
deploying a resource without them. Each landing zone assigns its own copy, because there is no management group to assign once and inherit
from. The impact, here: compliance outside the three policies rests on the modules' defaults and on review, and outside production the
default audit mode reports a breach without blocking it.

##### 2 in `foundation`

Assigns no policy; it deploys before the landing zone. Its `tags` parameter carries the CAF tags, the required `cost-center` among them, so
its Log Analytics workspace and Key Vault pass the required-tag policy once `discovery` assigns it.

##### 2 in `discovery`

The three assignments, from `policy-assignment.bicep`, named per subscription in `policyAssignmentNames` and given a non-compliance message
each. `policyEnforcementMode` reads `global.azure.policy_enforcement.nonproduction` in the `nsub` configs and the production key in the
`psub` configs, by config address.

##### 2 in `expedition`

Assigns no policy and is governed by its landing zone's: it deploys only to the landing zone's region, tags every resource, and creates no
public IP address. Wider policies that would fit it — public network access off on storage and SQL, a diagnostic setting on every data
resource — are planned as further assignments in `discovery`.

##### 2 status

partly realised — three built-in policies per subscription with one repository-wide enforcement setting; further policies are planned
(follow-up), and management group inheritance is not adopted, because the repository owns nothing above a subscription.

### 3 — Single control and management plane

```text
CAF Design principles — Azure landing zone design principles — recommendation 3
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-principles#single-control-and-management-plane
        (retrieved 2026-10-14)
Summary (ours): Do not put custom portals or tooling abstractions in front of Azure. Azure Resource Manager is the one consistent
control plane for central and workload operations alike, governed across the estate by role-based access control and policy.
Impact of deviation (ours): Mixing the control and management tooling of several vendors adds integration and feature-support
complexity and hidden dependencies; existing tooling investments should be reviewed against what Azure services provide.
```

#### What 3 means here

The control plane is Azure Resource Manager. `Deploy-Bicep` runs `az deployment group create` or `az deployment sub create` with the
compiled template, and `-DryRun` runs Azure's own `--what-if`; every Azure operation goes through the az CLI
([ADR-AZ-CLI#1](../prefer-az-cli.md#rule-adr-az-cli1)). catzc is a command line in front of Azure, which the principle warns against, but a
thin one: it harmonises how the organisation calls the vendor and delegates everything else to Bicep and the az CLI, never hiding or cloning
the vendor's behaviour ([ADR-DSGN-THINPLAT#2](../../design/thin-platforms.md#rule-adr-dsgn-thinplat2)). Access is the subscription's own
role-based access control, through the service connection that deploys it, and governance is Azure Policy (ADR-AZ-CAFPRIN#2). The repository
is the single place a change is made ([ADR-DSGN-SELFSERV#2](../../design/self-service.md#rule-adr-dsgn-selfserv2)), and what it changes is
plain Azure resources that the portal, the az CLI, and any Azure tool see as they are.

The management plane deviates. Monitoring is per subscription: `foundation` gives every subscription its own Log Analytics workspace, and
the landing zone and the workload of that subscription send their diagnostics and activity log there. There is no central workspace across
subscriptions. The impact, here: a view across customers or across the shared platform and its spokes needs a cross-workspace query, and a
platform-wide alert is one alert per workspace. The gain is isolation: one customer's telemetry stays in that customer's subscription.

##### 3 in `foundation`

`log-analytics.bicep` deploys the subscription's workspace, the management plane of that subscription alone; `nsub-weu-zct-fnd-log` for the
shared non-production subscription, `nsub-weu-zct-fnd-apex-log` for apex's.

##### 3 in `discovery`

Streams the subscription's activity log (`subscription-diagnostic-setting.bicep`) and the diagnostics of the virtual network and every
network security group (`diagnostic-setting.bicep`) to `foundation`'s workspace in the same subscription, named in
`logAnalyticsResourceGroupName` and `logAnalyticsName`.

##### 3 in `expedition`

Sends the diagnostics of the storage account, its blob service, and the database to the same per-subscription workspace. A workload of the
shared platform (`dev.yml`) reports to the shared workspace, a customer workload (`apex/dev.yml`) to its customer's.

##### 3 status

partly realised — one control plane, Azure Resource Manager, behind a thin command line; a single management plane is not adopted, because
monitoring is kept per subscription for isolation between customers.

### 4 — Application-centric service model

```text
CAF Design principles — Azure landing zone design principles — recommendation 4
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-principles#application-centric-service-model
        (retrieved 2026-10-14)
Summary (ours): Organise migration and development around applications rather than moving infrastructure, such as virtual machines,
as it is. The design treats old and new, IaaS and PaaS applications alike, and every application gets a secure environment.
Impact of deviation (ours): Segmenting workloads other than by the reference management group options — by organisation chart or by
Azure service, for example — complicates policy and access control and risks duplicated policies and exceptions. Separating
development, test and production is covered in the landing zone FAQ.
```

#### What 4 means here

The application is the unit a template serves. `expedition` is a workload: it lands in the landing zone of its subscription, places its
private endpoints in the spoke's `private-endpoints` subnet (the hub's `shared-services` subnet for the shared platform), registers them in
the hub's private DNS zones, and creates no network, DNS zone, or policy ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)). Every
workload of a subscription therefore meets the same secure environment, whatever it contains; a second workload template would land the same
way, with no network work. The shared modules include `vm.bicep`, so an IaaS workload would land in the same subnets under the same policies
as the PaaS one.

Workloads are segmented by customer subscription and by environment class, not by a management group archetype (the reference hierarchy's
corp and online groups). The impact, here: the policies sit on each subscription, not on a group of them, so every landing zone carries the
same three assignments. The duplication is a single template and a single setting ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)), so
the copies cannot drift; an exception for one customer would be a config value, visible in review.

##### 4 in `foundation`

Not applicable: it serves the subscription, not an application. It provides the vault and the workspace every application of that
subscription uses.

##### 4 in `discovery`

The secure environment every application gets: the virtual network, a network security group per workload subnet that denies inbound
internet traffic, the private DNS zones in the hub, the policies, and the budget. It holds no workload of its own.

##### 4 in `expedition`

The application: a storage account and a SQL server with one database, reached only through private endpoints, in its own resource group per
configuration slot. `apex/dev.yml` and its special slot `apex/dev-blu.yml` are two instances of the application side by side in one spoke.

##### 4 status

realised — workloads land in a landing zone they do not own, segmented by customer subscription; management group archetypes are not adopted
([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)).

### 5 — Alignment with Azure-native design and roadmaps

```text
CAF Design principles — Azure landing zone design principles — recommendation 5
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-principles#alignment-with-azure-native-design-and-roadmaps
        (retrieved 2026-10-14)
Summary (ours): Prefer Azure-native platform services wherever possible, and follow the Azure roadmaps so that new capabilities reach
the environment and inform migration and the direction of the landing zone.
Impact of deviation (ours): Third-party solutions create dependencies for feature support and for integration with first-party
services. Sometimes they are unavoidable, so weigh the trade-off.
```

#### What 5 means here

Every resource the templates deploy is an Azure-native service, described in Bicep, Azure's own language for Resource Manager templates,
from the shared modules in `infrastructure/modules/`. Governance uses Azure built-in policy definitions, monitoring Azure Monitor and Log
Analytics, secrets Key Vault, name resolution Azure Private DNS, and SQL access Entra ID
([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)). Deployment runs through the az CLI
([ADR-AZ-CLI#1](../prefer-az-cli.md#rule-adr-az-cli1)) from Azure DevOps pipelines. There is no third-party firewall, monitoring agent, or
secret store.

Following the roadmap is partly mechanised. `azure.yml` pins `bicep_min_version`, and `Assert-AzCliBicep` fails a Bicep build on an older
Bicep CLI. The resource API versions are written in each module by hand, and several are older or preview versions (`2021-05-01-preview` on
the diagnostic settings, for example), so a new capability reaches the templates when someone updates a module.

##### 5 in `foundation`

Two native services, `log-analytics.bicep` and `key-vault.bicep`.

##### 5 in `discovery`

Native networking and governance only: virtual network, network security groups, route table, peering, private DNS zones, built-in policy
assignments, a subscription diagnostic setting, and a Cost Management budget. The hub reserves `GatewaySubnet` and `AzureFirewallSubnet` for
Azure's own gateway and firewall.

##### 5 in `expedition`

Azure Storage and Azure SQL Database, reached through Azure Private Link, with Entra ID authentication.

##### 5 status

realised — Azure-native services, language, policy, and tooling throughout; a check that flags outdated or preview API versions in the
modules is planned (follow-up).

## Decision

The repository takes the five principles as the frame of its landing zone and states, per principle, whether it follows or deviates. It
follows the application-centric service model and Azure-native design in full, and the single control plane through a thin command line over
Azure Resource Manager. It follows subscription democratization and policy-driven governance at subscription level only: the repository
deploys into subscriptions it is given, so subscription vending, management groups, and inherited policy belong to whoever administers the
tenant ([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)). It deviates from a single management plane on purpose, keeping one workspace
per subscription so that customers stay isolated.

### How this is enforced

- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for `foundation`, `discovery`, and `expedition` on every change
  under `infrastructure/`, so a template that does not compile, or a config address that does not resolve, fails the build; the
  parameter-model test checks every rendered parameters file against the compiled template
  ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)).
- `AzureConfig` validates `azure.yml`: the subscriptions and their environments, and the `policy_enforcement` default and modes
  ([ADR-AZ-DATAMOD#8](../azure-data-model.md#rule-adr-az-datamod8), [ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)).
- `Assert-AzCliBicep` fails a Bicep build on a Bicep CLI older than `bicep_min_version`.
- The three policy assignments enforce or audit in Azure itself, per subscription.
- Planned (follow-up): further built-in policy assignments in `discovery` (ADR-AZ-CAFPRIN#2), and a quality gate that flags outdated or
  preview API versions in `infrastructure/modules/` (ADR-AZ-CAFPRIN#5). Neither exists.

## Consequences

- A new customer gets a governed landing zone from config files and one pull request, but waits for its subscriptions from the tenant's
  administrator.
- The repository never needs rights above a subscription, at the cost of repeating the policy assignments in every landing zone and of
  leaving management group policy to others.
- Outside production the default policy mode audits; a breach there is reported, not blocked, unless a repository sets
  `nonproduction: Default`.
- Each customer's telemetry stays in its own subscription; a view across the estate needs cross-workspace queries.
- Every service is Azure-native, so nothing in the templates depends on a third party's feature support; keeping API versions current is
  manual until its check exists.
