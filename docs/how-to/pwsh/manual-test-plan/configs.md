# Manual test plan — Configs

Config discovery, the config registry, and the shipped configs that are not Azure-specific. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Check                                                                         |
| --- | ---- | ----------------------------------------------------------------------------- |
| 1   | L0   | [Config conventions][c1]                                                      |
| 2   | L0   | [discovery + raw default][c2]                                                 |
| 3   | L0   | [Config validator coverage][c3]                                               |
| 4   | L0   | [integrity (shipped variants.yml)][c4]                                        |
| 5   | L0   | [against a real shipped config][c5]                                           |
| 6   | L0   | [integrity (shipped vendor.yml)][c6]                                          |
| 7   | L0   | [exporter.yml][c7]                                                            |
| 8   | L1   | [registry self-validation (shipped configs.yml)][c8]                          |
| 9   | L1   | [LinksConfig (shipped links.yml)][c9]                                         |
| 10  | L0   | [integrity (shipped timeouts.yml)][c10]                                       |
| 11  | L0   | [integrity (shipped go.yml)][c11]                                             |
| 12  | L0   | [integrity (shipped timeout-exemptions.yml)][c12]                             |
| 13  | L1   | [Build-AgentHook — Assert-BashTimeout parity with Get-TimeoutSeconds][c13]    |
| 14  | L0   | [integrity (shipped languages.yml)][c14]                                      |
| 15  | L0   | [integrity (shipped python.yml)][c15]                                         |
| 16  | L0   | [integrity (shipped bash.yml)][c16]                                           |
| 17  | L1   | [integrity (shipped maps.yml)][c17]                                           |
| 18  | L0   | [integrity (shipped parameter-consistency.yml)][c18]                          |
| 19  | L0   | [the shipped registry seals the engine-intrinsic configs][c19]                |
| 20  | L1   | [integrity (shipped source-conventions.yml)][c20]                             |
| 21  | L1   | [CommentsConfig (shipped comments.yml)][c21]                                  |
| 22  | L0   | [integrity (shipped file-carriers.yml)][c22]                                  |
| 23  | L0   | [resolves with the shipped registries, every language file to its entry][c23] |
| 24  | L0   | [names the steps it may list, each with an adapter in Format-Code][c24]       |
| 25  | L1   | [FolderWalkConfig (shipped folder-walk.yml)][c25]                             |
| 26  | L0   | [integrity (shipped languages.yml layout)][c26]                               |
| 27  | L1   | [SlidesConfig (shipped slides.yml)][c27]                                      |
| 28  | L1   | [RungsConfig (shipped rungs.yml)][c28]                                        |
| 29  | L1   | [ImporterConfig (shipped importer.yml)][c29]                                  |
| 30  | L1   | [RungsConfig declared ladder][c30]                                            |
| 31  | L1   | [Get-AccostedFile over the shipped contracts.accosted.yml][c31]               |
| 32  | L0   | [integrity (shipped markdownlint.yml)][c32]                                   |
| 33  | L2   | [Build-AgentHook — no package feed reaches a hook build][c33]                 |
| 34  | L1   | [Get-ChangeCheckPlan — the shipped languages.yml and plans.yml][c34]          |
| 35  | L1   | [Get-FileLimit (shipped registry)][c35]                                       |
| 36  | L1   | [FileLimitsConfig (shipped file-limits.yml)][c36]                             |
| 37  | L1   | [TrackTypesConfig — the shipped track types][c37]                             |

[c1]: #1-config-conventions
[c2]: #2-discovery--raw-default
[c3]: #3-config-validator-coverage
[c4]: #4-integrity-shipped-variantsyml
[c5]: #5-against-a-real-shipped-config
[c6]: #6-integrity-shipped-vendoryml
[c7]: #7-exporteryml
[c8]: #8-registry-self-validation-shipped-configsyml
[c9]: #9-linksconfig-shipped-linksyml
[c10]: #10-integrity-shipped-timeoutsyml
[c11]: #11-integrity-shipped-goyml
[c12]: #12-integrity-shipped-timeout-exemptionsyml
[c13]: #13-build-agenthook--assert-bashtimeout-parity-with-get-timeoutseconds
[c14]: #14-integrity-shipped-languagesyml
[c15]: #15-integrity-shipped-pythonyml
[c16]: #16-integrity-shipped-bashyml
[c17]: #17-integrity-shipped-mapsyml
[c18]: #18-integrity-shipped-parameter-consistencyyml
[c19]: #19-the-shipped-registry-seals-the-engine-intrinsic-configs
[c20]: #20-integrity-shipped-source-conventionsyml
[c21]: #21-commentsconfig-shipped-commentsyml
[c22]: #22-integrity-shipped-file-carriersyml
[c23]: #23-resolves-with-the-shipped-registries-every-language-file-to-its-entry
[c24]: #24-names-the-steps-it-may-list-each-with-an-adapter-in-format-code
[c25]: #25-folderwalkconfig-shipped-folder-walkyml
[c26]: #26-integrity-shipped-languagesyml-layout
[c27]: #27-slidesconfig-shipped-slidesyml
[c28]: #28-rungsconfig-shipped-rungsyml
[c29]: #29-importerconfig-shipped-importeryml
[c30]: #30-rungsconfig-declared-ladder
[c31]: #31-get-accostedfile-over-the-shipped-contractsaccostedyml
[c32]: #32-integrity-shipped-markdownlintyml
[c33]: #33-build-agenthook--no-package-feed-reaches-a-hook-build
[c34]: #34-get-changecheckplan--the-shipped-languagesyml-and-plansyml
[c35]: #35-get-filelimit-shipped-registry
[c36]: #36-filelimitsconfig-shipped-file-limitsyml
[c37]: #37-tracktypesconfig--the-shipped-track-types

## Checks

### 1. Config conventions

**Test file:** `pwsh/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1` (L0), block `Config conventions`.

**Guards:** every shipped config has a C# config type
([ADR-CONF-LOADING-CSHARPCONFIGTYPE](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)) and loads
through it.

**Checks:**

- The `Test-ShippedConfigs` quality gate reports 0 issues: every shipped `configs/<name>.yml` has a `type:` entry in `configs.yml`, every
  entry names a shipped config and a type that resolves, and every shipped config loads through `Get-Config`.

### 2. discovery + raw default

**Test file:** `pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1` (L0), block `discovery + raw default`.

**Guards:** a real config is discovered in its owning module and loads.

**Checks:**

- `Get-Config -Config tools` discovers the shipped `tools.yml` in its owning module and loads it (the raw default itself is pinned by a
  logic test on a fixture config).

### 3. Config validator coverage

**Test file:** `pwsh/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1` (L0), block `Config validator coverage`.

**Guards:** every PowerShell config validator — the extension point for a config that cannot ship a C# type
([ADR-CONF-LOADING-POWERSHELLVALIDATOR](../../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-powershellvalidator)) —
belongs to a real config.

**Checks:**

- The `Test-ConfigValidators` quality gate over the real tree reports 0 issues: every `Assert-*Config` validator maps to a `configs/*.yml`
  in its module (no orphans).

### 4. integrity (shipped variants.yml)

**Test file:** `pwsh/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1` (L0), block `integrity (shipped variants.yml)`.

**Guards:** The shipped variants.yml loads through `VariantsConfig` — ado_naming is a known order and have_customers is false, all, or a
valid customer-name list.

### 5. against a real shipped config

**Test file:** `pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1` (L0), block `against a real shipped config`.

**Guards:** `Get-ConfigValue` resolves a real shipped config subtree end-to-end through the live `Get-Config`.

### 6. integrity (shipped vendor.yml)

**Test file:** `pwsh/Catzc.Base.Vendor/tests/types/VendorConfig.Tests.ps1` (L0), block `integrity (shipped vendor.yml)`.

**Guards:** The shipped vendor.yml loads through `VendorConfig` (known keys, a source that is set, a source URL that is absolute).

### 7. exporter.yml

**Test file:** `pwsh/Catzc.Base.Exporter/tests/types/ExporterConfig.Tests.ps1` (L0), block `exporter.yml`.

**Guards:** The shipped exporter.yml loads through `ExporterConfig`.

### 8. registry self-validation (shipped configs.yml)

**Test file:** `pwsh/Catzc.Base.Config/tests/Get-ConfigRegistry.Tests.ps1` (L1), block `Get-ConfigRegistry — shipped configs.yml`.

**Guards:** the shipped `configs.yml` registry itself validates.

**Checks:**

- The live registry type runs against the shipped `configs.yml` and loads without error.

### 9. LinksConfig (shipped links.yml)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/types/LinksConfig.Tests.ps1` (L1), block `LinksConfig (shipped links.yml)`.

**Guards:** The shipped links.yml loads through Get-Config as a valid LinksConfig (wrap mode and line-limit settings for Format-Links).

### 10. integrity (shipped timeouts.yml)

**Test file:** `pwsh/Catzc.Base.Timeouts/tests/types/TimeoutsConfig.Tests.ps1` (L0), block `integrity (shipped timeouts.yml)`.

**Guards:** The shipped timeouts.yml loads through `TimeoutsConfig`.

### 11. integrity (shipped go.yml)

**Test file:** `pwsh/Catzc.Base.Languages/tests/types/GoConfig.Tests.ps1` (L0), block `integrity (shipped go.yml)`.

**Guards:** The shipped go.yml loads through `GoConfig`.

### 12. integrity (shipped timeout-exemptions.yml)

**Test file:** `pwsh/Catzc.Base.Timeouts/tests/types/TimeoutExemptionsConfig.Tests.ps1` (L0), block
`integrity (shipped timeout-exemptions.yml)`.

**Guards:** The shipped timeout-exemptions.yml loads through `TimeoutExemptionsConfig`, and every GUID it names is a registered budget.

### 13. Build-AgentHook — Assert-BashTimeout parity with Get-TimeoutSeconds

**Test file:** `pwsh/Catzc.Base.TypesSystem/tests/Build-AgentHook.Tests.ps1` (L1), block
`Build-AgentHook — Assert-BashTimeout parity with Get-TimeoutSeconds`.

**Guards:** The published Bash hook, reading the shipped timeouts.yml, allows exactly the foreground and background limits
`Get-TimeoutSeconds` resolves.

### 14. integrity (shipped languages.yml)

**Test file:** `pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` (L0), block `integrity (shipped languages.yml)`.

**Guards:** The shipped languages.yml loads through `LanguagesConfig`.

### 15. integrity (shipped python.yml)

**Test file:** `pwsh/Catzc.Base.Languages/tests/types/PythonConfig.Tests.ps1` (L0), block `integrity (shipped python.yml)`.

**Guards:** The shipped python.yml loads through `PythonConfig`, pinning pytest and ruff.

### 16. integrity (shipped bash.yml)

**Test file:** `pwsh/Catzc.Base.Languages/tests/types/BashConfig.Tests.ps1` (L0), block `integrity (shipped bash.yml)`.

**Guards:** The shipped bash.yml loads through `BashConfig`, pinning the vendored bats-core release and its archive digest.

### 17. integrity (shipped maps.yml)

**Test file:** `pwsh/Catzc.Base.Maps/tests/types/MapsConfig.Tests.ps1` (L1), block `integrity (shipped maps.yml)`.

**Guards:** The shipped maps.yml loads through `MapsConfig`.

### 18. integrity (shipped parameter-consistency.yml)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/types/ParameterConsistencyConfig.Tests.ps1` (L0), block
`integrity (shipped parameter-consistency.yml)`.

**Guards:** The shipped parameter-consistency.yml loads through `ParameterConsistencyConfig`, and every exempt parameter name carries its
reason.

### 19. the shipped registry seals the engine-intrinsic configs

**Test file:** `pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1` (L0), block `the shipped registry seals the engine-intrinsic configs`.

**Guards:** The shipped configs.yml registry (`ConfigsConfig`) seals the engine-intrinsic configs: configs, dependencies, profiles,
exporter, and glossary.

### 20. integrity (shipped source-conventions.yml)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1` (L1), block
`integrity (shipped source-conventions.yml)`.

**Guards:** The shipped source-conventions.yml loads through `SourceConventionsConfig`.

### 21. CommentsConfig (shipped comments.yml)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/types/CommentsConfig.Tests.ps1` (L1), block `CommentsConfig (shipped comments.yml)`.

**Guards:** The shipped comments.yml loads through Get-Config as a valid `CommentsConfig` (the comment-page languages, keep lists, pages map
and excludes).

### 22. integrity (shipped file-carriers.yml)

**Test file:** `pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1` (L0), block `integrity (shipped file-carriers.yml)`.

**Guards:** The shipped file-carriers.yml loads through `FileCarriersConfig`, and every file language of languages.yml has a carrier entry
(ADR-REPO-FILEMETA-HEADPOLICY).

### 23. resolves with the shipped registries, every language file to its entry

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/types/FileCarrierResolver.Tests.ps1` (L0), block
`resolves with the shipped registries, every language file to its entry`.

**Guards:** `FileCarrierResolver`, built from the shipped file-carriers.yml and languages.yml, resolves a real file of each kind to its
carrier entry (ADR-REPO-FILEMETA-KINDSCOPE).

### 24. names the steps it may list, each with an adapter in Format-Code

**Test file:** `pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1` (L0), block
`names the steps it may list, each with an adapter in Format-Code`.

**Guards:** `LanguagesConfig.ImprintSteps` lists exactly the imprint steps `Format-Code` has an adapter for
(ADR-REPO-FORMAT-CONFIGUREDFORMATTERS).

### 25. FolderWalkConfig (shipped folder-walk.yml)

**Test file:** `pwsh/Catzc.Base.Folders/tests/types/FolderWalkConfig.Tests.ps1` (L1), block `FolderWalkConfig (shipped folder-walk.yml)`.

**Guards:** The shipped folder-walk.yml loads through `FolderWalkConfig` and is readable at the global address
`global.folder-walk.prune_vendor_in_searches`.

### 26. integrity (shipped languages.yml layout)

**Test file:** `pwsh/Catzc.Base.Languages/tests/types/LanguageNaming.Tests.ps1` (L0), block
`integrity (shipped languages.yml layout)`.

**Guards:** The shipped languages.yml layout places the five live folders the aspects were written with, and the shared tests folder is not
live (ADR-AUTO-MODULE-EXISTSBYLAYOUT).

### 27. SlidesConfig (shipped slides.yml)

**Test file:** `pwsh/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1` (L1), block `SlidesConfig (shipped slides.yml)`.

**Guards:** The shipped slides.yml loads through `SlidesConfig` and points at the kit.

### 28. RungsConfig (shipped rungs.yml)

**Test file:** `pwsh/Catzc.Base.Flow/tests/types/RungsConfig.Tests.ps1` (L1), block `RungsConfig (shipped rungs.yml)`.

**Guards:** The shipped rungs.yml loads through `RungsConfig` (FDR-CD-RUNGSREGISTRY).

### 29. ImporterConfig (shipped importer.yml)

**Test file:** `pwsh/Catzc.Base.ModuleSystem/tests/types/ImporterConfig.Tests.ps1` (L1), block `ImporterConfig (shipped importer.yml)`.

**Guards:** The shipped importer.yml loads through `ImporterConfig` (ADR-AUTO-IMPORTER-DECIDESMIX).

### 30. RungsConfig declared ladder

**Test file:** `pwsh/Catzc.Base.Flow/tests/types/RungsConfig.Tests.ps1` (L1), block `RungsConfig declared ladder`.

**Guards:** An omitted rungs key takes the declared ladder in climbing order, main-uat to prod, each with its environment, gate and rules
(ADR-AUTO-DEFAULT-ONERESOLUTIONORDER).

### 31. Get-AccostedFile over the shipped contracts.accosted.yml

**Test file:** `pwsh/Catzc.Base.Contracts/tests/Get-AccostedFile.Integrity.Tests.ps1` (L1), block
`Get-AccostedFile over the shipped contracts.accosted.yml`.

**Guards:** the shipped accosted-contracts file loads as its typed model.

**Checks:**

- `Get-AccostedFile` reads `Catzc.Base.Contracts/accosted/contracts.accosted.yml` into an `AccostedFile`, and every run in it holds at least
  one command.

### 32. integrity (shipped markdownlint.yml)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/types/MarkdownlintConfig.Tests.ps1` (L0), block `integrity (shipped markdownlint.yml)`.

**Guards:** the shipped markdownlint.yml loads and takes the declared default.

**Checks:**

- `Get-Config -Config markdownlint` returns a `MarkdownlintConfig` whose `batch_size` is the type's `DefaultBatchSize`.

### 33. Build-AgentHook — no package feed reaches a hook build

**Test file:** `pwsh/Catzc.Base.TypesSystem/tests/Build-AgentHook.Tests.ps1` (L2), block
`Build-AgentHook — no package feed reaches a hook build`.

**Guards:** a hook build contacts no package feed, because NuGet reads its config from the project's folder up and finds the generated root
config's cleared feeds alone.

**Checks:**

- For each folder under `.claude/hooks` that holds a `.csproj`, `dotnet nuget list source` exits 0, lists no `[Enabled]` or `[Disabled]`
  source, and says "No sources found". The check skips when `dotnet` is absent.

### 34. Get-ChangeCheckPlan — the shipped languages.yml and plans.yml

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1` (L1), block
`Get-ChangeCheckPlan — the shipped languages.yml and plans.yml`.

**Guards:** a quality gate that governs one folder is given only the changed files under it.

**Checks:**

- With the shipped `languages.yml` (markdown `check_scopes: Test-Plans: global.plans.folder`) and `plans.yml`, `Get-ChangeCheckPlan` gives
  `Test-Plans` the changed plan and not the changed docs article, while `Test-Spelling` takes both.
- `Test-Change -DryRun` plans `Test-Plans` for a changed plan and for no docs article.

### 35. Get-FileLimit (shipped registry)

**Test file:** `pwsh/Catzc.Base.FileLimits/tests/Get-FileLimit.Tests.ps1` (L1), block `Get-FileLimit (shipped registry)`.

**Guards:** every language the shipped registry declares resolves to a file-limits class.

**Checks:**

- Every declared language resolves in `file-limits` without throwing.

### 36. FileLimitsConfig (shipped file-limits.yml)

**Test file:** `pwsh/Catzc.Base.FileLimits/tests/types/FileLimitsConfig.Tests.ps1` (L1), block `FileLimitsConfig (shipped file-limits.yml)`.

**Guards:** the shipped file-limits.yml loads as its type and gives the FunctionLength rule the declared body length.

**Checks:**

- The shipped `file-limits.yml` loads as a `FileLimitsConfig`.
- The FunctionLength analyzer rule resolves the function body length `FileLimitsConfig` declares.

### 37. TrackTypesConfig — the shipped track types

**Test file:** `pwsh/Catzc.Base.Variants/tests/types/TrackTypesConfig.Tests.ps1` (L1), block `TrackTypesConfig — the shipped track types`.

**Guards:** the shipped track types declare the output type as a holder that admits no module type.

**Checks:**

- The output type is declared, and it is a holder that admits no module type.
