# Documentation

**CATZC — Cloud Automation Toolkit, Zero-Ceremony.** A PowerShell 7.4+ module system with Azure/Bicep infrastructure-as-code and Azure
DevOps pipelines.

## Core principle

[**Zero ceremony, hard to fail**](adr/automation/zero-ceremony-poka-yoke.md) — every design choice is evaluated against two questions: "Does
this add ceremony?" and "Can the author get this wrong?".

## Getting started

New here? Start with the [**automation getting-started guide**](how-to/getting-started/automation/index.md) — how to load the system, use it
in a script and in CI, and the task index. Its how-to articles:

- [Add a function](how-to/getting-started/automation/powershell/add-a-function.md)
- [Add a module](how-to/getting-started/automation/add-a-module.md)
- [Add a C# type](how-to/getting-started/automation/BCL/add-a-dotnet-type.md)
- [Add an infrastructure template](how-to/getting-started/automation/add-an-infrastructure-template.md)
- [Run tests and checks](how-to/getting-started/automation/run-tests-and-checks.md)
- [Debug in VS Code](how-to/getting-started/automation/debug-in-vscode.md)
- [Add a CLI tool](how-to/getting-started/automation/add-a-cli-tool.md)
- [Vendor a module](how-to/getting-started/automation/vendor-a-module.md)
- [Add a doc chapter](how-to/getting-started/automation/add-a-doc-chapter.md)

## Module reference

Per-module reference, written domains-first — each [article](references/automation/index.md) declares the module's domains, describes it in
those terms, and sorts its functions and configs into them:

- [Catzc.Base.Asserts](references/automation/catzc-base-asserts.md),
  [Catzc.Base.Repository](references/automation/catzc-base-repository.md),
  [Catzc.Base.Environment](references/automation/catzc-base-environment.md),
  [Catzc.Base.Objects](references/automation/catzc-base-objects.md), [Catzc.Base.Writers](references/automation/catzc-base-writers.md),
  [Catzc.Base.Config](references/automation/catzc-base-config.md), [Catzc.Base.Execution](references/automation/catzc-base-execution.md),
  [Catzc.Base.Files](references/automation/catzc-base-files.md), [Catzc.Base.TypesSystem](references/automation/catzc-base-typessystem.md),
  [Catzc.Base.ModuleSystem](references/automation/catzc-base-modulesystem.md),
  [Catzc.Base.QualityGates](references/automation/catzc-base-qualitygates.md), [Catzc.Base.Git](references/automation/catzc-base-git.md),
  [Catzc.Base.VSCode](references/automation/catzc-base-vscode.md), [Catzc.Base.RootConfig](references/automation/catzc-base-rootconfig.md)
- [Catzc.Tooling.Core](references/automation/catzc-tooling-core.md), [Catzc.Tooling.Python](references/automation/catzc-tooling-python.md),
  [Catzc.Tooling.Node](references/automation/catzc-tooling-node.md),
  [Catzc.Tooling.Toolchain](references/automation/catzc-tooling-toolchain.md),
  [Catzc.Tooling.Provisioning](references/automation/catzc-tooling-provisioning.md)
- [Catzc.Azure](references/automation/catzc-azure.md), [Catzc.Azure.Cli](references/automation/catzc-azure-cli.md),
  [Catzc.Azure.DevOps](references/automation/catzc-azure-devops.md), [Catzc.Azure.Firewall](references/automation/catzc-azure-firewall.md),
  [Catzc.Azure.Templates](references/automation/catzc-azure-templates.md)

## Automation ADRs

The "why" and "how" behind the PowerShell automation layer.

### Design principles

- [Single-responsibility functions](adr/automation/single-responsibility-functions.md) — keep functions focused so they are easy to write,
  test, and debug
- [Open/closed architecture](adr/automation/open-closed-architecture.md) — extend by adding files, never by editing infrastructure
- [Dynamic module manifests](adr/automation/powershell/dynamic-module-manifests.md) — the PowerShell layer: generated .psd1, collision-free
  namespace
- [Fail fast with assertions](adr/automation/fail-fast-with-asserts.md) — catch errors at the source, not three layers down
- [Retry as a last resort](adr/automation/retry-as-last-resort.md) — last-ditch only, lowest level possible, never in a test
- [Test automation](adr/automation/test-automation.md) — isolate logic tests behind seams; bind only integrity tests to shipped assets
- [Idempotent state functions](adr/automation/idempotent-state-functions.md) — re-runs are always safe
- [Sensible defaults](adr/automation/sensible-defaults.md) — the zero-arg call does the right thing
- [Parameter design](adr/automation/powershell/parameter-design.md) — the PowerShell layer: positional primary argument, switches over
  booleans
- [Console output matters](adr/automation/powershell/console-output-matters.md) — every line of output is a UX decision
- [Error handling](adr/automation/powershell/error-handling.md) — fail immediately, no warnings, no middle ground
- [Never depend on $PWD](adr/automation/never-depend-on-pwd.md) — functions work from anywhere
- [Working-directory mechanics](adr/automation/powershell/working-directory-mechanics.md) — the PowerShell layer: the anchors, and
  Push-Location/Pop-Location

### Implementation decisions

- [One function per file](adr/automation/powershell/one-function-per-file.md) — makes discovery automatic and eliminates export ceremony
- [Use .ps1 not .psm1](adr/automation/powershell/use-ps1-not-psm1.md) — shared scope without boilerplate loaders
- [Approved verbs](adr/automation/powershell/respect-pwsh-verb-rules.md) — enforced naming so functions are self-documenting
- [Uniform formatting](adr/repository/uniform-formatting.md) — the whole repo, one mechanical standard
- [PowerShell formatting](adr/automation/powershell/powershell-formatting.md) — the PowerShell layer over uniform-formatting
- [Log before invoke](adr/automation/log-before-invoke.md) — automatic, not opt-in
- [Vendor dependencies](adr/automation/powershell/vendor-toolset-dependencies.md) — determinism without a restore step
- [Controlling system-wide deps](adr/automation/controlling-systemwide-deps.md) — version-locked, platform-aware, no container required
- [Effective in enterprises](adr/automation/effective-in-enterprises.md) — no gallery at runtime, no admin required
- [Module-path hygiene](adr/automation/powershell/module-path-hygiene.md) — the PowerShell layer: vendored copies win, network user paths
  fixed once
- [Prefer Az CLI](adr/automation/powershell/prefer-az-cli.md) — avoids assembly hell, no module ceremony
- [Prefer -DryRun over ShouldProcess](adr/automation/powershell/prefer-dryrun-over-shouldprocess.md) — an explicit switch beats the
  un-testable, easy-to-misuse -WhatIf/-Confirm subsystem
- [Conventional folders](adr/repository/conventional-folders.md) — predictable layout for the whole repository: root folders, modules,
  tests, assets, and output
- [Dedicated output directory](adr/repository/dedicated-output-directory.md) — all generated artifacts go to `out/`
- [Environment variables](adr/automation/environment-variables.md) — when and how to use them
- [Environment-variable mechanics](adr/automation/powershell/environment-variable-mechanics.md) — the PowerShell layer: scoping, runspaces,
  test isolation
- [Cross-platform](adr/automation/cross-platform.md) — runs on Windows, Linux, and macOS
- [Cross-platform PowerShell](adr/automation/powershell/cross-platform-powershell.md) — the language layer: Join-Path, compatible cmdlets,
  platform gating
- [Script-scope caching](adr/automation/powershell/script-scope-caching.md) — the PowerShell layer under
  [caching](adr/automation/caching.md): `$script:` slots, mock-the-whole-function
- [Avoid deep nesting](adr/automation/avoid-deep-nesting.md) — flat code is readable code
- [Avoid using semicolons](adr/automation/powershell/avoid-using-semicolons.md) — one statement per line
- [Prefer foreach over ForEach-Object](adr/automation/powershell/prefer-foreach-over-foreach-object.md) — clarity and debuggability
- [Automatic variable pitfalls](adr/automation/powershell/automatic-variable-pitfalls.md) — `$?`, `$_`, `$LASTEXITCODE` and their traps
- [Use proper package managers](adr/automation/use-proper-package-managers.md) — system tools via native package managers

### SOLID principles that don't apply

- **Liskov Substitution (L)** — LSP governs subtype hierarchies. This platform has no class hierarchies or subtype relationships.
- **Interface Segregation (I)** — ISP targets fat interfaces. PowerShell functions don't implement interfaces. The public/private split
  handles surface area.
- **Dependency Inversion (D)** — DIP requires a formal abstraction boundary. `Assert-Command` and `Invoke-Executable` provide light
  indirection, but not a formal abstraction layer.

### DRY and KISS

- **KISS** — This is [zero ceremony, hard to fail](adr/automation/zero-ceremony-poka-yoke.md). The foundational ADR's first test — "Does
  this add ceremony?" — is the KISS test.
- **DRY** — Enforced structurally: [dynamic module manifests](adr/automation/powershell/dynamic-module-manifests.md) eliminate manifest
  duplication, [sensible defaults](adr/automation/sensible-defaults.md) pull versions from config,
  [one function per file](adr/automation/powershell/one-function-per-file.md) makes the file name the export name.

## Pipeline ADRs

How Azure DevOps pipelines interact with the automation layer.

- [Pipeline runner pattern](adr/pipelines/pipeline-runner-pattern.md) — all pipeline steps invoke PowerShell through a single runner
- [Custom template discipline](adr/pipelines/custom-template-discipline.md) — when and how to use ADO templates
- [Pipeline variables](adr/pipelines/pipeline-variables.md) — setting ADO output variables from PowerShell
- [Pipeline detection](adr/pipelines/pipeline-detection.md) — how functions adapt to pipeline vs. local context
- [Dual authentication](adr/pipelines/dual-authentication.md) — pipeline system token vs. local Az token

## Terminology

- **catzc** — the reserved, source-code-level name: the `Catzc.*` module prefix, the C# `Catzc.*` namespaces, the `Catzc.` type-accelerator
  prefix, and the literal product token.
- **cats** (plural) — the conversational cover term for the catzc system as a whole, used in prose and docs and when talking to or about the
  system ("ask cats"). It stands in for the complicated, code-level catzc.

## Other

- [FAQ](faq.md) — common questions about the module system
