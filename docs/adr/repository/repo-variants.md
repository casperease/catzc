# ADR: Repo-wide variants — session-fixed settings behind `Test-`/`Assert-` primitives

## Rules: ADR-VARIANT

### Rule ADR-VARIANT:1

A repo-wide **variant** is a setting fixed for the importer session, declared in `configs/variants.yml` in the `Catzc.Base.Variants` module
and read through `Get-Config -Config variants` (so it inherits the session cache — re-run the importer to change it). The file is a
**growing dictionary**: today `ado_naming`, `git_workspace`, and `have_customers`, more as needed. A variant is the one home for a "this
whole repo works this way" switch — not a per-module config, not an environment variable.

- [What a variant is](#what-a-variant-is)

### Rule ADR-VARIANT:2

Nothing reads `variants.yml` directly. Each variant is exposed as typed primitives — a `Get-` value accessor and `Test-`/`Assert-` guards —
so a repo-wide decision is a one-liner (`Assert-HaveCustomers`, `Test-AdoNaming -Classic`) anywhere it is needed. The private `Get-Variant`
reader is the single access point the primitives share.

- [Primitives, not raw reads](#primitives-not-raw-reads)

### Rule ADR-VARIANT:3

`Catzc.Base.Variants` depends only on `Catzc.Base.Config` (to read the file) and `Catzc.Base.Asserts` (for the `Assert-` guards), and its
validator (`Assert-VariantsConfig`) is **self-contained** — it validates the parsed dictionary and reads no other config. So the only edge
is `Variants → Config`, which is acyclic because `Config` never depends on `Variants`. The consequence is the reach: the primitives are
callable from any module **above the Config layer** (all of `AzureExt`, `Tooling`, and the upper `Base` modules) — which is every real
consumer; only `Config`/`Repository`/`Asserts` themselves cannot call them, and they have no need to.

- [Why a Base module, and how far it reaches](#why-a-base-module-and-how-far-it-reaches)

### Rule ADR-VARIANT:4

`ado_naming` (`standard` | `classic`) selects the Azure resource-name component order — the key of `Get-AzureNameOrderSet` that
`Get-BicepResourceName` passes to the name assembler. It is a **variant, not a code constant**: `Get-AdoNaming` reads it (default
`standard`). Changing it re-spells every generated resource name, so it is a deliberate, one-time repo decision, not a runtime toggle (see
[naming-standard](../azure/azure-naming-standard.md)).

- [The three variants](#the-three-variants)

### Rule ADR-VARIANT:5

`have_customers` is **tri-state** — `false` (no customer deployments; only non-customer templates), `all` (every customer in `customer.yml`
is enabled), or a **list of customer names** (only those). `Get-EnabledCustomers` normalizes it; the plural `Test-`/`Assert-HaveCustomers`
answer the repo-wide question (with an optional `-Name` list), and the singular `Test-`/`Assert-HaveCustomer` cover one customer
(`ADR-VERBS:6` cardinality). The **enabled set lives in the variant**, not in `customer.yml`, precisely so these primitives can live in
`Base` while `customer.yml` stays an Azure-layer catalogue (see [customer-model](../azure/azure-customer-model.md)).

- [The three variants](#the-three-variants)

### Rule ADR-VARIANT:6

`git_workspace` (`main-direct` | `main-via-pr`, default `main-direct`) declares how changes reach main — the solo-author trunk versus
everything-through-a-PR (the deliberate flip when the repo goes from one author to more). It gates automation that **commits**
(`Sync-GeneratedFile` and anything that follows it): in `main-direct`, any named branch commits — including main, which IS the integration
path (one-living-version); in `main-via-pr`, work always happens on a branch, so committing is still always allowed there — the **single
stop condition** is a direct commit made while standing on main/master locally. Read it through `Get-GitWorkspace` /
`Test-GitWorkspace -MainDirect|-MainViaPr`.

- [The three variants](#the-three-variants)

## Context

Some settings are properties of the **whole repository**, fixed for a run: which Azure naming convention every resource name uses, whether
this repo does customer deployments at all. Scattering these as per-call parameters, per-module constants, or ambient environment variables
means no single answer, no single guard, and drift. They need one home, one read path, and one way to assert them.

The runtime already fixes the file set for a session at the importer boundary (see [caching](../automation/caching.md)), so a config-backed
value read once and cached for the session is exactly the right shape: stable for the whole run, changed only by editing the file and
re-importing. What is missing is a place to put such values and a disciplined way to read them.

### What a variant is

A variant is a repo-wide switch backed by `Catzc.Base.Variants/configs/variants.yml`, loaded and validated by `Get-Config -Config variants`
(convention validator `Assert-VariantsConfig`), and cached for the session. "Fixed for the importer session" is not special machinery — it
is the ordinary `Get-Config` cache boundary (`ADR-CACHE:6`, `ADR-PSCACHE:1`): the value is read once, every caller sees the same answer, and
re-running the importer is the only way to pick up an edit. The set of variants is open: `variants.yml` is a dictionary that grows a key
(and a matching primitive) whenever a new repo-wide switch is genuinely needed.

### Primitives, not raw reads

A flat config value read ad hoc gives every caller its own defaulting and interpretation. Instead each variant is a small, typed surface:

- a **value accessor** (`Get-AdoNaming`, `Get-EnabledCustomers`) that reads the variant and applies its default;
- **`Test-`** predicates that answer a boolean (`Test-AdoNaming -Standard`, `Test-HaveCustomer -Name acme`);
- **`Assert-`** guards that throw with an actionable message when the repo is not in the required state (`Assert-HaveCustomers`).

All of them route through one private reader, `Get-Variant -Name <key> -Default <x>`, so the growing dictionary has a single access point
and each variant's defaulting lives in exactly one place. A caller never mentions `variants.yml` or a raw key; it asks a named question.

### Why a Base module, and how far it reaches

The primitives must be usable as trivial guards wherever a repo-wide decision matters — deep in the Azure templating layer, in a tooling
step, anywhere. That argues for a low, widely-dependable **Base** module rather than the Azure layer. Reading a config never bypasses
`Get-Config` (`ADR-MODCFG:1`), so `Catzc.Base.Variants` depends on `Catzc.Base.Config`; that edge is acyclic because `Config` depends only
on `Repository` and `Asserts`, never on `Variants`. The reach follows from the graph: any module that sits **above** the Config layer can
call the primitives — every `AzureExt`, `Tooling`, and upper-`Base` module — and the three foundation modules that cannot (`Config`,
`Repository`, `Asserts`) never need to. The module's validator stays self-contained so validation adds no further edges; a variant that
needed to cross-check another asset would belong to that asset's layer, not here.

### The three variants

- **`ado_naming`** — the resource-name component order (`ADR-VARIANT:4`). One repo-wide choice of `standard` vs `classic`, read by
  `Get-AdoNaming` and applied by the name assembler; the order data itself is `Get-AzureNameOrderSet` in the Azure templating layer, and the
  variant only picks which key it uses.
- **`git_workspace`** — how changes reach main (`ADR-VARIANT:6`), `main-direct | main-via-pr`, default `main-direct`. Committing is always
  allowed in both modes — a solo trunk commits to main directly, and PR-mode work lives on branches where committing is equally fine; the
  variant exists for the one asymmetry, `main-via-pr` **and** standing on main/master locally, which is the only stop condition automation
  enforces (`Sync-GeneratedFile`'s branch guard reads `Test-GitWorkspace -MainViaPr`). This is the **PR-vs-Direct** integration axis the
  value-chain diagrams (`ADR-FLOW`) prefix a flow with (`PR + CD + …` vs a `Direct` flow).
- **`have_customers`** — the enabled-customer set (`ADR-VARIANT:5`), tri-state `false | all | [names]`. It is the gate for customer
  deployments and the source of the per-template `customer_deployment` default (see [customer-model](../azure/azure-customer-model.md)).
  Keeping the enabled set in the variant (rather than deriving it from `customer.yml`) is what lets the `HaveCustomer(s)` primitives answer
  "is this customer enabled" from `Base` without reaching up into the Azure-layer catalogue.

## Decision

Repo-wide, session-fixed settings are **variants**: keys in `Catzc.Base.Variants/configs/variants.yml`, each read only through a `Get-`/
`Test-`/`Assert-` primitive over the shared private `Get-Variant` reader. The module depends on `Config` and `Asserts` only, its validator
is self-contained, and the primitives are therefore callable from any module above the Config layer.

### How this is enforced

- **`Assert-VariantsConfig`** (private, convention-dispatched by `Get-Config`) validates `variants.yml` on load: known keys only,
  `ado_naming ∈ {standard, classic}`, `git_workspace ∈ {main-direct, main-via-pr}`, `have_customers` is `false`/`all`/a valid name list. A
  typo fails fast at import.
- **The dependency graph** (`dependencies.yml`, `Assert-ModuleDependency`) declares
  `Catzc.Base.Variants: [Catzc.Base.Config, Catzc.Base.Asserts]` and would fail the L2 suite on any edge that made the graph cyclic.
- **Code review** keeps new repo-wide switches in this module as variants with their own primitives, rather than as ad-hoc config reads or
  environment variables.

## Consequences

- A repo-wide decision has one home (`variants.yml`), one read path (`Get-Variant`), and one guard vocabulary (`Test-`/`Assert-`) usable
  almost anywhere.
- The values are session-stable by construction — the `Get-Config` cache boundary makes "fixed for the run" free, with the importer as the
  single invalidation knob.
- Adding a variant is a small, bounded act: a key in `variants.yml`, a clause in the validator, and a primitive — no new module, no new
  wiring.
- The cost is one indirection (a primitive per variant instead of a raw read) and the layering rule that the module stays self-contained;
  both are what keep the construct legible and cycle-free.

## Dora explains

DORA's research on code maintainability and platform engineering emphasizes sensible defaults and low-ceremony guard mechanisms; typed
variant primitives (`Test-`/`Assert-`) make repo-wide decisions auditable and testable from anywhere, so the only stop condition is
mechanical, not procedural.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — typed guards instead of raw config reads make repo-wide
  decisions explicit and enforceable.
- [Platform engineering](https://dora.dev/capabilities/platform-engineering/) — zero-ceremony access to sensible defaults makes repo-wide
  settings usable as simple, one-liner guards everywhere.
- [Continuous integration](https://dora.dev/capabilities/continuous-integration/) — session-cached variants mean config is locked for the
  run and unchanged across parallel build steps.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
