# pwsh/.internal/Catzc.Internal.Importer.psm1

The importer overlay — the single living copy of the toolset's whole load sequence. It exports one function, `Invoke-Importer`, whose
parameter block **is** the importer's public switch surface. The root `importer.ps1` is a thin, generated shim (produced by `New-Importer`
in `Catzc.Base.ModuleSystem`) that carries the same parameter block, sets `$env:RepositoryRoot`, and delegates here — so the committed entry
point can never drift from the load logic it delegates to (see [one-living-version](../../../drs/principles/one-living-version.md)). A
bundle's entry runs the same body in its `-Bundle` mode
([ADR-AUTO-BUNDLE-ONELIVINGIMPORTER](../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-onelivingimporter)). Like the
bootstrap, this overlay is import-time orchestration, not shared library code: the shim removes it once `Invoke-Importer` returns.

## What it does

`Invoke-Importer` runs the load sequence end to end:

1. **Guardrails** — enforce the PowerShell 7.4+ floor (the vendor loader relies on the bundled `Microsoft.PowerShell.PSResourceGet`, first
   shipped in 7.4), set strict mode, and set the fail-fast error and warning preferences (`-AllowWarnings` relaxes warnings to `Continue`).
2. **Console detection** — walk the call stack to tell a direct console session from a load inside a script, so a console session gets the
   end-of-load timer while a script does not.
3. **Shared modules** — with the Loader already imported by the shim, load `Bootstrap`, `Types`, and `Vendor` (with `-Force`, honouring the
   re-import invalidation boundary).
4. **Dependencies and modules** — install the custom error view, load the vendored dependencies (`Import-VendorModules`, deferring Pester
   and PSScriptAnalyzer as lazy), optionally wipe the compiled type DLLs first (`-ClearCompiledTypes`), then discover and import every
   `pwsh/*` module (`Import-AllModules`, which compiles the combined C# type assembly once before any module's functions).
5. **Post-import janitors** — keep the derived artifacts current and the session honest, in the fixed order of `Invoke-ImporterJanitors`:
   the type-cache tidy (`Clear-ModuleTypeCache`), the generated READMEs (`Build-Readme`), the cSpell dictionaries
   (`Build-TerminologyDictionary`), the managed root config files (`Build-RootConfig`), the session-PATH reconcile (`Sync-SessionTools`),
   the agent-hook, editor-extension and generated-file janitors, and a Windows warning when `PSModulePath` contains a network share. Each is
   guarded (absent in the bootstrap sandbox) and each is a fast no-op on a clean tree.
6. **Teardown** — remove the transient bootstrap module, leaving the resident Loader, Types, and Vendor in the session, and print the
   console load timer.

Its parameter block is asserted to match `importer.ps1` — a drift test regenerates the shim from it and compares — so the two can never
diverge. The switches are the toolset's load surface:

- `-ExportPrivates` exports `private/` functions so tests can reach them.
- `-AllowWarnings` lets warnings through instead of stopping the load.
- `-DiagnoseLoadTime` prints per-stage timings and an end-of-load summary.
- `-ClearCompiledTypes` deletes every compiled C# type DLL first, so each type is rebuilt from source.
- `-SkipJanitors` is a lean load for a copied subset (`Test-InIsolation`): no janitors and no `PSModulePath` check. Type loading still
  fast-paths on the committed `.compiled` DLL.
- `-CleanClone` opts in to a whitelisted deep clean (`Reset-GitCleanFxd`) as the janitor run's first step: it deletes only the
  auto-controlled generated artifacts, keeps and reports everything else, and lets the janitors regenerate the tree.
- `-Bundle` loads as an installed bundle: it honours the pre-set `$env:CatzcModulesRoot` (the bundle's own `pwsh/`, set by its `Catzc.psm1`)
  instead of deriving it, and forces `-SkipJanitors`, since a bundle is a read-only install with no git work tree. Only the bundle bootstrap
  passes it, so an inherited `CatzcModulesRoot` never diverts a mono repo or fixture load. After the modules load, a bundle applies the
  consumer's overlay (`Invoke-ConsumerOverlay`), and the load stops when the bundle lacks the overlay module rather than ignoring overrides.
- `-Languages` and `-Engines` select the import mix, which `Set-ImportMix` resolves once the modules are loaded; the modules outside it are
  removed. Without `Catzc.Base.ModuleSystem` the importer throws when either is given.

`-Verbose` shows the importer's state-change record
([ADR-PWSH-ANNOUNCE-IMPORTERLOADSEQUENCE](../../../drs/automation/pwsh/announce-state-changes.md#rule-adr-pwsh-announce-importerloadsequence)).
The dot-sourced shim binds it in the caller's scope, so the importer quiets the session-wide preference for the import and restores it in a
`finally`; otherwise every `Import-Module` would list each function it dot-sources and exports. Nothing about committing is a switch: who is
running decides (`Get-SessionActor`, ADR-PWSH-TYPES-JANITORSBYCALLER) — a person's import commits the generated `pwsh/.compiled`, an agent's
announces it, and a pipeline's or a test-run snapshot's never commits.

## Roots

The one bootstrap constant is the folder under the repository root that holds the modules (`pwsh`). It is read before any registry loads, so
it cannot come from one; everything after the import reads it through `Get-CatzcModulesRoot`, and `New-Importer` writes the shim's loader
line from that resolver (ADR-AUTO-LAYERS).

The importer sets two roots ([ADR-AUTO-BUNDLE-TWOROOTS](../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-tworoots)):

- **`RepositoryRoot`** — the working root (`out/`, repository-relative paths, git), set by the shim from `$PSScriptRoot`. Working-root
  readers anchor on it.
- **`CatzcModulesRoot`** — the `pwsh/` tree that holds the loaded modules. Config, type and vendor discovery follow this one. In the mono
  repo it equals `<repoRoot>/pwsh` and nothing pre-sets it, so the importer derives it; an installed bundle pre-sets it, which is what makes
  the toolset relocatable.

This establishes the session every entry loads into
([ADR-AUTO-BUNDLE-ISSESSION](../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-issession)). The two run modes never coexist
([DDR-RUNMODE-NEVERCOEXIST](../../../drs/design/run-modes.md#rule-ddr-runmode-nevercoexist)): `Import-AllModules` evicts the other mode, and
`Assert-CatzcRunModeExclusive` proves it before any janitor touches the tree from a mixed session.

## Console sessions

- **Detection** — the overlay runs one call below the generated shim, so the stack is `[0]` `Invoke-Importer`, `[1]` `importer.ps1`, `[2]`
  the shim's caller. An empty `ScriptName` at `[2]` means `importer.ps1` was dot-sourced with no calling script. This reproduces the shim's
  own `-not $MyInvocation.ScriptName` from inside the module. In scripts, authors add `trap { Write-Exception $_; break }` after the
  importer.
- **Host kind** — an interactive dot-source is the only console host. A script, a test worker, a `-File` or `-Command` process and a
  pipeline load the types and run the janitors at import.
- **Deferral** — a console import stays types-free: the import mix needs the types and the janitors call catzc commands, so both run once
  the first prompt has shown (`Enable-DeferredJanitors`).
- **Timer** — the load time splits into the session initializer (everything before the vendor import), the module import (from there to the
  last module loaded) and the session finalizer (assert, overlay, janitors, cleanup); the three sum to the total. The status line runs
  through the command info of `Write-Message`, since a lookup by name is a first use and would load the pending types.

## Announcements and shared modules

Every lasting change to the caller's session is announced
([ADR-AUTO-CONSOLE-ANNOUNCELASTINGCHANGES](../../../drs/automation/console-output-matters.md#rule-adr-auto-console-announcelastingchanges)):
the preferences and the error view, then the two roots and the internal modules that stay loaded. `RepositoryRoot` is set by the shim and
the modules by `Import-InternalModule`, which both delegate their announcement here. This is where `Write-ImporterMessage` (`Loader`) first
announces; like every announcement of the importer's own load, the lines go on its verbose record. A redirected session writes UTF-8
(`Set-RedirectedOutputEncoding`), the encoding the process relays stream, so a captured log has one encoding.

The loader is already imported by the shim. Bootstrap does the import-time discovery and is removed at the end; the loader, Types and Vendor
stay in the session, so post-import cover functions can `Import-InternalModule` the same shared code and delegate to it.

## Load timings

Under `-DiagnoseLoadTime` the importer collects per-stage timings and prints a summary of file-read and parse totals and the three slowest
stages.

- The raw-read figure is a pure `[IO.File]::ReadAllText` of every `.ps1` before `Import-Module`, so it isolates the cold file-read I/O
  (disk, network share, antivirus-on-read) from the parse. It is warm-cached after the first access, so a small value does not mean "no
  antivirus": a scanner on script parse (AMSI) lands in the parse/compile figure instead.
- The native C# type compile and load (every module's `types/*.cs` through `Import-CSharpTypes`) appears as one `types (combined)` row. A
  `compile+load` row is a cold cache (Roslyn); a `cache load` row reused the committed `pwsh/.compiled` DLL.

## Functions

- `Invoke-Importer` — run the toolset's entire load sequence; the single living copy of the importer body that the generated `importer.ps1`
  shim delegates to. Transient — the shim removes this module afterward.

The module-internal helpers `Invoke-Importer` drives (not exported):

- `Invoke-ConsumerOverlay` — apply a consumer's overlay at the end of a bundle load, or stop the load.
- `Assert-CatzcRunModeExclusive` — throw unless every loaded catzc module comes from the active code root.
- `Set-RedirectedOutputEncoding` — make a redirected session write UTF-8.
- `Invoke-TypeCacheJanitor` — run `Clear-ModuleTypeCache`, turning a build it cannot delete into one red line, never a failed load.
- `Invoke-AgentHookJanitor` — publish every agent hook (each folder under `.claude/hooks` with a csproj) whose C# source changed, without
  failing the load; a checkout without the hooks' code or dotnet is told, never stopped.
- `Invoke-EditorExtensionJanitor` — install the repository's own editor extensions whose installed copy is missing or stale, so loading the
  repo is the whole setup.
- `Invoke-GeneratedFilesJanitor` — check the stamp of every changed generated file, one line per stale file.
- `Write-InsideVsCodeNotice` — the one line a janitor prints instead of working inside VS Code: what it left undone and the command to run
  from a terminal outside the editor.
- `Write-LoadTime` and `Write-LoadTimeSummary` — the `-DiagnoseLoadTime` stage line and summary; the summary writes through the transient
  bootstrap, so it runs while that is still loaded.

## Related

- ADR: [one-living-version](../../../drs/principles/one-living-version.md) — why the shim is a generated copy of this one body.
- ADR: [use-ps1-not-psm1](../../../drs/automation/pwsh/use-ps1-not-psm1.md) — the overlay is a sanctioned `.psm1`.
- Reference: `Catzc.Base.ModuleSystem` — `New-Importer` generates the `importer.ps1` shim from this block; `Bootstrap`, `Vendor`, and
  `Types` — the shared modules it drives; the internal area overview.
