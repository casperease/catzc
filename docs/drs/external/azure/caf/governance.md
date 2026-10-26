# ADR: CAF governance — what the repository does about each of Microsoft's governance design recommendations

Pairs with [`landing-zones`](../../../azure/landing-zones.md) (the landing zone that assigns the policies and carries the budget) and
[`data-model`](../../../azure/azure-data-model.md) (the repository-wide `policy_enforcement` setting and the configuration tree every tag
and budget lives in).

## Rules: EDR-AZ-CAF-GOV

### Rule EDR-AZ-CAF-GOV-R01

Partly realised: every resource carries the six CAF tags from its config, and the landing zone requires one of them, `cost-center`, through
a deny-effect built-in policy; append-mode tagging is not adopted, because the templates write every tag themselves.

- [1 — Decide the required tags and enforce them by policy](#1--decide-the-required-tags-and-enforce-them-by-policy)
- [How this is enforced](#how-this-is-enforced)

### Rule EDR-AZ-CAF-GOV-R02

Not adopted, because the example customers carry no regulatory requirement; a repository whose customer does adds the matching built-in
regulatory initiative to the landing zone's policy set.

- [2 — Turn compliance requirements into policy](#2--turn-compliance-requirements-into-policy)

### Rule EDR-AZ-CAF-GOV-R03

Not adopted, because the repository owns no management group and defines no policy of its own: the built-in definitions it assigns exist in
every tenant.

- [3 — Define policies at the top of the hierarchy](#3--define-policies-at-the-top-of-the-hierarchy)

### Rule EDR-AZ-CAF-GOV-R04

Realised at the highest level the repository owns: the landing zone assigns its policies once per subscription, with no exclusion or
exemption, and no workload assigns a policy.

- [4 — Assign policies as high as is sensible](#4--assign-policies-as-high-as-is-sensible)
- [How this is enforced](#how-this-is-enforced)

### Rule EDR-AZ-CAF-GOV-R05

Not adopted, because the landing zone restricts where resources go and how they connect, not which services a subscription may use; a
repository that must restrict them adds a built-in resource-type policy to the landing zone's set.

- [5 — Govern resource provider registration by policy](#5--govern-resource-provider-registration-by-policy)

### Rule EDR-AZ-CAF-GOV-R06

Realised: the landing zone assigns three built-in policies and no custom definition, each pinned by its definition id in
`discovery/main.bicep` and registered in `guids.yml`, so a change of definition is one reviewed change.

- [6 — Prefer built-in policies](#6--prefer-built-in-policies)
- [How this is enforced](#how-this-is-enforced)

### Rule EDR-AZ-CAF-GOV-R07

Not adopted, because policy belongs to the landing zone and a workload owns none of it (ADR-AZ-LZ-WORKLOADOWNSNONE); the templates grant no
role to an application team.

- [7 — Let application teams govern their own scope](#7--let-application-teams-govern-their-own-scope)

### Rule EDR-AZ-CAF-GOV-R08

Not adopted, because the repository makes no assignment above a subscription; the subscription assignments carry no exclusions to manage.

- [8 — Keep root-level assignments few](#8--keep-root-level-assignments-few)

### Rule EDR-AZ-CAF-GOV-R09

Partly realised: every landing zone deploys a monthly budget whose alerts reach the subscription's `Owner` role; cost exports, forecast
alerts, and anomaly alerts are planned.

- [9 — Oversee spend with Cost Management](#9--oversee-spend-with-cost-management)
- [How this is enforced](#how-this-is-enforced)

### Rule EDR-AZ-CAF-GOV-R10

Partly realised: every resource names its paying team in `cost-center` and its workload in `workload`; the resource groups that
`Deploy-Bicep` creates for `foundation` and `expedition` carry no CAF tags, which is planned.

- [10 — Tag resources for cost analysis](#10--tag-resources-for-cost-analysis)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for adopting Azure across an organisation: strategy, planning, readiness,
governance, and operations. Its landing-zone guidance splits the platform an organisation builds into design areas, each with considerations
to weigh and numbered design recommendations; the landing zone that a subscription receives here is CAF's application landing zone
([ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone)).

The governance design area is about guardrails: what to audit, what to enforce, and what to deploy automatically by Azure Policy, drawing on
the identity, network, security, and management decisions, plus the cost oversight that keeps spend visible. Here governance is policy as
code. The landing zone `discovery` assigns three built-in policies
([ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)); whether they enforce or only audit
is the repository-wide setting `policy_enforcement` in `azure.yml`, with its sensible default declared once
([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)); every resource
carries the CAF tags; and every subscription has a budget. (The area page's out-of-scope paragraph reads as if reused from the network
design area, since it speaks of the networking foundation; the rules below rely only on the recommendations.)

These rules are vendor recommendation, not principled theory. They do not argue from first principles the way the axioms and DORA's research
do; they record what the repository does about each of Microsoft's ten governance recommendations, numbered in the order the area page lists
them (eight under deployment acceleration, two under cost management). Each rule cites Microsoft's page — area, page, section, link,
retrieval date — and summarises it in our own words, because the live CAF text is published under the Microsoft Learn Terms of Use, which
grant no licence to copy it into a shared repository. Nothing is quoted.

The [CAF reference](../../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

Three further pages of the governance area — on keeping a landing zone up to date, migrating its policies, and updating custom policies —
carry procedures rather than recommendations, so they are not rules here. They inform how this repository keeps its policies current: it
assigns built-in definitions only, pins each by its id, and changes one in a single reviewed change (see [6](#6--prefer-built-in-policies)).

The example basis is the repository's three templates: `foundation` (a Log Analytics workspace and a Key Vault per subscription),
`discovery` (the landing zone), and `expedition` (a workload that lands in it,
[ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone)). Every takeaway below points at what those
three do, or says plainly what they do not.

### 1 — Decide the required tags and enforce them by policy

```text
CAF governance — Azure governance design area, Deployment acceleration recommendations — recommendation 1
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (retrieved 2026-10-15)
Summary (ours): Decide which tags are mandatory and have Azure Policy enforce them, using the append mode so a missing tag is added rather
  than left out; the tagging strategy page holds the detail.
```

#### What 1 means here

The repository's tag set is the six CAF tags: `workload`, `environment`, `owner`, `cost-center`, `criticality`, and `data-classification`.
Every template takes them as one `tags` parameter from its config and passes it to every resource that takes tags. One of them is required
by policy: the landing zone assigns the built-in "Require a tag on resources" definition with `requiredTagName` (`cost-center` by default),
which denies a resource without the tag where `policy_enforcement` enforces and reports it where it audits
([ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)).

Append or modify effects are not used. They fill a missing tag after the fact, from a value the policy holds rather than the config, and a
modify policy needs a managed identity and remediation tasks for resources that exist before it. The templates write every tag
deterministically, so the policy's job is to stop a resource that skipped them, and deny does that. The other five tags are required by
convention and by review, not by policy.

##### 1 in `foundation`

Passes the CAF tags to the workspace and the Key Vault, so its resources pass the required-tag policy once the landing zone assigns it, for
example `cost-center: platform` in `nsub.yml` and `cost-center: apex` in `apex/psub.yml`.

##### 1 in `discovery`

Assigns the required-tag policy, and tags its own resource group and every resource in it from the config, for example
`workload: landing-zone` and `cost-center: platform` in `psub.yml`.

##### 1 in `expedition`

Passes the CAF tags to every resource of each configuration slot, for example `cost-center: apex` in `apex/prod.yml`.

##### 1 status

Partly realised — the tags are decided and one is required by a deny-effect policy; append mode is not adopted, and the other five tags are
required by convention only.

### 2 — Turn compliance requirements into policy

```text
CAF governance — Azure governance design area, Deployment acceleration recommendations — recommendation 2
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (retrieved 2026-10-15)
Summary (ours): Translate the regulatory and compliance obligations that apply into concrete policy definitions and role assignments.
```

#### What 2 means here

The example customers carry no regulatory obligation, so the landing zone's policy set holds only the three guardrails every subscription
needs. The `data-classification` tag records how sensitive a workload's data is (`confidential` for `apex`, `internal` for the shared
platform), but no policy reads it. A repository whose customer falls under a regulation adds the matching built-in regulatory initiative to
`discovery`'s policy set, pinned like the others (see [6](#6--prefer-built-in-policies)), and the assignment module takes an initiative id
as readily as a definition id.

##### 2 in `foundation`

Not applicable: it assigns no policy.

##### 2 in `discovery`

Assigns no regulatory initiative; it is the one place an initiative would be added.

##### 2 in `expedition`

Not applicable: a workload assigns no policy
([ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone)).

##### 2 status

Not adopted, because no example customer has a regulatory obligation to map.

### 3 — Define policies at the top of the hierarchy

```text
CAF governance — Azure governance design area, Deployment acceleration recommendations — recommendation 3
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (retrieved 2026-10-15)
Summary (ours): Create custom policy definitions at the top-level root management group, so they can be assigned at any level beneath it.
```

#### What 3 means here

The recommendation is about where custom definitions live in a management-group hierarchy. The repository has neither: it deploys into
subscriptions it is given and owns no management group
([ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone)), and it assigns built-in definitions only, which Azure
publishes at tenant level and every subscription can assign. It would apply if the repository defined a custom policy and gained rights over
the tenant's hierarchy; until then a custom definition would sit at subscription level, beside its assignment.

##### 3 status

Not adopted, because the repository owns no management group and defines no custom policy.

### 4 — Assign policies as high as is sensible

```text
CAF governance — Azure governance design area, Deployment acceleration recommendations — recommendation 4
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (retrieved 2026-10-15)
Summary (ours): Assign each policy at the highest level where it fits, and exclude a lower level only when it needs to differ.
```

#### What 4 means here

The highest level the repository owns is the subscription, so each policy is assigned there, once, by the landing zone
([ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone)). Every resource group of the subscription, those of
`foundation` and `expedition` included, inherits the assignments. No assignment carries an exclusion and the repository makes no exemption;
where production and non-production must differ, they differ through the enforcement mode, which each config reads by config address from
`policy_enforcement` (`global.azure.policy_enforcement.production` in `psub` configs, `.nonproduction` in `nsub` configs), not through a
narrower assignment.

##### 4 in `foundation`

Not applicable: it assigns no policy; its resources fall under the subscription's assignments.

##### 4 in `discovery`

Assigns the three policies at subscription scope through `infrastructure/modules/policy-assignment.bicep`, one assignment each per
subscription, named per config (for example `psub-weu-zct-disco-loc-pa`, `-tag-pa`, and `-pip-pa`).

##### 4 in `expedition`

Not applicable: a workload assigns no policy
([ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone)); its resource groups inherit the
subscription's assignments.

##### 4 status

Realised — one assignment per policy at subscription level, the highest level the repository owns, with no exclusions.

### 5 — Govern resource provider registration by policy

```text
CAF governance — Azure governance design area, Deployment acceleration recommendations — recommendation 5
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (retrieved 2026-10-15)
Summary (ours): Use Azure Policy at subscription or management-group level to control which resource providers may be registered.
```

#### What 5 means here

The landing zone's guardrails decide where resources go (allowed locations), whether their cost is attributable (the required tag), and
whether they face the internet (no public IP address on a network interface). Which services a subscription may use is left to the rights of
the identity that deploys into it, and nothing in the repository registers or restricts a resource provider. A repository that must narrow
the services adds a built-in resource-type policy to `discovery`'s set, pinned like the others.

##### 5 in `foundation`

Not applicable: it assigns no policy.

##### 5 in `discovery`

Assigns no resource-type or provider policy; it is where one would be added.

##### 5 in `expedition`

Not applicable: a workload assigns no policy.

##### 5 status

Not adopted, because the landing zone governs location, tagging, and exposure, not which services a subscription may use.

### 6 — Prefer built-in policies

```text
CAF governance — Azure governance design area, Deployment acceleration recommendations — recommendation 6
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (retrieved 2026-10-15)
Summary (ours): Use built-in policy definitions wherever they fit, to keep the effort of maintaining policy low.
```

#### What 6 means here

All three of the landing zone's policies are built-in: "Allowed locations", "Require a tag on resources", and "Network interfaces should not
have public IPs" ([ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)). Their meaning is
Microsoft's, and the repository maintains no custom definition.

Keeping them current is a matter of their ids. `discovery/main.bicep` pins each definition by its tenant-level id in one map, and each id is
registered in `pwsh/Base.QualityGates/configs/guids.yml` (`policy_allowed_locations`, `policy_require_tag_on_resources`,
`policy_nic_no_public_ip`), so no unexplained GUID enters the tree ([ADR-AUTO-GUIDS](../../../automation/managed-guids.md)). Microsoft
revises a built-in definition in place, under the same id, so an assignment follows the current version with no change here. When a
definition is deprecated or a better one appears, the id in `main.bicep` and its `guids.yml` entry change together in one reviewed change,
and the next deploy of every landing zone replaces the assignment; the repository never carries the old and the new definition side by side
([one-living-version](../../../principles/one-living-version.md)). The CAF pages on keeping a landing zone up to date and migrating its
policies describe that review for an organisation's own definitions; with built-ins only, it reduces to reviewing three ids.

##### 6 in `foundation`

Not applicable: it assigns no policy.

##### 6 in `discovery`

Holds the three definition ids in its `policyDefinitions` map, each with its parameters and a non-compliance message, and assigns them
through the shared assignment module.

##### 6 in `expedition`

Not applicable: a workload assigns no policy.

##### 6 status

Realised — three built-in definitions, pinned by id and registered, and no custom definition.

### 7 — Let application teams govern their own scope

```text
CAF governance — Azure governance design area, Deployment acceleration recommendations — recommendation 7
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (retrieved 2026-10-15)
Summary (ours): Give application teams the built-in Resource Policy Contributor role where they work, so they can govern their own
  applications.
```

#### What 7 means here

Policy here belongs to the landing zone, and a workload lands in it and owns none of it
([ADR-AZ-LZ-WORKLOADOWNSNONE](../../../azure/landing-zones.md#rule-adr-az-lz-workloadownsnone)): every workload of a subscription meets the
same policies, and none adds its own. The templates grant no role to a team; the only role assignment a module can make is the remediation
role of a policy assignment's managed identity, which no assignment of the landing zone uses. A team that needs a policy for its application
proposes it for the landing zone, through review like any other change. Role assignments for people belong to whoever administers the
subscription.

##### 7 status

Not adopted, because a workload owns no policy and the templates assign no roles to people.

### 8 — Keep root-level assignments few

```text
CAF governance — Azure governance design area, Deployment acceleration recommendations — recommendation 8
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (retrieved 2026-10-15)
Summary (ours): Make few assignments at the root management group, so exclusions do not have to be managed at every level beneath it.
```

#### What 8 means here

The repository makes no assignment above a subscription
([ADR-AZ-LZ-LANDINGZONE](../../../azure/landing-zones.md#rule-adr-az-lz-landingzone)), so it has no root-level assignment to keep few. The
concern behind the recommendation — exclusions spreading downward — does not arise either, because the subscription assignments carry none
(see [4](#4--assign-policies-as-high-as-is-sensible)). Assignments that a tenant's administrators make at a management group above the
subscriptions apply alongside the landing zone's and are theirs to manage.

##### 8 status

Not adopted, because the repository makes no assignment above a subscription.

### 9 — Oversee spend with Cost Management

```text
CAF governance — Azure governance design area, Cost management recommendations — recommendation 9
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (retrieved 2026-10-15)
Summary (ours): Use Microsoft Cost Management to keep financial oversight of the whole environment.
```

#### What 9 means here

Every landing zone deploys a Cost Management budget for its subscription through `infrastructure/modules/budget.bicep`: a monthly amount
from its config, with alerts at 50, 80, and 100 percent of actual cost to the holders of the subscription's `Owner` role, so no address is
kept in a config. The amounts are plain config values that anyone reading the repository can see and review. What is missing is the rest of
the oversight: no cost export writes daily data to storage, the budget compares against actual cost only, and there is no anomaly alert —
the same gaps [EDR-AZ-WAF-CO-CO03](../waf/cost-optimization.md#rule-edr-az-waf-co-co03) records and plans to close.

##### 9 in `foundation`

No budget of its own; its cost counts against the subscription's budget, which `discovery` deploys.

##### 9 in `discovery`

One budget per subscription: 500 for the shared non-production subscription, 1000 for shared production, 300 for each customer's
non-production subscription, and 800 for `apex` production, per month in the subscription's billing currency.

##### 9 in `expedition`

No budget of its own; its cost counts against the subscription's budget.

##### 9 status

Partly realised — a budget with role-addressed alerts per subscription; cost exports, forecast alerts, and anomaly alerts are planned
(follow-up).

### 10 — Tag resources for cost analysis

```text
CAF governance — Azure governance design area, Cost management recommendations — recommendation 10
Source: learn /azure/cloud-adoption-framework/ready/landing-zone/design-area/governance (retrieved 2026-10-15)
Summary (ours): Tag resources with metadata such as the cost centre or the project, so cost can be analysed at a finer grain.
```

#### What 10 means here

The CAF tags carry exactly that metadata: `cost-center` names the paying team and `workload` names the project, and `owner` and
`environment` let Cost Management group spend further. The required-tag policy makes `cost-center` mandatory (see
[1](#1--decide-the-required-tags-and-enforce-them-by-policy)). One gap remains. `Deploy-Bicep` creates the resource group of a
resource-group template (`foundation`, `expedition`) through `Deploy-AzureResourceGroup` with no CAF tags, and afterwards writes only the
deployment-provenance tags (`Set-BicepTrackingTagSet`). The required-tag policy covers resources, not resource groups, so the deploy
succeeds, but cost grouped by resource group, or inherited from it, has nothing to read there. The fix is for the resource group to take the
template's CAF tags from its config.

##### 10 in `foundation`

Its workspace and Key Vault carry the CAF tags; its resource group carries only the provenance tags.

##### 10 in `discovery`

Creates its own resource group through `infrastructure/modules/resource-group.bicep`, so the resource group and every resource in it carry
the CAF tags.

##### 10 in `expedition`

Every resource carries the CAF tags; each configuration slot's resource group carries only the provenance tags.

##### 10 status

Partly realised — every resource is tagged for cost analysis; CAF tags on the resource groups `Deploy-Bicep` creates are planned
(follow-up).

## Decision

The repository answers each of Microsoft's governance recommendations with what it does, what it plans, or why it does not adopt it.
Governance is policy as code inside the landing zone: three built-in policies pinned by id, assigned once per subscription, enforcing or
auditing by the one repository-wide `policy_enforcement` setting; the CAF tags written by every template, with `cost-center` required; and a
budget per subscription. The recommendations that assume a management-group hierarchy (custom definitions at the root, few root-level
assignments) and those that hand policy to application teams are not adopted, because the repository owns no level above a subscription and
keeps policy out of workloads. The planned items close the cost-oversight gaps and tag the resource groups that `Deploy-Bicep` creates.

### How this is enforced

- The landing zone's assignments are the enforcement: Azure denies a resource outside the region, without `cost-center`, or with a public IP
  address on a network interface where `policy_enforcement` enforces, and reports it where it audits
  ([ADR-AZ-LZ-THREEBUILTINPOLICIES](../../../azure/landing-zones.md#rule-adr-az-lz-threebuiltinpolicies)).
- `AzureConfig` declares the default of `policy_enforcement` and rejects an unknown key or mode
  ([ADR-AZ-DATAMOD-POLICYENFORCEMENTMODE](../../../azure/azure-data-model.md#rule-adr-az-datamod-policyenforcementmode)); `discovery`'s
  `@allowed` decorator on `policyEnforcementMode` rejects any other value at build time.
- `Test-ManagedGuids` fails an unregistered GUID in tracked text, so a built-in definition id can enter `discovery/main.bicep` only with its
  `guids.yml` entry ([ADR-AUTO-GUIDS](../../../automation/managed-guids.md)).
- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for every template, and the parameter-model test checks each
  rendered parameters file against the compiled parameter model
  ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../azure/azure-data-model.md#rule-adr-az-datamod-parametercontract)), so a missing `tags`,
  budget, or policy parameter fails the build.
- The budget's alerts reach the subscription's `Owner` role at each threshold.
- Planned (follow-up), not existing: a check over the compiled templates (`main.json`) that fails a resource without the CAF tags, CAF tags
  on the resource groups `Deploy-Bicep` creates, and cost exports with forecast and anomaly alerts.

## Consequences

- One edit to `azure.yml` changes whether every landing zone's policies enforce or audit; no template or config changes with it.
- Built-in definitions keep the policy logic Microsoft's to maintain; the repository reviews three ids and nothing else.
- Every resource's cost is attributable to a team and a workload, and every subscription's spend is watched against a budget.
- Governance above the subscription — management groups, regulatory initiatives across the tenant, role assignments for people — stays with
  the tenant's administrators; the repository never needs rights there.
- A required tag that is missing stops a deploy in production instead of being filled in, so a config without the CAF tags fails loudly.
