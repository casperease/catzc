# Documentation

**CATZC — Cloud Automation Toolkit, Zero-Ceremony.** A PowerShell 7.4+ module system with Azure/Bicep infrastructure-as-code and Azure
DevOps pipelines.

## Core principle

[**Zero ceremony, hard to fail**](drs/automation/zero-ceremony-poka-yoke.md) — every design choice is evaluated against two questions: "Does
this add ceremony?" and "Can the author get this wrong?".

## Getting started

New here? Start with the [**automation getting-started guide**](how-to/getting-started/automation/index.md) — how to load the system, use it
in a script and in CI, and the task index. Its how-to articles:

- [Add a function](how-to/getting-started/pwsh/powershell/add-a-function.md)
- [Add a module](how-to/getting-started/pwsh/add-a-module.md)
- [Add a C# type](how-to/getting-started/BCL/add-a-dotnet-type.md)
- [Add an infrastructure template](how-to/getting-started/automation/add-an-infrastructure-template.md)
- [Run tests and checks](how-to/getting-started/pwsh/run-tests-and-checks.md)
- [Debug in VS Code](how-to/getting-started/pwsh/debug-in-vscode.md)
- [Add a CLI tool](how-to/getting-started/pwsh/add-a-cli-tool.md)
- [Vendor a module](how-to/getting-started/pwsh/vendor-a-module.md)
- [Add a doc chapter](how-to/getting-started/automation/add-a-doc-chapter.md)

## Explanation

How cats works and why, one diagram per article — start at the [**explanation index**](explanation/index.md), which also shows how to read
the diagrams. By ADR domain:

- [Ado](explanation/ado/index.md) — how Azure DevOps calls prove their credentials
- [Automation](explanation/automation/index.md) — module dependencies, the importer, and the bundle
- [Azure](explanation/azure/index.md) — how Azure resource names are assembled
- [Configuration](explanation/configuration/index.md) — how configuration is read, cached and addressed
- [Design](explanation/design/index.md) — the commit lifecycle, run modes, module aspects, tracks, the thin platform, the server remote
- [Flow](explanation/flow/index.md) — promotion, the pipeline runner, and the globsets that trigger pipelines
- [Repository](explanation/repository/index.md) — how managed root files and repository variants are kept in shape

## Module reference

Per-module reference, written responsibilities-first — each [article](references/pwsh/index.md) declares the module's responsibilities,
describes it in those terms, and sorts its functions and configs into them:

- [Catzc.Base.Asserts](references/pwsh/base-asserts/index.md), [Catzc.Base.Repository](references/pwsh/base-repository/index.md),
  [Catzc.Base.Environment](references/pwsh/base-environment/index.md), [Catzc.Base.Objects](references/pwsh/base-objects/index.md),
  [Catzc.Base.Writers](references/pwsh/base-writers/index.md), [Catzc.Base.Config](references/pwsh/base-config/index.md),
  [Catzc.Base.Execution](references/pwsh/base-execution/index.md), [Catzc.Base.Files](references/pwsh/base-files/index.md),
  [Catzc.Base.TypesSystem](references/pwsh/base-types-system/index.md),
  [Catzc.Base.ModuleSystem](references/pwsh/base-module-system/index.md),
  [Catzc.Base.QualityGates](references/pwsh/base-quality-gates/index.md), [Catzc.Base.Git](references/pwsh/base-git/index.md),
  [Catzc.Base.VSCode](references/pwsh/base-vs-code/index.md), [Catzc.Base.RootConfig](references/pwsh/base-root-config/index.md)
- [Catzc.Tooling.Core](references/pwsh/tooling-core/index.md), [Catzc.Tooling.Python](references/pwsh/tooling-python/index.md),
  [Catzc.Tooling.Node](references/pwsh/tooling-node/index.md), [Catzc.Tooling.Toolchain](references/pwsh/tooling-toolchain/index.md),
  [Catzc.Tooling.Provisioning](references/pwsh/tooling-provisioning/index.md)
- [Catzc.Azure](references/pwsh/azure/index.md), [Catzc.Azure.Cli](references/pwsh/azure-cli/index.md),
  [Catzc.Azure.DevOps](references/pwsh/azure-dev-ops/index.md), [Catzc.Azure.Firewall](references/pwsh/azure-firewall/index.md),
  [Catzc.Azure.Templates](references/pwsh/azure-templates/index.md)

## Automation ADRs

The "why" and "how" behind the automation and its pwsh engine.

### Design principles

- [Single-responsibility functions](drs/automation/single-responsibility-functions.md) — keep functions focused so they are easy to write,
  test, and debug
- [Open/closed architecture](drs/automation/open-closed-architecture.md) — extend by adding files, never by editing infrastructure
- [Dynamic module manifests](drs/automation/pwsh/dynamic-module-manifests.md) — the pwsh rules: generated .psd1, collision-free namespace
- [Fail fast with assertions](drs/automation/fail-fast-with-asserts.md) — catch errors at the source, not three layers down
- [Assert idioms](drs/automation/pwsh/assert-idioms.md) — the pwsh rules: guards after the param block, a declared time limit on long work
- [Retry as a last resort](drs/automation/retry-as-last-resort.md) — last-ditch only, lowest level possible, never in a test
- [Test automation](drs/automation/test-automation.md) — isolate logic tests behind seams; bind only integrity tests to shipped assets
- [Pester testing](drs/automation/pwsh/pester-testing.md) — the language layer: the mock idioms, test-file conventions, and engine gotchas
- [Idempotent state functions](drs/automation/idempotent-state-functions.md) — re-runs are always safe
- [Sensible defaults](drs/automation/sensible-defaults.md) — the zero-arg call does the right thing
- [Parameter design](drs/automation/pwsh/parameter-design.md) — the pwsh rules: positional primary argument, switches over booleans
- [Console output matters](drs/automation/console-output-matters.md) — every line of output is a UX decision
- [Error handling](drs/automation/pwsh/error-handling.md) — fail immediately, no warnings, no middle ground
- [Never depend on $PWD](drs/automation/never-depend-on-pwd.md) — functions work from anywhere
- [Working-directory mechanics](drs/automation/pwsh/working-directory-mechanics.md) — the pwsh rules: the anchors, and
  Push-Location/Pop-Location

### Implementation decisions

- [The pwsh engine](drs/automation/pwsh/pwsh-engine.md) — PowerShell 7.4+, strict mode in every scope, one dot-sourced importer
- [One function per file](drs/automation/pwsh/one-function-per-file.md) — makes discovery automatic and eliminates export ceremony
- [Use .ps1 not .psm1](drs/automation/pwsh/use-ps1-not-psm1.md) — shared scope without boilerplate loaders
- [Approved verbs](drs/automation/pwsh/respect-pwsh-verb-rules.md) — enforced naming so functions are self-documenting
- [Spell out names](drs/automation/spell-out-names.md) — no invented abbreviations
- [Identifier names](drs/automation/pwsh/identifier-names.md) — the pwsh rules: the analyzer rule that checks every variable and noun
- [Uniform formatting](drs/repository/uniform-formatting.md) — the whole repo, one mechanical standard
- [PowerShell formatting](drs/automation/pwsh/powershell-formatting.md) — the pwsh rules over uniform-formatting
- [Log before invoke](drs/automation/log-before-invoke.md) — automatic, not opt-in
- [Vendor dependencies](drs/automation/pwsh/vendor-toolset-dependencies.md) — determinism without a restore step, no gallery at runtime
- [Controlling system-wide deps](drs/automation/controlling-systemwide-deps.md) — version-locked, platform-aware, no container required
- [Effective in enterprises](drs/automation/effective-in-enterprises.md) — no admin required
- [Module-path hygiene](drs/automation/pwsh/module-path-hygiene.md) — the pwsh rules: vendored copies win, network user paths fixed once
- [Prefer Az CLI](drs/azure/prefer-az-cli.md) — avoids assembly hell, no module ceremony
- [Dry run](drs/automation/dry-run.md) — an explicit dry-run parameter on every side-effecting function
- [Prefer -DryRun over ShouldProcess](drs/automation/pwsh/prefer-dryrun-over-shouldprocess.md) — the pwsh rules: an explicit switch beats
  the un-testable, easy-to-misuse -WhatIf/-Confirm subsystem
- [Conventional folders](drs/repository/conventional-folders.md) — predictable layout for the whole repository: root folders, modules,
  tests, assets, and output
- [Dedicated output directory](drs/repository/dedicated-output-directory.md) — all generated artifacts go to `out/`
- [Environment variables](drs/automation/environment-variables.md) — when and how to use them
- [Environment-variable mechanics](drs/automation/pwsh/environment-variable-mechanics.md) — the pwsh rules: scoping, runspaces, test
  isolation
- [Cross-platform](drs/automation/cross-platform.md) — runs on Windows, Linux, and macOS
- [Cross-platform PowerShell](drs/automation/pwsh/cross-platform-powershell.md) — the language layer: Join-Path, compatible cmdlets,
  platform guards
- [Script-scope caching](drs/automation/pwsh/script-scope-caching.md) — the pwsh rules under [caching](drs/automation/caching.md):
  `$script:` cache entries, mock-the-whole-function
- [Avoid deep nesting](drs/automation/avoid-deep-nesting.md) — flat code is readable code
- [Avoid using semicolons](drs/automation/pwsh/powershell-formatting.md) — one statement per line
- [Prefer foreach over ForEach-Object](drs/automation/pwsh/prefer-foreach-over-foreach-object.md) — clarity and debuggability
- [Automatic variable pitfalls](drs/automation/pwsh/automatic-variable-pitfalls.md) — `$?`, `$_`, `$LASTEXITCODE` and their traps
- [Use proper package managers](drs/automation/use-proper-package-managers.md) — system tools via native package managers
- [Hosting C# types](drs/automation/pwsh/hosting-csharp-types.md) — the pwsh rules under native C# types: Add-Type, accelerators, stale
  types

### SOLID principles that don't apply

- **Liskov Substitution (L)** — LSP governs subtype hierarchies. This platform has no class hierarchies or subtype relationships.
- **Interface Segregation (I)** — ISP targets fat interfaces. PowerShell functions don't implement interfaces. The public/private split
  handles surface area.
- **Dependency Inversion (D)** — DIP requires a formal abstraction boundary. `Assert-Command` and `Invoke-Executable` provide light
  indirection, but not a formal abstraction layer.

### DRY and KISS

- **KISS** — This is [zero ceremony, hard to fail](drs/automation/zero-ceremony-poka-yoke.md). The foundational ADR's first test — "Does
  this add ceremony?" — is the KISS test.
- **DRY** — Enforced structurally: [dynamic module manifests](drs/automation/pwsh/dynamic-module-manifests.md) eliminate manifest
  duplication, [sensible defaults](drs/automation/sensible-defaults.md) pull versions from config,
  [one function per file](drs/automation/pwsh/one-function-per-file.md) makes the file name the export name.

## Pipeline ADRs

How Azure DevOps pipelines interact with the catzc commands.

- [Pipeline runner pattern](drs/ado/pipeline-runner-pattern.md) — all pipeline steps invoke PowerShell through a single runner
- [Custom template discipline](drs/ado/custom-template-discipline.md) — when and how to use ADO templates
- [Pipeline variables](drs/ado/pipeline-variables.md) — setting ADO output variables from PowerShell
- [Pipeline detection](drs/automation/pwsh/pipeline-detection.md) — how functions adapt to pipeline vs. local context
- [Dual authentication](drs/ado/dual-authentication.md) — pipeline system token vs. local Az token

## Terminology

- **catzc** — the reserved, source-code-level name: the `Catzc.*` module prefix, the C# `Catzc.*` namespaces, the `Catzc.` type-accelerator
  prefix, and the literal product token.
- **cats** (plural) — the conversational cover term for the catzc system as a whole, used in prose and docs and when talking to or about the
  system ("ask cats"). It stands in for the complicated, code-level catzc.

## Other

- [FAQ](how-to/getting-started/automation/faq.md) — common questions about the module system
