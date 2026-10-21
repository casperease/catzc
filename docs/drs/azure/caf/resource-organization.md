# ADR: CAF resource organization — what the repository does about each management group and subscription recommendation

Pairs with [`landing-zones`](../landing-zones.md) (the subscription landing zone that stops below the management groups) and
[`data-model`](../azure-data-model.md) (the subscriptions, environments, and customers every recommendation here is weighed against).

## Rules: ADR-AZ-CAF-RESORG

### Rule ADR-AZ-CAF-RESORG-KEEPMANAGEMENTGROUPHIERARCHYFLAT

Not adopted: the repository has no management group hierarchy to keep flat, because its landing zone stops at the subscription
([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)).

- [1 — Keep the management group hierarchy flat](#1--keep-the-management-group-hierarchy-flat)

### Rule ADR-AZ-CAF-RESORG-GROUPBYPOLICYNEEDNOTBYORGANISATIONCHART

Not adopted: there are no management groups, so none can mirror the organisation chart; the repository's grouping is the subscription model
in `azure.yml`, keyed by customer and environment class.

- [2 — Group by policy need, not by organisation chart](#2--group-by-policy-need-not-by-organisation-chart)

### Rule ADR-AZ-CAF-RESORG-NOWORKLOADTEAMROLESATMANAGEMENTGROUPLEVEL

Adopted: the repository grants no role above a subscription; each subscription is deployed by its own service connection, pinned with
`-SubscriptionIdAssertIs`, and the templates make no role assignment for workload teams.

- [3 — No workload-team roles at management-group level](#3--no-workload-team-roles-at-management-group-level)

### Rule ADR-AZ-CAF-RESORG-NAVIGATEACROSSHIERARCHYBYTAGS

Partly adopted: every resource carries the six CAF tags and the landing zone requires `cost-center`; the resource groups that `Deploy-Bicep`
creates for `foundation` and `expedition` carry deployment-tracking tags but not the CAF tags.

- [4 — Navigate across the hierarchy by tags](#4--navigate-across-the-hierarchy-by-tags)

### Rule ADR-AZ-CAF-RESORG-SANDBOXMANAGEMENTGROUP

Not adopted: there is no sandbox management group; experiments run in a non-production configuration slot of an existing subscription.

- [5 — A sandbox management group](#5--a-sandbox-management-group)

### Rule ADR-AZ-CAF-RESORG-PLATFORMMANAGEMENTGROUP

Not adopted: there is no platform management group; the shared subscriptions `shared_nonprod` and `shared_prod` hold the platform role, each
with its own subscription-level policies.

- [6 — A platform management group](#6--a-platform-management-group)

### Rule ADR-AZ-CAF-RESORG-LANDINGZONEMANAGEMENTGROUPSPERWORKLOADARCHETYPE

Not adopted: there are no archetype management groups; the network kind of a subscription (hub or spoke) is the repository's one archetype
split, and it is a config value in `network.yml`.

- [7 — Landing zone management groups per workload archetype](#7--landing-zone-management-groups-per-workload-archetype)

### Rule ADR-AZ-CAF-RESORG-FEWPOLICYASSIGNMENTSATROOT

Not adopted: the repository assigns no policy at the root management group, or at any management group, so the intent holds by construction.

- [8 — Few policy assignments at the root](#8--few-policy-assignments-at-the-root)

### Rule ADR-AZ-CAF-RESORG-ENFORCECOMPLIANCEPOLICY

Adopted at subscription level: every landing zone assigns three built-in policies whose enforcement mode is `policy_enforcement` in
`azure.yml` ([ADR-AZ-LZ-THREEBUILTINPOLICIES](../landing-zones.md#rule-adr-az-lz-threebuiltinpolicies),
[ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)).

- [9 — Enforce compliance with policy](#9--enforce-compliance-with-policy)

### Rule ADR-AZ-CAF-RESORG-ONLYPRIVILEGEDUSERSOPERATEMANAGEMENTGROUPS

Not adopted: the management group hierarchy settings are tenant administration, outside what the repository deploys.

- [10 — Only privileged users operate management groups](#10--only-privileged-users-operate-management-groups)

### Rule ADR-AZ-CAF-RESORG-DEFAULTMANAGEMENTGROUPNEWSUBSCRIPTIONS

Not adopted: the default management group for new subscriptions is a tenant setting, outside what the repository deploys.

- [11 — A default management group for new subscriptions](#11--a-default-management-group-for-new-subscriptions)

### Rule ADR-AZ-CAF-RESORG-SEPARATEENVIRONMENTSBYSUBSCRIPTIONNOTBYMANAGEMENTGROUP

Adopted: production and non-production are separated by subscription, never by a management group — `azure.yml` maps the standard
environments onto a non-production and a production subscription per customer and for the shared platform.

- [12 — Separate environments by subscription, not by management group](#12--separate-environments-by-subscription-not-by-management-group)

### Rule ADR-AZ-CAF-RESORG-NOMANAGEMENTGROUPSPERREGION

Not adopted: there are no management groups to split by region, and every environment deploys to one region.

- [13 — No management groups per region](#13--no-management-groups-per-region)

### Rule ADR-AZ-CAF-RESORG-SUBSCRIPTIONASUNITMANAGEMENT

Adopted: the subscription is the unit of management — one landing zone, one workspace, one Key Vault, one budget, and one service connection
per subscription ([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)).

- [14 — The subscription as the unit of management](#14--the-subscription-as-the-unit-of-management)

### Rule ADR-AZ-CAF-RESORG-SUBSCRIPTIONOWNERSKNOWTHEIRDUTIES

Partly adopted: each subscription's budget alerts its `Owner` role and its policies report compliance to that role's view; access reviews
and remediation are the owner's practice, not the repository's.

- [15 — Subscription owners know their duties](#15--subscription-owners-know-their-duties)

### Rule ADR-AZ-CAF-RESORG-FOURTESTSNEWSUBSCRIPTION

Partly adopted: a new subscription is cut along a management boundary (the customer), a policy boundary (the environment class), and a
network boundary (one virtual network per subscription); scale limits are not a criterion.

- [16 — Four tests for a new subscription](#16--four-tests-for-a-new-subscription)

### Rule ADR-AZ-CAF-RESORG-GROUPSUBSCRIPTIONSUNDERMANAGEMENTGROUPS

Not adopted: subscriptions are grouped in `azure.yml` by customer and environment class, not under management groups.

- [17 — Group subscriptions under management groups](#17--group-subscriptions-under-management-groups)

### Rule ADR-AZ-CAF-RESORG-FOURDEDICATEDPLATFORMSUBSCRIPTIONS

Not adopted: the platform runs in one shared subscription per environment class, which holds the hub and the shared platform's workloads,
not in four dedicated platform subscriptions.

- [18 — Four dedicated platform subscriptions](#18--four-dedicated-platform-subscriptions)

### Rule ADR-AZ-CAF-RESORG-SUBSCRIPTIONVENDINGPROCESS

Partly adopted: **subscription vending** is a pull request — an `azure.yml` entry, its range in `network.yml` (the IP address plan), and one
config per template that gives it its workspace, vault, landing zone, tags, and budget; creating the subscription itself is not adopted,
because the repository deploys only into subscriptions it is given.

- [19 — A subscription vending process](#19--a-subscription-vending-process)

### Rule ADR-AZ-CAF-RESORG-FLEXIBLESUBSCRIPTIONMODEL

Adopted: the subscription model is config — a customer has a production and a non-production subscription or a non-production one alone, and
the shared platform's workloads share the shared subscriptions.

- [20 — A flexible subscription model](#20--a-flexible-subscription-model)

### Rule ADR-AZ-CAF-RESORG-SERVICEHEALTHEVERYSUBSCRIPTION

Partly adopted: every landing zone streams the subscription's activity log, its `ServiceHealth` category included, to `foundation`'s
workspace; a Service Health alert per subscription is planned.

- [21 — Service Health on every subscription](#21--service-health-on-every-subscription)

### Rule ADR-AZ-CAF-RESORG-PERREGIONSUBSCRIPTIONSONLYGOVERNANCEORQUOTA

Adopted: subscriptions are never split by region, because every environment deploys to one region.

- [22 — Per-region subscriptions only for governance or quota](#22--per-region-subscriptions-only-for-governance-or-quota)

### Rule ADR-AZ-CAF-RESORG-DISASTERRECOVERYPAIRONESUBSCRIPTION

Not adopted: the repository deploys no secondary region, so no disaster-recovery pair needs a subscription decision.

- [23 — A disaster-recovery pair in one subscription](#23--a-disaster-recovery-pair-in-one-subscription)

### Rule ADR-AZ-CAF-RESORG-RESOURCEGROUPRESOURCESREGION

Adopted: a resource group is created in its environment's region and the resources in it default to the resource group's region.

- [24 — A resource group in its resources' region](#24--a-resource-group-in-its-resources-region)

### Rule ADR-AZ-CAF-RESORG-ONEREGIONPERRESOURCEGROUP

Adopted: a resource group never mixes regions — one region per environment, and the landing zone's allowed-locations policy keeps every
resource in it.

- [25 — One region per resource group](#25--one-region-per-resource-group)

### Rule ADR-AZ-CAF-RESORG-SUBSCRIPTIONSASSCALEUNITS

Partly adopted: every deploying customer has subscriptions of its own, so load spreads across subscriptions by customer; no subscription is
split for scale.

- [26 — Subscriptions as scale units](#26--subscriptions-as-scale-units)

### Rule ADR-AZ-CAF-RESORG-CAPACITYRESERVATIONS

Not adopted: the templates deploy no virtual machine or other capacity-constrained compute to reserve.

- [27 — Capacity reservations](#27--capacity-reservations)

### Rule ADR-AZ-CAF-RESORG-CAPACITYDASHBOARDALERTS

Planned: capacity alerts on the database in production and a workbook over `foundation`'s workspace; no capacity dashboard or alert exists.

- [28 — A capacity dashboard with alerts](#28--a-capacity-dashboard-with-alerts)

### Rule ADR-AZ-CAF-RESORG-QUOTAINCREASESATPROVISIONING

Not adopted: no template deploys a resource whose default quota needs raising at provisioning.

- [29 — Quota increases at provisioning](#29--quota-increases-at-provisioning)

### Rule ADR-AZ-CAF-RESORG-SERVICESAVAILABLETARGETREGIONS

Not adopted as a check: every environment uses `westeurope`, where every service the templates deploy is offered; a new region in
`azure.yml` is the trigger to check availability.

- [30 — Services available in the target regions](#30--services-available-in-the-target-regions)

### Rule ADR-AZ-CAF-RESORG-QUOTAGROUPS

Not adopted: no template consumes quota that a Quota Group would share.

- [31 — Quota Groups](#31--quota-groups)

### Rule ADR-AZ-CAF-RESORG-AUTOMATEDQUOTAREQUESTS

Not adopted: there are no quota requests to automate.

- [32 — Automated quota requests](#32--automated-quota-requests)

### Rule ADR-AZ-CAF-RESORG-QUOTAALERTS

Not adopted: no template consumes a quota close enough to its limit to need an alert.

- [33 — Quota alerts](#33--quota-alerts)

### Rule ADR-AZ-CAF-RESORG-BLOCKSUBSCRIPTIONTRANSFERSBETWEENDIRECTORIES

Not adopted: the subscription transfer policy is a tenant setting, outside what the repository deploys.

- [34 — Block subscription transfers between directories](#34--block-subscription-transfers-between-directories)

### Rule ADR-AZ-CAF-RESORG-SHORTLISTEXEMPTEDUSERS

Not adopted: the list of users exempted from the transfer policy is a tenant setting, outside what the repository deploys.

- [35 — A short list of exempted users](#35--a-short-list-of-exempted-users)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation onto Azure, from strategy and planning to running the
estate. Its "Ready" methodology describes the Azure landing zone: the platform an organisation prepares before workloads arrive, built from
a set of design areas, each with its own design considerations and recommendations.

Resource organization is the design area that decides how resources are grouped and governed: the management group hierarchy that carries
policy and access by inheritance, the subscriptions that bound management, policy, cost, and scale, and the naming and tagging that make
resources findable (the naming and tagging recommendations have their own record). Microsoft's reference design keeps platform subscriptions
apart from workload subscriptions, groups them in a management group hierarchy under the tenant root, and gives each workload its own
subscription through a vending process.

These rules are vendor recommendation, not principled theory: they record what Microsoft advises for Azure and what this repository does
about each of the area's 35 recommendations (13 on management groups, 22 on subscriptions), and they carry no more authority than that. CAF
recommendations carry no vendor codes, so a rule's number is its order on Microsoft's pages, management groups first. Each recommendation
below cites Microsoft's page — its title, section, link, and retrieval date — and summarises it in our own words. Nothing is quoted, because
the live CAF text is published under the [Microsoft Learn Terms of Use](https://learn.microsoft.com/en-us/legal/termsofuse), not under a
reuse licence. The example basis of every takeaway is the three templates `foundation`, `discovery` (the landing zone), and `expedition`
(the workload), deployed in that order ([landing-zones](../landing-zones.md)).

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

One decision shapes most of this record. The repository has no management groups: its landing zone is deployed at subscription scope and
deploys nothing at management-group or tenant level, because a repository that deploys into subscriptions it is given cannot assume it owns
the hierarchy above them ([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)). So each management group recommendation
below says what leaving it out costs here and what would change that, and each subscription recommendation maps to the subscription model in
`azure.yml` — shared and customer subscriptions, non-production and production ([data-model](../azure-data-model.md)) — and the customer
catalogue in `customer.yml` ([customer-model](../azure-customer-model.md)).

### 1 — Keep the management group hierarchy flat

```text
CAF Resource organization — Management groups — recommendation 1
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Keep the management group hierarchy shallow, three to four levels at most, so that inheritance stays easy to follow.
```

#### What 1 means here

The repository has no hierarchy to keep flat: every policy, diagnostic setting, and budget is assigned at subscription level by `discovery`
([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)). The cost is that nothing the repository deploys is inherited: a
second landing zone gets its guardrails by deploying its own copy, and a tenant administrator who adds a management group above a
subscription adds policy the configuration tree does not show. What would change it: a repository that administers its own tenant and owns
the hierarchy, which would then live in config beside `azure.yml` and be deployed at tenant level.

##### 1 status

not adopted, because the repository deploys only into subscriptions it is given and owns no management group.

### 2 — Group by policy need, not by organisation chart

```text
CAF Resource organization — Management groups — recommendation 2
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): A management group exists to apply policy to workloads that share security and compliance needs. Do not shape the
  hierarchy after the organisation chart, and do not use it for billing or for access control.
```

#### What 2 means here

Without management groups the question moves down a level: the repository groups subscriptions in `azure.yml` by customer (the `customer`
key, [ADR-AZ-CUSTOMER-TWOBINDINGS](../azure-customer-model.md#rule-adr-az-customer-twobindings)) and by environment class (the environments
each subscription serves), and the policy need follows the environment class through `policy_enforcement`
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)). The cost of having no management
group is that a policy need shared by many subscriptions is assigned in each one. A tenant whose compliance needs differ by workload kind,
rather than by customer, would be the trigger to add management groups, grouped by that need.

##### 2 status

not adopted, because there are no management groups; the subscription model groups by customer and environment class instead.

### 3 — No workload-team roles at management-group level

```text
CAF Resource organization — Management groups — recommendation 3
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Give workload teams their roles at subscription or resource group level, normally through the vending process, never at a
  management group, where inheritance grants more than intended. Platform teams may hold rights at management-group level only through
  just-in-time elevation (PIM).
```

#### What 3 means here

The repository grants nothing above a subscription because it has no management groups, and the identities that deploy are cut per
subscription: each CD pipeline names one service connection per subscription (`sc-apex-nonprod`, `sc-apex-prod`, `sc-nova-nonprod`, …), and
`Deploy-Bicep` requires `-SubscriptionIdAssertIs` in a pipeline, so a deploy that reaches the wrong subscription fails before it starts. The
templates make no role assignment for people; the one role-assignment resource in the modules, in `policy-assignment.bicep`, grants a
policy's own managed identity its remediation role, and `discovery` does not use it. How the service connections themselves get their roles,
and whether platform staff elevate through PIM, is tenant administration outside the repository.

##### 3 in `foundation`

No role assignment; deployed by the subscription's own service connection.

##### 3 in `discovery`

No role assignment; its three policy assignments carry no managed identity, so no remediation role is granted. Deployed at subscription
scope by the subscription's own service connection.

##### 3 in `expedition`

No Azure role assignment. Database administration goes to an Entra ID group (`entraAdminLogin`, `entraAdminObjectId`) on the SQL server,
which is a data-plane administrator, not a management-group or subscription role
([ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins)).

##### 3 status

realised — no role is granted above a subscription, and every deploy runs under a service connection pinned to one subscription.

### 4 — Navigate across the hierarchy by tags

```text
CAF Resource organization — Management groups — recommendation 4
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): For cross-cutting questions, query by tags enforced through policy rather than adding levels to the hierarchy.
```

#### What 4 means here

The CAF tags (`workload`, `environment`, `owner`, `cost-center`, `criticality`, `data-classification`) are a parameter of every template,
set from each config, and the landing zone's required-tag policy makes `cost-center` mandatory on every resource of the subscription
([ADR-AZ-LZ-THREEBUILTINPOLICIES](../landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)). A query across subscriptions by `owner` or by
`environment` therefore works without a hierarchy. Two gaps remain: only one of the six tags is enforced by policy, and the resource groups
that `Deploy-Bicep` creates (`Deploy-AzureResourceGroup`) carry the deployment-tracking tags from `Set-BicepTrackingTagSet`, not the CAF
tags. The naming and tagging record owns the tag set itself.

##### 4 in `foundation`

Its workspace and Key Vault carry the CAF tags from the config (for example `owner: platform` in `nsub.yml`); its resource group does not.

##### 4 in `discovery`

Its resource group and every resource that takes tags carry the CAF tags (`workload: landing-zone`), and it assigns the required-tag policy
for `cost-center`. Requiring the other CAF tags, or inheriting them from the resource group, is planned.

##### 4 in `expedition`

Every resource carries the CAF tags (`workload: expedition`); its resource group does not.

##### 4 status

partly realised — the CAF tags are on every resource and `cost-center` is enforced; enforcing the other tags and tagging the resource groups
`Deploy-Bicep` creates are planned (follow-up).

### 5 — A sandbox management group

```text
CAF Resource organization — Management groups — recommendation 5
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Keep a sandbox management group where users can experiment, isolated from development, test, and production.
```

#### What 5 means here

There is no sandbox management group and no sandbox subscription. An experiment runs as an extra configuration slot in a non-production
subscription (`apex/dev-blu.yml` beside `apex/dev.yml` in `expedition`,
[ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)), so it lands in the same landing
zone, behind the same guardrails, as the rest of non-production. The cost is that an experiment is not isolated from development and test:
it shares their network, their budget, and their audit-only policy mode. A need to try services the landing zone would deny would be the
trigger for a sandbox subscription, declared in `azure.yml` like any other.

##### 5 status

not adopted, because there are no management groups; experiments run as configuration slots inside non-production subscriptions.

### 6 — A platform management group

```text
CAF Resource organization — Management groups — recommendation 6
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Under the root, a platform management group holds the policies and role assignments common to the platform and gathers
  the foundational subscriptions, and with them their billing.
```

#### What 6 means here

The platform's subscriptions are the two shared ones, `shared_nonprod` and `shared_prod`, the only subscriptions in `azure.yml` without a
`customer` key; each holds a hub and the shared platform's workloads. Their common policies are not inherited from a platform management
group: each gets the same three assignments from its own `discovery` deploy. The cost is two assignments of each policy instead of one; what
would change it is the same as for recommendation 1, a repository that owns its tenant's hierarchy.

##### 6 status

not adopted, because there are no management groups; the shared subscriptions carry the platform's policies each for itself.

### 7 — Landing zone management groups per workload archetype

```text
CAF Resource organization — Management groups — recommendation 7
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Under the landing zones management group, add one child per kind of workload (such as online, corp, or local) whose
  members share their security, compliance, connectivity, and feature needs.
```

#### What 7 means here

The repository has one archetype axis and keeps it in config: a subscription's network is a hub or a spoke (`kind` in `network.yml`,
[ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../azure-network-model.md#rule-adr-az-network-networkpersubscription)), and every spoke has the same
connectivity — peered to its tier's hub, private endpoints only, no public IP address on a network interface. Every customer subscription is
a "corp" landing zone in CAF's terms; there is no "online" archetype, since no template exposes a public endpoint. A workload that must be
reachable from the internet would be the trigger for a second archetype, as a new network kind and its own policy set, before it would need
a management group.

##### 7 status

not adopted, because there are no management groups and every customer subscription shares one archetype.

### 8 — Few policy assignments at the root

```text
CAF Resource organization — Management groups — recommendation 8
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Assign as little as possible at the root management group, so that what is inherited further down stays easy to debug.
```

#### What 8 means here

The repository assigns nothing at the root, or at any management group, so the intent holds by construction: every policy that applies to a
resource the repository deploys is visible in that subscription's `discovery` config. What the tenant's administrators assign at the root is
outside the configuration tree, and a root assignment that denies what a template deploys surfaces as a failed deploy.

##### 8 status

not adopted, because the repository owns no management group; nothing is assigned at the root.

### 9 — Enforce compliance with policy

```text
CAF Resource organization — Management groups — recommendation 9
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Enforce compliance requirements through Azure Policy assigned at management group or subscription level.
```

#### What 9 means here

Adopted at subscription level, the one level the repository owns. Every landing zone assigns three built-in policies — allowed locations, a
required tag, no public IP address on a network interface — through `policy-assignment.bicep`
([ADR-AZ-LZ-THREEBUILTINPOLICIES](../landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)). Whether they deny or only audit is
`policy_enforcement` in `azure.yml`, enforcing in production and auditing outside it by default
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)), so a repository changes its
compliance stance with one edit.

##### 9 in `foundation`

Assigns no policy; its resources fall under the landing zone's policies and carry the tag the required-tag policy asks for.

##### 9 in `discovery`

The three assignments in every config, with names from the config (`psub-weu-zct-disco-apex-loc-pa`, `…-tag-pa`, `…-pip-pa`) and the
enforcement mode by config address (`global.azure.policy_enforcement.production` in a `psub` config, `.nonproduction` in an `nsub` one).

##### 9 in `expedition`

Assigns no policy and owns none ([ADR-AZ-LZ-WORKLOADOWNSNONE](../landing-zones.md#rule-adr-az-lz-workloadownsnone)); it deploys within the
landing zone's region, with the CAF tags, and with no public IP address.

##### 9 status

realised — every subscription's landing zone enforces its policies at subscription level, with one repository-wide enforcement setting.

### 10 — Only privileged users operate management groups

```text
CAF Resource organization — Management groups — recommendation 10
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Turn on the hierarchy setting that requires a role to create management groups; by default any user may create one under
  the root.
```

#### What 10 means here

The hierarchy settings belong to the tenant, and the repository deploys nothing at tenant level
([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)). The cost is that the repository cannot show the setting is on; it
relies on the tenant's administrators. A repository that administers its own tenant would set it in a tenant-level deployment.

##### 10 status

not adopted, because the setting is tenant administration outside what the repository deploys.

### 11 — A default management group for new subscriptions

```text
CAF Resource organization — Management groups — recommendation 11
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Set a default management group, the sandbox being a good choice, so that a newly created subscription (a Visual Studio
  one, for example) never lands under the root.
```

#### What 11 means here

The repository creates no subscription and owns no management group, so where a new subscription lands is the tenant's setting. A
subscription reaches the repository only when someone adds it to `azure.yml`; until then nothing deploys into it. A repository that owned
its hierarchy would set the default together with recommendation 10.

##### 11 status

not adopted, because the setting is tenant administration outside what the repository deploys.

### 12 — Separate environments by subscription, not by management group

```text
CAF Resource organization — Management groups — recommendation 12
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Do not create management groups for production, test, and development; separate the environments by subscription inside
  one management group.
```

#### What 12 means here

The environments are separated by subscription. In `azure.yml` a non-production subscription serves `dev`, `test`, and `nsub`, and a
production one serves `preprod`, `prod`, and `psub`, for the shared platform (`shared_nonprod`, `shared_prod`) and for each customer
(`apex_nonprod`, `apex_prod`). The policy difference between the classes is the enforcement mode, read per class from `policy_enforcement`
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)), not a different management
group. Below the production boundary, `dev` and `test` share a subscription and are kept apart by resource group, one per configuration slot
([ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION](../azure-data-model.md#rule-adr-az-datamod-onefileonesubscription)).

##### 12 in `foundation`

One config per subscription: `nsub.yml` and `psub.yml` for the shared platform, `apex/nsub.yml` and `apex/psub.yml` for `apex`, and a
non-production one for `nova` and `flux`.

##### 12 in `discovery`

The same six configs; each reads the enforcement mode of its class, so production denies and non-production audits by default.

##### 12 in `expedition`

A config per standard environment and configuration slot (`dev.yml`, `test.yml`, `apex/dev.yml`, `apex/prod.yml`, …), each resolving to the
subscription that serves its environment ([ADR-AZ-DATAMOD-NAMEKEYEDMAPS](../azure-data-model.md#rule-adr-az-datamod-namekeyedmaps)).

##### 12 status

realised — production and non-production are separate subscriptions, with no management group per environment.

### 13 — No management groups per region

```text
CAF Resource organization — Management groups — recommendation 13
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-management-groups
  (retrieved 2026-10-15)
Summary (ours): Use the standard hierarchy for deployments across several regions too; only a regulatory need tied to location, such as data
  residency or sovereignty, justifies management groups by location.
```

#### What 13 means here

There are no management groups to split, and every environment in `azure.yml` deploys to one region (`westeurope`), with one address space
per environment ([ADR-AZ-NETWORK-ONEADDRESSSPACE](../azure-network-model.md#rule-adr-az-network-oneaddressspace)). A customer bound by data
residency in another region would be the trigger; even then, the repository's first answer is a subscription and environments in that
region, and its allowed-locations policy, before a management group.

##### 13 status

not adopted, because there are no management groups and the repository deploys to one region.

### 14 — The subscription as the unit of management

```text
CAF Resource organization — Subscriptions — Organization and governance — recommendation 14
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Treat the subscription as the unit of management, cut to fit the needs of the business.
```

#### What 14 means here

The subscription is the repository's unit of management. `azure.yml` declares each one by name, with its tenant, the environments it serves,
and its customer when it has one ([ADR-AZ-DATAMOD-TWOCONFIGLAYERS](../azure-data-model.md#rule-adr-az-datamod-twoconfiglayers));
`network.yml` gives each one network
([ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../azure-network-model.md#rule-adr-az-network-networkpersubscription)); and the
once-per-subscription templates give each one its workspace, vault, landing zone, guardrails, and budget
([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)). The business fit is the customer: every customer in
`customer.yml` that deploys has subscriptions of its own.

##### 14 in `foundation`

One workspace and one Key Vault per subscription (`environment_kind: subscription` in `options.yml`).

##### 14 in `discovery`

One landing zone per subscription, deployed at subscription scope (`deployment_target: Subscription`).

##### 14 in `expedition`

Not a unit of its own: its resource groups live inside the subscription their environment resolves to.

##### 14 status

realised — every subscription is declared once and gets the same baseline and landing zone from config.

### 15 — Subscription owners know their duties

```text
CAF Resource organization — Subscriptions — Organization and governance — recommendation 15
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Make sure subscription owners know what they are responsible for: reviewing privileged access periodically, owning the
  budget and the resources, and keeping the subscription compliant with policy, remediating where it is not.
```

#### What 15 means here

Two of the duties reach the owner through what the landing zone deploys. The budget's alerts go to the holders of the subscription's `Owner`
role at 50, 80, and 100 percent (`budget.bicep`, `contactRoles` defaulting to `Owner`), so no address list is kept and whoever owns the
subscription hears about its spend. The policies report compliance in the subscription, and in non-production they audit rather than deny,
so a non-compliant resource is a finding for the owner to remediate. The `owner` tag names the accountable team on every resource. Periodic
access reviews and the owner's understanding of these duties are practices of the organisation, not something a template deploys.

##### 15 in `foundation`

Its resources carry the `owner` tag (`platform` for the shared subscriptions, the customer for theirs).

##### 15 in `discovery`

The budget per subscription (`budgetAmount`, for example 800 for `apex/psub.yml`), alerting the `Owner` role, and the three policy
assignments whose compliance the owner sees.

##### 15 in `expedition`

Its resources carry the `owner` tag; its cost counts against the subscription's budget.

##### 15 status

partly realised — budget alerts and policy compliance reach the subscription owner; access reviews and the owner's briefing belong to the
organisation.

### 16 — Four tests for a new subscription

```text
CAF Resource organization — Subscriptions — Organization and governance — recommendation 16
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Decide whether a requirement needs a new subscription by four tests: scale limits (a large, specialised workload gets its
  own), a management boundary, a policy boundary (a regulated workload such as one under PCI), and network topology (a virtual network
  cannot span subscriptions).
```

#### What 16 means here

Three of the four tests are built into the subscription model. The management boundary is the customer: each customer has subscriptions of
its own, bound by the `customer` key ([ADR-AZ-CUSTOMER-TWOBINDINGS](../azure-customer-model.md#rule-adr-az-customer-twobindings)). The
policy boundary is the environment class: production and non-production are separate subscriptions with their own enforcement mode
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)). The network test is one virtual
network per subscription, a hub or a spoke, in `network.yml`
([ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../azure-network-model.md#rule-adr-az-network-networkpersubscription)). Scale limits are not a
criterion: no template comes near a subscription limit, and the model has no way to give one customer's workload a second subscription of
the same class.

##### 16 in `foundation`

One baseline per subscription, whatever test created the subscription.

##### 16 in `discovery`

One network per subscription; the hub-and-spoke peering is how subscriptions that a test separated reach each other
([ADR-AZ-LZ-HUBANDSPOKE](../landing-zones.md#rule-adr-az-lz-hubandspoke)).

##### 16 in `expedition`

Its configuration slots share their subscription; a workload that needed its own subscription for scale or regulation would need a
subscription entry the model does not offer per workload.

##### 16 status

partly realised — management, policy, and network boundaries decide the subscriptions; scale is not a criterion.

### 17 — Group subscriptions under management groups

```text
CAF Resource organization — Subscriptions — Organization and governance — recommendation 17
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Subscriptions that need the same policies and role assignments sit under the same management group.
```

#### What 17 means here

The grouping exists, but in config rather than in Azure: `azure.yml` groups subscriptions by customer and by environment class, and the same
`discovery` template with the same enforcement setting gives every subscription of a class the same policies. The cost, as for
recommendation 1, is one assignment per subscription instead of one inherited assignment, and no grouping visible in the Azure portal. A
repository that owns its tenant's hierarchy would be the trigger.

##### 17 status

not adopted, because there are no management groups; `azure.yml` groups the subscriptions instead.

### 18 — Four dedicated platform subscriptions

```text
CAF Resource organization — Subscriptions — Organization and governance — recommendation 18
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Run the platform in four separate subscriptions — management, security, connectivity, and identity — and never merge
  them, so that each gets its own policies, roles, and billing.
```

#### What 18 means here

The platform is one shared subscription per environment class. `shared_nonprod` and `shared_prod` each hold the connectivity role (the hub,
its reserved gateway and firewall subnets, and the private DNS zones) and the shared platform's workloads; the management role is spread,
since every subscription, customer ones included, gets its own Log Analytics workspace and Key Vault from `foundation`. There is no identity
subscription, because the repository deploys no directory or identity services, and no security subscription, because it deploys no central
security tooling. The cost is that the hub's network and the shared platform's workloads share one subscription's policies, roles, and
budget. A central security or operations team that needs its own boundary, or a hub firewall or gateway with its own operators, would be the
trigger to split connectivity into a subscription of its own in `azure.yml`.

##### 18 in `foundation`

The shared subscriptions get the same baseline as every customer subscription (`nsub.yml`, `psub.yml`); there is no central management
workspace.

##### 18 in `discovery`

The hub is the `discovery` landing zone of `shared_nonprod` or `shared_prod` (`kind: hub` in `network.yml`), not of a dedicated connectivity
subscription.

##### 18 in `expedition`

The shared platform's workload (`dev.yml`, `test.yml`) lands in the hub's `shared-services` subnet, in the same subscription as the
connectivity resources.

##### 18 status

not adopted, because one shared subscription per environment class serves the platform at this size; splitting out connectivity is the first
step when it outgrows that.

### 19 — A subscription vending process

```text
CAF Resource organization — Subscriptions — Organization and governance — recommendation 19
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Automate creating subscriptions for workload teams behind a self-service request.
```

#### What 19 means here

CAF's subscription vending guidance describes the process as an intake request, an IP address plan (IPAM) that hands the subscription its
ranges, a subscription created by infrastructure as code, and a baseline of tags and budgets on it. The repository does all of that except
the creation. The intake is a pull request
([DDR-SELFSERV-CONSUMERSPROVISIONTHEMSELVES](../../design/self-service.md#rule-ddr-selfserv-consumersprovisionthemselves)): a
customer entry in `customer.yml` when the customer is new, a subscription entry in `azure.yml`, and the subscription's network in
`network.yml`, which is the repository's IP address plan — the ranges live there and nowhere else
([ADR-AZ-NETWORK-ONEIPPLAN](../azure-network-model.md#rule-adr-az-network-oneipplan)), and `Test-AzureNetworkPlan` fails a plan where two
networks overlap ([ADR-AZ-NETWORK-NOOVERLAP](../azure-network-model.md#rule-adr-az-network-nooverlap)). The baseline is a config per
once-per-subscription template: `foundation` for the workspace and the vault, `discovery` for the landing zone with its CAF tags, policies,
and budget. The customer's CD pipeline then deploys them in order.

Creating the subscription is not adopted. It takes rights on a billing account, above any subscription, and the repository deploys only into
subscriptions it is given ([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)), so a subscription's `id` in `azure.yml`
names one someone else created, and its service connection is set up outside the repository too. The cost is a wait on the tenant's
administrators before a new customer's first deploy. A repository that held a billing account role would be the trigger to add a
subscription-creation template, deployed at tenant level, ahead of `foundation`.

##### 19 in `foundation`

The first deploy into a vended subscription: one config (`<customer>/nsub.yml`, `<customer>/psub.yml`) per new subscription.

##### 19 in `discovery`

The landing zone of the vended subscription: its network by config address from `network.yml`, its tags, policies, and budget. A new spoke
also needs the hub's config to list it, in the order of
[ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../landing-zones.md#rule-adr-az-lz-linksneedbothnetworks).

##### 19 in `expedition`

Not part of vending: the first workload deployed after it.

##### 19 status

partly realised — intake by pull request, IP address plan in `network.yml`, and an IaC baseline with tags and budget exist; creating the
subscription is not adopted, because it needs rights above any subscription.

### 20 — A flexible subscription model

```text
CAF Resource organization — Subscriptions — Organization and governance — recommendation 20
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Avoid a rigid subscription model; group subscriptions by criteria that can change with the organisation. Some
  applications share a landing zone subscription, others need their own.
```

#### What 20 means here

The model is config, so it changes with an edit. A customer may have a production and a non-production subscription (`apex_nonprod`,
`apex_prod`) or a non-production one alone (`nova_nonprod`, `flux_nonprod`); the customers enabled for deployment are a repository variant,
`have_customers` ([ADR-AZ-CUSTOMER-HAVECUSTOMERSVARIANT](../azure-customer-model.md#rule-adr-az-customer-havecustomersvariant)); and a
subscription's environments are a list. Applications share a subscription by default — every workload of a customer and class lands in that
customer's subscription — and the shared platform's workloads share the shared subscriptions. The one rigid point is that a subscription is
bound to at most one customer and a customer has one subscription per environment
([ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](../azure-data-model.md#rule-adr-az-datamod-schemaandintegrity)).

##### 20 in `foundation`

A new subscription in `azure.yml` is a new config here.

##### 20 in `discovery`

A new subscription is a new config and a new network in `network.yml`.

##### 20 in `expedition`

A new configuration slot in an existing subscription is a new config file, with no subscription change.

##### 20 status

realised — subscriptions, their customers, and their environments are config entries, and workloads share subscriptions by default.

### 21 — Service Health on every subscription

```text
CAF Resource organization — Subscriptions — Operational excellence — recommendation 21
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Give every subscription Service Health alerts, so that a platform incident affecting its resources reaches the people who
  run them.
```

#### What 21 means here

The signal is collected but not alerted on. Every landing zone deploys `subscription-diagnostic-setting.bicep`, which streams the activity
log, its `ServiceHealth` and `ResourceHealth` categories included, to `foundation`'s workspace
([ADR-AZ-LZ-THREEBUILTINPOLICIES](../landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)). No activity-log alert or action group exists,
so a Service Health event is recorded and nobody is told. The reliability record plans the same alert
([ADR-AZ-WAF-RE-RE10](../waf/reliability.md#rule-adr-az-waf-re-re10)).

##### 21 in `foundation`

The workspace that receives the activity log; no alert.

##### 21 in `discovery`

The activity log diagnostic setting in every config. A Service Health alert per subscription, with an action group that notifies the
subscription's `Owner` role like the budget does, belongs here.

##### 21 in `expedition`

Not applicable: Service Health is per subscription, and the workload owns no subscription-level resource.

##### 21 status

partly realised — Service Health events reach the workspace for every subscription; a Service Health alert in `discovery` is planned
(follow-up).

### 22 — Per-region subscriptions only for governance or quota

```text
CAF Resource organization — Subscriptions — Multiple regions — recommendation 22
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Add subscriptions per region only when a region needs its own governance, such as sovereignty, or to get past a quota
  limit.
```

#### What 22 means here

No subscription is split by region. Each environment in `azure.yml` names one region (`region: westeurope`, `region_code: weu`), with one
address space per environment ([ADR-AZ-NETWORK-ONEADDRESSSPACE](../azure-network-model.md#rule-adr-az-network-oneaddressspace)), and every
subscription serves its environments in that region. A second region would be a new environment with its own `region`, served by the
existing subscriptions unless governance or quota calls for more.

##### 22 in `foundation`

One baseline per subscription, in the region of its per-subscription environment (`nsub` or `psub`).

##### 22 in `discovery`

The allowed-locations policy pins every resource of the subscription to the landing zone's region.

##### 22 in `expedition`

Each configuration slot deploys to the region of its environment, inside the subscription that serves it.

##### 22 status

realised — subscriptions are cut by customer and environment class, never by region.

### 23 — A disaster-recovery pair in one subscription

```text
CAF Resource organization — Subscriptions — Multiple regions — recommendation 23
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Where scale is no concern, a primary and secondary disaster-recovery pair may share one subscription (some recovery tools
  require it); deployments that run active-active and are managed independently belong in separate subscriptions.
```

#### What 23 means here

The repository deploys no secondary region: recovery is a redeploy from the templates, and production databases keep geo-redundant backups
([ADR-AZ-LZ-EVERYPILLAR](../landing-zones.md#rule-adr-az-lz-everypillar)). So there is no pair to place. A workload with a recovery target
that a redeploy cannot meet would be the trigger; in the subscription model as it stands, its secondary region would be a second environment
served by the same production subscription, which is the shared-subscription option this recommendation allows.

##### 23 status

not adopted, because no template deploys to a secondary region.

### 24 — A resource group in its resources' region

```text
CAF Resource organization — Subscriptions — Multiple regions — recommendation 24
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Create a resource group in the same region as the resources it contains.
```

#### What 24 means here

The region comes from one place, the environment in `azure.yml`. `Deploy-Bicep` creates a resource-group-target template's resource group
through `Deploy-AzureResourceGroup` in the environment's region, and passes the same region as the deployment location for a
subscription-target template. Each template's `location` parameter defaults to that region, so the resource group and its resources agree
unless a config overrides `location`, which none does.

##### 24 in `foundation`

Its resource group is created in the environment's region; `location` defaults to `resourceGroup().location`.

##### 24 in `discovery`

It creates its own resource group (`resource-group.bicep`) at `location`, which defaults to `deployment().location`, the environment's
region, and deploys every resource there.

##### 24 in `expedition`

Its resource group is created in the environment's region; `location` defaults to `resourceGroup().location`, and the template states it
must match the region of the network it lands in.

##### 24 status

realised — the resource group and its resources take the same region from the environment.

### 25 — One region per resource group

```text
CAF Resource organization — Subscriptions — Multiple regions — recommendation 25
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Do not put resources from different regions in one resource group.
```

#### What 25 means here

The same mechanism as recommendation 24 keeps every resource of a resource group in one region, and the landing zone's allowed-locations
policy, assigned with the landing zone's region as its only allowed location, denies a resource elsewhere where `policy_enforcement`
enforces, and reports it where it audits ([ADR-AZ-LZ-THREEBUILTINPOLICIES](../landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)).

##### 25 in `foundation`

All its resources take the resource group's region.

##### 25 in `discovery`

All its resources take `location`, and it assigns the allowed-locations policy for the subscription.

##### 25 in `expedition`

All its resources take the resource group's region, under the landing zone's allowed-locations policy.

##### 25 status

realised — one region per environment, enforced in production by the allowed-locations policy.

### 26 — Subscriptions as scale units

```text
CAF Resource organization — Subscriptions — Quota and capacity — recommendation 26
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Scale out across subscriptions rather than running into one subscription's platform limits.
```

#### What 26 means here

The subscription per customer spreads load: every customer's workloads count against their own subscription's limits, never against a shared
one. Within a customer and class, though, there is one subscription, and the model allows no second one of the same class
([ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](../azure-data-model.md#rule-adr-az-datamod-schemaandintegrity)). The example workloads are a storage
account and one database per configuration slot, far from any subscription limit, so the gap costs nothing at this size. A customer whose
workloads approach a limit would be the trigger to let the model hold more than one subscription per customer and environment.

##### 26 in `foundation`

Not applicable: one workspace and one vault per subscription, far from any limit.

##### 26 in `discovery`

One network per subscription; a second subscription for scale would need its own range in `network.yml` and its own spoke.

##### 26 in `expedition`

Each configuration slot adds a resource group with a storage account, a SQL server, and a database to the subscription of its environment.

##### 26 status

partly realised — subscriptions per customer spread the load; splitting a customer's subscription for scale is not modelled.

### 27 — Capacity reservations

```text
CAF Resource organization — Subscriptions — Quota and capacity — recommendation 27
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): In regions where capacity is constrained, reserve capacity for the resources the workload depends on.
```

#### What 27 means here

Capacity reservations apply to virtual machines, and no template deploys one; the modules include `vm.bicep`, but none of `foundation`,
`discovery`, and `expedition` uses it. The workloads are platform services (SQL Database and Storage). A template that deploys virtual
machines in a constrained region would be the trigger.

##### 27 status

not adopted, because no template deploys capacity-constrained compute.

### 28 — A capacity dashboard with alerts

```text
CAF Resource organization — Subscriptions — Quota and capacity — recommendation 28
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Build a dashboard with views of how much capacity is used, and alert as use approaches critical thresholds, such as 90
  percent CPU.
```

#### What 28 means here

The metrics are collected but nothing views or alerts on them. `diagnostic-setting.bicep` sends the metrics of each resource kind it
supports to `foundation`'s workspace, the database's included, and no workbook, dashboard, metric alert, or action group exists. The
reliability record plans alerts on database availability and capacity in production
([ADR-AZ-WAF-RE-RE10](../waf/reliability.md#rule-adr-az-waf-re-re10)); this recommendation adds a view over the same metrics.

##### 28 in `foundation`

The workspace holds the metrics; a workbook over them belongs here, since every subscription has one workspace.

##### 28 in `discovery`

Not applicable: the network resources have no capacity that fills up at this size.

##### 28 in `expedition`

The database's CPU and storage are the capacity signals; a metric alert on each in production configs is planned.

##### 28 status

planned (follow-up) — metric alerts on the database and a capacity workbook over the workspace.

### 29 — Quota increases at provisioning

```text
CAF Resource organization — Subscriptions — Quota and capacity — recommendation 29
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Request quota increases, such as virtual machine cores, while the subscription is provisioned, before workloads exceed the
  defaults.
```

#### What 29 means here

The templates deploy a handful of platform resources per subscription, well inside the default quotas, and no virtual machine cores. The
repository does not provision subscriptions either (recommendation 19). A template that consumes a quota-bound resource, such as virtual
machines, would be the trigger to request the increase in the intake pull request.

##### 29 status

not adopted, because no template comes near a default quota.

### 30 — Services available in the target regions

```text
CAF Resource organization — Subscriptions — Quota and capacity — recommendation 30
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Confirm that the services and features the workload needs are available in the regions it will run in.
```

#### What 30 means here

Every environment in `azure.yml` uses `westeurope`, where SQL Database, Storage, Key Vault, Log Analytics, Private Link, and private DNS,
with the zone redundancy the production configs ask for, are all offered. Nothing checks availability before a deploy; a missing service
fails the deploy. A new region in `azure.yml` is the trigger to check availability as part of the change.

##### 30 status

not adopted as a check, because the repository uses one region where every service it deploys is available.

### 31 — Quota Groups

```text
CAF Resource organization — Subscriptions — Quota and capacity — recommendation 31
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Share quota across subscriptions by putting them in a Quota Group.
```

#### What 31 means here

Quota Groups pool compute quota across subscriptions, and no template consumes compute quota. They are also managed above the subscription,
where the repository has no rights. Virtual machine workloads across many customer subscriptions would be the trigger.

##### 31 status

not adopted, because no template consumes the quota a Quota Group shares.

### 32 — Automated quota requests

```text
CAF Resource organization — Subscriptions — Quota and capacity — recommendation 32
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Automate quota requests through the Azure Quota REST API.
```

#### What 32 means here

There are no quota requests to automate (recommendation 29). If there were, a request would belong to the intake of a subscription, run
through the az CLI like every other Azure call ([prefer-az-cli](../prefer-az-cli.md)).

##### 32 status

not adopted, because the repository makes no quota requests.

### 33 — Quota alerts

```text
CAF Resource organization — Subscriptions — Quota and capacity — recommendation 33
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Alert subscription owners as their usage approaches a quota limit.
```

#### What 33 means here

No template uses enough of any quota for an alert to fire. Should one, the alert would sit beside the budget in `discovery` and notify the
subscription's `Owner` role in the same way.

##### 33 status

not adopted, because no template comes near a quota limit.

### 34 — Block subscription transfers between directories

```text
CAF Resource organization — Subscriptions — Tenant transfer restriction — recommendation 34
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Set the subscription policy so that no one may move a subscription out of the Entra directory or into it.
```

#### What 34 means here

The subscription policy is a tenant-wide setting, and the repository deploys nothing at tenant level
([ADR-AZ-LZ-LANDINGZONE](../landing-zones.md#rule-adr-az-lz-landingzone)). Each subscription in `azure.yml` names its tenant, and
`Deploy-Bicep` verifies the session's subscription against `-SubscriptionIdAssertIs` before a deploy, so a subscription moved to another
directory fails its next deploy rather than receiving one. A repository that administers its own tenant would set the policy there.

##### 34 status

not adopted, because the setting is tenant administration outside what the repository deploys.

### 35 — A short list of exempted users

```text
CAF Resource organization — Subscriptions — Tenant transfer restriction — recommendation 35
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/landing-zone/design-area/resource-org-subscriptions
  (retrieved 2026-10-15)
Summary (ours): Exempt only a few users from the transfer policy: members of platform operations and the break-glass accounts.
```

#### What 35 means here

The exemption list belongs to the same tenant setting as recommendation 34. The repository's one break-glass credential, the SQL login
beside each server's Entra ID administrator group ([ADR-AZ-LZ-SQLENTRAADMINS](../landing-zones.md#rule-adr-az-lz-sqlentraadmins)), is a
database login, not a directory account, so it has no place on this list.

##### 35 status

not adopted, because the setting is tenant administration outside what the repository deploys.

## Decision

The repository answers each of Microsoft's resource organization recommendations with what it does, what it plans, or why it does not adopt
it. The management group recommendations are not adopted, because the landing zone stops at the subscription; for each, the record names
what that costs and what would change it, and the two whose intent the subscription level can meet — no workload roles above a subscription,
and compliance by policy — are realised there. The subscription recommendations are largely realised by the subscription model in
`azure.yml` and the once-per-subscription templates: the subscription as the unit of management, environments separated by subscription, a
flexible model, one region per resource group, and vending by pull request with `network.yml` as the IP address plan. The gaps are planned:
a Service Health alert per subscription, capacity alerts, and the CAF tags on every resource group. Creating subscriptions, platform
subscriptions per function, quota management, and tenant settings are not adopted, each for its stated reason.

### How this is enforced

- `AzureConfig` validates `azure.yml`: every subscription, its environments, and its customer reference, and the default of
  `policy_enforcement` ([ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](../azure-data-model.md#rule-adr-az-datamod-schemaandintegrity)).
- `NetworkConfig` and `Test-AzureNetworkPlan` hold the IP address plan: one network per subscription, of the right kind, with no overlap
  ([network-model](../azure-network-model.md)).
- `Deploy-Bicep` requires `-SubscriptionIdAssertIs` in a pipeline and fails a deploy whose session targets another subscription, and each CD
  pipeline names one service connection per subscription.
- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for every template, and the parameter-model test checks each
  rendered parameters file against the compiled template
  ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../azure-data-model.md#rule-adr-az-datamod-parametercontract)).
- The landing zone's allowed-locations and required-tag policies deny a resource in another region or without `cost-center` where
  `policy_enforcement` enforces, and report it where it audits
  ([ADR-AZ-LZ-THREEBUILTINPOLICIES](../landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)).
- Planned (follow-up), not existing: a Service Health alert and action group in `discovery`, metric alerts on the database in `expedition`'s
  production configs and a capacity workbook over `foundation`'s workspace, and the CAF tags on the resource groups `Deploy-Bicep` creates.

## Consequences

- The repository needs no rights above a subscription, at the cost of repeating each policy assignment per subscription and leaving
  management groups, the tenant's hierarchy settings, and the subscription transfer policy to the tenant's administrators.
- A new customer subscription is a pull request against `azure.yml`, `network.yml`, and one config per template, but it waits on someone
  with billing rights to create the subscription first.
- The platform's connectivity and the shared platform's workloads share one subscription per environment class, so they share its policies,
  roles, and budget until connectivity is split out.
- One region per environment keeps every resource group single-region by construction; a second region is a new environment, not a new
  subscription.
- Health and capacity signals reach `foundation`'s workspace, but nobody is told of a Service Health event or a filling database until the
  planned alerts exist.
