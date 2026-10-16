---
plan:
  status: active
  class: feature
  value: medium-high
  reviewed: 2026-10-16
  targets:
    [
      automation/.internal/Catzc.Internal.Bootstrap.psm1,
      automation/.internal/Catzc.Internal.Types.psm1,
      automation/.compiled,
      docs/adr/automation/BCL/native-csharp-types.md,
    ]
catzc:
  immutable:
    with_body_sha: b70b976499b7
    repo_status: clean
    path: ".claude/plans/plan-lazy-types-load.md"
    folder: plans
    name: plan-lazy-types-load
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#{7,15}
---

# Find the types DLL fast, load it only on first use

The importer finds and verifies the compiled types assembly without loading it; the assembly enters the process on the first use of a type.
Phase 0 (measure and spike) is done as of 2026-10-15; its results section sits in the carried draft. Phases 1 to 5 are open.

## Why its value is medium-high

Every session pays the hash, shadow copy, Add-Type, verification and registration today, whether or not it uses a type. A session that never
uses a type should never pay the load or hold the shadow copy.

## Needed docs

- native-csharp-types ADR: a new rule that the importer never loads the types assembly; the first use does. Drift rules #7 and #15 kept.
- Comment pages of the touched Bootstrap and Types functions; the 8-cell types-load.yml documented with its default declared once.

## Needed tests

- L0 tests for types-load.yml and the policy resolver, neutral fixture names.
- Test-TypesAssemblyContent on a fixture DLL (metadata-only existence check per type).
- Manifest emitted beside the DLL and treated as one build by the janitor and Clear-CompiledType; bundle ships it.
- Get-LoadedTypeDrift reports not-yet-loaded as not drift.

## Open steps

- [ ] Phase 1 metadata verification (check: Test-TypesAssemblyContent tests; import behaviour unchanged).
- [ ] Phase 2 manifest (check: janitor and Clear-CompiledType tests; committed beside the DLL).
- [ ] Phase 3 deferred load, trigger per D3 (check: a session without type use shows no load; drift guard tests).
- [ ] Phase 4 stat-stamp memo, only if Phase 0 says so (check: timing table).
- [ ] Phase 5 rules, docs, tests (check: Test-Links, Test-AdrRegistry clean).

## Refs

- memory: lazy-types-load-plan.md
- docs/adr/automation/BCL/native-csharp-types.md

## Carried: out/plan-lazy-types-load.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: find the types DLL fast, load it only on first use

## Goal

The importer **finds and verifies** `automation/.compiled/Catzc.Types.<hash>.dll` without loading it. The assembly enters the process only
when the first type is actually used (a `[Catzc.*]` literal, an alias, a function that touches one). A session that never uses a type never
pays the load, and never holds the shadow copy.

## What happens today (read from the code)

`Import-CSharpTypes` (`automation/.internal/Catzc.Internal.Bootstrap.psm1:325`) does, every import:

1. `Get-CombinedTypeHash` reads and hashes every `types/*.cs` of every module. This is the "find" cost: the key is content-derived.
2. `Get-LoadedTypeDrift` compares against `$global:__CatzcTypes`.
3. Missing DLL: `Build-CombinedTypeAssembly` (Roslyn), prune of old DLLs.
4. `Import-TypesAssembly` (`Catzc.Internal.Types.psm1:393`) copies to the shadow root, prunes old shadows, and calls `Add-Type -Path` — the
   eager load.
5. **Verification** (`PSTypeName($tf.Type).Type` per type) — resolves each type, so it needs the load.
6. Registration: `PSTypeAliasAttribute` -> `TypeAccelerators::Add`, `ConsoleDisplayAttribute` -> `Update-TypeData` — both need `Type`
   objects, so they need the load too.

So the load is forced by steps 5 and 6, not by step 4. Lazy loading means replacing what 5 and 6 need with something that does not need the
assembly in memory, and adding a trigger for the real load.

## Design decisions to take (recommendation first)

| #   | Decision                                                  | Recommendation                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| --- | --------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| D1  | How to verify without loading                             | Read the DLL's metadata with `System.Reflection.Metadata` (`PEReader`/`MetadataReader`) — no load, no lock. Check each expected type (module namespace + file base name) exists. Falls back to nothing: a mismatch throws as today.                                                                                                                                                                                                                                                                                                                                                                                               |
| D2  | How to get aliases and display properties without loading | Have `Build-CombinedTypeAssembly` also write a sidecar manifest `Catzc.Types.<hash>.json` next to the DLL (type FQN, alias names, display properties), read from the same metadata pass. Same hash key, same prune. One source of truth: generated, never hand-edited.                                                                                                                                                                                                                                                                                                                                                            |
| D3  | The load trigger                                          | Type accelerators and `PSTypeName` need a loaded type, and PowerShell has no "type not found" hook. Trigger options: **(a)** a stub function per module public command that calls `Import-TypesAssembly` once (an idempotent guard) — costs a check per call; **(b)** `AppDomain.AssemblyResolve` — does not fire for PowerShell type-literal lookup, so unusable; **(c)** a tiny always-loaded stub assembly holding the accelerators as lazy `Type` shims — heavy. Recommend (a), placed in the shared loader `Import-ModuleFiles.ps1` so no function file changes (ADR-PWSH-ONEFUNC, zero ceremony). Spike first, see Phase 0. |
| D4  | Accelerators registered before the load                   | Registered from the manifest as a deferred table; applied by the trigger in one batch. Until then `[Alias]` is unresolved — acceptable only if every entry path goes through the trigger.                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| D5  | Finding cost (the hash)                                   | Keep the content hash as the key (ADR-AUTO-TYPES). Cheapen the _find_: stat-stamp (path+size+mtime) memo in the session record, full hash only when the stamp changes. Only if Phase 0 shows the hash dominates.                                                                                                                                                                                                                                                                                                                                                                                                                  |

## Phases

### Phase 0 — measure and spike (nothing committed)

- Time the import stages with `-DiagnoseLoadTime` (cold and warm): hash, shadow copy, `Add-Type`, verification, registration. Record in the
  plan.
- Spike D3(a): does a loader-level guard catch every first use, including `[Catzc.X]::New()` in a test file and in a bare console? List the
  entry paths that bypass it (class `using`, type literals in scripts, formatting of a returned object, `-is [Alias]`).
- Decide D3. If any bypass cannot be closed, record it as an `eagerTypes` entry in the config (see "Configured per mode"), not as a code
  branch.
- Pick the owning module, add `types-load.yml` with the 8 cells and the `Get-TypesLoadPolicy` resolver, and write its L0 tests (the list
  under "L0 tests that lock these facts"). Only these and the spike notes are committed work in Phase 0; no load-path code changes.
- Output: a `## Phase 0 results` section appended to this file (timings table, bypass list, owning module, D3 verdict). Phases 1+ start only
  after the user reads it.

Status: plan finalized 2026-10-15. Phase 0 started (timings run first).

### Phase 1 — metadata verification (D1)

- `Test-TypesAssemblyContent` (private, Types module): metadata-only existence check per expected type. L0 tests with the fixture DLL
  (neutral names, `widget`/`gadget`).
- `Import-CSharpTypes` verifies through it; `Add-Type` stays where it is. Behaviour-neutral, proves the reader.

### Phase 2 — manifest (D2)

- `Build-CombinedTypeAssembly` emits `Catzc.Types.<hash>.json`; the janitor (`Invoke-TypeCacheJanitor`) and `Clear-CompiledType` treat it as
  part of the same build; bundle builder ships it with the DLL (`ADR-BUNDLE`, `Assert-CatzcBundle`, `Test-BuildArtifact`).
- Decide committed vs gitignored: the DLL is committed (`.compiled`, `Get-CommittedTypesDrift`); the manifest follows it so a bundle needs
  no compile.

### Phase 3 — deferred load (D3, D4)

- Split `Import-CSharpTypes` into `Register-DeferredTypes` (verify + manifest into `$global:__CatzcTypes`, no load) and `Initialize-Types`
  (shadow copy, `Add-Type`, accelerators, display data), idempotent.
- Wire the trigger per D3. Keep the changed-after-load drift guard (`ADR-AUTO-TYPES#7`, `#15`): drift is compared at register time, and the
  loaded-vs-source comparison keeps working once loaded.
- `Get-LoadedTypeDrift` reports `Loaded = $false` as "not yet loaded", not as drift.

### Phase 4 — the find (D5, only if Phase 0 says so)

- Stat-stamp memo in front of `Get-CombinedTypeHash`.

### Phase 5 — rules, docs, tests

- Update `docs/adr/automation/BCL/native-csharp-types.md` (new rule: the importer never loads the types assembly; the first use does) and
  the comment pages for the touched Bootstrap/Types functions. One living version: delete the eager path in the same change
  (`ADR-PRIN-ONELIVE`).
- Tests: L0 for verification and manifest; L1 for "after import the assembly is not in `AppDomain.GetAssemblies()`" and "after first use it
  is, exactly once, and accelerators resolve"; a bundle test that a read-only install loads lazily without compiling.
- Per-file checks only, one file at a time.

## Risks

- **No type-resolution hook** in PowerShell: the trigger (D3) is the whole design. A missed entry path surfaces as "Unable to find type", a
  loud failure, not silent.
- Test runs that use types immediately gain nothing, but lose nothing: the guard loads on the first call.
- Analyzer/VS Code hosts that reference accelerators at parse time may need the load earlier; Phase 0 must try them.
- The shadow-copy prune currently runs on the load; it moves with the load, so an unused session no longer refreshes its copy's timestamp.

## Configured per mode, not decided once (replaces the three open questions)

The trigger, the eager fallback, and the "which entries stay unloaded" question are answered by **configuration**, one entry per mode
(`ADR-PRIN-CONFIG`, `ADR-AUTO-DEFAULT#6`: caller's value, else the module config, else the sensible default declared once on the config
type). Nothing in code branches on a mode name; code reads the resolved setting.

### The 8 modes

Three binary axes, 2 x 2 x 2 = 8. Only pwsh can load the C# DLL (`ADR-AUTO-ENGINE:1`); bash and zsh never do, so they are outside the table
and the model answers `load: never` for them by one rule, not eight rows.

| Axis                                                | Values                                                                               |
| --------------------------------------------------- | ------------------------------------------------------------------------------------ |
| host (the "engine" side: how pwsh runs catzc)       | `console` (interactive) / `headless` (pipeline, test worker, analyzer, `pwsh -File`) |
| os                                                  | `windows` / `unix` (Linux and macOS)                                                 |
| run mode (`Get-CatzcRunMode`, `ADR-DSGN-RUNMODE:4`) | `source` / `build`                                                                   |

> Assumption to confirm: your "2x2 = 8" read as these three axes. If the third axis is something else, only the table keys change.

### The settings (one config type, defaults declared on it)

| Setting      | Meaning                                                                                                      | Answers |
| ------------ | ------------------------------------------------------------------------------------------------------------ | ------- |
| `load`       | `lazy`: unloaded after verification, loaded by the first use. `eager`: loaded right after verification       | old Q3  |
| `trigger`    | `lookup-hook`: the shared-loader guard of D3(a). `none`: only valid with `eager`                             | old Q1  |
| `eagerTypes` | FQNs loaded at import even when `load: lazy`; the escape for a literal-reference path the guard cannot catch | old Q2  |
| `shadowCopy` | load from the per-user shadow copy (Windows locks a loaded DLL) or in place                                  | os fact |

Config file: `automation/<owning module>/configs/types-load.yml` (owner decided in Phase 0; a Types/Objects-side module, not Bootstrap,
since Bootstrap is removed after import). Keys are the mode, `host.os.runmode`, plus a `default` row.

### Sensible defaults (the 8 cells)

| host     | os      | run mode | load  | trigger     | shadowCopy | Why                                                                                                                                                     |
| -------- | ------- | -------- | ----- | ----------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| console  | windows | source   | lazy  | lookup-hook | true       | the prompt pays nothing; the lock is why the shadow exists                                                                                              |
| console  | windows | build    | lazy  | lookup-hook | true       | same; the bundle ships DLL + manifest, no compile                                                                                                       |
| console  | unix    | source   | lazy  | lookup-hook | false      | Unix does not lock a loaded file, so load in place                                                                                                      |
| console  | unix    | build    | lazy  | lookup-hook | false      | same                                                                                                                                                    |
| headless | windows | source   | eager | none        | true       | a pipeline must fail at import on stale or missing types, not mid-run (`ADR-AUTO-TYPES#15`, `ADR-AUTO-FAILFAST`); test workers use types at once anyway |
| headless | windows | build    | eager | none        | true       | same                                                                                                                                                    |
| headless | unix    | source   | eager | none        | false      | same                                                                                                                                                    |
| headless | unix    | build    | eager | none        | false      | same                                                                                                                                                    |

`eagerTypes` is empty everywhere until Phase 0 names a type the guard cannot catch. Verification is metadata-only in **all eight** cells
(D1), so an eager cell still never trusts an unverified DLL; it only loads right after. Flip any cell by editing its row, not code.

`shadowCopy: false` on Unix changes `Import-TypesAssembly` (today it shadows everywhere): that is a design change to confirm in Phase 3,
because the drift guard and the janitor assume a shadow path.

## L0 tests that lock these facts

New file `automation/<owning module>/tests/Get-TypesLoadPolicy.Tests.ps1` (L0, neutral widget/gadget fixtures, `ADR-AUTO-TEST`,
`ADR-TEST:3`):

- **Closed table:** the config has exactly the 8 keys (host x os x run mode) and no other; a missing or extra key fails.
- **Defaults declared once:** an empty config resolves every cell to the default row; the default row is the only place the values are
  written (no literal repeated in a function).
- **Each cell:** a theory over all 8 asserts `load`, `trigger`, `shadowCopy` equal the table above, so changing a default is a visible test
  edit.
- **Resolution order:** explicit parameter beats config beats default (`ADR-AUTO-DEFAULT#6`).
- **Invariants:** `trigger: none` only with `load: eager`; `eagerTypes` only names types present in the manifest; an unknown value throws.
- **Engines:** `Get-TypesLoadPolicy` for bash and zsh answers `load: never` and never reads the table.
- **Mode detection:** host, os and run mode resolve from injected inputs (not the real session), so all 8 are reachable on any machine.
- **Behaviour (L0 with the fixture DLL):** in a `lazy` cell the assembly is absent from `AppDomain.GetAssemblies()` after register and
  present exactly once after first use; in an `eager` cell it is present right after register.

Phase 0 gains: pick the owning module, add `types-load.yml` and the `Get-TypesLoadPolicy` resolver (the one reader; Bootstrap calls it),
then the tests above, before any load-path code changes.

## Phase 0 results (timings, 2026-10-15)

| Stage                                                                            | Cold (compile+load) | Warm (cache load) |
| -------------------------------------------------------------------------------- | ------------------- | ----------------- |
| types (combined, 253 files): hash + shadow copy + `Add-Type` + verify + register | 1366 ms             | 79 ms             |
| all modules loaded                                                               | 2935 ms             | 1675 ms           |

- Warm, the types step is 79 ms of 1675 ms (about 5%): the lazy load saves at most that, plus the shadow copy. The win is mostly the cold
  path (1.3 s Roslyn is unaffected by laziness) and not holding the DLL in memory.
- The hash (reading 253 sources) is inside the 79 ms, so D5 (stat-stamp memo) is probably not worth it. Split the 79 ms by stage in the
  spike before deciding.
- `TOTAL import ms` printed 5604 in both runs; treat it as unreliable and use the per-stage rows.
- The check "Catzc.Types loaded" by assembly name returned 0 (the shadow assembly has another name); the spike must test by a known type
  instead.
- The cold run rewrote `automation/.compiled/Catzc.Types.70f101c2.dll` (type sources had changed since the committed DLL).
- Still open: D3 spike, bypass list, owning module, config + `Get-TypesLoadPolicy` + L0 tests.

## Phase 0 spike results (2026-10-15; scripts in out/spike/)

Warm types step split (`stage-split.ps1`, fresh process, includes JIT): hash of 253 sources **155 ms**, shadow copy + prune + `Add-Type`
**41 ms**, drift compare **38 ms**, PSTypeName verify **1 ms**. The hash dominates, not the load, so **D5 (cheaper find) is worth doing**,
and the lazy load alone saves only about 41 ms.

Census: 449 files use `[Catzc.*]` literals, 44 use `[OutputType([Catzc...])]`, 1 alias exists (`Catzc.Module.Depm`), 24 types carry
`ConsoleDisplay`, 2 test files define PowerShell `class`es (neither derives from a Catzc type, to be confirmed in Phase 3).

Guard coverage (`guard-spike.ps1`, fixture DLL, one fresh process per case):

| Path                                                                                             | Unloaded result                                           |
| ------------------------------------------------------------------------------------------------ | --------------------------------------------------------- |
| function defined while unloaded (typed param, OutputType); `ParseFile` + dot-source (the loader) | works, 0 parse errors                                     |
| literal in a body after a guard call; `[Alias]`; `-is`/`-as`; `New-Object`                       | works                                                     |
| failed lookup, then guard, then retry                                                            | works (no negative cache)                                 |
| guard **inside** a function with a typed param or `[OutputType]`                                 | **fails**: binding resolves the type before the body runs |
| caller guards first                                                                              | works                                                     |
| top-level script or console literal with no guard                                                | **fails**                                                 |
| `class K : Catzc.Type` while unloaded                                                            | **fails** at parse (none in tree today)                   |

Verdict on D3: a guard in the function body (D3a as written) is **wrong**. The trigger must run before binding, so use
`$ExecutionContext.InvokeCommand.PreCommandLookupAction` (`hook-spike.ps1`):

- Unfiltered, it loads on the first command of any kind, so a console would be eager in practice. Filtered by name against the catzc
  function set, it loaded before a typed-param private function and an `[OutputType]` public function ran, with the assembly still unloaded
  before the call.
- Cost is about 7 microseconds per command lookup (84 vs 48 ms per 5000), paid until the hook removes itself on the first load.
- Needs, in the plan's config terms: `trigger: lookup-hook` replaces `lookup-hook`.

Uncovered, so recorded as the rule: a literal typed by hand in the console or at the top level of a test script before any catzc command
runs. Console cells: accept (a `Initialize-Types` command and the prompt hook can load on the first prompt, decided in Phase 3). Headless
cells are eager already, which closes the test-script case. `eagerTypes` stays empty.

Still open in Phase 0: owning module, `types-load.yml`, `Get-TypesLoadPolicy`, its L0 tests. Plan edits needed: D3 recommendation (a) to
lookup-hook; settings table `trigger` values; D5 to "do it".

## Phase 0 done (2026-10-15)

- Config: `automation/.internal/assets/types-load.yml` (the 8 rows). Resolver: `Get-TypesLoadPolicy` in
  `automation/.internal/Catzc.Internal.Types.psm1` (explicit value, else row, else default row). Tests:
  `automation/.internal/tests/Get-TypesLoadPolicy.Tests.ps1`, 27 L0 tests, run and all passed.
- Every earlier mention of the `loader-guard` trigger now reads `lookup-hook` (the spike showed a body guard is too late for typed
  parameters; D3 is the name-filtered `PreCommandLookupAction`).
- Deviation to confirm: `ADR-AUTO-DEFAULT#6` says the default is declared on the setting's config type. The policy is read while the C#
  types assembly is still unloaded, so the default row and allowed values are declared once in `Get-TypesLoadPolicy`'s module
  (`$script:TypesLoadDefault`), not on a C# type. Phase 5 should record this exception in the ADR.
- Not done yet, in later phases: the bundle must ship `types-load.yml` (`files.yml` package entry), the importer must call
  `Get-TypesLoadPolicy` (Phase 3), `Initialize-Types` and the lookup hook, and the changed-after-load drift rules.

## Phase 1 done (2026-10-15)

- `Test-TypesAssemblyContent -Path -Expected` added to `automation/.internal/Catzc.Internal.Types.psm1` (exported). It reads the DLL bytes
  into memory and walks `MetadataReader.TypeDefinitions` (top-level public types only): no `Assembly` load, no file lock. A missing type
  throws the message `Import-CSharpTypes` threw before.
- Tests: `automation/.internal/tests/Test-TypesAssemblyContent.Tests.ps1`, 8 L0 tests on a `widget`/`gadget` fixture DLL
  (`Add-Type -OutputAssembly`): complete, missing, non-public, nested, wrong namespace, missing file, assembly absent from
  `AppDomain.GetAssemblies()`, file deletable. All 8 passed.
- `Import-CSharpTypes` (`Catzc.Internal.Bootstrap.psm1`) now verifies through it, before `Import-TypesAssembly` (so a bad DLL is rejected
  before it is loaded). Add-Type, accelerators and display data are unchanged.
- `Import-CSharpTypes.Tests.ps1`: 24 passed, 1 skipped, 1 failed. The failure is "exactly one committed assembly" (`Test-BuildArtifact`):
  `automation/.compiled` has pending git changes (the rebuilt DLL is uncommitted), not a code fault. It passes once the DLL is committed.

## Phase 2 done (2026-10-15)

- Manifest `automation/.compiled/Catzc.Types.<hash>.json`: `{ hash, types: [{ name, aliases, display }] }`, types sorted ordinally, LF, no
  BOM. Generated from the DLL's metadata, never edited. `display` is the effective ConsoleDisplay set (own, else nearest in-assembly base,
  as the attribute is inherited). Committed beside the DLL (`.compiled/**` is already binary in `.gitattributes`, not ignored, and in the
  `compiled` globset).
- `Catzc.Internal.Types.psm1`: `Get-TypesAssemblyManifest` (metadata reader; `Test-TypesAssemblyContent` now uses it, one reader),
  `Write-TypesAssemblyManifest` (tmp + move, skips an existing one); `Build-CombinedTypeAssembly` writes it in both branches and returns
  `Manifest`.
- `Catzc.Internal.Bootstrap.psm1`: `Clear-CompiledType` and the stale-DLL prune in `Import-CSharpTypes` delete a DLL's manifest with it (a
  locked DLL keeps its manifest); `Import-CSharpTypes` writes a missing manifest, and with `-PrebuiltOnly` throws instead (a bundle never
  writes).
- `Clear-ModuleTypeCache` removes a superseded build's manifest. `Get-CommittedTypesDrift` requires exactly the current-hash manifest.
  `Catzc.Internal.Builder.psm1` plans the manifest (Copy of the committed one, else generated with the DLL; a committed DLL without a
  manifest is a plan violation). `Assert-CatzcBundle` requires exactly one manifest named for the DLL.
- Tests added or extended, all run and passing: Get/Write-TypesAssemblyManifest (9 + 6), Test-TypesAssemblyContent (8),
  Build-CombinedTypeAssembly (15), Clear-CompiledType (4), Clear-ModuleTypeCache (22), Test-BuildArtifact incl. Get-CommittedTypesDrift
  (17), Invoke-ModuleBuild (25), Assert-CatzcBundle (27), New-CatzcNuGetPackage (4), Import-CSharpTypes (27 pass, 1 skipped, 1 fail).
- The one failure is unchanged: "exactly one committed assembly" fails while `automation/.compiled` has uncommitted changes (the rebuilt DLL
  and now its json). It passes once both are committed.
- Not done, still Phase 3+: nothing reads the manifest yet; `Test-TypesAssemblyContent` could be fed from it instead of the DLL once the
  importer defers the load.

## Phase 3 done (2026-10-15)

- `Catzc.Internal.Types.psm1`: `Register-DeferredTypes` (records a verified DLL as pending in `$global:__CatzcDeferredTypes`, keyed by code
  root), `Initialize-Types` (idempotent; clears the hook first, then `Import-TypesAssembly`, then accelerators and `Update-TypeData` from
  the manifest JSON, never from `Type` attributes), `Enable-DeferredTypesLoad` (name-filtered `PreCommandLookupAction`; with nothing pending
  it clears the hook). `Import-TypesAssembly` gained `-ShadowCopy` (false loads in place), which is how `shadowCopy` from `types-load.yml`
  is honoured.
- Deviation from the plan text: no separate `Register-DeferredTypes` split of `Import-CSharpTypes`; `Import-CSharpTypes` stays the register
  step (hash, drift, build, manifest, metadata verify, policy, register, then `Initialize-Types` at once for an eager cell or an
  `eagerTypes` entry).
- `Import-CSharpTypes` takes `-HostKind` (default `headless`, so a caller that says nothing loads eagerly) and derives the run mode from
  `-PrebuiltOnly` (bundle = build). It calls `Get-TypesLoadPolicy`, refuses an `eagerTypes` name no module declares, and labels the
  diagnostic line "verified, load deferred". `Import-AllModules` passes `-HostKind` through and calls `Enable-DeferredTypesLoad` once every
  module's exported command names are known. `Invoke-Importer` passes `console` only for an interactive dot-source outside a pipeline.
- `Invoke-Importer` runs its own "Loaded in N seconds" line through `Write-Message`'s command info: a lookup by name is a first use and
  loaded the types for a status line.
- Bundles: `assets/types-load.yml` is now a runtime internal file of the build, and `Assert-CatzcBundle` requires it (the importer reads it
  at every import).
- `Get-LoadedTypeDrift` needed no change: a root with nothing loaded reports `Loaded = $false` and is current, never drift.
- Tests, all run: Initialize-Types.Tests.ps1 (11, new: both functions, the hook, the shadow and in-place loads, the missing manifest),
  Import-TypesAssembly (7), Import-CSharpTypes (30 pass, 1 skipped, 1 fail; 3 new lazy cases pass; the one failure is the unchanged
  uncommitted-DLL check), Import-AllModules (18), Get-TypesLoadPolicy (27), Invoke-ModuleBuild (25), Assert-CatzcBundle (28),
  New-CatzcNuGetPackage (4), Get-LoadedTypeDrift (4).
- Checked by hand in fresh processes (`out/spike/p3-e2e-launcher.ps1`, `p3-bundle-launcher*.ps1`): a console-style import with
  `-SkipJanitors` leaves the types unloaded with the hook set and one pending record; the first catzc command loads them, clears the hook
  and registers the alias. A bundle built from `Catzc.Base.Objects` imports unloaded with the hook set, and `Initialize-Types` loads it from
  the shadow copy.
- **Finding:** a source-tree console import with the janitors on loads the types during the import anyway. The janitors (`Build-AdrIndex`,
  `Build-Readme`, ...) are public catzc commands, so the first one trips the hook. Lazy pays off where no janitor runs: a bundle (janitors
  are forced off), `-SkipJanitors`, and any session that imports then waits. Making the source console lazy too means the janitors run after
  the first prompt, or are not catzc commands by name. Decision for the user.
- Not done: the console prompt hook (a literal typed at the prompt before any catzc command stays unresolved until `Initialize-Types` or a
  command runs); the comment pages for the touched Bootstrap/Types/Importer functions; the ADR text; an L1 test of the
  not-loaded-after-import invariant through the real importer.
