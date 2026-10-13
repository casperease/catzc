# docs/how-to/automation/manual-test-plan/configs.md

`Manual test plan — Configs`

Config discovery, the config registry, and the shipped configs that are not Azure-specific. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                                    | FullNameFilter                                   | Guards                                                                                                                                                                                                          |
| --- | ---- | -------------------------------------------------------------------------------------------- | ------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L0   | automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1                              | Config conventions                               | Every `Assert-*Config` maps to a shipped config and rejects malformed input.                                                                                                                                    |
| 2   | L0   | automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1                                      | discovery + raw default                          | Raw (unvalidated) configs load as ordered dictionaries from disk.                                                                                                                                               |
| 3   | L0   | automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1                                      | convention validation (owner scope)              | Convention-validated configs load and pass their owner's validator.                                                                                                                                             |
| 4   | L0   | automation/Catzc.Base.Variants/tests/Assert-VariantsConfig.Tests.ps1                         | integrity (shipped variants.yml)                 | The shipped variants.yml validates — ado_naming is a known order and have_customers is false, all, or a valid customer-name list.                                                                               |
| 5   | L0   | automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1                                 | against a real shipped config                    | `Get-ConfigValue` resolves a real shipped config subtree end-to-end through the live `Get-Config`.                                                                                                              |
| 6   | L0   | automation/Catzc.Base.Vendor/tests/Assert-VendorConfig.Tests.ps1                             | integrity (shipped vendor.yml)                   | The shipped vendor.yml passes Assert-VendorConfig (known keys, a present source, an absolute source URL).                                                                                                       |
| 7   | L0   | automation/Catzc.Base.Exporter/tests/Assert-ExporterConfig.Tests.ps1                         | exporter.yml                                     | The shipped exporter.yml validates through Assert-ExporterConfig.                                                                                                                                               |
| 8   | L1   | automation/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1                              | Get-ConfigRegistry — shipped configs.yml         | The shipped `configs.yml` registry, located through `Get-CatzcModuleRoot`, validates and loads in both run modes.                                                                                               |
| 9   | L1   | automation/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Integrity.Tests.ps1 | Import-PSReadLineKeyHandlerSet (shipped configs) | The shipped key-handler configs (`key-handler-bindings.yml` + `key-handler-supported.yml`) bind through Get-Config and the real convention validators, asserting structural invariants only (ADR-AUTO-TEST#17). |
| 10  | L1   | automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1                         | LinksConfig (shipped links.yml)                  | The shipped links.yml loads through Get-Config as a valid LinksConfig (wrap mode and line-limit settings for Format-Links).                                                                                     |

## Checks

### 1. Config conventions

**Guards:** every config validator maps to a shipped config, and each rejects malformed input.

**Checks:**

- Every private `Assert-*Config` validator maps to a `configs/<name>.yml` (no orphans).
- Each validated shipped config (`ado`, `azure`, `network`, `dependencies`) rejects a malformed file through `Get-Config`.

### 2. discovery + raw default

**Guards:** raw (unvalidated) configs load correctly from disk.

**Checks:**

- A config with no validator is discovered and loaded as an ordered dictionary.

### 3. convention validation (owner scope)

**Guards:** convention-validated configs load and pass their owner-module validator.

**Checks:**

- A real config with a private `Assert-*Config` (e.g. `dependencies.yml`) loads and passes validation.

### 8. registry self-validation (shipped configs.yml)

**Guards:** the shipped `configs.yml` registry itself validates.

**Checks:**

- The live registry validator runs against the shipped `configs.yml` and loads without error.
