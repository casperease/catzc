---
catzc:
  derived:
    path: docs/how-to/automation/manual-test-plan/configs.md
    kind: how-to
    body_sha: fccbf8c307fa
    adrs:
      - ADR-CONF-LOADING#4
      - ADR-CONF-LOADING#5
      - ADR-REPO-CONTRACT#8
      - ADR-REPO-FILEMETA#1
---

# Manual test plan — Configs

Config discovery, the config registry, and the shipped configs that are not Azure-specific. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                           | FullNameFilter                                          | Guards                                                                                                                                                 |
| --- | ---- | ----------------------------------------------------------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | L0   | automation/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1                     | Config conventions                                      | `Test-ShippedConfigs` reports 0 issues: every shipped config has a registered C# config type and loads through it.                                     |
| 2   | L0   | automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1                             | discovery + raw default                                 | A real shipped config is discovered in its owning module and loads through `Get-Config`.                                                               |
| 3   | L0   | automation/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1        | Config validator coverage                               | `Test-ConfigValidators` reports 0 issues: no orphan `Assert-*Config` validator — each maps to a `configs/*.yml` in its module.                         |
| 4   | L0   | automation/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1                 | integrity (shipped variants.yml)                        | The shipped variants.yml loads through `VariantsConfig` — ado_naming is a known order and have_customers is false, all, or a valid customer-name list. |
| 5   | L0   | automation/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1                        | against a real shipped config                           | `Get-ConfigValue` resolves a real shipped config subtree end-to-end through the live `Get-Config`.                                                     |
| 6   | L0   | automation/Catzc.Base.Vendor/tests/types/VendorConfig.Tests.ps1                     | integrity (shipped vendor.yml)                          | The shipped vendor.yml loads through `VendorConfig` (known keys, a source that is set, a source URL that is absolute).                                 |
| 7   | L0   | automation/Catzc.Base.Exporter/tests/types/ExporterConfig.Tests.ps1                 | exporter.yml                                            | The shipped exporter.yml loads through `ExporterConfig`.                                                                                               |
| 8   | L1   | automation/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1                     | Get-ConfigRegistry — shipped configs.yml                | The shipped `configs.yml` registry, located through `Get-CatzcModuleRoot`, validates and loads in both run modes.                                      |
| 9   | L1   | automation/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1                | LinksConfig (shipped links.yml)                         | The shipped links.yml loads through Get-Config as a valid LinksConfig (wrap mode and line-limit settings for Format-Links).                            |
| 10  | L0   | automation/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1                 | integrity (shipped timeouts.yml)                        | The shipped timeouts.yml loads through `TimeoutsConfig`.                                                                                               |
| 11  | L0   | automation/Catzc.Base.Languages/tests/types/GoConfig.Tests.ps1                      | integrity (shipped go.yml)                              | The shipped go.yml loads through `GoConfig`.                                                                                                           |
| 12  | L0   | automation/Catzc.Base.Timeouts/tests/types/TimeoutExemptionsConfig.Tests.ps1        | integrity (shipped timeout-exemptions.yml)              | The shipped timeout-exemptions.yml loads through `TimeoutExemptionsConfig`, and every GUID it names is a registered budget.                            |
| 13  | L1   | automation/Catzc.Base.TypesSystem/tests/Build-BashTimeoutHook.Tests.ps1             | Build-BashTimeoutHook — parity with Get-TimeoutSeconds  | The published Bash hook, reading the shipped timeouts.yml, allows exactly the foreground and background limits `Get-TimeoutSeconds` resolves.          |
| 14  | L0   | automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1               | integrity (shipped languages.yml)                       | The shipped languages.yml loads through `LanguagesConfig`.                                                                                             |
| 15  | L0   | automation/Catzc.Base.Languages/tests/types/PythonConfig.Tests.ps1                  | integrity (shipped python.yml)                          | The shipped python.yml loads through `PythonConfig`, pinning pytest and ruff.                                                                          |
| 16  | L0   | automation/Catzc.Base.Languages/tests/types/BashConfig.Tests.ps1                    | integrity (shipped bash.yml)                            | The shipped bash.yml loads through `BashConfig`, pinning the vendored bats-core release and its archive digest.                                        |
| 17  | L1   | automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1               | ContractsConfig (shipped contracts.yml)                 | The shipped contracts.yml loads through `ContractsConfig` on an addressing mode that is built (ADR-REPO-CONTRACT#8).                                   |
| 18  | L1   | automation/Catzc.Base.Maps/tests/types/MapsConfig.Tests.ps1                         | integrity (shipped maps.yml)                            | The shipped maps.yml loads through `MapsConfig`.                                                                                                       |
| 19  | L0   | automation/Catzc.Base.QualityGates/tests/types/ParameterConsistencyConfig.Tests.ps1 | integrity (shipped parameter-consistency.yml)           | The shipped parameter-consistency.yml loads through `ParameterConsistencyConfig`, and every exempt parameter name carries its reason.                  |
| 20  | L0   | automation/Catzc.Base.Config/tests/Get-Config.Tests.ps1                             | the shipped registry seals the engine-intrinsic configs | The shipped configs.yml registry (`ConfigsConfig`) seals the engine-intrinsic configs: configs, dependencies, profiles, exporter, and glossary.        |
| 21  | L1   | automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1    | integrity (shipped source-conventions.yml)              | The shipped source-conventions.yml loads through `SourceConventionsConfig`.                                                                            |
| 22  | L1   | automation/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1             | CommentsConfig (shipped comments.yml)                   | The shipped comments.yml loads through Get-Config as a valid `CommentsConfig` (the comment-page languages, keep lists, pages map and excludes).        |
| 23  | L0   | automation/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1            | integrity (shipped file-carriers.yml)                   | The shipped file-carriers.yml loads through `FileCarriersConfig`, and every file language of languages.yml has a carrier entry (ADR-REPO-FILEMETA#1).  |

## Checks

### 1. Config conventions

**Guards:** every shipped config has a C# config type
([ADR-CONF-LOADING#4](../../../adr/configuration/module-config-loading.md#rule-adr-conf-loading4)) and loads through it.

**Checks:**

- The `Test-ShippedConfigs` quality gate reports 0 issues: every shipped `configs/<name>.yml` has a `type:` entry in `configs.yml`, every
  entry names a shipped config and a type that resolves, and every shipped config loads through `Get-Config`.

### 2. discovery + raw default

**Guards:** a real config is discovered in its owning module and loads.

**Checks:**

- `Get-Config -Config tools` discovers the shipped `tools.yml` in its owning module and loads it (the raw default itself is pinned by a
  logic test on a fixture config).

### 3. Config validator coverage

**Guards:** every PowerShell config validator — the extension point for a config that cannot ship a C# type
([ADR-CONF-LOADING#5](../../../adr/configuration/module-config-loading.md#rule-adr-conf-loading5)) — belongs to a real config.

**Checks:**

- The `Test-ConfigValidators` quality gate over the real tree reports 0 issues: every `Assert-*Config` validator maps to a `configs/*.yml`
  in its module (no orphans).

### 8. registry self-validation (shipped configs.yml)

**Guards:** the shipped `configs.yml` registry itself validates.

**Checks:**

- The live registry type runs against the shipped `configs.yml` and loads without error.
