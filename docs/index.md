---
catzc:
  immutable:
    with_body_sha: "818cbe98f9ce"
    repo_status: locked
    path: docs/index.md
    folder: docs
    name: index
    filetype: md
    role: index
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/ado/custom-template-discipline.md
      - docs/adr/ado/dual-authentication.md
      - docs/adr/ado/pipeline-variables.md
      - docs/adr/automation/avoid-deep-nesting.md
      - docs/adr/automation/caching.md
      - docs/adr/automation/console-output-matters.md
      - docs/adr/automation/controlling-systemwide-deps.md
      - docs/adr/automation/cross-platform.md
      - docs/adr/automation/dry-run.md
      - docs/adr/automation/effective-in-enterprises.md
      - docs/adr/automation/environment-variables.md
      - docs/adr/automation/fail-fast-with-asserts.md
      - docs/adr/automation/idempotent-state-functions.md
      - docs/adr/automation/log-before-invoke.md
      - docs/adr/automation/never-depend-on-pwd.md
      - docs/adr/automation/open-closed-architecture.md
      - docs/adr/automation/pwsh/assert-idioms.md
      - docs/adr/automation/pwsh/automatic-variable-pitfalls.md
      - docs/adr/automation/pwsh/avoid-using-semicolons.md
      - docs/adr/automation/pwsh/cross-platform-powershell.md
      - docs/adr/automation/pwsh/dynamic-module-manifests.md
      - docs/adr/automation/pwsh/environment-variable-mechanics.md
      - docs/adr/automation/pwsh/error-handling.md
      - docs/adr/automation/pwsh/hosting-csharp-types.md
      - docs/adr/automation/pwsh/identifier-names.md
      - docs/adr/automation/pwsh/module-path-hygiene.md
      - docs/adr/automation/pwsh/one-function-per-file.md
      - docs/adr/automation/pwsh/parameter-design.md
      - docs/adr/automation/pwsh/pester-testing.md
      - docs/adr/automation/pwsh/powershell-formatting.md
      - docs/adr/automation/pwsh/prefer-dryrun-over-shouldprocess.md
      - docs/adr/automation/pwsh/prefer-foreach-over-foreach-object.md
      - docs/adr/automation/pwsh/pwsh-engine.md
      - docs/adr/automation/pwsh/respect-pwsh-verb-rules.md
      - docs/adr/automation/pwsh/script-scope-caching.md
      - docs/adr/automation/pwsh/use-ps1-not-psm1.md
      - docs/adr/automation/pwsh/vendor-toolset-dependencies.md
      - docs/adr/automation/pwsh/working-directory-mechanics.md
      - docs/adr/automation/retry-as-last-resort.md
      - docs/adr/automation/sensible-defaults.md
      - docs/adr/automation/single-responsibility-functions.md
      - docs/adr/automation/spell-out-names.md
      - docs/adr/automation/test-automation.md
      - docs/adr/automation/use-proper-package-managers.md
      - docs/adr/automation/zero-ceremony-poka-yoke.md
      - docs/adr/azure/prefer-az-cli.md
      - docs/adr/flow/pipeline-detection.md
      - docs/adr/flow/pipeline-runner-pattern.md
      - docs/adr/repository/conventional-folders.md
      - docs/adr/repository/dedicated-output-directory.md
      - docs/adr/repository/uniform-formatting.md
      - docs/explanation/ado/index.md
      - docs/explanation/automation/index.md
      - docs/explanation/azure/index.md
      - docs/explanation/configuration/index.md
      - docs/explanation/design/index.md
      - docs/explanation/flow/index.md
      - docs/explanation/index.md
      - docs/explanation/repository/index.md
      - docs/how-to/getting-started/automation/add-a-doc-chapter.md
      - docs/how-to/getting-started/automation/add-an-infrastructure-template.md
      - docs/how-to/getting-started/automation/faq.md
      - docs/how-to/getting-started/automation/index.md
      - docs/how-to/getting-started/pwsh/BCL/add-a-dotnet-type.md
      - docs/how-to/getting-started/pwsh/add-a-cli-tool.md
      - docs/how-to/getting-started/pwsh/add-a-module.md
      - docs/how-to/getting-started/pwsh/debug-in-vscode.md
      - docs/how-to/getting-started/pwsh/powershell/add-a-function.md
      - docs/how-to/getting-started/pwsh/run-tests-and-checks.md
      - docs/how-to/getting-started/pwsh/vendor-a-module.md
      - docs/references/pwsh/catzc-azure-cli.md
      - docs/references/pwsh/catzc-azure-devops.md
      - docs/references/pwsh/catzc-azure-firewall.md
      - docs/references/pwsh/catzc-azure-templates.md
      - docs/references/pwsh/catzc-azure.md
      - docs/references/pwsh/catzc-base-asserts.md
      - docs/references/pwsh/catzc-base-config.md
      - docs/references/pwsh/catzc-base-environment.md
      - docs/references/pwsh/catzc-base-execution.md
      - docs/references/pwsh/catzc-base-files.md
      - docs/references/pwsh/catzc-base-git.md
      - docs/references/pwsh/catzc-base-modulesystem.md
      - docs/references/pwsh/catzc-base-objects.md
      - docs/references/pwsh/catzc-base-qualitygates.md
      - docs/references/pwsh/catzc-base-repository.md
      - docs/references/pwsh/catzc-base-rootconfig.md
      - docs/references/pwsh/catzc-base-typessystem.md
      - docs/references/pwsh/catzc-base-vscode.md
      - docs/references/pwsh/catzc-base-writers.md
      - docs/references/pwsh/catzc-tooling-core.md
      - docs/references/pwsh/catzc-tooling-node.md
      - docs/references/pwsh/catzc-tooling-provisioning.md
      - docs/references/pwsh/catzc-tooling-python.md
      - docs/references/pwsh/catzc-tooling-toolchain.md
      - docs/references/pwsh/index.md
---

# Documentation

**CATZC — Cloud Automation Toolkit, Zero-Ceremony.** A PowerShell 7.4+ module system with Azure/Bicep infrastructure-as-code and Azure
DevOps pipelines.

## Core principle

[**Zero ceremony, hard to fail**](adr/automation/zero-ceremony-poka-yoke.md) — every design choice is evaluated against two questions: "Does
this add ceremony?" and "Can the author get this wrong?".

## Getting started

New here? Start with the [**automation getting-started guide**](how-to/getting-started/automation/index.md) — how to load the system, use it
in a script and in CI, and the task index. Its how-to articles:

- [Add a function](how-to/getting-started/pwsh/powershell/add-a-function.md)
- [Add a module](how-to/getting-started/pwsh/add-a-module.md)
- [Add a C# type](how-to/getting-started/pwsh/BCL/add-a-dotnet-type.md)
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

- [Catzc.Base.Asserts](references/pwsh/catzc-base-asserts.md), [Catzc.Base.Repository](references/pwsh/catzc-base-repository.md),
  [Catzc.Base.Environment](references/pwsh/catzc-base-environment.md), [Catzc.Base.Objects](references/pwsh/catzc-base-objects.md),
  [Catzc.Base.Writers](references/pwsh/catzc-base-writers.md), [Catzc.Base.Config](references/pwsh/catzc-base-config.md),
  [Catzc.Base.Execution](references/pwsh/catzc-base-execution.md), [Catzc.Base.Files](references/pwsh/catzc-base-files.md),
  [Catzc.Base.TypesSystem](references/pwsh/catzc-base-typessystem.md),
  [Catzc.Base.ModuleSystem](references/pwsh/catzc-base-modulesystem.md),
  [Catzc.Base.QualityGates](references/pwsh/catzc-base-qualitygates.md), [Catzc.Base.Git](references/pwsh/catzc-base-git.md),
  [Catzc.Base.VSCode](references/pwsh/catzc-base-vscode.md), [Catzc.Base.RootConfig](references/pwsh/catzc-base-rootconfig.md)
- [Catzc.Tooling.Core](references/pwsh/catzc-tooling-core.md), [Catzc.Tooling.Python](references/pwsh/catzc-tooling-python.md),
  [Catzc.Tooling.Node](references/pwsh/catzc-tooling-node.md), [Catzc.Tooling.Toolchain](references/pwsh/catzc-tooling-toolchain.md),
  [Catzc.Tooling.Provisioning](references/pwsh/catzc-tooling-provisioning.md)
- [Catzc.Azure](references/pwsh/catzc-azure.md), [Catzc.Azure.Cli](references/pwsh/catzc-azure-cli.md),
  [Catzc.Azure.DevOps](references/pwsh/catzc-azure-devops.md), [Catzc.Azure.Firewall](references/pwsh/catzc-azure-firewall.md),
  [Catzc.Azure.Templates](references/pwsh/catzc-azure-templates.md)

## Automation ADRs

The "why" and "how" behind the automation and its pwsh engine.

### Design principles

- [Single-responsibility functions](adr/automation/single-responsibility-functions.md) — keep functions focused so they are easy to write,
  test, and debug
- [Open/closed architecture](adr/automation/open-closed-architecture.md) — extend by adding files, never by editing infrastructure
- [Dynamic module manifests](adr/automation/pwsh/dynamic-module-manifests.md) — the pwsh rules: generated .psd1, collision-free namespace
- [Fail fast with assertions](adr/automation/fail-fast-with-asserts.md) — catch errors at the source, not three layers down
- [Assert idioms](adr/automation/pwsh/assert-idioms.md) — the pwsh rules: guards after the param block, a declared time limit on long work
- [Retry as a last resort](adr/automation/retry-as-last-resort.md) — last-ditch only, lowest level possible, never in a test
- [Test automation](adr/automation/test-automation.md) — isolate logic tests behind seams; bind only integrity tests to shipped assets
- [Pester testing](adr/automation/pwsh/pester-testing.md) — the language layer: the mock idioms, test-file conventions, and engine gotchas
- [Idempotent state functions](adr/automation/idempotent-state-functions.md) — re-runs are always safe
- [Sensible defaults](adr/automation/sensible-defaults.md) — the zero-arg call does the right thing
- [Parameter design](adr/automation/pwsh/parameter-design.md) — the pwsh rules: positional primary argument, switches over booleans
- [Console output matters](adr/automation/console-output-matters.md) — every line of output is a UX decision
- [Error handling](adr/automation/pwsh/error-handling.md) — fail immediately, no warnings, no middle ground
- [Never depend on $PWD](adr/automation/never-depend-on-pwd.md) — functions work from anywhere
- [Working-directory mechanics](adr/automation/pwsh/working-directory-mechanics.md) — the pwsh rules: the anchors, and
  Push-Location/Pop-Location

### Implementation decisions

- [The pwsh engine](adr/automation/pwsh/pwsh-engine.md) — PowerShell 7.4+, strict mode in every scope, one dot-sourced importer
- [One function per file](adr/automation/pwsh/one-function-per-file.md) — makes discovery automatic and eliminates export ceremony
- [Use .ps1 not .psm1](adr/automation/pwsh/use-ps1-not-psm1.md) — shared scope without boilerplate loaders
- [Approved verbs](adr/automation/pwsh/respect-pwsh-verb-rules.md) — enforced naming so functions are self-documenting
- [Spell out names](adr/automation/spell-out-names.md) — no invented abbreviations
- [Identifier names](adr/automation/pwsh/identifier-names.md) — the pwsh rules: the analyzer rule that checks every variable and noun
- [Uniform formatting](adr/repository/uniform-formatting.md) — the whole repo, one mechanical standard
- [PowerShell formatting](adr/automation/pwsh/powershell-formatting.md) — the pwsh rules over uniform-formatting
- [Log before invoke](adr/automation/log-before-invoke.md) — automatic, not opt-in
- [Vendor dependencies](adr/automation/pwsh/vendor-toolset-dependencies.md) — determinism without a restore step, no gallery at runtime
- [Controlling system-wide deps](adr/automation/controlling-systemwide-deps.md) — version-locked, platform-aware, no container required
- [Effective in enterprises](adr/automation/effective-in-enterprises.md) — no admin required
- [Module-path hygiene](adr/automation/pwsh/module-path-hygiene.md) — the pwsh rules: vendored copies win, network user paths fixed once
- [Prefer Az CLI](adr/azure/prefer-az-cli.md) — avoids assembly hell, no module ceremony
- [Dry run](adr/automation/dry-run.md) — an explicit dry-run parameter on every side-effecting function
- [Prefer -DryRun over ShouldProcess](adr/automation/pwsh/prefer-dryrun-over-shouldprocess.md) — the pwsh rules: an explicit switch beats
  the un-testable, easy-to-misuse -WhatIf/-Confirm subsystem
- [Conventional folders](adr/repository/conventional-folders.md) — predictable layout for the whole repository: root folders, modules,
  tests, assets, and output
- [Dedicated output directory](adr/repository/dedicated-output-directory.md) — all generated artifacts go to `out/`
- [Environment variables](adr/automation/environment-variables.md) — when and how to use them
- [Environment-variable mechanics](adr/automation/pwsh/environment-variable-mechanics.md) — the pwsh rules: scoping, runspaces, test
  isolation
- [Cross-platform](adr/automation/cross-platform.md) — runs on Windows, Linux, and macOS
- [Cross-platform PowerShell](adr/automation/pwsh/cross-platform-powershell.md) — the language layer: Join-Path, compatible cmdlets,
  platform guards
- [Script-scope caching](adr/automation/pwsh/script-scope-caching.md) — the pwsh rules under [caching](adr/automation/caching.md):
  `$script:` cache entries, mock-the-whole-function
- [Avoid deep nesting](adr/automation/avoid-deep-nesting.md) — flat code is readable code
- [Avoid using semicolons](adr/automation/pwsh/avoid-using-semicolons.md) — one statement per line
- [Prefer foreach over ForEach-Object](adr/automation/pwsh/prefer-foreach-over-foreach-object.md) — clarity and debuggability
- [Automatic variable pitfalls](adr/automation/pwsh/automatic-variable-pitfalls.md) — `$?`, `$_`, `$LASTEXITCODE` and their traps
- [Use proper package managers](adr/automation/use-proper-package-managers.md) — system tools via native package managers
- [Hosting C# types](adr/automation/pwsh/hosting-csharp-types.md) — the pwsh rules under native C# types: Add-Type, accelerators, stale
  types

### SOLID principles that don't apply

- **Liskov Substitution (L)** — LSP governs subtype hierarchies. This platform has no class hierarchies or subtype relationships.
- **Interface Segregation (I)** — ISP targets fat interfaces. PowerShell functions don't implement interfaces. The public/private split
  handles surface area.
- **Dependency Inversion (D)** — DIP requires a formal abstraction boundary. `Assert-Command` and `Invoke-Executable` provide light
  indirection, but not a formal abstraction layer.

### DRY and KISS

- **KISS** — This is [zero ceremony, hard to fail](adr/automation/zero-ceremony-poka-yoke.md). The foundational ADR's first test — "Does
  this add ceremony?" — is the KISS test.
- **DRY** — Enforced structurally: [dynamic module manifests](adr/automation/pwsh/dynamic-module-manifests.md) eliminate manifest
  duplication, [sensible defaults](adr/automation/sensible-defaults.md) pull versions from config,
  [one function per file](adr/automation/pwsh/one-function-per-file.md) makes the file name the export name.

## Pipeline ADRs

How Azure DevOps pipelines interact with the catzc commands.

- [Pipeline runner pattern](adr/flow/pipeline-runner-pattern.md) — all pipeline steps invoke PowerShell through a single runner
- [Custom template discipline](adr/ado/custom-template-discipline.md) — when and how to use ADO templates
- [Pipeline variables](adr/ado/pipeline-variables.md) — setting ADO output variables from PowerShell
- [Pipeline detection](adr/flow/pipeline-detection.md) — how functions adapt to pipeline vs. local context
- [Dual authentication](adr/ado/dual-authentication.md) — pipeline system token vs. local Az token

## Terminology

- **catzc** — the reserved, source-code-level name: the `Catzc.*` module prefix, the C# `Catzc.*` namespaces, the `Catzc.` type-accelerator
  prefix, and the literal product token.
- **cats** (plural) — the conversational cover term for the catzc system as a whole, used in prose and docs and when talking to or about the
  system ("ask cats"). It stands in for the complicated, code-level catzc.

## Other

- [FAQ](how-to/getting-started/automation/faq.md) — common questions about the module system
