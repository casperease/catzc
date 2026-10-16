---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants.md
    folder: docs/references/automation
    name: catzc-base-variants
    filetype: md
    kind: reference
    language: markdown
    track: docs
    body_sha: f850a5c1b74e
    links:
      - docs/adr/automation/caching.md
      - docs/adr/azure/azure-naming-standard.md
      - docs/adr/design/module-aspects.md
      - docs/adr/repository/repo-variants.md
      - docs/references/automation/catzc-base-asserts.md
      - docs/references/automation/catzc-base-config.md
      - docs/references/automation/catzc-base-globs.md
      - docs/references/automation/catzc-base-objects.md
---

# Catzc.Base.Variants

The repo-wide variants module — the single home for settings that are **fixed for the importer session** and read the same everywhere. A
variant is a repo-wide switch, backed by `configs/variants.yml`, loaded once per session (re-run the importer to pick up an edit — the
`Get-Config` cache boundary, see [caching](../../adr/automation/caching.md)). The file is a growing dictionary: the Azure resource-name
component order (`ado_naming`), the enabled-customer set (`have_customers`), how changes reach main (`git_workspace`), and the per-track
aspect classifications (`aspects`). Nothing reads the raw file — callers use the module's `Test-`/`Assert-`/`Get-` primitives, so a
repo-wide guard is a one-liner anywhere above the config layer (see [repo-variants](../../adr/repository/repo-variants.md)). It is a member
of the `Base` group and depends on [Catzc.Base.Config](catzc-base-config.md) (to read the config),
[Catzc.Base.Objects](catzc-base-objects.md) (the base of its config type), and [Catzc.Base.Asserts](catzc-base-asserts.md).

## Responsibilities

| Responsibility   | Area      | Name                                                                             |
| ---------------- | --------- | -------------------------------------------------------------------------------- |
| responsibility:1 | naming    | [Resource-name order variant](#responsibility1--resource-name-order-variant)     |
| responsibility:2 | customers | [Enabled-customer set variant](#responsibility2--enabled-customer-set-variant)   |
| responsibility:3 | workspace | [Git workspace variant](#responsibility3--git-workspace-variant)                 |
| responsibility:4 | aspects   | [Aspect classification variant](#responsibility4--aspect-classification-variant) |

### responsibility:1 — Resource-name order variant

Which Azure resource-name component order the repo uses — `standard` (env/slot first) or `classic` (type first, CAF-style). `Get-AdoNaming`
returns the value that `Get-BicepResourceName` passes to the name assembler (a key of `Get-AzureNameOrderSet`); `Test-AdoNaming` and
`Assert-AdoNaming` guard a code path that only holds under one convention. Changing this variant re-spells every generated resource name, so
it is a deliberate, one-time repo decision, not a runtime toggle (see [naming-standard](../../adr/azure/azure-naming-standard.md)).

### responsibility:2 — Enabled-customer set variant

Whether the repo does customer deployments, and for which customers. The `have_customers` variant is tri-state — `false` (only non-customer
templates), `all` (every customer defined in `customer.yml`), or a list of customer names (only those). `Get-EnabledCustomers` normalizes
it; the plural `Test-`/`Assert-HaveCustomers` answer "is the repo customer-enabled" (or "are these names enabled"), and the singular
`Test-`/`Assert-HaveCustomer` cover the common one-customer check. This module owns _which customers are enabled by policy_; the catalogue
of who the customers are lives in `customer.yml` one layer up.

### responsibility:3 — Git workspace variant

How changes reach main — `main-direct` (the default: the solo-author trunk, direct commits to main allowed) or `main-via-pr` (everything
reaches main through a pull request). `Get-GitWorkspace` returns the mode and `Test-GitWorkspace -MainDirect|-MainViaPr` answers whether it
is the one named; the canonical consumer is the stop condition for automated commits — a direct commit while standing on main locally in
`main-via-pr` mode.

### responsibility:4 — Aspect classification variant

Each track's ordered, first-match classification of a unit's files into named aspects (see
[module-aspects](../../adr/design/module-aspects.md)). `Get-Aspect` returns a track's aspects as typed records, each a name and its glob
patterns, the last the `**` catch-all remainder; a track with no configured or default entry falls back to the `automation` convention.

## What the module does

This module turns repo-wide decisions into stable facts every caller can guard on. They are all read through one private reader
(`Get-Variant`) over `configs/variants.yml`, which `Get-Config` parses, validates through its config type (`VariantsConfig`), and caches for
the session. Because the file is read once and never mid-session, a variant is a fixed truth every caller agrees on, and the only way to
change it is to edit the file and re-run the importer.

The naming order (responsibility 1) selects, in one place, how every Azure resource name is spelled. The name assembler is order-agnostic;
the variant picks which order it applies, so a repo commits to a naming convention as data rather than as scattered code.

The enabled-customer set (responsibility 2) is the gate for customer deployments. Its default is `false`, so a fresh repo has only
non-customer templates until it deliberately opts in. When it names specific customers, a customer template that targets an unlisted
customer is rejected — the variant genuinely controls which customers deploy, not just whether any do. Keeping the enabled set in the
variant (rather than reading `customer.yml`) is what lets these primitives live in the `Base` layer while `customer.yml` stays an
Azure-layer concern.

The git workspace (responsibility 3) gates automation that commits, and the aspect classification (responsibility 4) is the data the
[Catzc.Base.Globs](catzc-base-globs.md) aspect engine compiles into scan programs.

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                                   | Function               |
| ------------------------------------------------ | ---------------------- |
| responsibility:1 — Resource-name order variant   | `Get-AdoNaming`        |
|                                                  | `Test-AdoNaming`       |
|                                                  | `Assert-AdoNaming`     |
| responsibility:2 — Enabled-customer set variant  | `Get-EnabledCustomers` |
|                                                  | `Test-HaveCustomers`   |
|                                                  | `Assert-HaveCustomers` |
|                                                  | `Test-HaveCustomer`    |
|                                                  | `Assert-HaveCustomer`  |
| responsibility:3 — Git workspace variant         | `Get-GitWorkspace`     |
|                                                  | `Test-GitWorkspace`    |
| responsibility:4 — Aspect classification variant | `Get-Aspect`           |
| config                                           | `variants.yml`         |
