# ADR: Use .ps1 for function files, not .psm1

## Rules: ADR-PWSH-USEPS

### Rule ADR-PWSH-USEPS-SCRIPTFILESFORFUNCTIONS

Use `.ps1` for all module function files — dot-sourced into the module's session state by the module's loader, they share it, so public and
private functions see each other without imports.

- [Decision](#decision)
- [Source and the generated build](#source-and-the-generated-build)

### Rule ADR-PWSH-USEPS-MODULEFILESRESERVED

Reserve `.psm1` for genuine module or standalone files only — the `pwsh/.internal/*.psm1` shared modules, the `pwsh/.scriptanalyzer/*.psm1`
analyzer rules, the `PrePost.psm1` starter, and per-template `PrePost.psm1`, the only `.psm1` under `infrastructure/` — never for a
per-function file inside a module. All other PowerShell code is in `.ps1` files.

- [Decision](#decision)
- [How this is enforced](#how-this-is-enforced)

## Context

We use a one-function-per-file layout with public/private separation by folder. Public functions need to call private functions without the
author adding any imports or boilerplate. This requires all function files within a module to share the same scope.

### Why `.psm1` does not fit

**The `.psm1` extension exists to create a scope boundary.** That is its entire purpose versus a plain `.ps1` file. Each `.psm1` loaded via
`NestedModules` in a manifest gets its own isolated module scope — by design, not by accident.

Microsoft designed `NestedModules` with `.psm1` files for **dependency composition** — independent sub-libraries (like referencing a NuGet
package), each encapsulated in a scope of its own, with controlled exports. This works well for that purpose.

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

- The `pwsh/.internal/*.psm1` shared modules — `Catzc.Internal.Loader` (the always-loaded entry point that provides
  `Import-InternalModule`), `Catzc.Internal.Importer` (the load sequence, `Invoke-Importer`), `Catzc.Internal.Bootstrap` (module discovery
  and loading: `Import-AllModules`, `New-DynamicManifest`, `Import-CSharpTypes`), `Catzc.Internal.Vendor` (`Import-VendorModules`),
  `Catzc.Internal.TestKit` (an on-demand Pester fixture library), and `Catzc.Internal.Types`.
- The custom PSScriptAnalyzer rule modules under `pwsh/.scriptanalyzer/` (e.g. `FunctionLength.psm1`, `VariableCasing.psm1`) — standalone
  analyzer rule modules, not module function files.
- Per-template `PrePost.psm1` files (the `Catzc.Azure.Templates/assets/PrePost.psm1` starter and any
  `infrastructure/templates/<name>/PrePost.psm1`) — see [`prepost-extension-modules`](prepost-extension-modules.md).

None of these are per-function files within a module, so the rule above is intact: a module's function files are always `.ps1`.

### Source and the generated build

The toolset runs in two modes ([run-modes](../design/run-modes.md)). In source mode the generated manifest lists every `.ps1` function file
of a module in its `PrivateData`, and its one `NestedModules` entry, the shared loader `pwsh/.internal/assets/Import-ModuleFiles.ps1`,
parses each file in memory and dot-sources it into the module's session state
([dynamic-module-manifests](dynamic-module-manifests.md#regenerated-manifests)). In build mode `Build-Modules` concatenates the same files —
`private/` first, then the root, each in ordinal order and each preceded by a `# source:` marker line naming its source path — into one
`<Module>.functions.ps1`, and the built manifest lists that one file
([dynamic-module-manifests](dynamic-module-manifests.md#rule-adr-pwsh-manifest-bundlecarriesmanifests)). The merged file is a `.ps1` too, so
the module's public and private functions share one session state in both modes, and it is one module per folder, so each module keeps its
own `$script:` scope. It is output, not source: it exists only in a build under `out/pwsh/built/` and the installs copied from it, is
rewritten on every build, and the rules of this ADR apply to the files it is generated from
([one-function-per-file](one-function-per-file.md#rule-adr-pwsh-onefunc-governssource)).

### How this is enforced

- **Bootstrap module** — `New-DynamicManifest` only scans for `*.ps1` files. Any `.psm1` file inside a module folder is silently ignored.
- **`Test-Automation.Tests.ps1`** — only discovers `.ps1` files for validation, reinforcing that `.psm1` is not used for function files.
- **`Build-Modules`** — reads only the source `.ps1` function files, writes the merged `<Module>.functions.ps1` under
  `out/pwsh/built/<bundle>/`, and `Assert-CatzcBundle` checks that every built module has its manifest and its one merged file.

## Consequences

- Function files use `.ps1` extension: `Get-Foo.ps1`, not `Get-Foo.psm1`
- `New-DynamicManifest` lists a module's `.ps1` files for the shared loader, which dot-sources each into the module's session state
- One shared loader for every source module, itself a `.ps1` run as the manifest's nested script — no per-module `.psm1`
- Private functions are automatically available to public functions
- Aligns with the established PowerShell community convention
- The installed build carries one generated `.ps1` per module with the same shared-scope semantics, so the source and the build load the
  same way
