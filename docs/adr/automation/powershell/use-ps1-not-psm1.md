# ADR: Use `.ps1` for function files, not `.psm1`

## Rules: ADR-USEPS

### Rule ADR-USEPS:1

Use `.ps1` for all module function files — listed in the manifest's `NestedModules`, they share the module's session state, so public and
private functions see each other without imports.

- [Decision](#decision)

### Rule ADR-USEPS:2

Reserve `.psm1` for genuine module or standalone files only — the `automation/.internal/*.psm1` shared modules, the
`automation/.scriptanalyzer/*.psm1` analyzer rules, and per-template `PrePost.psm1` — never for a per-function file inside a module.

- [Decision](#decision)
- [How this is enforced](#how-this-is-enforced)

## Context

We use a one-function-per-file layout with public/private separation by folder. Public functions need to call private functions without the
author adding any imports or boilerplate. This requires all function files within a module to share the same scope.

### What we learned

**The `.psm1` extension exists to create a scope boundary.** That is its entire purpose versus a plain `.ps1` file. Each `.psm1` loaded via
`NestedModules` in a manifest gets its own isolated module scope — by design, not by accident.

Microsoft designed `NestedModules` with `.psm1` files for **dependency composition** — independent sub-libraries (like referencing a NuGet
package), each with their own encapsulated scope and controlled exports. This works well for that purpose.

Our use case is different: we want **code organization** — splitting one module's internals across files. For this, scope isolation is
harmful:

- A private helper in one `.psm1` is invisible to a public function in another `.psm1` unless explicitly exported (which defeats "private")
- Module-scoped variables (`$script:`) are isolated per `.psm1`
- Sharing state between nested `.psm1` files requires `$global:` (a code smell)

### Established community pattern

The standard PowerShell community pattern is:

- Individual functions live in `.ps1` files (no scope boundary)
- A single root `.psm1` dot-sources all `.ps1` files into one shared scope
- Public/Private folder convention controls exports
- `.ps1` files in a manifest's `NestedModules` run in the module's session state (shared scope), unlike `.psm1` files which get isolated
  scope

This pattern is used by dbatools, PSFramework, and Microsoft's own modules. Build tools like Plaster, Stucco, and ModuleBuilder implement
it, and Microsoft's official documentation endorses it.

## Decision

Use `.ps1` for all function files. Reserve `.psm1` for genuine module or standalone files — never for a per-function file inside a module.
The sanctioned `.psm1` files are:

- The `automation/.internal/*.psm1` shared modules — `Catzc.Internal.Loader` (the always-loaded entry point that provides
  `Import-InternalModule`), `Catzc.Internal.Bootstrap` (module discovery and loading: `Import-AllModules`, `New-DynamicManifest`,
  `Import-VendorModules`, `Import-CSharpTypes`), `Catzc.Internal.TestKit` (an on-demand Pester fixture library), and `Catzc.Internal.Types`.
- The custom PSScriptAnalyzer rule modules under `automation/.scriptanalyzer/` (e.g. `FunctionLength.psm1`, `VariableCasing.psm1`) —
  standalone analyzer rule modules, not module function files.
- Per-template `PrePost.psm1` files (the `Catzc.Azure.Templates/assets/PrePost.psm1` starter and any
  `infrastructure/templates/<name>/PrePost.psm1`) — see [`prepost-extension-modules`](prepost-extension-modules.md).

None of these are per-function files within a module, so the rule above is intact: a module's function files are always `.ps1`.

### How this is enforced

- **Bootstrap module** — `New-DynamicManifest` only scans for `*.ps1` files. Any `.psm1` file inside a module folder is silently ignored.
- **`Test-Automation.Tests.ps1`** — only discovers `.ps1` files for validation, reinforcing that `.psm1` is not used for function files.

## Consequences

- Function files use `.ps1` extension: `Get-Foo.ps1`, not `Get-Foo.psm1`
- `New-DynamicManifest` lists `.ps1` files in `NestedModules` — they share the module's session state natively
- No `_loader.psm1` workaround needed — manifest-only solution
- Private functions are automatically available to public functions
- Aligns with the established PowerShell community convention

## Dora explains:

DORA research shows that aligning code structure with established community patterns improves maintainability and reduces onboarding
friction. Using .ps1 files for module functions eliminates scope isolation and boilerplate, letting developers focus on logic rather than
module plumbing.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — shared scope eliminates boilerplate and scope isolation
  overhead.
- [Documentation quality](https://dora.dev/capabilities/documentation-quality/) — established patterns reduce onboarding friction.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
- `.psm1` remains in use only for genuine module/standalone files, never for a module's function files: the `automation/.internal/*.psm1`
  shared modules (loader, bootstrap, TestKit, types), the `automation/.scriptanalyzer/*.psm1` custom analyzer rule modules, and per-template
  `PrePost.psm1` files (see [`prepost-extension-modules`](prepost-extension-modules.md))
