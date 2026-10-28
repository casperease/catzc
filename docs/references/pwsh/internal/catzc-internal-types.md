# pwsh/.internal/Catzc.Internal.Types.psm1

The single implementation of the combined C# type-source hash, and of the shared work around the combined types assembly it names. Its core
export, `Get-CombinedTypeHash`, enumerates, orders, and hashes every module's `types/*.cs` exactly the way the committed
`pwsh/.compiled/Catzc.Types.<hash>.dll` is keyed. It lives in `.internal` because two layers must agree on that hash byte-for-byte — the
**loader** (`Import-CSharpTypes` in `Catzc.Internal.Bootstrap`, which builds and keys the DLL) and the **cache janitor**
(`Clear-ModuleTypeCache`, a `Catzc` module, which decides which DLLs to keep). The algorithm used to be copied into both and mirrored again
in tests, with a standing "keep them identical" note; it now lives here once and both call it through `Import-InternalModule Types` (see
[one-living-version](../../../drs/principles/one-living-version.md)). It is **resident** — kept in the session, not removed with the
bootstrap.

## What it does

`Get-CombinedTypeHash` takes the automation root and returns, for every non-dot module's `types/*.cs`:

- **`CombinedHash`** — the 8-character lowercase hash that names the DLL (`Catzc.Types.<hash>.dll`), or `$null` when no module ships a C#
  type source;
- **`Snapshot`** — an ordered map of `"<module>/<bare type>"` to that file's per-file digest;
- **`Files`** — the source list, sorted ordinally, that the caller validates and compiles.

Two properties make the key stable and honest. The hash is **EOL-insensitive** — every `CR` byte is stripped before each file's digest — so
a CRLF vs LF working tree (a `git core.autocrlf` setting, an editor's format-on-save) keys the same DLL on every machine and never re-keys
on a pure line-ending flip. And it **folds in each file's `<module>|<bare type>`**, so moving a `.cs` between modules or renaming it re-keys
the assembly even when the content is byte-identical. Ordering is deterministic and culture-independent (an ordinal comparer, not the
culture-aware `Sort-Object`).

What it deliberately does **not** do is validate namespaces or reject dotted filenames — those are the loader's poka-yokes, kept out of the
shared enumerator on purpose, because the janitor must never throw on a source that is malformed. The full contract of the combined assembly
and its committed prebuild is the [native-csharp-types](../../../drs/automation/BCL/native-csharp-types.md) decision record and the BCL
type-system reference (`docs/references/BCL/types-system.md`).

## Loading the assembly

- **Shadow copies** — Windows locks a loaded DLL, so loading in place would pin a superseded build. `Import-TypesAssembly` therefore loads a
  copy from the per-user folder `Get-TypesShadowRoot` names, shared by every session and clone: a copy is named by its source hash, so equal
  names mean equal types. `Get-TypesPruneAfter` bounds pruning by age, so a copy another process just wrote but not yet loaded is not pruned
  under it. `-ShadowCopy $false` loads the file in place, for a system that does not lock a loaded file (`types-load.yml` `shadowCopy`).
  `Get-TypesStampPath` names the memo per modules root, beside the shadow copies.
- **Content check** — `Test-TypesAssemblyContent` reads the assembly into memory and parses it with `System.Reflection.Metadata`, so the
  assembly is never loaded into the process and the file is never locked. A missing expected type throws; a complete assembly returns
  nothing. `Get-TypesAssemblyManifest` reads the same metadata for each public type: its full name, its `PSTypeAlias` names and its
  `ConsoleDisplay` properties (its own, else the nearest base type's in the same assembly); `Write-TypesAssemblyManifest` writes that as
  `Catzc.Types.<hash>.json` beside the assembly, named by the same hash, unless it is already there.
- **Build and drift** — `Build-CombinedTypeAssembly` compiles a frozen copy of the sources into the hash-named assembly without loading it,
  so a save mid-compile cannot make the DLL name differ from its bytes. `Get-LoadedTypeDrift` compares the types loaded in the process with
  a code root's sources: a loaded assembly cannot be swapped in a running process, so a source edited after loading stays stale.
- **Contract** — `Write-TypesContract` writes the types surface (each public type's name, aliases, display and public members) to each
  module group's provided contract, `types.json`, only where the surface moved, each file stamped with the generated head in its json `"//"` property (built in place, since the head function is
  not loaded yet; the schema allows the property, and the drift check reads only `types`); `Get-TypesContractDrift` names how a built assembly differs
  from the committed contracts, and `Get-TypesContractPath` finds a namespace's contract path (it runs in the bootstrap, before the tracks
  can be read). `Save-BurstJournalWrite` records a file a writer is about to write in the journal of the staged burst the process runs in,
  so a failed burst restores exactly what its import wrote; outside a burst it does nothing.

## Load policy and deferral

`Get-TypesLoadPolicy` says whether, when, and how the assembly loads in one mode. A setting resolves in the one fixed order: the caller's
explicit value, else the mode's row in `types-load.yml`, else the default row. Only pwsh can load a C# assembly, so any other engine answers
`Load` `never` without reading the table. The default row and the allowed values live in the module, not on a C# type, because the policy is
read while the types assembly is still unloaded. The host kind defaults to `headless` inside a pipeline and `console` otherwise; the run
mode is passed by the caller, since `Get-CatzcRunMode` is not loaded yet when the importer asks, and defaults to `source`. `-Generation` is
which build of a root the session loads: 1 for the first, more when changed builds stack. Builds stack side by side only in a developer's
interactive session in the source tree; every other cell keeps one.

A lazy load defers the types until a catzc command is first used:

- `Register-DeferredTypes` records a verified assembly as pending (known, not loaded), keyed by code root in a session-global record that
  survives a re-import of this module.
- `Enable-DeferredTypesLoad` makes the first lookup of one of the named commands load the pending types, before the command binds its
  parameters. A guard inside a function is too late, since a typed parameter or an `OutputType` resolves its type before the body runs. The
  hook is filtered by name, so only a catzc command pays for it, and with nothing pending it clears itself.
- `Initialize-Types` loads every pending assembly and registers its accelerators and default display properties from the manifest. It is
  idempotent, and it removes the hook first, since nothing below may re-enter it. Each accelerator takes its type from this build's
  assembly, because a full type name keeps resolving to the first-loaded build.

## Why it is shaped so

- The type-assembly build functions live one per file beside the module and share its scope.
- The shadow folder is shared by every session and clone: a shadow copy is named by its source hash, so equal names mean equal types.
- A build younger than the prune age may be another tree's current one, since every tree's sessions share the shadow folder.
- Windows locks a loaded DLL, so loading in place would pin a superseded build; a load uses a shadow copy.
- `Test-TypesAssemblyContent` reads the metadata only, so the assembly is never loaded into the process and its file is never locked.
- The default load-policy row lives in the module, not on a C# type: the policy is read while the types assembly is still unloaded.
- A load-policy setting resolves in one order: the explicit value, the mode's row, the default row; only pwsh can load an assembly.

## Functions

- `Get-CombinedTypeHash` — the one combined C# type-source hash (with the per-file snapshot and the source list, ordered) that both the
  loader and the cache janitor key the committed `Catzc.Types.<hash>.dll` off.
- `Get-TypeSourceBody` — read the body of one type source file for the hash.
- `Build-CombinedTypeAssembly` — compile the type sources into one hash-named assembly on disk.
- `Get-LoadedTypeDrift` — compare the loaded types with a code root's sources.
- `Get-TypesShadowRoot`, `Get-TypesPruneAfter`, `Get-TypesStampPath` — the shadow folder, its age bound and the per-root memo path.
- `Import-TypesAssembly` — load an assembly through a shadow copy.
- `Test-TypesAssemblyContent` — check an assembly declares every expected public type, reading metadata only.
- `Get-TypesAssemblyManifest`, `Write-TypesAssemblyManifest` — read and write the assembly's alias and display manifest.
- `Get-TypesContractPath`, `Write-TypesContract`, `Get-TypesContractDrift` — the types surface contract.
- `Save-BurstJournalWrite` — journal a file write for a staged burst.
- `Get-TypesLoadPolicy` — resolve whether, when and how the assembly loads in a mode.
- `Register-DeferredTypes`, `Enable-DeferredTypesLoad`, `Initialize-Types` — the deferred load.

## Related

- Decision record: [native-csharp-types](../../../drs/automation/BCL/native-csharp-types.md) — the single combined assembly and its hash
  key.
- Decision record: [caching](../../../drs/automation/caching.md) — the committed compiled-type prebuild this hash names.
- Principle: [one-living-version](../../../drs/principles/one-living-version.md) — why the algorithm lives here once.
- Reference: `Catzc.Internal.Bootstrap` — the loader (`Import-CSharpTypes`) that consumes this hash; `Catzc.Base.TypesSystem` — the module
  whose `Clear-ModuleTypeCache` janitor also calls it; the BCL type-system reference (`docs/references/BCL/types-system.md`) and the
  internal area overview.

## comment:1

Above `[System.IO.Directory]::CreateDirectory($ShadowRoot) | Out-Null`, written with `#`.

```text
A process that loads or is about to load a build holds its hash for its lifetime: an empty Catzc.Types.<hash>.<pid>.hold the prune
of any other process honours while that process lives. A dead holder's file is the prune's to delete.
```
