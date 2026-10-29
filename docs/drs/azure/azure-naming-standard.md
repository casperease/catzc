# Azure: Azure resource naming standard

<!-- cspell:ignore weuwkspvm prweufindiscaphotst weufindiscxaphotst weudiscvm etlco -->

Pairs with [`data-model`](azure-data-model.md), which defines how these components are sourced and assembled.

## Rules: ADR-AZ-NAMING

### Rule ADR-AZ-NAMING-DETERMINISTICNAMES

Every Azure name is written in full in the slot config that deploys it and matched against the one canonical form: the render of one
canonical component set — no random suffixes or hashes — hyphenated for relaxed types, concatenated for tight types. The match renders
candidates from the known component sets through the one renderer, so a name is never parsed; the leftover is the role, the only free part.

- [Components](#components)
- [Declared names, matched](#declared-names-matched)

### Rule ADR-AZ-NAMING-TWOTEMPLATEIDENTIFIERS

Each template carries two identifiers: a readable kebab-case folder name and a 2–5 char `short_name`. `short_name` is **derived** from the
folder name (first 5 `[a-z0-9]`, hyphens dropped) by `BicepShortName`, and **optionally overridden** in the template's `options.yml`. All
Azure-facing identifiers use `short_name`, never the folder name.

- [Two identifiers per template](#two-identifiers-per-template)

### Rule ADR-AZ-NAMING-ENVIRONMENTFIRST

Environment is the first segment (env-first sort); env and customer each render readable (name/key) in generous patterns and as a 2-char
shortcode in the restricted `kv`/`storage`/`vm` patterns.

- [Components](#components)

### Rule ADR-AZ-NAMING-PATTERNPERRESOURCETYPE

Each resource type ties to one render/constraint pattern (`long`/`kv`/`storage`/`vm`) from the type registry, which fixes the separator, the
length budget, and which env/customer form is used.

- [Ordering & render forms](#ordering--render-forms)

### Rule ADR-AZ-NAMING-ORDERISVARIANT

Component order is the `naming` repo variant (`Get-Naming`, default `standard`), not a per-name argument: a preset (`standard`, `classic`)
or an explicit list of segments, holding every component exactly once and `type` among them. It is the one naming order, for resource and
service-connection names alike; changing it changes the canonical form every declared name is matched against.

- [Ordering & render forms](#ordering--render-forms)

### Rule ADR-AZ-NAMING-LOWERCASECOMPONENTS

All components are lowercase with case-sensitive validation; `org`, `short_name`, `role`, env `name`, and customer `key` must start with a
letter — only `slot` may be all-digit.

- [Character & case rules](#character--case-rules)

### Rule ADR-AZ-NAMING-NEVERTRUNCATE

Never truncate to fit — the namer computes the render and throws at deploy time if it exceeds the type's limit, listing the components that
can be shortened (silent truncation collides on globally-unique types).

- [Length budget](#length-budget)

### Rule ADR-AZ-NAMING-SUBSCRIPTIONNOTCOMPONENT

The subscription is a resolution axis only and is never a name component; the customer that renders is derived from it
(`subscription.customer`).

- [Components](#components)

### Rule ADR-AZ-NAMING-CAFALIGNMENT

The standard follows the CAF naming convention in substance and differs from it in four places on purpose. A name holds only stable facts;
the component set is environment, slot, region, organisation, template `short_name`, customer, role, and type, with the template standing
for CAF's workload and the slot for its instance number; the order puts the environment first and the type last; and the type tokens equal
CAF's abbreviations. Names are written in the slot configs and matched against the canonical form `Get-AzureResourceName` renders, not taken
from Microsoft's naming tool, and hold codes chosen in config, never a person's name or a secret.

- [CAF alignment](#caf-alignment)

### Rule ADR-AZ-NAMING-EXCEPTIONENTRY

A parameter keeps a name off the canonical form only with a `naming_exception: <reason>` entry beside its `value`
([PDR-CONFIG-EXCEPTIONISCONFIGENTRY](../principles/configure-not-program.md#rule-pdr-config-exceptionisconfigentry)). The name gate counts
and lists every exception, and the build drops the entry from the rendered parameters.

- [Declared names, matched](#declared-names-matched)

## Context

The binding constraint is the **storage account**: 3–24 chars, lowercase letters and digits only, globally unique, so a storage name's
components hold **no hyphen** or uppercase and the name stays ≤ 24. Relaxed types (resource group ≤ 90, most others) never bind.

Two goals shape the standard:

- **Env-first sort.** The environment is the first segment, so listing resources alphabetically groups them by environment.
- **Readable where humans look, tight where bytes bind.** Environments carry a readable **name** (`develop`, `preprod`) used in config
  files, deploy args, and relaxed resource names, plus a 2-char **shortcode** (`de`, `pp`) used only in the restricted (tight-budget)
  patterns — so a long, clear name never costs a storage/vm name a byte. **Customers carry the identical split** — a readable **key**
  (`apex`) for generous names + a 2-char **shortcode** (`ap`) for restricted ones — for the same reason. Likewise template _folders_ are
  readable labels; a separate `short_name` carries their Azure identity.

## Decision

```yml drawio
description:
  An Azure resource name is assembled from eight components in a fixed order; the type's pattern picks the form and the limit, a render past
  the limit throws at deploy time and is never truncated, and three worked examples show the names that come out.
about:
  rules: [ADR-AZ-NAMING]
  lens: implementation
content:
  title: How an Azure name is assembled
  kind: reference
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-components, label: COMPONENTS IN STANDARD ORDER }
    - { id: band-render, label: RENDER BY THE TYPE'S PATTERN }
    - { id: band-names, label: "EXAMPLES: prod fin weu apex" }
  groups:
    - { id: grp-name, label: Resource Name, in: band-components }
    - { id: grp-resource-groups, label: Resource Groups, in: band-names }
    - { id: grp-storage, label: Storage, in: band-names }
    - { id: grp-virtual-machine, label: Virtual Machine, in: band-names }
  glyphs:
    - { id: c-env, kind: set, label: 1 env, in: grp-name }
    - { id: c-slot, kind: set, label: 2 slot (optional), in: grp-name }
    - { id: c-region, kind: set, label: 3 region, in: grp-name }
    - { id: c-org, kind: set, label: 4 org, in: grp-name }
    - { id: c-short-name, kind: set, label: 5 short_name, in: grp-name }
    - { id: c-customer, kind: set, label: 6 customer, in: grp-name }
    - { id: c-role, kind: set, label: 7 role (optional), in: grp-name }
    - { id: c-type, kind: set, label: 8 type, in: grp-name }
    - { id: g-pattern, kind: code, label: pattern of the type, in: band-render }
    - { id: g-limit, kind: gate, label: "fits the limit?", in: band-render }
    - { id: f-throws, kind: failure, label: "throws at deploy time, never truncated", in: band-render }
    - { id: r-name, kind: result, label: deterministic name, in: band-render }
    - { id: n-rg-base, kind: result, label: prod-weu-fin-disc-rg, in: grp-resource-groups }
    - { id: n-rg-slot, kind: result, label: prod-001-weu-fin-edge-waf, in: grp-resource-groups }
    - { id: n-rg-customer, kind: result, label: prod-weu-fin-disc-apex-rg, in: grp-resource-groups }
    - { id: n-storage-base, kind: result, label: prweufindiscaphotst (19), in: grp-storage }
    - { id: n-storage-slot, kind: result, label: pr001weufindiscxaphotst (23), in: grp-storage }
    - { id: n-vm, kind: result, label: pr001weudiscvm (14), in: grp-virtual-machine }
  edges:
    - { from: g-pattern, to: grp-name, kind: flow, label: reads }
    - { from: g-pattern, to: g-limit, kind: flow, label: "" }
    - { from: g-limit, to: r-name, kind: flow, label: fits }
    - { from: g-limit, to: f-throws, kind: fail, label: exceeds }
    - { from: r-name, to: grp-resource-groups, kind: flow, label: "" }
    - { from: r-name, to: grp-storage, kind: flow, label: "" }
    - { from: r-name, to: grp-virtual-machine, kind: flow, label: "" }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-components: { x: 20, y: 84, w: 1260, h: 150 }
  band-render: { x: 20, y: 254, w: 1260, h: 190 }
  band-names: { x: 20, y: 464, w: 1260, h: 260 }
  grp-name: { x: 30, y: 120, w: 1240, h: 104 }
  c-env: { x: 56, y: 164, w: 124, h: 44 }
  c-slot: { x: 208, y: 164, w: 124, h: 44 }
  c-region: { x: 360, y: 164, w: 124, h: 44 }
  c-org: { x: 512, y: 164, w: 124, h: 44 }
  c-short-name: { x: 664, y: 164, w: 124, h: 44 }
  c-customer: { x: 816, y: 164, w: 124, h: 44 }
  c-role: { x: 968, y: 164, w: 124, h: 44 }
  c-type: { x: 1120, y: 164, w: 124, h: 44 }
  g-pattern: { x: 550, y: 290, w: 200, h: 44 }
  g-limit: { x: 800, y: 278, w: 110, h: 68 }
  f-throws: { x: 950, y: 290, w: 290, h: 44 }
  r-name: { x: 390, y: 390, w: 760, h: 44 }
  grp-resource-groups: { x: 40, y: 504, w: 390, h: 204 }
  grp-storage: { x: 455, y: 504, w: 390, h: 204 }
  grp-virtual-machine: { x: 870, y: 504, w: 390, h: 204 }
  n-rg-base: { x: 60, y: 544, w: 350, h: 44 }
  n-rg-slot: { x: 60, y: 598, w: 350, h: 44 }
  n-rg-customer: { x: 60, y: 652, w: 350, h: 44 }
  n-storage-base: { x: 475, y: 544, w: 350, h: 44 }
  n-storage-slot: { x: 475, y: 598, w: 350, h: 44 }
  n-vm: { x: 890, y: 544, w: 350, h: 44 }
```

![How an Azure name is assembled](.assets/azure-name-assembly.drawio.png)

### Two identifiers per template

| Identifier       | Where                                                                   | Form                              | Purpose                                                             |
| ---------------- | ----------------------------------------------------------------------- | --------------------------------- | ------------------------------------------------------------------- |
| **folder name**  | `infrastructure/templates/<folder>/`                                    | kebab-case, e.g. `discovery`      | Human label + discovery key + repo navigation. Not an Azure id.     |
| **`short_name`** | **derived** from `<folder>`; optional `options.yml` override (**opt.**) | 2–5 lowercase-alnum, e.g. `disco` | The Azure identifier segment. Globally unique across all templates. |

`short_name` is **derived** from the folder name — lowercase, keep only `[a-z0-9]` (hyphens/punctuation dropped), take the first 5 chars
(`discovery` → `disco`, `my-template` → `mytem`) — by `Catzc.Azure.Templates.BicepShortName`. A template MAY override it with an explicit
`short_name` in its **optional** `options.yml`; `options.yml` is not required for identity. `BicepShortName` validates both forms
(`^[a-z][a-z0-9]{1,4}$`): a malformed override, or a folder that cannot derive ≥2 valid chars without an override, throws at discovery. All
Azure-facing identifiers (resource names, tracking-tag prefixes, deployment names) use `short_name`, never the folder name.

### Components

| #   | Component    | Req | Len | Charset                                      | Source                                                                                                                                                                                                                                                                                                                       |
| --- | ------------ | --- | --- | -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | `env`        | ✔   | 2+  | name `[a-z][a-z0-9]+` / shortcode `[a-z]{2}` | The environment's identity; first segment → env-grouped sort. **Pattern-chosen render:** generous (`long`) patterns use the readable **name** (`develop`, `prod`); restricted (`kv`/`storage`/`vm`) patterns use the 2-char **shortcode** (`de`, `pr`). From `azure.yml`.                                                    |
| 2   | `slot`       | ✖   | 1–3 | `[a-z0-9]`                                   | Optional special-deployment discriminator **within** an environment (ordinal `001`, blue-green, spoke). A **separate segment** beside `env` (hyphen-joined in relaxed, concatenated in tight). Deploy-time input (`-Slot`); omitted ⇒ the base / index-0 slot.                                                               |
| 3   | `region`     | ✔   | 3   | `[a-z]{3}`                                   | Azure region code (`weu`, `neu`, `eus`). From `azure.yml` env `region_code`.                                                                                                                                                                                                                                                 |
| 4   | `org`        | ✔   | 2–3 | `[a-z][a-z0-9]{1,2}`                         | Vertical / organization. Global, one per repo (`azure.yml`).                                                                                                                                                                                                                                                                 |
| 5   | `short_name` | ✔   | 2–5 | `[a-z][a-z0-9]{1,4}`                         | Template id segment. **Derived** from the template folder name (first 5 `[a-z0-9]`, `BicepShortName`); optional `options.yml` override. Globally unique.                                                                                                                                                                     |
| 6   | `customer`   | ✖   | 2+  | key `[a-z][a-z0-9]+` / shortcode `[a-z]{2}`  | Customer / sub-tenant. **Pattern-chosen render** (like `env`): generous (`long`) patterns use the readable **key** (`apex`); restricted (`kv`/`storage`/`vm`) patterns use the 2-char **shortcode** (`ap`). **Derived** from the deploy's subscription (`subscription.customer` in `azure.yml`), not a deploy arg; optional. |
| 7   | `role`       | ✖   | 2–3 | `[a-z][a-z0-9]{1,2}`                         | **Within a slot**, the sibling discriminator among same-type resources (`hot`/`cool`/`arc`). Bicep author, per resource.                                                                                                                                                                                                     |
| 8   | `type`       | ✔   | 2–5 | `[a-z]{2,5}`                                 | Resource-type abbreviation (`rg`, `st`, `kv`, `sqldb`). The resource being named. Each type ties to a render pattern (`Get-AzureNamePatternSet`); the 5-char form is only for the `long` pattern — the restricted `kv` (≤24), `storage` (concatenated ≤24) and `vm` (≤15) patterns keep a 2–4 char abbreviation.             |

**Three discriminator axes, kept distinct:**

- `slot` = _which deployment of the template_ in this env (horizontal; same for every resource in one deployment; deploy-time `-Slot`,
  omitted ⇒ base slot).
- `region` = _where_ — its own field, so multi-region slots differ automatically without consuming `slot`.
- `role` = _which sibling within one slot_ among same-type resources (vertical).

### Ordering & render forms

Each resource type ties to one of **four render/constraint patterns**, declared beside the types in
`pwsh/Azure.Templates/configs/resource-types.yml` (read by `Get-AzureNamePatternSet`; a type names its pattern, `long` when it names none):

A pattern fixes the **render separator** and the **length budget**; it also selects the **env form**:

- **`long`** (RG ≤ 90, SQL, most) — hyphen-separated, generous (per-type limit). Uses the env **name**.
- **`kv`** (key vault = 24) — hyphen-separated like `long`, but length-restricted to 24. Uses the **shortcode** (it is restricted-budget, so
  it takes the short env form even though it is hyphenated).
- **`storage`** (storage account = 24, lowercase-alnum, no hyphens) — concatenated. Uses the **shortcode**.
- **`vm`** — the same concatenated render as `storage`, capped at **15** (the Windows computer-name limit). Uses the **shortcode**.

The **`customer`** segment follows the same env-form selection: the readable **key** in `long`, the 2-char **shortcode** in
`kv`/`storage`/`vm`.

`env` and `slot` are **separate segments** — joined by the render separator (a hyphen in relaxed, nothing in tight); the `slot` segment is
dropped when empty. So:

```text
relaxed (long):   <env>-<slot>-<region>-<org>-<short_name>[-<customer>][-<role>]-<type>
tight (storage):  <env><slot><region><org><short_name>[<customer>][<role>]<type>
```

One config file ⟷ one slot ⟷ one resource group. Sort key is `env`, then `slot`, then `region`.

**Component order is the `naming` repo variant**: `Get-Naming` (default `standard`) returns the order, which the variant holds as a preset
name or as an explicit list of segments; the variant lives in `variants.yml`, and a consumer overlays it from `.catzc/`
([ADR-AUTO-OVERLAY-CONFIGFRAGMENT](../automation/consumer-overlay.md#rule-adr-auto-overlay-configfragment)). `VariantsConfig` rejects a list
that misses a component, repeats one, or lacks `type`. An order is pure data — an ordered list of _segments_ — so the one renderer
(`Get-AzureResourceName`) and the matcher are order-agnostic. Two presets ship:

- `standard` — `<env>-<slot>-<region>-<org>-<short_name>[-<customer>][-<role>]-<type>` (env/slot first, type last).
- `classic` — `<type>-<org>-<short_name>[-<customer>]-<env>-<region>[-<slot>][-<role>]` (type first, CAF-style, slot trailing).

The same order spells the service-connection names, so a repository has one naming order.

### Length budget

Restricted patterns use the 2-char **shortcode** for _both_ `env` and `customer`, so the tight budget is independent of how long the
readable `name` / customer `key` is. `short_name` is capped at **5**; the worst-case tight name is:

```text
env_sc(2) + slot(3) + region(3) + org(3) + short_name(5) + cust_sc(2) + role(3) + type(2) = 23
```

So the full-house corner (slot + customer + role together) **fits** the 24-char storage limit at 23, with a byte to spare. (The 2-char
customer shortcode is what buys this — a 4-char customer code would push the same name to 25.) The other restricted patterns: `kv`
(hyphenated, 24) carries a customer comfortably (~22) but cannot also take the slot + role segments at `short_name`=5. The **`vm`** pattern
(15) **omits** `org`, `customer`, and `role` (the resource group already encodes them), so it renders
`<env_sc>[<slot>]<region><short_name>vm` — e.g. `de001weuwkspvm` (14) — and fits 15 even with a slot. A customer therefore never appears in
a VM name. An over-limit render throws at deploy time and is never truncated (ADR-AZ-NAMING-NEVERTRUNCATE).

### Character & case rules

- All components lowercase. Validation is **case-sensitive** — `Get-AzureResourceName` checks every component with the case-sensitive
  `-cnotmatch` operator (PowerShell's default `-match`/`-notmatch` is case-insensitive), so the patterns themselves carry no `(?-i)` prefix.
- `org`, `short_name`, `role`, env `name`, customer `key` **start with a letter** (Key Vault and others reject leading digits). Only `slot`
  may be all-digit. Each component's pattern is the charset of [Components](#components); a `type` is also guarded by membership in the type
  registry.

### Resource-type registry

`pwsh/Azure.Templates/configs/resource-types.yml` is the one registry of each type's abbreviation, render **pattern**, length, and any
**omitted** components, typed by `ResourceTypesConfig` and read through `Get-AzureResourceTypeSet`. A type line holds only what differs from
the defaults declared once on the type, pattern `long` and charset `[a-z0-9-]`
([PDR-CONFIG-DEFAULTDECLAREDONCE](../principles/configure-not-program.md#rule-pdr-config-defaultdeclaredonce)); its key is the ident itself,
and the readable name is the line's comment. `long`-pattern types carry their own per-type `limit` (the Azure max for that type);
`kv`/`storage`/`vm` take their cap from the pattern (24/24/15) and declare no `limit`. A type may also declare `omit`, components it drops
from its render because they are encoded elsewhere (only `vm` does so, dropping org/customer/role). A new type is a line in the config. The
registry declares no range within which a name must be unique, because a deterministic name differs wherever its components differ.

Every registered type accepts the characters a render can produce. The `long` render is lowercase letters, digits, and hyphens, starting
with a letter and ending with a letter or digit, which the most restrictive types (the budget: letters, digits, underscores, and hyphens;
the network types: start with a letter or digit, end with a letter, digit, or underscore) all allow. So a type carries its length, and a
`charset` only where it narrows the default (the storage account, letters and digits only). The budget abbreviation is `budg` because a
`type` is at most 5 letters. A policy assignment at the management-group level would be capped at 24; the templates assign policies at the
subscription only, so `pa` carries the subscription limit, 64.

### CAF alignment

A name holds only facts that never change for the resource, because most names cannot change once the resource exists: environment,
configuration slot, region, organisation, template, customer, role, and type. Owner, cost centre, criticality, and data classification live
in the CAF tags ([ADR-AZ-LZ-CAFTAGS](landing-zones.md#rule-adr-az-lz-caftags)).

The type registry carries each type's length limit and the render pattern its characters, and an over-limit name throws
([ADR-AZ-NAMING-NEVERTRUNCATE](#rule-adr-az-naming-nevertruncate)). A deterministic name differs wherever its components differ, and every
globally unique type carries the organisation and the template; an external collision fails the deploy and is fixed by another special slot
or `short_name`, never by a random suffix. The names written in the template configs are matched against the canonical form, so a drift from
the render fails the name gate before any deploy ([ADR-AZ-NAMING-DETERMINISTICNAMES](#rule-adr-az-naming-deterministicnames)).

The component order is fixed repository-wide by the `naming` variant, and its default puts the environment first and the type last, unlike
CAF's type-first examples, which the `classic` order reproduces. Hyphens appear where the type allows them, with no delimiter in the
`storage` and `vm` patterns, chosen per type by its render pattern. Every type token in `resource-types.yml` that CAF lists equals CAF's
abbreviation; the alert rule takes the spelled-out `alert`, one token for the metric, activity-log and scheduled-query kinds, which a role
tells apart; the three other types CAF does not list take `budg` (budget), `pa` (policy assignment) and `wb` (workbook, whose resource name
Azure requires to be a GUID, so the namer derives its display name and the GUID derives from that), and a private DNS zone keeps the name
Azure requires. Subnets keep the names of the network plan instead of an `snet` name, and every type in CAF's examples that the templates
deploy is named by the standard, type last and with no instance counter.

Each shipped template pins its `short_name` in its `options.yml` (`fnd` for `foundation`, `disco` for `discovery`, `exped` for
`expedition`), so renaming a folder never re-spells a resource, and the integrity test checks that `short_name` is unique across the shipped
templates. The subnets of a spoke are named by the keys of the network plan in `network.yml` (`shared-services`, `private-endpoints`, one
per environment), plus the names Azure fixes for `GatewaySubnet` and `AzureFirewallSubnet`, because a subnet's name is unique only in its
virtual network and the landing zone reads the subnet map by config address
([ADR-AZ-DATAMOD-VALUEBYADDRESS](azure-data-model.md#rule-adr-az-datamod-valuebyaddress)). Management groups and subscriptions are named by
no template: `azure.yml` keys its subscriptions, and their display names are the tenant's. Budget alerts go to the subscription's `Owner`
role, so no address appears in a name or a config.

### Declared names, matched

`Every name is written where it deploys and checked against the canonical form`

A slot config spells every name it deploys in full, so a reader of the slot sees what lands in Azure, and the consumer's `options.yml` holds
no naming rule. A canonical name describes itself: it carries the environment, slot, region, organisation, template `short_name`, customer,
role and type, so the consumer declares nothing per name beside it.

**Which values are names.** Every string leaf, at any depth, under a slot parameter whose key ends in `Name` or `Names`; the slot's
top-level `ResourceGroup` key ([ADR-AZ-DATAMOD-DECLAREDGROUPNAME][r1]);
and the `resourceGroups/<x>` and resource-name segments of an Azure resource ID anywhere in the slot. The key suffix decides, never a trace
through the bicep, because a name reaches a template through `scope:`, string interpolation and display names alike; with the suffix rule a
wrong type ident cannot slip through, since every such value either matches or fails.

**Matched, not parsed.** The `storage` and `vm` renders join their parts with no separator, and org, `short_name`, role and slot vary in
length, so splitting a name is ambiguous. Every part except the role comes from a small known set: the environments (`azure.yml`), the
customers (`customer.yml`), the `short_name` of every template, the slots of every slot file, the type abbreviations and the one org. The
matcher renders the candidates through the one renderer under the configured order and takes the leftover as the role, which must match
`^[a-z][a-z0-9]{1,2}$` ([ADR-AZ-NAMING-LOWERCASECOMPONENTS](#rule-adr-az-naming-lowercasecomponents)). Exactly one match returns the
components; no match fails with a diagnosis per part; more than one fails as ambiguous, in practice a `short_name` collision the integrity
test blocks first.

**Own and foreign names.** A name's environment, customer and slot equal those of its file, and its `short_name` that of its template, or
the name belongs to another template: a name owned by another template is written in full with that template's `short_name`, and the gate
checks that the owner has a slot at those coordinates. Lists and objects of names are plain nested yml (a hub's `spokes` items, a
`policyAssignmentNames` map). The NSG names are a coverage check: the keys of `networkSecurityGroupNames` equal the subscription's subnets
in `network.yml` minus its `no_nsg_subnets`.

**The one computed case.** An ephemeral slot has no file
([ADR-AZ-DATAMOD-EPHEMERALSLOT](azure-data-model.md#rule-adr-az-datamod-ephemeralslot)), so the build matches each declared name of the base
slot and re-renders the template's own names with the runtime slot; a foreign name stays as written.

`Test-BicepResourceNames` is the gate: it reports the names checked, the exceptions
([ADR-AZ-NAMING-EXCEPTIONENTRY](#rule-adr-az-naming-exceptionentry)) and the foreign names. `Get-AzureResourceName` validates every
component case-sensitively, checks the type against the registry, and throws on an over-limit render.

### Worked examples

Env `prod` (shortcode `pr`), org `fin`, region `weu`:

Per-customer rows use customer `apex` (shortcode `ap`):

| Scenario                                 | Relaxed (name / key)                                     | Tight (shortcode)                                                                  |
| ---------------------------------------- | -------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| Prod discovery RG, base slot             | `prod-weu-fin-disc-rg`                                   | —                                                                                  |
| WAF in two slots of prod                 | `prod-001-weu-fin-edge-waf`, `prod-002-weu-fin-edge-waf` | —                                                                                  |
| Per-customer RG, base slot               | `prod-weu-fin-disc-apex-rg` (readable key)               | —                                                                                  |
| Per-customer hot storage, base slot      | —                                                        | `prweufindiscaphotst` (19, customer shortcode `ap`)                                |
| Storage, slot + customer + role, short5  | —                                                        | `pr001weufindiscxaphotst` (**23 — fits**, thanks to the 2-char customer shortcode) |
| VM, slot 001 (org/customer/role omitted) | —                                                        | `pr001weudiscvm` (14 — `vm` drops org/customer/role)                               |

## Consequences

- Folders stay readable (`discovery`); `short_name` (2–5) carries Azure identity — no readability tax.
- `short_name` is the Azure id. By default it is **derived** from the folder, so a new template needs no `options.yml` to get a valid id —
  but renaming the folder then changes the derived `short_name`, and every declared name of the template fails the match until it is
  re-spelled. Pin the id against folder churn by setting an explicit `short_name` override in `options.yml` (the derivation and the override
  are the same one-invariant `BicepShortName`).
- The restricted patterns use the 2-char shortcode for **both env and customer**, so readable env names and customer keys cost nothing in
  tight names; the full-house corner (slot + customer + role) fits storage at 23 ≤ 24. The deploy-time assert still guards any remaining
  over-limit render (e.g. a `kv` carrying customer + slot + role).
- Each environment maps to one region (region is an env attribute). Multi-region-per-environment would need env×region modeling and is out
  of scope.
- Deterministic-only means no entropy for globally-unique types; an external collision fails the deploy and is fixed by adjusting `slot` /
  `short_name` (no auto-hash).
- The **subscription** selects which subscription a deploy targets and never appears in a name; the **customer** that renders is derived
  from it (`subscription.customer`). See [`data-model`](azure-data-model.md).

[r1]: azure-data-model.md#rule-adr-az-datamod-declaredgroupname
