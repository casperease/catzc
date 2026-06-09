# Catzc.Base.Variants

The repo-wide variants module — the single home for settings that are **fixed for the importer session** and read the same everywhere. A
variant is a repo-wide switch, backed by `configs/variants.yml`, loaded once per session (re-run the importer to pick up an edit — the
`Get-Config` cache boundary, see [caching](../../adr/automation/caching.md)). There are two today, and the file is a growing dictionary: the
Azure resource-name component order (`ado_naming`) and the enabled-customer set (`have_customers`). Nothing reads the raw file — callers use
the module's `Test-`/`Assert-`/`Get-` primitives, so a repo-wide guard is a one-liner anywhere above the config layer. It is a member of the
`Base` group and depends on [Catzc.Base.Config](catzc-base-config.md) (to read the config) and [Catzc.Base.Asserts](catzc-base-asserts.md).

## Domains

| Domain   | Area      | Name                                                                   |
| -------- | --------- | ---------------------------------------------------------------------- |
| domain:1 | naming    | [Resource-name order variant](#domain1--resource-name-order-variant)   |
| domain:2 | customers | [Enabled-customer set variant](#domain2--enabled-customer-set-variant) |

### domain:1 — Resource-name order variant

Which Azure resource-name component order the repo uses — `standard` (env/slot first) or `classic` (type first, CAF-style). `Get-AdoNaming`
returns the value that `Get-BicepResourceName` passes to the name assembler (a key of `Get-AzureNameOrderSet`); `Test-AdoNaming` and
`Assert-AdoNaming` guard a code path that only holds under one convention. Changing this variant re-spells every generated resource name, so
it is a deliberate, one-time repo decision, not a runtime toggle (see [naming-standard](../../adr/azure/naming-standard.md)).

### domain:2 — Enabled-customer set variant

Whether the repo does customer deployments, and for which customers. The `have_customers` variant is tri-state — `false` (only non-customer
templates), `all` (every customer defined in `customer.yml`), or a list of customer names (only those). `Get-EnabledCustomers` normalizes
it; the plural `Test-`/`Assert-HaveCustomers` answer "is the repo customer-enabled" (or "are these names enabled"), and the singular
`Test-`/`Assert-HaveCustomer` cover the common one-customer check. This module owns _which customers are enabled by policy_; the catalogue
of who the customers are lives in `customer.yml` one layer up.

## What the module does

This module turns two repo-wide decisions into stable facts every caller can guard on. Both are read through one private reader
(`Get-Variant`) over `configs/variants.yml`, which `Get-Config` parses, validates (`Assert-VariantsConfig`), and caches for the session.
Because the file is read once and never mid-session, a variant is a fixed truth every caller agrees on, and the only way to change it is to
edit the file and re-run the importer.

The naming order (domain 1) selects, in one place, how every Azure resource name is spelled. The name assembler is order-agnostic; the
variant picks which order it applies, so a repo commits to a naming convention as data rather than as scattered code.

The enabled-customer set (domain 2) is the gate for customer deployments. Its default is `false`, so a fresh repo has only non-customer
templates until it deliberately opts in. When it names specific customers, a customer template that targets an unlisted customer is rejected
— the variant genuinely controls which customers deploy, not just whether any do. Keeping the enabled set in the variant (rather than
reading `customer.yml`) is what lets these primitives live in the `Base` layer while `customer.yml` stays an Azure-layer concern.

## Division

The module's public functions, sorted into the domains above.

| Domain                                  | Function               |
| --------------------------------------- | ---------------------- |
| domain:1 — Resource-name order variant  | `Get-AdoNaming`        |
|                                         | `Test-AdoNaming`       |
|                                         | `Assert-AdoNaming`     |
| domain:2 — Enabled-customer set variant | `Get-EnabledCustomers` |
|                                         | `Test-HaveCustomers`   |
|                                         | `Assert-HaveCustomers` |
|                                         | `Test-HaveCustomer`    |
|                                         | `Assert-HaveCustomer`  |
| config                                  | `variants.yml`         |
