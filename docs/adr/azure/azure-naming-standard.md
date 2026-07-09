# ADR: Azure resource naming standard

<!-- cspell:ignore weuwkspvm prweufindiscaphotst weufindiscxaphotst weudiscvm etlco -->

Pairs with [`data-model`](azure-data-model.md), which defines how these components are sourced and assembled.

## Rules: ADR-NAMING

### Rule ADR-NAMING:1

Every Azure name is assembled deterministically from one canonical component set — no random suffixes or hashes — rendered two ways:
hyphenated for relaxed types, concatenated for tight types.

- [Components](#components)

### Rule ADR-NAMING:2

Each template carries two identifiers: a readable kebab-case folder name and a 2–5 char `short_name`. `short_name` is **derived** from the
folder name (first 5 `[a-z0-9]`, hyphens dropped) by `BicepShortName`, and **optionally overridden** in the template's `options.yml`. All
Azure-facing identifiers use `short_name`, never the folder name.

- [Two identifiers per template](#two-identifiers-per-template)

### Rule ADR-NAMING:3

Environment is the first segment (env-first sort); env and customer each render readable (name/key) in generous patterns and as a 2-char
shortcode in the restricted `kv`/`storage`/`vm` patterns.

- [Components](#components)

### Rule ADR-NAMING:4

Each resource type ties to one render/constraint pattern (`long`/`kv`/`storage`/`vm`) from the type registry, which fixes the separator, the
length budget, and which env/customer form is used.

- [Ordering & render forms](#ordering--render-forms)

### Rule ADR-NAMING:5

Component order is the `ado_naming` repo variant (`Get-AdoNaming`, default `standard`; see [repo-variants](../repository/repo-variants.md)),
not a per-name argument; changing it re-spells every derived name.

- [Ordering & render forms](#ordering--render-forms)

### Rule ADR-NAMING:6

All components are lowercase with case-sensitive validation; `org`, `short_name`, `role`, env `name`, and customer `key` must start with a
letter — only `slot` may be all-digit.

- [Character & case rules](#character--case-rules)

### Rule ADR-NAMING:7

Never truncate to fit — the namer computes the render and throws at deploy time if it exceeds the type's limit, naming which components to
shorten (silent truncation collides on globally-unique types).

- [Length budget](#length-budget)

### Rule ADR-NAMING:8

The subscription is a resolution axis only and is never a name component; the customer that renders is derived from it
(`subscription.customer`).

- [Component sourcing](#component-sourcing)

## Context

Every Azure resource name is assembled from one canonical component set, rendered two ways (hyphenated for relaxed types, concatenated for
tight types). Names are **deterministic** — no random suffixes or hashes.

The binding constraint is the **storage account**: 3–24 chars, lowercase letters + digits only, **no hyphens**, globally unique. Any
component that appears in a storage name cannot contain hyphens or uppercase, and the assembled name must stay ≤ 24. Relaxed types (resource
group ≤ 90, most others) never bind.

Two goals shape the standard:

- **Env-first sort.** The environment is the first segment, so listing resources alphabetically groups them by environment.
- **Readable where humans look, tight where bytes bind.** Environments carry a readable **name** (`develop`, `preprod`) used in config
  files, deploy args, and relaxed resource names, plus a 2-char **shortcode** (`de`, `pp`) used only in the restricted (tight-budget)
  patterns — so a long, clear name never costs a storage/vm name a byte. **Customers carry the identical split** — a readable **key**
  (`apex`) for generous names + a 2-char **shortcode** (`ap`) for restricted ones — for the same reason. Likewise template _folders_ are
  readable labels; a separate `short_name` carries their Azure identity.

## Decision

### Two identifiers per template

| Identifier       | Where                                                                   | Form                              | Purpose                                                             |
| ---------------- | ----------------------------------------------------------------------- | --------------------------------- | ------------------------------------------------------------------- |
| **folder name**  | `infrastructure/templates/<folder>/`                                    | kebab-case, e.g. `discovery`      | Human label + discovery key + repo navigation. Not an Azure id.     |
| **`short_name`** | **derived** from `<folder>`; optional `options.yml` override (**opt.**) | 2–5 lowercase-alnum, e.g. `disco` | The Azure identifier segment. Globally unique across all templates. |

`short_name` is **derived** from the folder name — lowercase, keep only `[a-z0-9]` (hyphens/punctuation dropped), take the first 5 chars
(`discovery` → `disco`, `my-template` → `mytem`) — by `Catzc.Azure.Templates.BicepShortName`. A template MAY override it with an explicit
`short_name` in its **optional** `options.yml`; `options.yml` is no longer required for identity. `BicepShortName` validates both forms
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
| 7   | `role`       | ✖   | 2–3 | `[a-z][a-z0-9]{1,2}`                         | **Intra-slot** sibling discriminator among same-type resources (`hot`/`cool`/`arc`). Bicep author, per resource.                                                                                                                                                                                                             |
| 8   | `type`       | ✔   | 2–5 | `[a-z]{2,5}`                                 | Resource-type abbreviation (`rg`, `st`, `kv`, `sqldb`). The resource being named. Each type ties to a render pattern (`Get-AzureNamePatternSet`); the 5-char form is only for the `long` pattern — the restricted `kv` (≤24), `storage` (concatenated ≤24) and `vm` (≤15) patterns keep a 2–4 char abbreviation.             |

**Three discriminator axes, kept distinct:**

- `slot` = _which deployment of the template_ in this env (horizontal; same for every resource in one deployment; deploy-time `-Slot`,
  omitted ⇒ base slot).
- `region` = _where_ — its own field, so multi-region slots differ automatically without consuming `slot`.
- `role` = _which sibling within one slot_ among same-type resources (vertical).

### Ordering & render forms

Each resource type ties to one of **three render/constraint patterns** (`Get-AzureNamePatternSet`; every type names its pattern in
`Get-AzureResourceTypeSet`):

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

**Component order is the `ado_naming` repo variant**: `Get-AdoNaming` (default `standard`) selects a named order from
`Get-AzureNameOrderSet`; the variant lives in `variants.yml` (see [repo-variants](../repository/repo-variants.md)). An order is pure data —
an ordered list of _segments_ — so the assembler (`Get-AzureResourceName`) is order-agnostic. Two ship:

- `standard` — `<env>-<slot>-<region>-<org>-<short_name>[-<customer>][-<role>]-<type>` (env/slot first, type last).
- `classic` — `<type>-<org>-<short_name>[-<customer>]-<env>-<region>[-<slot>][-<role>]` (type first, CAF-style, slot trailing).

### Length budget

Restricted patterns use the 2-char **shortcode** for _both_ `env` and `customer`, so the tight budget is independent of how long the
readable `name` / customer `key` is. `short_name` is capped at **5**; the worst-case tight name is:

```text
env_sc(2) + slot(3) + region(3) + org(3) + short_name(5) + cust_sc(2) + role(3) + type(2) = 23
```

So the full-house corner (slot + customer + role together) **fits** the 24-char storage limit at 23, with a byte to spare. (The 2-char
customer shortcode is what buys this — a 4-char customer code would push the same name to 25.) The other restricted patterns: `kv`
(hyphenated, 24) carries a customer comfortably (~22) but cannot also take slot + role at `short_name`=5. The **`vm`** pattern (15)
**omits** `org`, `customer`, and `role` (the resource group already encodes them), so it renders `<env_sc>[<slot>]<region><short_name>vm` —
e.g. `de001weuwkspvm` (14) — and fits 15 even with a slot. A customer therefore never appears in a VM name. The namer computes the render
and **throws at deploy time** if it exceeds the target type's limit, naming which components to shorten. Never truncate silently (truncation
collides on globally-unique types).

### Character & case rules

- All components lowercase. Validation is **case-sensitive** — `Get-AzureResourceName` checks every component with the case-sensitive
  `-cnotmatch` operator (PowerShell's default `-match`/`-notmatch` is case-insensitive), so the patterns themselves carry no `(?-i)` prefix.
- `org`, `short_name`, `role`, env `name`, customer `key` **start with a letter** (Key Vault and others reject leading digits). Only `slot`
  may be all-digit.
- Key regexes (matched with the case-sensitive `-cmatch`/`-cnotmatch`):
  - `type`: `^[a-z]{2,5}$` (2–5 letters; also gated by membership in the type registry)
  - `short_name`: `^[a-z][a-z0-9]{1,4}$` (2–5)
  - folder name: `^[a-z][a-z0-9-]*$` (kebab, starts with a letter)
  - `region`: `^[a-z]{3}$`
  - env `name`: `^[a-z][a-z0-9]+$` (the azure.yml key; unique, prefix-free)
  - env `shortcode`: `^[a-z]{2}$` (unique)
  - customer `key`: `^[a-z][a-z0-9]+$` (the customer.yml key; unique)
  - customer `shortcode`: `^[a-z]{2}$` (unique)
  - `slot`: `^[a-z0-9]{1,3}$`

### Component sourcing

| Component    | Resolved from                                                                                                                    |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| `env`        | deploy `-Environment` name → the env's `name` (relaxed) or 2-char `shortcode` (restricted), `azure.yml`                          |
| `slot`       | deploy-time input (`-Slot`; the special slot being deployed); optional                                                           |
| `region`     | `region_code` of the deploy environment in `azure.yml`                                                                           |
| `org`        | global `org` value in `azure.yml` (one per repo)                                                                                 |
| `short_name` | **derived** from the template folder (first 5 `[a-z0-9]`, `BicepShortName`); overridden by the template's optional `options.yml` |
| `customer`   | the resolved subscription's `customer` → its `key` (generous) or 2-char `shortcode` (restricted), from `customer.yml`; optional  |
| `role`       | the bicep author, per resource inside the template; optional                                                                     |
| `type`       | the resource type being named                                                                                                    |

### Resource-type registry

`Get-AzureResourceTypeSet` defines each type's abbreviation, render **pattern**, length, and any **omitted** components. `long`-pattern
types carry their own per-type `limit` (the Azure max for that type); `kv`/`storage`/`vm` take their cap from the pattern (24/24/15) and
declare no `limit`. A type may also declare `omit` — components it drops from its render because they are encoded elsewhere (only `vm` does
so, dropping org/customer/role). The set is extended in code as consuming repos need; this table mirrors the shipped registry
(`Get-AzureResourceTypeSet`):

| Type                     | abbr    | pattern | limit / cap | omit                |
| ------------------------ | ------- | ------- | ----------- | ------------------- |
| Resource group           | `rg`    | long    | 90          | —                   |
| Storage account          | `st`    | storage | 24 (cap)    | —                   |
| Key Vault                | `kv`    | kv      | 24 (cap)    | —                   |
| Web application firewall | `waf`   | long    | 128         | —                   |
| Virtual network          | `vnet`  | long    | 64          | —                   |
| SQL logical server       | `sql`   | long    | 63          | —                   |
| SQL database             | `sqldb` | long    | 128         | —                   |
| Virtual machine          | `vm`    | vm      | 15 (cap)    | org, customer, role |
| Synapse workspace        | `synw`  | long    | 50          | —                   |
| Data Factory (V2)        | `adf`   | long    | 63          | —                   |
| Log Analytics workspace  | `log`   | long    | 63          | —                   |
| Network interface        | `nic`   | long    | 80          | —                   |
| Public IP address        | `pip`   | long    | 80          | —                   |

### Worked examples

Env `prod` (shortcode `pr`), org `fin`, region `weu`:

Per-customer rows use customer `apex` (shortcode `ap`):

| Scenario                                 | Relaxed (name / key)                                     | Tight (shortcode)                                                                  |
| ---------------------------------------- | -------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| Prod discovery RG, base slot             | `prod-weu-fin-disc-rg`                                   | —                                                                                  |
| Two prod WAF slots                       | `prod-001-weu-fin-edge-waf`, `prod-002-weu-fin-edge-waf` | —                                                                                  |
| Per-customer RG, base slot               | `prod-weu-fin-disc-apex-rg` (readable key)               | —                                                                                  |
| Per-customer hot storage, base slot      | —                                                        | `prweufindiscaphotst` (19, customer shortcode `ap`)                                |
| Storage, slot + customer + role, short5  | —                                                        | `pr001weufindiscxaphotst` (**23 — fits**, thanks to the 2-char customer shortcode) |
| VM, slot 001 (org/customer/role omitted) | —                                                        | `pr001weudiscvm` (14 — `vm` drops org/customer/role)                               |

## Consequences

- Folders stay readable (`discovery`); `short_name` (2–5) carries Azure identity — no readability tax.
- `short_name` is the Azure id. By default it is **derived** from the folder, so a new template needs no `options.yml` to get a valid id —
  but renaming the folder then re-spells the derived `short_name` and its resources. Pin the id against folder churn by setting an explicit
  `short_name` override in `options.yml` (the derivation and the override are the same one-invariant `BicepShortName`).
- The restricted patterns use the 2-char shortcode for **both env and customer**, so readable env names and customer keys cost nothing in
  tight names; the full-house corner (slot + customer + role) fits storage at 23 ≤ 24. The deploy-time assert still guards any remaining
  over-limit render (e.g. a `kv` carrying customer + slot + role).
- Each environment maps to one region (region is an env attribute). Multi-region-per-environment would need env×region modeling and is out
  of scope.
- Deterministic-only means no entropy for globally-unique types; an external collision fails the deploy and is fixed by adjusting `slot` /
  `short_name` (no auto-hash).
- The **subscription** (the config folder a template deploys to) is a **resolution axis only** — it selects _which subscription_ a deploy
  targets and is **never** a resource-name component. Names are assembled from the components above
  (env/slot/region/org/short*name/customer/role/type); the subscription never appears in them. The **customer** that does render is
  \_derived* from that subscription (`subscription.customer`). See [`data-model`](azure-data-model.md).

## Dora explains

DORA research shows that standardized, maintainable naming and configuration-driven automation reduce deployment lead time and errors. This
ADR encodes deterministic, derived resource names that are never hand-typed, enabling safe infrastructure automation.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — standardized, deterministic naming rules reduce cognitive
  load.
- [Deployment automation](https://dora.dev/capabilities/deployment-automation/) — derived naming enables reliable, repeatable resource
  naming.
- [Version control](https://dora.dev/capabilities/version-control/) — naming rules versioned as configuration, reproducible and auditable.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
