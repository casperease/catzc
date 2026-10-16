---
catzc:
  derived:
    path: docs/adr/azure/caf/naming-and-tagging.md
    kind: adr
    body_sha: "87723a9fb3e1"
    defines:
      - ADR-AZ-CAFNAME#{1-22}
    adrs:
      - ADR-AZ-DATAMOD#{5,9-11}
      - ADR-AZ-LZ#{1,3,4,6}
      - ADR-AZ-NAMING
      - ADR-AZ-WAFCO#3
      - ADR-AZ-WAFSE#3
      - ADR-REPO-VARIANT#4
    links:
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod10
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod11
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod5
      - docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9
      - docs/adr/azure/azure-naming-standard.md
      - docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming1
      - docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming2
      - docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming3
      - docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming4
      - docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming5
      - docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming6
      - docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming7
      - docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming8
      - docs/adr/azure/landing-zones.md
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz1
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz3
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz4
      - docs/adr/azure/landing-zones.md#rule-adr-az-lz6
      - docs/adr/azure/waf/cost-optimization.md#rule-adr-az-wafco3
      - docs/adr/azure/waf/security.md#rule-adr-az-wafse3
      - docs/adr/repository/repo-variants.md#rule-adr-repo-variant4
      - docs/references/caf/index.md
---

# ADR: CAF naming and tagging — what the repository does about each of Microsoft's naming and tagging recommendations

<!-- cspell:ignore prweuzctexpedapst debluweuzctexpedapst -->

Pairs with [`naming-standard`](../azure-naming-standard.md) (the repository's own naming standard, which this record compares with
Microsoft's) and [`landing-zones`](../landing-zones.md) (the landing zone whose policy requires a tag).

## Rules: ADR-AZ-CAFNAME

### Rule ADR-AZ-CAFNAME:1

Adopted: a name holds only facts that never change for the resource — environment, configuration slot, region, organisation, template,
customer, role, and type ([ADR-AZ-NAMING#1](../azure-naming-standard.md#rule-adr-az-naming1)); owner, cost centre, criticality, and data
classification live in the CAF tags.

- [1 — Put only stable facts in a name](#1--put-only-stable-facts-in-a-name)

### Rule ADR-AZ-CAFNAME:2

Adopted in the namer: the type registry carries each type's length limit and the render patterns its characters, and an over-limit name
throws; a check that the names written in the template configs equal the namer's render is planned.

- [2 — Respect each type's naming rules](#2--respect-each-types-naming-rules)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFNAME:3

Adopted: a deterministic name differs wherever its components differ, and every globally unique type carries the organisation and the
template; an external collision fails the deploy and is fixed by another special slot or `short_name`, never by a random suffix.

- [3 — Know where a name must be unique](#3--know-where-a-name-must-be-unique)

### Rule ADR-AZ-CAFNAME:4

Adopted with a different component set: environment, slot, region, organisation, template `short_name`, customer, role, and type; the
template stands for CAF's workload, the slot for its instance number, and the organisation, customer, and role are added.

- [4 — Choose the name components](#4--choose-the-name-components)

### Rule ADR-AZ-CAFNAME:5

Adopted: the component order is fixed repository-wide by the `ado_naming` variant; its default puts the environment first and the type last,
unlike CAF's type-first examples, which the `classic` order reproduces.

- [5 — Fix the component order](#5--fix-the-component-order)

### Rule ADR-AZ-CAFNAME:6

Adopted: hyphens where the type allows them, no delimiter in the `storage` and `vm` patterns, chosen per type by its render pattern
([ADR-AZ-NAMING#4](../azure-naming-standard.md#rule-adr-az-naming4)).

- [6 — Choose a delimiter](#6--choose-a-delimiter)

### Rule ADR-AZ-CAFNAME:7

Adopted: every type token in `Get-AzureResourceTypeSet` that CAF lists equals CAF's abbreviation; the two types CAF does not list take
`budg` (budget) and `pa` (policy assignment), and a private DNS zone keeps the name Azure requires.

- [7 — Use the CAF abbreviations](#7--use-the-caf-abbreviations)

### Rule ADR-AZ-CAFNAME:8

Not adopted, because `Get-AzureResourceName` is the repository's name generator, driven by its own configs and tested with the rest of the
code.

- [8 — Generate names with a tool](#8--generate-names-with-a-tool)

### Rule ADR-AZ-CAFNAME:9

Adopted: names and tags are built from codes chosen in config — environment names, a customer key, team and class values — never from a
person's name or a secret.

- [9 — Keep sensitive information out of names and tags](#9--keep-sensitive-information-out-of-names-and-tags)

### Rule ADR-AZ-CAFNAME:10

Adopted with deliberate differences: every type in CAF's examples that the templates deploy is named by the standard, type last and with no
instance counter; subnets keep the names of the network plan instead of an `snet` name.

- [10 — Compare with CAF's example names](#10--compare-with-cafs-example-names)

### Rule ADR-AZ-CAFNAME:11

Partly adopted: the **CAF tags** are a fixed set of six keys, `cost-center` is the one mandatory key, and the others are set by convention
in every config; a tag schema declared once and checked against every config is planned.

- [11 — Define the tagging requirements](#11--define-the-tagging-requirements)

### Rule ADR-AZ-CAFNAME:12

Partly adopted: one built-in policy per landing zone requires the `cost-center` tag ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3));
requiring the other keys and checking their values is planned, and resource selectors are not adopted, because each landing zone has one
region.

- [12 — Enforce the tags with Azure Policy](#12--enforce-the-tags-with-azure-policy)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AZ-CAFNAME:13

Adopted for the CAF tags, which carry codes only; what the `branch` provenance tag records for a deploy from a devbox is an open decision.

- [13 — Keep secrets and personal data out of tags](#13--keep-secrets-and-personal-data-out-of-tags)

### Rule ADR-AZ-CAFNAME:14

Adopted for the CAF tags (lowercase keys and values); the provenance tags `Deployed_From_*` use mixed-case keys, and a casing check is
planned with the tag schema.

- [14 — Keep tag keys and values in one case](#14--keep-tag-keys-and-values-in-one-case)

### Rule ADR-AZ-CAFNAME:15

Not adopted, because each environment maps to one region, the region code is a name component, and the allowed-locations policy holds each
landing zone to its region.

- [15 — Tag the region](#15--tag-the-region)

### Rule ADR-AZ-CAFNAME:16

Adopted: a shared module takes `tags` exactly when its resource type supports tags; peerings, subnets, policy assignments, budgets, and
diagnostic settings take none.

- [16 — Tag only what supports tags](#16--tag-only-what-supports-tags)

### Rule ADR-AZ-CAFNAME:17

Adopted as `workload` and `environment`; tier and repository tags are not adopted, because each example template is one tier and the
provenance tags name the commit.

- [17 — Functional tags](#17--functional-tags)

### Rule ADR-AZ-CAFNAME:18

Adopted as `criticality` and `data-classification`; a service-level tag is not adopted, because no example workload declares a service
level.

- [18 — Classification tags](#18--classification-tags)

### Rule ADR-AZ-CAFNAME:19

Adopted as `cost-center`, the mandatory key; department, program, and budget tags are not adopted, because the budget is a resource of the
landing zone and the customer is the unit of cost.

- [19 — Accounting tags](#19--accounting-tags)

### Rule ADR-AZ-CAFNAME:20

Not adopted, because the example workloads model no business process; a workload that does adds its purpose tags in its own configs.

- [20 — Purpose tags](#20--purpose-tags)

### Rule ADR-AZ-CAFNAME:21

Adopted as one `owner` key, naming the customer or `platform`, on every resource; the CAF tags on the resource groups that
`Deploy-AzureResourceGroup` creates are planned.

- [21 — Ownership tags](#21--ownership-tags)

### Rule ADR-AZ-CAFNAME:22

Not adopted, because no Microsoft workload assessment runs against these subscriptions; the `workload` and `criticality` tags are what such
an assessment would read.

- [22 — Tag workloads for Microsoft assessments](#22--tag-workloads-for-microsoft-assessments)

## Context

Microsoft's Cloud Adoption Framework (CAF) is its guidance for taking an organisation to Azure: strategy, planning, the landing zone that
workloads land in, and the governance and management around them. Its landing-zone guidance splits the platform into design areas, each with
a list of design recommendations.

Naming and tagging belongs to the resource organisation design area and has three pages of its own: how to build a naming convention, a
table of resource abbreviations, and how to build a tagging strategy. Names identify a resource for its whole life; tags carry the facts
about it that cost reports, policies, and automation read and that may change. The repository has its own naming standard,
[ADR-AZ-NAMING](../azure-naming-standard.md), with its type registry in `Get-AzureResourceTypeSet`, and a set of CAF tags in every template
config, so this record says, item by item, where they agree with CAF, where they deliberately differ, and why.

These rules are vendor recommendation, not principled theory. They record what the repository does about each of Microsoft's twenty-two
naming and tagging items, numbered in page order: 1 to 10 from the naming page (with the abbreviation table under 7), 11 to 22 from the
tagging page. CAF items carry no codes of their own, so each rule cites Microsoft's page and section — title, link, retrieval date — and
summarises the item in our own words, because the CAF text is published under the Microsoft Learn Terms of Use, which grant no licence to
copy it into a shared repository. Nothing is quoted.

The [CAF reference](../../../references/caf/index.md) lists every CAF record in this repository and the Microsoft pages each one cites.

The example basis is the repository's three templates: `foundation` (a Log Analytics workspace and a Key Vault per subscription),
`discovery` (the landing zone, [ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)), and `expedition` (a workload that lands in it,
[ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)). Each config of each template writes its resource names and its CAF tags as values, so
the takeaways below point at those configs.

### 1 — Put only stable facts in a name

```text
CAF naming and tagging — Define your naming convention — recommendation 1 (Understand resource names in Azure: name permanence)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (retrieved 2026-10-15)
Summary (ours): Most resource names cannot be changed once the resource exists, so a name should carry only facts that stay true for the
  resource's life, and everything else belongs in tags.
```

#### What 1 means here

The standard's components are all fixed for a resource's life: the environment, the configuration slot, the region, the organisation, the
template's `short_name`, the customer, the role, and the type ([ADR-AZ-NAMING#1](../azure-naming-standard.md#rule-adr-az-naming1)). What can
change — who owns the resource, who pays for it, how critical it is, how sensitive its data is — is a CAF tag (`owner`, `cost-center`,
`criticality`, `data-classification`). The one component that could drift is `short_name`, derived from the template's folder name; each
template pins it in its `options.yml`, so renaming a folder never re-spells a resource
([ADR-AZ-NAMING#2](../azure-naming-standard.md#rule-adr-az-naming2)).

##### 1 in `foundation`

`options.yml` pins `short_name: fnd`; the workspace is `nsub-weu-zct-fnd-log` and the vault `ns-weu-zct-fnd-kv`, while the owner and the
cost centre are tags.

##### 1 in `discovery`

`options.yml` pins `short_name: disco`. A spoke's names carry its customer key, which is fixed for the subscription
(`psub-weu-zct-disco-apex-vnet`); its owner is the `owner: apex` tag.

##### 1 in `expedition`

`options.yml` pins `short_name: exped`. A special slot is part of the name (`dev-blu-weu-zct-exped-apex-sql`), because a slot is a separate
deployment with its own resource group for its whole life.

##### 1 status

Realised — names carry only stable components, and every changeable fact is a tag.

### 2 — Respect each type's naming rules

```text
CAF naming and tagging — Define your naming convention — recommendation 2 (Understand resource names in Azure: naming rules)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (retrieved 2026-10-15)
Summary (ours): Every resource type has its own rules: where its name must be unique, how long it may be, and which characters it may
  use.
```

#### What 2 means here

The type registry (`Get-AzureResourceTypeSet`) ties each type to a render pattern and, for the `long` pattern, to the type's Azure length
limit; the `kv`, `storage`, and `vm` patterns carry their own caps ([ADR-AZ-NAMING#4](../azure-naming-standard.md#rule-adr-az-naming4)).
Every component is lowercase and checked case-sensitively ([ADR-AZ-NAMING#6](../azure-naming-standard.md#rule-adr-az-naming6)), so a render
holds only characters every registered type accepts, and a render over the limit throws instead of being cut short
([ADR-AZ-NAMING#7](../azure-naming-standard.md#rule-adr-az-naming7)).

The resource-group name of a template deployed into a resource group is derived by `Get-BicepResourceGroupName`
([ADR-AZ-DATAMOD#5](../azure-data-model.md#rule-adr-az-datamod5)). Every other name, and the resource group of the subscription-target
`discovery`, is a literal value in a config. Nothing compares those literals with the namer's render, so a mistyped name passes the build
and meets Azure's own rules only at deploy.

##### 2 in `foundation`

`logAnalyticsName` and `keyVaultName` are literals in each config; the resource group is derived.

##### 2 in `discovery`

Every name is a literal: `resourceGroupName`, `virtualNetworkName`, the `networkSecurityGroupNames` map, `routeTableName`, the peering
names, `policyAssignmentNames`, and `budgetName`.

##### 2 in `expedition`

`storageAccountName`, `sqlServerName`, `sqlDatabaseName`, and the two private endpoint names are literals; the resource group is derived.

##### 2 status

Partly realised — the namer enforces the rules; a check that every name in a template config equals `Get-BicepResourceName`'s render is
planned (follow-up).

### 3 — Know where a name must be unique

```text
CAF naming and tagging — Define your naming convention — recommendation 3 (Understand resource names in Azure: name scope)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (retrieved 2026-10-15)
Summary (ours): A name is unique either globally (services with a public DNS name), within its resource group (a virtual network), or
  within its parent resource (a subnet in its virtual network).
```

#### What 3 means here

The standard's registry table records where Azure requires each type's name to be unique, and the registry itself does not carry it, because
a deterministic name differs wherever its components differ. The globally unique types the templates deploy — the storage account, the Key
Vault, and the SQL server — all carry the organisation and the template's `short_name`, so two repositories with different organisation
codes never collide. A collision with a name outside the repository fails the deploy, and is fixed by another special slot or `short_name`,
never by a random suffix ([ADR-AZ-NAMING#1](../azure-naming-standard.md#rule-adr-az-naming1)).

##### 3 in `foundation`

The vault `ps-weu-zct-fnd-ap-kv` is globally unique; the workspace is unique in its resource group.

##### 3 in `discovery`

The network types are unique in their resource group, and subnets and peerings in their virtual network; the budget and the policy
assignments are unique in the subscription.

##### 3 in `expedition`

The storage account `prweuzctexpedapst` and the SQL server `prod-weu-zct-exped-apex-sql` are globally unique; the database is unique in its
server.

##### 3 status

Realised — deterministic names cover every uniqueness rule the templates meet.

### 4 — Choose the name components

```text
CAF naming and tagging — Define your naming convention — recommendation 4 (Choose naming components)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (retrieved 2026-10-15)
Summary (ours): Typical components are the resource-type abbreviation, the workload or application, the environment, the region, and an
  instance number.
```

#### What 4 means here

The standard uses all five of CAF's components, under its own names, and adds three
([ADR-AZ-NAMING#1](../azure-naming-standard.md#rule-adr-az-naming1)):

| CAF component   | Standard component | Difference and why                                                                                                                                        |
| --------------- | ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| resource type   | `type`             | Same; the token is CAF's abbreviation where CAF lists one (item 7).                                                                                       |
| workload        | `short_name`       | The template is the workload; its 2–5 letter id keeps tight names short.                                                                                  |
| environment     | `env`              | Same; the readable name in generous names, a 2-letter code in tight ones (ADR-AZ-NAMING#3).                                                               |
| region          | `region`           | Same; a 3-letter code (`weu`) from `azure.yml`.                                                                                                           |
| instance number | `slot`             | Optional: the base slot carries none, and a special slot may be a word (`blu`), because one config is one deployment.                                     |
| —               | `org`              | Added: one organisation code per repository keeps global names apart between repositories.                                                                |
| —               | `customer`         | Added: derived from the subscription, so each customer's resources are named for it ([ADR-AZ-NAMING#8](../azure-naming-standard.md#rule-adr-az-naming8)). |
| —               | `role`             | Added: tells sibling resources of one type apart inside one slot (`blb` and `sql` private endpoints).                                                     |

A counter as the instance number would say nothing about why a second instance exists; a named special slot does, and the base slot needs no
number at all.

##### 4 in `foundation`

Environment, region, organisation, template, customer, and type: `psub-weu-zct-fnd-apex-log`.

##### 4 in `discovery`

The same, plus a role for siblings: the network security group of the `shared-services` subnet is `nsub-weu-zct-disco-ss-nsg`.

##### 4 in `expedition`

All eight in one name: `dev-blu-weu-zct-exped-apex-blb-pep` (environment, slot, region, organisation, template, customer, role, type).

##### 4 status

Realised — with a deliberately different component set.

### 5 — Fix the component order

```text
CAF naming and tagging — Define your naming convention — recommendation 5 (Develop your naming convention: component order)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (retrieved 2026-10-15)
Summary (ours): Decide once in which order the components appear, and keep to it.
```

#### What 5 means here

The order is one repository-wide choice, the `ado_naming` variant in `variants.yml`
([ADR-AZ-NAMING#5](../azure-naming-standard.md#rule-adr-az-naming5),
[ADR-REPO-VARIANT#4](../../repository/repo-variants.md#rule-adr-repo-variant4)), never a per-name argument. Its default, `standard`, puts
the environment first and the type last, so an alphabetical list of resources groups them by environment, then slot, then region. CAF's
examples put the type first; the `classic` order (`<type>-<org>-<short_name>[-<customer>]-<env>-<region>[-<slot>][-<role>]`) reproduces that
shape for a repository that wants it. The repository ships with `standard`.

##### 5 in `foundation`

`standard`: `nsub-weu-zct-fnd-log`, where CAF's shape would start with `log-`.

##### 5 in `discovery`

`standard`: `nsub-weu-zct-disco-vnet`, where CAF's shape would start with `vnet-`.

##### 5 in `expedition`

`standard`: `prod-weu-zct-exped-apex-sqldb`, where CAF's shape would start with `sqldb-`.

##### 5 status

Realised — one fixed order, chosen for environment-first sorting over CAF's type-first examples.

### 6 — Choose a delimiter

```text
CAF naming and tagging — Define your naming convention — recommendation 6 (Develop your naming convention: delimiter)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (retrieved 2026-10-15)
Summary (ours): Hyphens make names easier to read, but some types forbid them; choose between readability (the common choice) and one
  form for every type (no delimiter).
```

#### What 6 means here

The standard takes both, per type: the render pattern of a type fixes its separator
([ADR-AZ-NAMING#4](../azure-naming-standard.md#rule-adr-az-naming4)). The `long` and `kv` patterns join segments with hyphens; the `storage`
and `vm` patterns concatenate them, because a storage account forbids hyphens and a VM's computer name is capped at 15. The components are
the same in both forms, so a hyphenated name and its concatenated sibling read alike.

##### 6 in `foundation`

Hyphens in both of its names, `nsub-weu-zct-fnd-log` and `ns-weu-zct-fnd-kv`.

##### 6 in `discovery`

Hyphens in every name.

##### 6 in `expedition`

Hyphens everywhere except the storage account, `debluweuzctexpedapst`.

##### 6 status

Realised — readability where the type allows it, concatenation where it does not.

### 7 — Use the CAF abbreviations

```text
CAF naming and tagging — Define your naming convention — recommendation 7 (Develop your naming convention: abbreviations), with the
  abbreviation table of Abbreviation recommendations for Azure resources
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming and
  https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations (retrieved 2026-10-15)
Summary (ours): Use CAF's resource-type abbreviations to keep names within their length limits. The abbreviation page lists one per
  resource type, by category, with its provider namespace.
```

#### What 7 means here

The `type` token of each type in `Get-AzureResourceTypeSet` is CAF's abbreviation wherever CAF lists one. The table compares every type the
templates name:

| Resource type           | CAF abbreviation        | Registry token | Difference and why                                                                            |
| ----------------------- | ----------------------- | -------------- | --------------------------------------------------------------------------------------------- |
| Resource group          | `rg`                    | `rg`           | None.                                                                                         |
| Virtual network         | `vnet`                  | `vnet`         | None.                                                                                         |
| Subnet                  | `snet`                  | `snet`         | None in the token; the templates name subnets from the network plan instead (item 10).        |
| Network security group  | `nsg`                   | `nsg`          | None.                                                                                         |
| Route table             | `rt`                    | `rt`           | None.                                                                                         |
| Virtual network peering | `peer`                  | `peer`         | None.                                                                                         |
| Private endpoint        | `pep`                   | `pep`          | None.                                                                                         |
| Storage account         | `st`                    | `st`           | None.                                                                                         |
| SQL logical server      | `sql`                   | `sql`          | None.                                                                                         |
| SQL database            | `sqldb`                 | `sqldb`        | None.                                                                                         |
| Key Vault               | `kv`                    | `kv`           | None.                                                                                         |
| Log Analytics workspace | `log`                   | `log`          | None.                                                                                         |
| Private DNS zone        | the zone's own DNS name | not registered | None: Azure requires the private-link DNS zone name, so it is no name the standard assembles. |
| Policy definition       | a descriptive name      | not registered | None: the landing zone assigns built-in definitions and defines none of its own.              |
| Policy assignment       | not listed              | `pa`           | Ours: CAF lists none, and the registry needs a token for every type the namer renders.        |
| Budget                  | not listed              | `budg`         | Ours: CAF lists none; `budget` would break the 5-letter cap on `type`, so it is `budg`.       |

The registry also holds `waf`, `vm`, `synw`, `adf`, `nic`, and `pip`, which none of the three templates deploys; this record does not
compare them, and the next refresh of the CAF import adds them to the table.

##### 7 in `foundation`

`log` and `kv`, both CAF's.

##### 7 in `discovery`

`rg`, `vnet`, `nsg`, `rt`, and `peer` are CAF's; `pa` and `budg` are the registry's own, for the two types CAF does not list. The private
DNS zones carry the names Azure requires (`privatelink.blob.<storage suffix>` and the SQL private-link DNS zone).

##### 7 in `expedition`

`st`, `sql`, `sqldb`, and `pep`, all CAF's.

##### 7 status

Realised — every listed type uses CAF's token, and the two unlisted ones have tokens of their own.

### 8 — Generate names with a tool

```text
CAF naming and tagging — Define your naming convention — recommendation 8 (Develop your naming convention: Azure Naming Tool)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (retrieved 2026-10-15)
Summary (ours): Microsoft's Azure Naming Tool generates names from a convention you configure in it.
```

#### What 8 means here

The repository's generator is `Get-AzureResourceName` (with `Get-BicepResourceName` over it), driven by `azure.yml`, `customer.yml`, the
type registry, and the `ado_naming` variant, and tested like the rest of the code. A second generator outside the repository would hold a
second copy of the convention that could disagree with the first.

##### 8 status

Not adopted — the in-repository namer is the one generator.

### 9 — Keep sensitive information out of names and tags

```text
CAF naming and tagging — Define your naming convention — recommendation 9 (Note on personal and confidential information)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (retrieved 2026-10-15)
Summary (ours): Azure does not treat names and tags as customer data, so neither may hold personal, sensitive, or confidential
  information.
```

#### What 9 means here

A name is assembled from config codes that the standard validates by pattern: an environment name, a region code, the organisation code, the
template's `short_name`, a customer key, a role ([ADR-AZ-NAMING#6](../azure-naming-standard.md#rule-adr-az-naming6)). A customer key is a
short code chosen in `customer.yml`, not the customer's legal name. Tag values are team and class codes. Item 13 covers the tags in detail.

##### 9 in `foundation`

Names and tags hold codes only (`ps-weu-zct-fnd-ap-kv`, `owner: apex`).

##### 9 in `discovery`

The same; budget alerts go to the subscription's `Owner` role, so no address appears in a config.

##### 9 in `expedition`

The same; the SQL break-glass password is a Key Vault reference, never a value ([ADR-AZ-LZ#6](../landing-zones.md#rule-adr-az-lz6)).

##### 9 status

Realised — names are built from validated codes only.

### 10 — Compare with CAF's example names

```text
CAF naming and tagging — Define your naming convention — recommendation 10 (Example Azure resource names)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming (retrieved 2026-10-15)
Summary (ours): Example patterns for common types: a resource group by workload and environment, a virtual network and a subnet by
  subscription purpose, region, and number, a network security group by policy or application, a route table by its purpose, a SQL
  database by workload and environment, a storage account by workload and number without hyphens; management groups by GUID with an
  editable display name; subscriptions by descriptive display names.
```

#### What 10 means here

Every type in CAF's examples that the templates deploy is named by the standard, so the difference from each example is the same two
choices: the type comes last (item 5), and there is no instance counter (item 4).

| CAF example shape               | The repository's name            |
| ------------------------------- | -------------------------------- |
| `rg-<workload>-<env>`           | `prod-weu-zct-exped-apex-rg`     |
| `vnet-<purpose>-<region>-<###>` | `psub-weu-zct-disco-apex-vnet`   |
| `nsg-<policy or app>-<###>`     | `psub-weu-zct-disco-apex-pe-nsg` |
| `rt-<name>`                     | `psub-weu-zct-disco-apex-rt`     |
| `sqldb-<workload>-<env>`        | `prod-weu-zct-exped-apex-sqldb`  |
| `st<workload><###>`             | `prweuzctexpedapst`              |

Subnets differ deliberately. Their names are the keys of the network plan in `network.yml` (`shared-services`, `private-endpoints`, one per
environment such as `dev`), plus the names Azure fixes for `GatewaySubnet` and `AzureFirewallSubnet`. A subnet's name is unique only in its
virtual network, the landing zone reads the subnet map by config address
([ADR-AZ-DATAMOD#10](../azure-data-model.md#rule-adr-az-datamod10)), and `expedition` looks up `private-endpoints` by name, so the plan's
key is the most useful name it can have.

Management groups and subscriptions are not named here: the repository creates neither ([ADR-AZ-LZ#1](../landing-zones.md#rule-adr-az-lz1)).
`azure.yml` keys its subscriptions (`shared_nonprod`, `apex_prod`); their display names are the tenant's.

##### 10 in `foundation`

Its resource group, workspace, and vault follow the standard.

##### 10 in `discovery`

Every name follows the standard except the subnets, which keep the network plan's names.

##### 10 in `expedition`

Every name follows the standard.

##### 10 status

Realised — with deliberate differences: type last, no instance counter, and subnets named by the network plan.

### 11 — Define the tagging requirements

```text
CAF naming and tagging — Define your tagging strategy — recommendation 11 (Define your tagging requirements)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Before tagging, line up with the existing naming and governance standards, decide whether cost must be split below the
  subscription (tag inheritance can help), list the operational and compliance facts the tags must carry, and decide which tags are
  mandatory and centrally enforced and which are optional.
```

#### What 11 means here

The CAF tags are six keys, set on every resource that takes tags: `workload`, `environment`, `owner`, `cost-center`, `criticality`, and
`data-classification`. Cost is split below the subscription by `cost-center` and `workload`
([ADR-AZ-WAFCO#3](../waf/cost-optimization.md#rule-adr-az-wafco3)); tag inheritance is not used, because every template passes the tags to
each resource itself. The mandatory key is `cost-center`, required by the landing zone's policy
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)); the other five are mandatory only by convention.

The tag set is written out in full in each config — eighteen copies across the three templates — and no file declares the keys or their
allowed values once. A config that drops a key or misspells a value passes the build. The schema belongs in one config (for example a tag
block in `azure.yml`, validated by `AzureConfig`), with every template config checked against it.

##### 11 in `foundation`

Six configs, each with the six keys (`workload: foundation`).

##### 11 in `discovery`

Six configs, each with the six keys (`workload: landing-zone`); the landing zone also assigns the policy that requires `cost-center`.

##### 11 in `expedition`

Six configs, each with the six keys (`workload: expedition`).

##### 11 status

Partly realised — the keys and the mandatory one are decided; a tag schema declared once and checked against every config is planned
(follow-up).

### 12 — Enforce the tags with Azure Policy

```text
CAF naming and tagging — Define your tagging strategy — recommendation 12 (Implement consistent tagging: enforce with Azure Policy)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Enforce one tagging schema everywhere with Azure Policy, using resource selectors such as the resource location for rules
  that apply only in some regions.
```

#### What 12 means here

Each landing zone assigns the built-in policy that requires a tag on resources, with `cost-center` as its tag
([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)). It enforces or audits by `policy_enforcement` in `azure.yml`, whose default enforces
in production and audits outside it ([ADR-AZ-DATAMOD#11](../azure-data-model.md#rule-adr-az-datamod11)). It checks that the key is present,
not its value, and the other five keys are not required by any policy.

Resource selectors are not used: each landing zone sits in one region, which the allowed-locations policy holds it to, so no tag rule varies
by region.

##### 12 in `foundation`

Not applicable: it assigns no policy; its resources carry `cost-center` and so pass `discovery`'s assignment.

##### 12 in `discovery`

The `requireTag` assignment (`nsub-weu-zct-disco-tag-pa` and its siblings), parameter `requiredTagName`, default `cost-center`.

##### 12 in `expedition`

Not applicable: it assigns no policy ([ADR-AZ-LZ#4](../landing-zones.md#rule-adr-az-lz4)); its resources carry `cost-center`.

##### 12 status

Partly realised — one key is enforced; requiring the other keys and their allowed values, from the planned tag schema, is planned
(follow-up).

### 13 — Keep secrets and personal data out of tags

```text
CAF naming and tagging — Define your tagging strategy — recommendation 13 (Implement consistent tagging: no sensitive values)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Tags are plain text that shows up in cost reports, the APIs, deployment history, exports, and logs, so no secret or
  personal value belongs in one.
```

#### What 13 means here

The CAF tags hold team codes (`platform`, `apex`), class values (`high`, `confidential`), and template names. `Deploy-Bicep` adds three
provenance tags after a deploy through `Set-BicepTrackingTagSet`: the commit, the build id, and the branch. A pipeline deploy records the
build's branch. A deploy from a devbox records the local branch name as it stands, so a branch named after a person would put that name in a
tag on the resource group or subscription; whether a devbox deploy records its branch is open.

##### 13 in `foundation`

Codes only in the CAF tags; the provenance tags land on its resource group.

##### 13 in `discovery`

Codes only in the CAF tags; the provenance tags land on the subscription, prefixed with the template name.

##### 13 in `expedition`

Codes only in the CAF tags; the provenance tags land on its resource group.

##### 13 status

Partly realised — the CAF tags carry no sensitive value; what the `branch` provenance tag records for a devbox deploy is to be decided.

### 14 — Keep tag keys and values in one case

```text
CAF naming and tagging — Define your tagging strategy — recommendation 14 (Implement consistent tagging: case sensitivity)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Tag keys are case-insensitive but values are case-sensitive, so use lowercase keys and one casing for values, or reports
  split one value into several.
```

#### What 14 means here

Every CAF tag key and value is lowercase, with hyphens between words (`cost-center`, `data-classification`, `landing-zone`), matching the
lowercase rule of the naming standard ([ADR-AZ-NAMING#6](../azure-naming-standard.md#rule-adr-az-naming6)). CAF's examples run the words
together (`costcenter`); the hyphen is kept for readability, and both are lowercase. The provenance tags differ: their keys are mixed case
(`Deployed_From_Commit`, `discovery_Deployed_From_Commit`), from `Get-BicepTrackTagNameSet`. Nothing checks the casing of a key or a value.

##### 14 in `foundation`

Lowercase CAF tags in all six configs.

##### 14 in `discovery`

Lowercase CAF tags in all six configs; its provenance tags on the subscription are mixed case.

##### 14 in `expedition`

Lowercase CAF tags in all six configs.

##### 14 status

Partly realised — the CAF tags are lowercase; a casing check with the tag schema, and lowercase provenance-tag keys, are planned
(follow-up).

### 15 — Tag the region

```text
CAF naming and tagging — Define your tagging strategy — recommendation 15 (Implement consistent tagging: region tags)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Add a tag naming the region, for reporting and compliance across regions.
```

#### What 15 means here

Each environment maps to one region in `azure.yml` (`region`, `region_code`), the region code is a component of every name
([ADR-AZ-NAMING#3](../azure-naming-standard.md#rule-adr-az-naming3)), and the allowed-locations policy keeps each landing zone's resources
in its region ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)). A region tag would repeat what the name and the resource's own location
state. A repository that spans regions within one environment would need the region modelled first, and would then add the tag.

##### 15 in `foundation`

No region tag; `weu` in every name.

##### 15 in `discovery`

No region tag; `weu` in every name, and the allowed-locations assignment holds the region.

##### 15 in `expedition`

No region tag; `weu` in every name.

##### 15 status

Not adopted, because the region is a name component and a policy-held fact of each landing zone.

### 16 — Tag only what supports tags

```text
CAF naming and tagging — Define your tagging strategy — recommendation 16 (Implement consistent tagging: services that support tags)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Not every resource type takes tags; check Microsoft's support list.
```

#### What 16 means here

Each shared module in `infrastructure/modules/` takes a `tags` parameter exactly when its resource type supports tags: the resource group,
virtual network, network security group, route table, private DNS zone and its links, private endpoint, storage account, SQL server and
database, Key Vault, and Log Analytics workspace. The peering, subnet, policy assignment, budget, and diagnostic setting modules take none.
The built-in policy that requires a tag ignores types that cannot carry one, so it never denies a peering or a budget.

##### 16 in `foundation`

Both resources take tags and get them.

##### 16 in `discovery`

Every taggable resource gets the CAF tags; the peerings, policy assignments, budget, and diagnostic settings carry none.

##### 16 in `expedition`

Every taggable resource gets the CAF tags; the diagnostic settings carry none. Its resource group, created by `Deploy-AzureResourceGroup`
before the deploy, carries only the provenance tags (item 21).

##### 16 status

Realised — tags go to every type the templates deploy that takes them.

### 17 — Functional tags

```text
CAF naming and tagging — Define your tagging strategy — recommendation 17 (Use foundational tagging categories: functional)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Functional tags describe a resource's technical role: its application, tier, environment, and region, for example an app,
  tier, environment, region, or repository tag.
```

#### What 17 means here

`workload` and `environment` are the repository's functional tags; they match CAF's application and environment examples. A tier tag is not
used, because each example template is one tier (the landing zone, the baseline, the data workload), and `workload` names it. A region tag
is item 15. A repository tag is covered by the provenance tags, which name the commit, the build, and the branch of the deploy.

The `environment` value is the environment class of the subscription for the per-subscription templates (`nonprod`, `prod`) and the standard
environment for `expedition` (`dev`, `test`, `prod`).

##### 17 in `foundation`

`workload: foundation`, `environment: nonprod` or `prod`.

##### 17 in `discovery`

`workload: landing-zone`, `environment: nonprod` or `prod`.

##### 17 in `expedition`

`workload: expedition`, `environment: dev`, `test`, or `prod`.

##### 17 status

Realised — `workload` and `environment`; tier and repository tags are not adopted, for the reasons above.

### 18 — Classification tags

```text
CAF naming and tagging — Define your tagging strategy — recommendation 18 (Use foundational tagging categories: classification)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Classification tags record sensitivity, compliance, and service level, for example criticality, confidentiality, and SLA
  tags.
```

#### What 18 means here

`criticality` (`low`, `medium`, `high`) and `data-classification` (`internal`, `confidential`) are the repository's classification tags,
matching CAF's criticality and confidentiality examples. `data-classification` is the record of the data's sensitivity
([ADR-AZ-WAFSE#3](../waf/security.md#rule-adr-az-wafse3)). No service-level tag is set, because no example workload declares a service
level. The allowed values of both tags are a convention, checked by nothing until the planned tag schema (item 11).

##### 18 in `foundation`

`criticality: high` for the shared platform and each production subscription, `medium` for customer non-production;
`data-classification: internal` for the platform, `confidential` for customers.

##### 18 in `discovery`

The same values as `foundation` for the same subscriptions.

##### 18 in `expedition`

`criticality: low` outside production and `high` in production; `data-classification` as above.

##### 18 status

Realised — criticality and data classification; a service-level tag is not adopted.

### 19 — Accounting tags

```text
CAF naming and tagging — Define your tagging strategy — recommendation 19 (Use foundational tagging categories: accounting)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Accounting tags attribute cost to organisational units and projects for chargeback, showback, budgets, and alerts, for
  example department, program, business centre, budget, and cost centre tags.
```

#### What 19 means here

`cost-center` is the repository's accounting tag and its one mandatory key ([ADR-AZ-CAFNAME#12](#rule-adr-az-cafname12)); it names the
customer or `platform`, so a subscription's spend groups by the customer that pays for it
([ADR-AZ-WAFCO#3](../waf/cost-optimization.md#rule-adr-az-wafco3)). Department and program tags are not used, because the customer is the
unit of cost. A budget tag is not used, because the budget is a resource: each landing zone deploys one per subscription, with its amount in
config.

##### 19 in `foundation`

`cost-center` equals `owner` in every config (`platform`, `apex`, `nova`, `flux`).

##### 19 in `discovery`

The same, beside the budget it deploys (`budgetAmount` in each config).

##### 19 in `expedition`

The same, per configuration slot.

##### 19 status

Realised — one cost-centre tag, required by policy.

### 20 — Purpose tags

```text
CAF naming and tagging — Define your tagging strategy — recommendation 20 (Use foundational tagging categories: purpose)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Purpose tags link a resource to the business process it serves and its business and revenue impact.
```

#### What 20 means here

The example workloads model no business process, so there is nothing true to write in a purpose tag; `criticality` (item 18) is the closest
fact they carry. A workload that serves a named business process adds its purpose tags in its own configs, and the planned tag schema
(item 11) would list them as optional keys.

##### 20 in `foundation`

Not applicable: a platform baseline serves every workload of its subscription.

##### 20 in `discovery`

Not applicable: a landing zone serves every workload of its subscription.

##### 20 in `expedition`

Not applicable: the example workload has no business process behind it.

##### 20 status

Not adopted, because the examples serve no business process.

### 21 — Ownership tags

```text
CAF naming and tagging — Define your tagging strategy — recommendation 21 (Use foundational tagging categories: ownership)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Ownership tags name the business unit and the operations team responsible for a resource.
```

#### What 21 means here

`owner` is the repository's ownership tag: one key for both of CAF's examples, because the customer that owns a subscription is also the
party accountable for running it, and the shared platform is owned by `platform`. Budget alerts go to the subscription's `Owner` role, not
to the tag ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)), so the tag records accountability and the role carries the notification.

The resource groups that `Deploy-AzureResourceGroup` creates for `foundation` and `expedition` carry only the provenance tags, so the
ownership of those resource groups is read from their resources. Passing the CAF tags to the resource group it creates is planned.

##### 21 in `foundation`

`owner: platform` or the customer key, on both resources; its resource group carries no CAF tags.

##### 21 in `discovery`

`owner` on every taggable resource and on the resource group, which the template creates itself with the CAF tags.

##### 21 in `expedition`

`owner` on every taggable resource; its resource group carries no CAF tags.

##### 21 status

Partly realised — `owner` is on every resource; the CAF tags on the resource groups of `foundation` and `expedition` are planned
(follow-up).

### 22 — Tag workloads for Microsoft assessments

```text
CAF naming and tagging — Define your tagging strategy — recommendation 22 (Use tags to support Microsoft assessments)
Source: https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging (retrieved 2026-10-15)
Summary (ours): Tag workloads so that Microsoft's assessment tooling can find them, following its guidance on labelling mission-critical
  workloads.
```

#### What 22 means here

No Microsoft workload assessment runs against the repository's subscriptions, so no tag is set for one. The `workload` and `criticality`
tags name each workload and its importance; an organisation that runs such an assessment maps them to the labels it expects, in the tag
schema of item 11.

##### 22 status

Not adopted, because no Microsoft assessment runs against these subscriptions.

## Decision

The repository's naming standard agrees with CAF on what a name is for and on the type tokens, and differs from it deliberately in three
places: the environment comes first and the type last, the instance number is an optional special slot, and organisation, customer, and role
are components of their own. The two types CAF does not abbreviate take `budg` and `pa`, and subnets keep the network plan's names. The CAF
tags cover CAF's functional, classification, accounting, and ownership categories with six lowercase keys, `cost-center` required by policy;
purpose, region, tier, and service-level tags are not adopted, each for its stated reason. The planned work closes the gaps: a tag schema
declared once and checked, a name check over the template configs, the CAF tags on every resource group, and lowercase provenance tag keys.

### How this is enforced

- `Get-AzureResourceName` validates every component case-sensitively, checks the type against `Get-AzureResourceTypeSet`, and throws when a
  render exceeds its type's limit; `Get-AzureResourceName.Content.Tests.ps1` covers its renders and its errors.
- `Get-BicepResourceGroupName` derives the resource group of every template deployed into a resource group, and the integrity test checks
  that `short_name` is unique across the shipped templates.
- The landing zone's required-tag policy denies a resource without `cost-center` where `policy_enforcement` enforces, and reports it where
  it audits ([ADR-AZ-LZ#3](../landing-zones.md#rule-adr-az-lz3)).
- `ci-infrastructure.yaml` runs `Assert-BicepTemplate` and `Build-Bicep` for every template, and the parameter-model test checks each
  rendered parameters file against the compiled template ([ADR-AZ-DATAMOD#9](../azure-data-model.md#rule-adr-az-datamod9)), so a config
  without its `tags` object fails the build.
- Planned (follow-up), not existing: a tag schema declared once and checked against every template config (keys, allowed values, lowercase);
  a check that every name in a template config equals `Get-BicepResourceName`'s render; the other CAF keys required by policy.

## Consequences

- A reader who knows CAF recognises every type token; the order and the components differ for stated reasons, and the `classic` variant
  gives the CAF shape to a repository that wants it.
- Names sort by environment, and global names never collide between repositories with different organisation codes.
- A changeable fact is a tag edit, never a rename.
- Until the name check exists, a mistyped name in a config surfaces only when Azure rejects it or when someone reads it.
- Until the tag schema exists, five of the six CAF tags are kept by convention alone, in eighteen hand-written copies.
- The resource groups of `foundation` and `expedition` carry no CAF tags until the resource-group creation passes them.
