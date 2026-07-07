# ADR: PrePost extension modules

## Rules: ADR-PREPOST

### Rule ADR-PREPOST:1

`PrePost.psm1` is the only `.psm1` allowed under `infrastructure/`. Under `automation/`, `.psm1` is reserved for genuine module/standalone
files (the `automation/.internal/*.psm1` shared modules, the analyzer rule modules, the PrePost starter); all other PowerShell uses `.ps1`.

- [Why this does not conflict with `use-ps1-not-psm1`](#why-this-does-not-conflict-with-use-ps1-not-psm1)
- [Why a single `.psm1` (not three `.ps1` files)](#why-a-single-psm1-not-three-ps1-files)

### Rule ADR-PREPOST:2

`Catzc.Azure.Templates/assets/PrePost.psm1` is a starter reference, not loaded by any code. It is one of the few `.psm1` files under
`automation/`, but it is data authors copy, not an imported module.

- [`assets/PrePost.psm1` is a copy-in starter, not a loaded default](#assetsprepostpsm1-is-a-copy-in-starter-not-a-loaded-default)

### Rule ADR-PREPOST:3

The file name is exactly `PrePost.psm1` at the template-folder root. Discovery in `Get-BicepTemplates` looks for that exact filename.

- [Where per-template hooks live — `infrastructure/templates/<name>/PrePost.psm1`](#where-per-template-hooks-live--infrastructuretemplatesnameprepostpsm1)

### Rule ADR-PREPOST:4

A template's `PrePost.psm1` may export any subset of the three hooks. Hooks it does not export are no-ops (skipped) — there is no
fall-through to a default.

- [Where per-template hooks live — `infrastructure/templates/<name>/PrePost.psm1`](#where-per-template-hooks-live--infrastructuretemplatesnameprepostpsm1)

### Rule ADR-PREPOST:5

`Build-Bicep` / `Deploy-Bicep` import the template's module with `Import-Module -Scope Local -Force -PassThru` and invoke each hook only if
it appears in the module's `ExportedCommands`.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PREPOST:6

`Build-Bicep` copies the per-template `PrePost.psm1` into the build output so `Deploy-Bicep` can re-import it from the artifacts folder on a
pipeline agent, where `Get-BicepDeploymentContext` re-keys its path into `ctx.artifacts.prepost_module`.

- [How this is enforced](#how-this-is-enforced)

## Context

`Catzc.Azure.Templates` provides three optional hooks a template can ship to customize the build/deploy flow:

- **`Invoke-BicepPrepareParameterSet`** — build-time. Merges global config (`Get-Config -Config azure` etc.) into the per-slot parameter set
  before rendering `parameters.<slot>.json`. The deliberate seam between the two config layers.
- **`Invoke-BicepPreDeploy`** — pre-deploy. State-changing prep (create queues, fetch key-vault material) and readiness checks.
- **`Invoke-BicepPostDeploy`** — post-deploy. Fixups (e.g. Functions runtime settings) and verification.

### Hook arguments — an invocation collection, not raw scalars

Each hook receives the build/deploy invocation as a **single collection**, plus the computed descriptor objects. The invocation collection
carries the _arguments the operation is acting on_ — so adding a dimension (customer, mode, …) is a new key, never a new parameter on every
hook:

- **prepare** → `-BuildInvocation` = `@{ Template; Environment; Slot; Subscription; Customer }` · `-TemplateDescriptor` ·
  `-ConfigurationDescriptor`. (Build is mode-agnostic — it only renders parameter files.) `Subscription` is the config folder being built;
  `Customer` is derived from it.
- **preDeploy** → `-DeployInvocation` = `@{ Template; Environment; Slot; Subscription; Customer; Mode }` · `-TemplateDescriptor` ·
  `-ConfigurationDescriptor` · `-EnvironmentDescriptor` · `[switch] -DryRun`.
- **postDeploy** → the preDeploy set (minus `-DryRun`) · `-DeploymentOutput`.

The descriptor/result objects (`TemplateDescriptor`, `ConfigurationDescriptor`, `EnvironmentDescriptor`, `DeploymentOutput`) stay their own
parameters — they are computed results, not invocation arguments. **`-DryRun` is also its own first-class parameter, not a collection key**
— it is the side-effect kill switch, too important to hide in a bag. A state-changing preDeploy hook **must honor `-DryRun`** (return
without mutating on a preview); Deploy-Bicep runs preDeploy before its own `--what-if` branch, so the hook owns that guard. PostDeploy never
runs on a preview, so it takes no `-DryRun`.

The hooks are **opt-in per template, and there are no defaults**. A template that needs none ships no `PrePost.psm1`; a template that needs
one ships a single `infrastructure/templates/<name>/PrePost.psm1` exporting any subset of the three. When a hook is not provided, the
corresponding step is simply skipped — the _code_ supplies the no-op, not a loaded default.

The shape used for a template's PrePost is **one `.psm1` file containing the hooks it overrides**. A starter (`assets/PrePost.psm1`) ships
the canonical shape — three no-op hooks — purely as a copy-in template. This ADR explains both choices.

### Why a single `.psm1` (not three `.ps1` files)

The three hooks are **conceptually grouped**: they form one extension surface that runs the template-specific orchestration around a deploy.
A template that needs to provision a queue in `PreDeploy` almost always wants to tear it down (or verify it) in `PostDeploy`, and frequently
needs to seed parameter values from key-vault material in `Prepare`. Splitting them across three files would scatter related code without
removing any of the coupling.

A single `.psm1` also:

- **Starter matches override 1:1.** The starter (`assets/PrePost.psm1`) and a real per-template override are literally the same shape, so
  authoring is "copy the starter, keep the hook(s) you need, delete the rest." No translation between "starter style" and "override style".
- **Atomic copy-in unit.** "Copy the template + its `PrePost.psm1`." No need to remember which subset of three files is shipped.
- **Private helpers between hooks.** The override can share script-scoped functions or parameter shaping between the three hooks without
  exporting them.
- **One well-defined import target.** `Import-Module <path>` once, regardless of which hooks the template provides. The discovery and
  invocation logic in `Build-Bicep` / `Deploy-Bicep` is one path, not three.
- **Mirrors the source.** Eases the manual copy-in step for a template that ships as a single `.psm1`.

### `assets/PrePost.psm1` is a copy-in starter, not a loaded default

`assets/PrePost.psm1` sits in the module's `assets/` folder next to `azure.yml`. It is **not loaded or called by any production code** — it
exists only as the canonical shape an author copies to `infrastructure/templates/<name>/PrePost.psm1`. Its three hooks are no-ops: a
starting point to edit, not a runtime default. (Tests that exercise the starter import it explicitly.)

There is deliberately **no default hook** loaded into the module's session state. Loading a default at module-init would couple production
code to an asset module, put the asset on the call graph, and make the build/deploy functions call hook names that resolve only at runtime.
The only PrePost code that ever runs is a template's own.

### Where per-template hooks live — `infrastructure/templates/<name>/PrePost.psm1`

A template that needs a hook ships one file:

```text
infrastructure/templates/<template>/
  main.bicep
  options.yml
  configuration/<slot>.yml
  PrePost.psm1                ← any subset of the three hooks
```

`Build-Bicep` and `Deploy-Bicep` detect this file via `Get-BicepTemplates` (the `prepost_module` key on template metadata), import it with
`Import-Module -Scope Local -PassThru`, and invoke **only the hooks it actually exports**, resolved from the module's `ExportedCommands`. A
hook the module does not export — or a template with no `PrePost.psm1` at all — is skipped (the step no-ops in code).

Invoking through the module's exported command object (rather than a bare `Invoke-Bicep*` call) keeps the call dynamic: production code
under `automation/` contains **no reference** to hook functions that live only in template folders, so static analysis
(`Test-FunctionDependency`) stays clean.

Per-template modules do NOT live under `automation/` and are NOT loaded by the bootstrap module. They are loaded on demand. The `.psm1`
extension is exactly the right tool: an isolated scope that can be cleanly imported, expose any subset of three exports, and be discarded.

### Why this does not conflict with `use-ps1-not-psm1`

[`use-ps1-not-psm1`](use-ps1-not-psm1.md) governs **function files inside `automation/`** that declare the module's regular per-function
exports. Its goal is shared scope across one module's internals.

Neither `assets/PrePost.psm1` nor `infrastructure/templates/<name>/PrePost.psm1` is a "function file inside an `automation/` module":

- The asset is a **reference file** (a starter shipped as a module). It is never imported by production code — only copied by authors — and
  is not auto-scanned as a `.ps1`.
- The per-template module lives **outside `automation/`** entirely, in `infrastructure/`.

The `use-ps1-not-psm1` "shared scope across module internals" use case and this ADR's "isolated extension point loaded on demand" use case
have different scope requirements. The two ADRs apply in different parts of the repo and do not contradict each other.

### Why not three separate `.ps1` files

A three-`.ps1` shape would break the atomic copy-in unit and the starter-matches-override symmetry, forcing an author to assemble three
files instead of editing one. The single-`.psm1` form is what authors actually copy.

## Decision

A template's PrePost hooks live in **one `.psm1` file** at `infrastructure/templates/<name>/PrePost.psm1`, exporting any subset of:

- `Invoke-BicepPrepareParameterSet`
- `Invoke-BicepPreDeploy`
- `Invoke-BicepPostDeploy`

There are **no default hooks**. `assets/PrePost.psm1` is a copy-in starter only — never loaded or called by code.

### How this is enforced

- `Get-BicepTemplates` reads `PrePost.psm1` at the template root if present and surfaces its path as `prepost_module` on the template
  metadata; absence is fine.
- `Build-Bicep` imports the module (if present), resolves `Invoke-BicepPrepareParameterSet` from its `ExportedCommands`, and calls it per
  slot; with no hook it uses the per-slot config unchanged.
- `Deploy-Bicep` does the same with the artifacts-folder copy for the pre/post hooks; absent hooks are skipped.
- No module-init loads the starter, and no production code references the hook names by bareword (they are invoked via the exported command
  object), so `Test-FunctionDependency` reports no unresolved calls.

## Consequences

- A template with no special needs ships zero PowerShell — just `main.bicep`, `options.yml`, and `configuration/<slot>.yml`. No hook runs,
  which is correct.
- A template that needs a hook adds **one file** (`PrePost.psm1`), copied from `automation/Catzc.Azure.Templates/assets/PrePost.psm1`,
  keeping the hooks it needs. No central registry, no manifest, no import wiring.
- Production code never depends on the asset module: the only PrePost code that runs is a template's own. The asset is pure reference data.
- The `.psm1` extension is reserved for narrow, well-defined uses — never for a module's function files: the `.internal` shared modules
  (`automation/.internal/*.psm1`), the custom PSScriptAnalyzer rule modules (`automation/.scriptanalyzer/*.psm1`), the PrePost starter
  (`automation/Catzc.Azure.Templates/assets/PrePost.psm1`, a copy-in reference), and per-template extension points
  (`infrastructure/templates/<template>/PrePost.psm1`).
- Future extension points of the same shape (a small group of related hooks loaded on demand from a consumer-supplied module) can reuse this
  pattern: a starter file plus a per-consumer module, invoked only when present.

## Dora explains

DORA's research connects loosely coupled architectures to faster delivery and better team autonomy. A single, clearly-defined extension
point for per-template hooks allows teams to customize deployments without scattered code or central orchestration.

- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — clear extension points enable independent template
  customization.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — grouped hooks in one .psm1 avoid scattered, duplicated code.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
