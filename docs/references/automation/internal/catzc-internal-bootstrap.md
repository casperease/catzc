# Catzc.Internal.Bootstrap

The import-time engine. It does the heavy lifting the [Importer overlay](catzc-internal-importer.md) delegates to: discovering the modules
on disk, generating each module's manifest, compiling and loading every module's native C# types into one assembly, and guarding against
function-name collisions — all before any `automation/*` module's functions exist. It is **transient**: loaded early and removed at the tail
of `Invoke-Importer`, so its import-time functions do not linger in the session. Its console writer, `Write-ImporterMessage`, is what the
whole importer routes output through, because the module system's own `Write-Message` is not loaded yet.

## What it does

Bootstrap is the part of the load sequence that turns a folder of `.ps1` files into imported modules with working C# types:

- **Module discovery and import** — `Import-AllModules` enumerates the non-dot module directories under the automation root, runs the
  name-collision guard, removes any stale previously-loaded modules (leaving the vendored and `.internal` modules alone), compiles and loads
  the combined C# type assembly once, then for each module generates its manifest and imports it. Import order is irrelevant because the
  types are already loaded, so a function in any module can reference a type in any other.
- **Manifest generation** — `New-DynamicManifest` scans a module folder for `.ps1` files (root files are public, `private/` files are
  private, `.Tests.ps1` excluded), and writes a canonical `<Module>.psd1` listing them in `NestedModules` so they share one session state.
  It scans for `.ps1` only — a `.psm1` inside a module folder is silently ignored — which is one of the mechanical enforcements of
  [use-ps1-not-psm1](../../../adr/automation/powershell/use-ps1-not-psm1.md). `Get-DynamicManifestContent` renders the manifest text: the
  `=` column is computed from the longest key rather than hand-padded, endings are LF, and the output is formatter-stable — running the
  formatter over it is a no-op — so the bytes are identical on every platform and every build of a commit
  ([ADR-REPO-FORMAT#1](../../../adr/repository/uniform-formatting.md)).
- **C# type compile and load** — `Import-CSharpTypes` compiles every module's `types/*.cs` into one hash-keyed assembly,
  `automation/.compiled/Catzc.Types.<hash>.dll`, so a type in one module can reference a type in another. It keys the assembly off the
  combined source hash from [Catzc.Internal.Types](catzc-internal-types.md) (the same hash the cache janitor uses, so the two can never
  drift), enforces the loader's poka-yokes (a dotted filename or a namespace that does not match the module folder is rejected — the same
  invariant `Test-Types` enforces), loads the committed DLL when its hash matches or compiles fresh through Roslyn once per hash, verifies
  every expected type resolved, and publishes each type's `[PSTypeAlias]` accelerator. On a devbox it degrades gracefully when the live
  types are stale (warn and keep the loaded copy); in CI a stale-types load is a hard failure. The full contract is the
  [native-csharp-types](../../../adr/automation/BCL/native-csharp-types.md) ADR and the [BCL type-system reference](../BCL/types-system.md).
- **Collision guard** — `Assert-UniqueModuleFunctionName` turns PowerShell's silent last-writer-wins command shadowing into a loud, fast
  failure before anything loads. It catches two cases and reports all of them at once: two automation modules exporting the same name, and
  an automation function whose name would shadow an already-imported shipped command (a vendored module, a built-in, or an `.internal`
  module).
- **Pre-import cache wipe** — `Clear-CompiledType` deletes every `automation/.compiled/*.dll` before modules load, so the
  `-ClearCompiledTypes` switch forces a rebuild from source. It is best-effort (a locked DLL is skipped) and distinct from the post-import
  `Clear-ModuleTypeCache` janitor, which keeps the current build and self-skips in CI.

## Functions

The exported surface the importer calls:

- `Import-AllModules` — discover, guard, and import every `automation/*` module, compiling the combined C# type assembly first.
- `Write-ImporterMessage` — the `[Importer.ps1]`-prefixed console writer the whole importer uses before `Write-Message` is available.
- `Clear-CompiledType` — delete the compiled type DLLs before import so the types rebuild from source (`-ClearCompiledTypes`).

The module-internal engine `Import-AllModules` drives (not exported):

- `New-DynamicManifest` — generate a module's canonical `<Module>.psd1` from its `.ps1` files.
- `Get-DynamicManifestContent` — render the manifest hashtable as canonical, formatter-stable `.psd1` text.
- `Import-CSharpTypes` — compile and load every module's `types/*.cs` into the one hash-keyed `Catzc.Types.<hash>.dll`.
- `Assert-UniqueModuleFunctionName` — fail the import on a duplicate or shadowing exported function name.

## Related

- ADR: [use-ps1-not-psm1](../../../adr/automation/powershell/use-ps1-not-psm1.md) — `New-DynamicManifest` scanning only `.ps1` is the
  enforcement; Bootstrap is itself a sanctioned `.psm1`.
- ADR: [native-csharp-types](../../../adr/automation/BCL/native-csharp-types.md) and [caching](../../../adr/automation/caching.md) — the one
  combined assembly, its committed prebuild, and the hash key `Import-CSharpTypes` loads by.
- ADR: [uniform-formatting](../../../adr/repository/uniform-formatting.md) — the canonical, hand-alignment-free manifest text.
- Reference: [Catzc.Internal.Types](catzc-internal-types.md) — the shared hash; the [BCL type-system reference](../BCL/types-system.md);
  [Catzc.Base.ModuleSystem](../catzc-base-modulesystem.md) — the post-import dependency-graph check over the same modules; the
  [internal area overview](index.md).
