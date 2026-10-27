# pwsh/.internal/Catzc.Internal.Bootstrap.psm1

The import-time engine. It does the heavy lifting the Importer overlay (`Catzc.Internal.Importer`) delegates to: discovering the modules on
disk, generating each module's manifest, compiling and loading every module's native C# types into one assembly, and guarding against
function-name collisions — all before any `pwsh/*` module's functions exist. It is **transient**: loaded early and removed at the tail of
`Invoke-Importer`, so its import-time functions do not linger in the session. The console writer the whole importer routes output through,
`Write-ImporterMessage`, lives in the resident loader, so a line printed after the import still reaches it.

## What it does

Bootstrap is the part of the load sequence that turns a folder of `.ps1` files into imported modules with working C# types:

- **Module discovery and import** — `Import-AllModules` enumerates the non-dot module directories under the automation root, runs the
  name-collision guard, removes any stale previously-loaded modules (leaving the vendored and `.internal` modules alone), compiles and loads
  the combined C# type assembly once, then for each module generates its manifest and imports it. Import order is irrelevant because the
  types are already loaded, so a function in any module can reference a type in any other.
- **Manifest generation** — `New-DynamicManifest` scans a module folder for `.ps1` files (root files are public, `private/` files are
  private, `.Tests.ps1` excluded), and writes a canonical `<Module>.psd1` that lists them in `PrivateData.CatzcFiles` and names the shared
  loader `assets/Import-ModuleFiles.ps1` as its one `NestedModules` entry: the loader parses each file in memory and dot-sources it into the
  module, so they share one session state and keep their source file and line. It scans for `.ps1` only — a `.psm1` inside a module folder
  is silently ignored — which is one of the mechanical enforcements of [use-ps1-not-psm1](../../../drs/automation/pwsh/use-ps1-not-psm1.md).
  `Get-DynamicManifestContent` renders the manifest text: the `=` column is computed from the longest key rather than hand-padded, endings
  are LF, and the output is formatter-stable — running the formatter over it is a no-op — so the bytes are identical on every platform and
  every build of a commit ([ADR-REPO-FORMAT-TOOLSFORMAT](../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-toolsformat)).
- **C# type compile and load** — `Import-CSharpTypes` compiles every module's `types/*.cs` into one hash-keyed assembly,
  `pwsh/.compiled/Catzc.Types.<hash>.dll`, so a type in one module can reference a type in another. It keys the assembly off the combined
  source hash from `Catzc.Internal.Types` (the same hash the cache janitor uses, so the two can never drift), enforces the loader's
  poka-yokes (a dotted filename or a namespace that does not match the module folder is rejected — the same invariant the `Test-Formatting`
  gate checks through `Format-Types`), loads the committed DLL when its hash matches or compiles fresh through Roslyn once per hash,
  verifies every expected type resolved, and publishes each type's `[PSTypeAlias]` accelerator. On a devbox it degrades gracefully when a
  live type changed or was removed (warn and keep the loaded copy), and fails fast when a type was added since load; in CI a stale-types
  load is a hard failure. The full contract is the [native-csharp-types](../../../drs/automation/BCL/native-csharp-types.md) ADR and the BCL
  type-system reference (`docs/references/BCL/types-system.md`).
- **Collision guard** — `Assert-UniqueModuleFunctionName` turns PowerShell's silent last-writer-wins command shadowing into a loud, fast
  failure before anything loads. It catches two cases and reports all of them at once: two catzc modules exporting the same name, and an
  automation function whose name would shadow an already-imported shipped command (a vendored module, a built-in, or an `.internal` module).
- **Pre-import cache wipe** — `Clear-CompiledType` deletes every `pwsh/.compiled/*.dll` before modules load, so the `-ClearCompiledTypes`
  switch forces a rebuild from source. It is best-effort (a locked DLL is skipped) and distinct from the post-import `Clear-ModuleTypeCache`
  janitor, which keeps the current build and self-skips in CI.

## Manifest details

- **Read-only load** — a bundle is a read-only install, so `-ReadOnly` never generates or writes a manifest: it must already be present
  (`Build-Modules` pre-generates every module's manifest) and its path is returned.
- **Explicit lists** — a module that is not one function per file passes `-NestedModule` (relative to the module folder, forward slashes, in
  load order) and `-FunctionToExport` together, and the folder is not enumerated. `-ExportPrivates` exports every function (`'*'`).
- **Determinism** — the shared loader (the manifest's one nested module, `../.internal/assets/Import-ModuleFiles.ps1`, since a module folder
  sits directly under the modules root beside `.internal`) dot-sources each listed `.ps1` into the module's session state in list order.
  Private functions group first, then public; each group is ordinal-sorted and its paths use forward slashes, so the emitted manifest is
  byte-identical on every platform and every build of the same commit.
- **Write only on change** — `Write-DynamicManifest` writes the rendered text only when it differs, so an unchanged module yields identical
  bytes and no write, and parallel workers never race on the manifest files. The L2 tests guard the canonical form.
- **Private-function folder** — `Get-PrivateFunctionFolder` is the pre-types reader of the powershell layout's private-function row in
  `languages.yml`; once types load, `LanguagesConfig.FolderOf` reads the same row
  ([ADR-REPO-FOLDERS-NAMESARESETTINGS](../../../drs/repository/conventional-folders.md#rule-adr-repo-folders-namesaresettings)).

## Collision guard details

The guard checks two cases. The first is two catzc modules exporting one name (with `-ExportPrivates`, the `private/` functions join the
check). The second is a module function shadowing an already-imported **shipped** command. Shipped means a command that loads before the
catzc modules and would be silently shadowed by their `-Scope Global` import: a built-in (under `$PSHOME`), a vendored module (under
`.vendor/`), or an `.internal` shared module. The `.internal` modules sit directly in their folder, so their `ModuleBase` ends at
`.internal` with no trailing separator, and the match covers that too. Scoping the check to shipped commands by module path means a user's
unrelated session module never blocks the import, and catzc's own modules (current, or stale on a devbox re-import) are excluded naturally,
since their base is none of those.

`Get-ForeignCatzcModule` returns every loaded catzc module that does not come from a given code root (`-IncludeInternal` adds the
`Catzc.Internal.*` loader modules, which belong to a root through its `.internal` folder). The package module also belongs when its
`ModuleBase` is the root's parent, since its code root is `pwsh/`.

## Functions

The exported surface the importer calls:

- `Import-AllModules` — discover, guard, and import every `pwsh/*` module, compiling the combined C# type assembly first.
- `Clear-CompiledType` — delete the compiled type DLLs before import so the types rebuild from source (`-ClearCompiledTypes`); unlike
  `Clear-ModuleTypeCache` it wipes every build in any context, skipping only locked DLLs.
- `Get-ForeignCatzcModule` — list the loaded catzc modules that do not come from the given code root.

The module-internal engine `Import-AllModules` drives (not exported):

- `New-DynamicManifest` — generate a module's canonical `<Module>.psd1` from its `.ps1` files, and return its path.
- `Write-DynamicManifest` — write rendered manifest text to its `.psd1` only when it differs.
- `Get-DynamicManifestContent` — render the manifest hashtable as canonical, formatter-stable `.psd1` text.
- `Get-PrivateFunctionFolder` — read the private-function folder name from the languages config before types load.
- `Import-CSharpTypes` — compile and load every module's `types/*.cs` into the one hash-keyed `Catzc.Types.<hash>.dll`.
- `Assert-UniqueModuleFunctionName` — fail the import on a duplicate or shadowing exported function name.

## Related

- ADR: [use-ps1-not-psm1](../../../drs/automation/pwsh/use-ps1-not-psm1.md) — `New-DynamicManifest` scanning only `.ps1` is the enforcement;
  Bootstrap is itself a sanctioned `.psm1`.
- ADR: [native-csharp-types](../../../drs/automation/BCL/native-csharp-types.md) and [caching](../../../drs/automation/caching.md) — the one
  combined assembly, its committed prebuild, and the hash key `Import-CSharpTypes` loads by.
- ADR: [uniform-formatting](../../../drs/repository/uniform-formatting.md) — the canonical, hand-alignment-free manifest text.
- Reference: `Catzc.Internal.Types` — the shared hash; the BCL type-system reference (`docs/references/BCL/types-system.md`);
  `Catzc.Base.ModuleSystem` — the post-import dependency-graph check over the same modules; the internal area overview.
