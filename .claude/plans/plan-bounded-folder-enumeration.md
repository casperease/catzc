---
plan:
  status: active
  class: feature
  value: medium
  reviewed: 2026-10-16
  waits_on: a level-2 Test-Automation rerun to confirm the three test-tag fixes (unconfirmed as of 2026-10-16 15:33)
  targets: [automation/Catzc.Base.Folders, automation/.scriptanalyzer/NoUnboundedEnumeration.psm1, docs/adr/pwsh/bounded-enumeration.md]
---

# Bounded folder enumeration: raw .NET, depth 2 by default, nothing deeply loaded

Built and migrated (the draft's own status, 2026-10-16): the walker and Get-ChildPath in Catzc.Base.Folders, ADR-PWSH-ENUM at
docs/adr/pwsh/bounded-enumeration.md (exists in the tree), the migration of every non-test and test site, and the analyzer rule
NoUnboundedEnumeration (exists in the tree). Where the draft disagrees with the code (module name Files versus Folders, -PruneVendor,
measured depths), the code and the draft's later result sections win. What remains is the user's gate run; then this plan is deleted.

## Why its value is medium

About 70 call sites enumerated with no depth limit and 8 used Get-ChildItem; a deep tree or a vendor folder made any of them slow or
wrong. The value is delivered; what is left is the proof at level 2.

## Done, and why

- Everything the draft planned, per its status line and its "Gate result and decision" section carried below.
- The ADR draft once kept as out/h.md is carried below for the record; the real ADR is in docs/adr/pwsh and is the one living version.
- The gate conflict found during formatting (a new .yml between Test-Comments and Test-FileMeta) belongs to the file-meta rollout; see
  plan-file-head-immutable-edges-classes.
- Session report of 15:33: the level-2 gate failed on three bad ADR test tags; the three fixes and their reasons are in the carried
  "Gate result and decision (2026-10-16)" section below. Lesson recorded there and in the memory note bounded-folder-enumeration: every
  test citation needs the ADR-<CODE>#<n> form naming a real rule. The gate was not rerun, so the fix is unconfirmed. The old draft
  sections still say Catzc.Base.Files and -IncludeVendor (the status line names -PruneVendor); the code and the later results win, by the
  draft's own status line. Other plans mention ADR-AUTO-FAILFAST only in passing and were left alone by that session.

## Rules to keep (from the prompt beside this file)

- The user handles every commit and runs the full Test-Automation; a whole-suite run is asked for first. A level-2 rerun scoped to this
  feature runs in the background under the time safeguard.
- Peer sessions edit the same tree: re-read before editing, leave their work in progress alone.

## Open steps

- [ ] Rerun the level-2 gate in the background; fix only findings in this feature, report the rest (check: its report in
  out/test-automation shows the three tags accepted).
- [ ] On green, the user runs the full suite in their own time; then delete this plan and its prompt (the plans plan's rule).

## Refs

- memory: bounded-folder-enumeration.md
- prompt-bounded-folder-enumeration-continue.md (beside this file)

## Carried: out/plan-bounded-folder-enumeration.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: bounded folder enumeration

Status (2026-10-16): built and migrated. Walker, `ADR-PWSH-ENUM`, the migration of every non-test and test site, and the analyzer rule `Measure-NoUnboundedEnumeration` are done (see the memory note `bounded-folder-enumeration` for the per-stage record). What remains is the level-2 `Test-Automation` gate run by the person (see "Gate result and decision"). Sections below are the original plan and the step results; where they disagree with the code (module name, `-PruneVendor`, measured depths), the code and the later results win.

## Rules this plan enforces

1. **Raw .NET only.** Every child-and-deeper folder or file enumeration in `.ps1`/`.psm1` uses `System.IO` (`Directory.Enumerate*`, `EnumerationOptions`). `Get-ChildItem`, `gci`, `dir`, `ls` are banned for the filesystem.
2. **Shallow by default.** Depth defaults to **2** (decision D1). Deeper is always an explicit override at the call site (`-Depth`).
3. **Nothing is deeply loaded.** Enumeration is lazy and pruned: no `SearchOption.AllDirectories` into a full list, and no walking `.vendor`, `.git`, `node_modules`, `out` unless asked.
4. **Always look for optimizations, and be open to creating types.** For any enumeration that is hot, repeated, or deep, weigh a compiled C# type (module `types/` folder, built into the types assembly) against PowerShell. A type can bring a manual stack walk, a depth counter, prune sets, `EnumerationOptions` (`RecurseSubdirectories`, `MaxRecursionDepth`, `IgnoreInaccessible`, `AttributesToSkip`), sorting and result shaping, all without per-item PowerShell pipeline cost. This applies to this plan and to every later change: when a measurement shows PowerShell is the cost, propose the type rather than micro-tuning script.

## Scan result (2026-10-15)

- About 70 non-test call sites already use raw .NET.
- None has a depth limit. Every recursive raw call uses `SearchOption.AllDirectories`.
- 12 non-test sources use cmdlets: 8 files still use `Get-ChildItem`, and 7 of those 8 recurse with no limit.

Violations to migrate (file:line):

**A. Cmdlet enumeration**
- `Catzc.Base.Vendor/Install-VendorModule.ps1:60` (`-Recurse`)
- `Catzc.Base.Vendor/private/Get-VendoredModule.ps1:20,21`
- `Catzc.Base.QualityGates/Format-Types.ps1:42` (`-Recurse`)
- `Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1:59` (`-Recurse`)
- `Catzc.Base.QualityGates/private/Get-AutomationSourceFiles.ps1:21-64` (8 calls, 4 recurse)
- `Catzc.Base.QualityGates/private/Import-VendoredPester.ps1:18`
- `Catzc.Base.QualityGates/private/Invoke-DotnetFormat.ps1:44`
- `Catzc.Base.Languages/New-PythonProject.ps1:39,43` and `New-GoWorkspace.ps1:42,46`
- `Catzc.Base.TypesSystem/Build-BashTimeoutHook.ps1:39`
- `Catzc.Tooling.Core/Install-Tool.ps1:100` (`-Recurse`)
- `Catzc.Tooling.Toolchain/Install-Java.ps1:44,65`
- `Catzc.Base.ModuleSystem/Copy-Automation.ps1:111` and `Catzc.Base.Environment/assets/Set-LocalPSModulePath.ps1:65` ("non-empty?" tests)
- `.internal/Catzc.Internal.Bootstrap.psm1:693` and `Catzc.Internal.Vendor.psm1:43,57`

**B. Raw `AllDirectories`, unbounded**
- `.internal/Catzc.Internal.Builder.psm1:218,387,702,715`
- `Catzc.Base.Git/Remove-RepositorySnapshot.ps1:33`
- `Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1:39,43` (riskiest: all `*.yml` under `automation`, `.vendor` included)
- `Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1:31`, `Get-ChangeTestFile.ps1:46`, `Get-BashTestCases.ps1:28`, `Build-EnglishDictionary.ps1:46`
- `Catzc.Tooling.Toolchain/private/Install-UvStandalone.ps1:60`, `Get-DotnetInstallHolder.ps1:25`
- `Catzc.Tooling.Provisioning/private/Get-PackageTreePlan.ps1:32,47`

Out of scope: provider enumeration (`gci env:`, `function:`, registry keys), help-text examples, tests, vendored Pester.

Model to follow: `Catzc.Azure.DevOps/Get-AdoYamlFiles.ps1` (manual walk with pruning, no depth parameter yet).

## Design

1. **Core walker as a C# type** (first candidate, per rule 4). The `Catzc.*` type lives in the `types/` folder of the owning module (proposal: `Catzc.Base.Files`). It does a lazy manual-stack walk and takes: root, `maxDepth`, entry kind (file, directory, both), pattern(s), prune names, and a sort flag. It returns `string[]`/`IEnumerable<string>`.
   - Measure first: a PowerShell-only helper vs. the type on `automation/` (cold and warm). Keep the type only if the numbers justify it; record them in the plan's results.
   - The type takes `depth` and `exclude` as explicit arguments and declares no default of its own. The default is declared once, on the config type that maps the module's `configs/<name>.yml` (`ADR-AUTO-DEFAULT#6`), and the wrapper reads it as `[int] $Depth = (Get-Config -Config <name>).depth` (`ADR-PWSH-PARAM#4`). The type is a `static class`, so `ADR-AUTO-TYPES#14` (console `ToString`) exempts it.
2. **Thin public/private PowerShell wrapper** (`Verb-Noun.ps1`, one function per file, `ADR-PWSH-ONEFUNC`; `ADR-PWSH-PARAM` for `-Depth`, `-Path`, `-Filter`). It only binds parameters and calls the type. Name to be chosen with the user (decision D2).
3. **Boot-time callers** (`.internal/*.psm1`, `Bootstrap`, `Builder`) load before module types exist. They get either inline raw .NET with an explicit depth, or a type from the `Catzc.Internal.Types` path. Check load order before choosing (decision D3).
4. **Analyzer rule** in `automation/.scriptanalyzer/`: flags `Get-ChildItem`/`gci`/`dir`/`ls` on filesystem paths and `SearchOption.AllDirectories` outside the walker. Mapped to an ADR rule (decision D4: a new rule in the Automation or PWSH ADRs, or a new one).
5. **Tests** (L0, neutral fixtures `widget`/`gadget` per `ADR-TEST:3`): default depth, override depth, prune, ordering, missing root, no deep load (a fixture tree deeper than the default is not entered).

## Steps

1. Read the governing ADRs (index, `ADR-PWSH-*`, `ADR-AUTO-DEFAULT`, `ADR-AUTO-TEST`, the types ADR).
2. Build the walker (type plus wrapper) and its tests. Run its tests in a fresh `pwsh` (C# edits need a recompile), in the background under the time safeguard.
3. Measure vs. the PowerShell-only form. Decide type vs. script, and write the numbers down.
4. Migrate group B first (the cheapest swap and the highest risk), then group A, **one file at a time**, running that file's tests before the next. No batch scripts.
5. Add the analyzer rule only after the tree is clean, so it lands green.
6. Report faithfully: which gates ran and which didn't.

## Decisions for the user

- **D1** default depth: **2** (decided by the user).
- **D2** (accepted): module `Catzc.Base.Files`. Type `Catzc.FolderWalker` in `types/FolderWalker.cs`. Public wrapper `Get-ChildPath` with `-Path`, `-Depth` (default 2, declared once on the type), `-Filter`, `-Directory`/`-File`, `-Exclude` (default prune: `.git`, `node_modules`, `out`), and `-IncludeVendor` (switch, off). Whether `.vendor` is pruned from searches is **not** a parameter default and not a list entry: it is the global config value `prune_vendor_in_searches` (default `true`), in the walker's config (name `folder-walk`, `Catzc.Base.Files/configs/folder-walk.yml`, config type `Catzc.Base.Files.FolderWalkConfig`, registered in `Catzc.Base.Config/configs/configs.yml`). Any code reads it as `global.folder-walk.prune_vendor_in_searches` (`Get-ConfigValue`, `config-value-addressing`). Resolution (`ADR-AUTO-DEFAULT#6`): `-IncludeVendor` explicit → config value → the default `true` declared once on `FolderWalkConfig`. The same config holds `depth` (2) and `exclude`.
- **D3** (accepted): first check `Catzc.Internal.Types.psm1` load order. If the walker can compile at the internal level before `Builder` needs it, one type serves everyone and `Get-ChildPath` wraps it. Fallback only if load order forbids it: boot-time sites keep non-recursive inline `Enumerate*` (depth 1); the four recursive `Builder` sites still get the type. Never an inline copy of the stack-walk (`ADR-PRIN-ONELIVE`).
- **D4** (accepted): new ADR `docs/adr/pwsh/bounded-enumeration.md`, code `ADR-PWSH-ENUM`, added to the index table. Rules: (1) raw .NET only; (2) depth default 2, override explicit; (3) nothing unbounded; (4) hot or deep enumeration is a compiled type (cites `ADR-AUTO-TYPES`). Depth default cites `ADR-AUTO-DEFAULT#6`; nesting cites `ADR-AUTO-NONEST`. The analyzer rule maps to it (`Test-AnalyzerAdrMap`).
- **D5** (accepted): explicit `-Depth` per site, from measured need, never unlimited. Estimates, confirmed at each migration:

  | Site | `-Depth` |
  |---|---|
  | `Test-ConfigIdentityHygiene:39`, `Get-FixtureIdentityTokens:31` (`automation/**/*.yml`) | 3, prune `.vendor` |
  | `Test-ConfigIdentityHygiene:43` (infrastructure `*.yml`) | 4 (verify) |
  | `Builder:218` | 3 |
  | `Get-ChangeTestFile:46`, `Get-BashTestCases:28` | 3 |
  | `Get-DotnetInstallHolder:25` | 4 |
  | `Install-UvStandalone:60` | 3 |
  | `Get-PackageTreePlan:32,47` | explicit 8 (named exception: whole package tree) |
  | `Build-EnglishDictionary:46` | replace the search with a resolved known path |
  | `Builder:387,702,715`, `Remove-RepositorySnapshot:33` | explicit 8 (named exception: whole build/snapshot tree) |

  Sites that walk a whole tree on purpose are named exceptions with the depth stated at the call site.

## Step 1 findings (ADRs and load order read 2026-10-15)

Read in full: `ADR-AUTO-TYPES`, `ADR-AUTO-DEFAULT`; read the rules of `ADR-PWSH-PARAM`, `ADR-PWSH-PESTER#9`, and the index.

1. **D3 resolved by the load order.** `Invoke-Importer` loads the internal modules, then `Import-CSharpTypes` (`Bootstrap.psm1:747`) builds and loads the one combined assembly, then the modules. So:
   - `Builder` and `TestKit` load on demand after the import, and can call `[Catzc.Base.Files.FolderWalker]`. Still to verify: a build run in a fresh process (`Build-Catzc` / `-Bundle`, which loads prebuilt types only) has the assembly before `Builder` enumerates.
   - `Bootstrap`, `Vendor` and `Types` run before or while the types load. Their enumerations are all depth 1 (`Bootstrap:693`, `Vendor:43,57`, the `types/*.cs` scans), so they stay inline raw .NET, non-recursive. No walker, no stack-walk copy.
2. **Vendor pruning is a registry value** (the user's decision, 2026-10-15): `prune_vendor_in_searches` lives in the registered `folder-walk` config as above. Config names are global (`ADR-CONF-LOADING`), reading is global access, and the registry self-validates through `ConfigsConfig`, so `Test-ShippedConfigs` keeps `configs.yml` and the shipped `folder-walk.yml` in step. Open naming check: the key is `prune_vendor_in_searches` (snake_case, mirrors the YAML per `ADR-AUTO-TYPES#8`); say so if you meant the config's own name instead.
2b. **Default location corrected.** `ADR-AUTO-DEFAULT#6` puts a configurable setting's default on the config type, not in a function or a type. So the depth default (2) and the default prune list become a config (`Catzc.Base.Files/configs/<name>.yml`, a C# config type registered in `configs.yml`, read through `Get-Config`). To check at build time: how a config type is registered (the module-config-loading ADR).
3. **D4 refined: an enumeration rule already exists in part.** `ADR-PWSH-PESTER#9` says "prefer `[System.IO]` over filesystem cmdlets on hot paths" (a speed rule, filed under Pester). The new `ADR-PWSH-ENUM` takes over the enumeration part (all filesystem enumeration, raw .NET, bounded depth, default 2, type for hot or deep). `PESTER#9` is cut back to the non-enumeration cmdlets (`Copy-Item -Recurse`, `New-Item`, `Set-Content`) and links to `ENUM`, so one rule carries each behaviour (`ADR-PRIN-ONELIVE`). The ADR index is generated from `automation/Catzc.Base.Docs/configs/adrs.yml`, so the new code is registered there, not hand-edited into `index.md`.
4. **ADR examples teach the old form.** `avoid-deep-nesting.md` (lines 63, 75, 163), `powershell-formatting.md:84` and `prefer-foreach-over-foreach-object.md:160` show `Get-ChildItem` in code samples. They are updated with the new `Get-ChildPath` form in the same change.
5. **Type-edit consequences** (`ADR-AUTO-TYPES#7,13`, cache-state contract):
   - A new `types/FolderWalker.cs` re-keys the one committed `automation/.compiled/Catzc.Types.<hash>.dll`.
   - Anything that uses the type needs a fresh `pwsh` process after the edit.
   - Under a Claude (agent) session, `Sync-GeneratedFile` does not commit the new DLL: it announces it, and the person commits it. Expect a pending `.compiled` change at the end.
   - The new type edge from callers to `Catzc.Base.Files` must be declared in `configs/dependencies.yml` for any module that does not already depend on `Catzc.Base.Files` (`ADR-AUTO-TYPES#4`; the module declares `Base`, which includes it). `Test-ModuleDependency` checks it.
   - The C# file is formatted by `Format-Types` (file-scoped `namespace Catzc.Base.Files;`).

## Step 2 result (2026-10-15)

Built and tested; 31 tests in 3 files passed (`FolderWalker` 9, `FolderWalkConfig` 11, `Get-ChildPath` 11), run with `Invoke-TestFile` in a fresh `pwsh`.

Deviations from the accepted plan, each decided or forced during the build:
- **D2 changed (user chose it):** the home is a new module `Catzc.Base.Folders`, not `Catzc.Base.Files`. `Files` depends on `Git`, and `Git` (`Remove-RepositorySnapshot`) needs the walker. `Folders` depends on `Config` and `Objects` only, so `Git`, `Vendor`, `Languages` and `Files` can all use it.
- **Vendor pruning is `-PruneVendor [bool]`, not `-IncludeVendor`.** Its default is read in the declaration from the registry value (`ADR-PWSH-PARAM#4`), so the caller's explicit value wins over the config.
- **Defaults:** `depth` (2) and `exclude` (`.git`, `node_modules`, `out`) are declared only on `FolderWalkConfig`. The shipped `folder-walk.yml` states only `prune_vendor_in_searches: true`.
- **Never follows a link.** A link is listed, never entered. A test found that Pester's own `TestDrive` cleanup follows a junction cycle, so the test removes its junction itself.

Files added: `automation/Catzc.Base.Folders/{types/FolderWalker.cs, types/FolderWalkConfig.cs, configs/folder-walk.yml, Get-ChildPath.ps1, tests/…}`. Files edited: `Catzc.Base.Config/configs/configs.yml` (registry entry), `Catzc.Base.ModuleSystem/configs/dependencies.yml` (`Catzc.Base.Folders: [Config, Objects]`).

Not done yet:
- The module's reference page (`docs/references/automation/catzc-base-folders.md`; the module README is generated from it), and the format and meta steps (`Format-Code`, `Format-FileMeta`, `Test-FileMeta`).
- `Test-ShippedConfigs`, `Test-ModuleDependency` and the type gates (`Test-ShippedTypes`, `Test-Formatting`). Only the three new test files have run.
- Benchmark of the type against a PowerShell-only walk (step 3), `ADR-PWSH-ENUM`, the migration (step 4) and the analyzer rule (step 5).
- The committed `automation/.compiled` DLL is re-keyed (`7af35ad1` → `4ebc4652`); the person commits it.

## Step 3 result: benchmark (2026-10-15, `out/bench-folder-walk.ps1`)

Seeded random sample (seed 42): 12 folders from the first three levels of the repository, each with a random depth of 1 to 4, pruning `.git`, `.vendor`, `node_modules`, `out`. Median of 5 warm runs after a warm-up.

| Contestant | Total over 12 roots |
| --- | --- |
| `Get-ChildItem -Recurse -Depth` (no pruning, as the old code did) | 16.7 ms |
| PowerShell-only walk (raw .NET calls in a PowerShell loop, with pruning) | 13.2 ms |
| `FolderWalker` type | **4.3 ms** |
| Unbounded raw `AllDirectories` (no depth, no pruning, for reference) | 5.3 ms |

- The type is 3.9x faster than `Get-ChildItem` and 3.1x faster than the PowerShell-only walk. On the largest sampled folder (`Catzc.Base.QualityGates`, depth 2, 404 entries) the PowerShell walk (6.3 ms) was slower than `Get-ChildItem` (3.7 ms) and the type took 1.4 ms: the per-item PowerShell loop costs more than the cmdlet, which is the case for the type.
- All 12 results equal the PowerShell walk's set, so the type and the plain walk agree.
- Caveat: the sampled trees are small (1 to 404 entries), warm-cache, one machine. The gap grows with tree size, but this run did not measure a large tree.

## Gate result and decision (2026-10-16)

`Test-Automation -Output Minimal -Level 2` stopped in `Assert-TestTagGate` on 3 tests of this module. The gate's message says "missing a required tier/category tag", but the cause was the ADR citation form: `Get-TestTagViolations` requires `ADR-<CODE>#<n>` (`^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$`) and rejects a bare code. Tier and category tags were fine. Decisions, applied on disk:

| Test | File | Tag now |
|---|---|---|
| fails fast on a folder that does not exist | `tests/Get-ChildPath.Tests.ps1:69` | `ADR-AUTO-FAILFAST#1` (assert inputs at entry) |
| fails fast on a missing folder and on a depth below 1 | `tests/types/FolderWalker.Tests.ps1:85` | `ADR-AUTO-FAILFAST#1` |
| readable as `global.folder-walk.prune_vendor_in_searches` | `tests/types/FolderWalkConfig.Tests.ps1:75` | `ADR-CONF-ADDRESSING#1` (the old `ADR-CONF-ADDRESS` was also the wrong code) |

A grep over `Catzc.Base.Folders` finds no other citation without `#<n>`. Not yet confirmed: the level-2 `Test-Automation` run itself passing (the person runs it; `#1` versus `#2` for the fail-fast tests is a judgment call to revisit if wanted). Lesson for the remaining steps: every new test cites rules in `#<n>` form, and each rule must exist in the registry.

## Open issue found during formatting (not caused by this plan)

A new `.yml` conflicts between two gates in the in-progress file-meta rollout: with the `#` meta head, `Test-Comments` reports "a 6-line comment is still in the file"; without it, `Test-FileMeta` reports drift ("expected the imprinted meta block"). `Export-Comments` also mangles a yml head if `Format-Code` runs on it again (it duplicated the head and wrote a residue line to a page). `folder-walk.yml` is left headless, like every other config yml in the repo today. Re-run `Format-FileMeta` on it once the rollout settles the yml carrier.

## Standing principle (applies beyond this plan)

When any code path is slow or repeated, ask first whether a compiled type removes the cost. Creating a type is an accepted optimization here, not a last resort.

## Carried: out/h.md, the ADR-PWSH-ENUM draft (verbatim, absorbed 2026-10-16)

---
catzc:
  derived:
    path: docs/adr/pwsh/bounded-enumeration.md
    kind: adr
    body_sha: "6a7207852e05"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PWSH-PARAM#4
      - ADR-PWSH-PESTER#9
---

# ADR: Bounded enumeration

## Rules: ADR-PWSH-ENUM

### Rule ADR-PWSH-ENUM:1

List the children of a folder, and anything deeper, with raw .NET only, through `Get-ChildPath` (the `Catzc.Base.Folders` module, backed by
the compiled `FolderWalker` type). `Get-ChildItem`, `gci`, `dir`, and `ls` never enumerate the filesystem.

- [Raw .NET, one way](#raw-net-one-way)

### Rule ADR-PWSH-ENUM:2

Enumeration is shallow by default: the depth is 2, declared once on the `folder-walk` config type (ADR-AUTO-DEFAULT#6) and read in the
parameter declaration (ADR-PWSH-PARAM#4). A deeper walk is an explicit `-Depth` at the call site, never a new default.

- [Shallow by default](#shallow-by-default)

### Rule ADR-PWSH-ENUM:3

Nothing is enumerated without a bound. `SearchOption.AllDirectories`, an unlimited depth, and a walk that builds a full list before it
filters are all unbounded. A call site that walks a whole tree on purpose is a named exception: it states its depth, and the comment says
why that depth is needed.

- [Nothing unbounded](#nothing-unbounded)

### Rule ADR-PWSH-ENUM:4

A walk prunes the folders that are never the answer: the config's `exclude` names (`.git`, `node_modules`, `out`) and, while the global
config value `prune_vendor_in_searches` is `true`, the vendor folder. A caller's explicit `-Exclude` or `-PruneVendor` wins over the
config. A walk lists a link and never enters it.

- [Pruned, and never through a link](#pruned-and-never-through-a-link)

### Rule ADR-PWSH-ENUM:5

Enumeration that is hot, repeated, or deep is a compiled C# type (ADR-AUTO-TYPES), measured against the PowerShell form. `FolderWalker` is
that type for folders. Code that needs a different walk extends the one type; it never carries a second copy of the stack walk
(ADR-PRIN-ONELIVE).

- [A compiled type for the hot path](#a-compiled-type-for-the-hot-path)

### Rule ADR-PWSH-ENUM:6

Code that loads before `Catzc.Base.Folders` exists (the internal bootstrap, vendor, and types modules, and the modules `Folders` itself
depends on) lists one level with an inline, non-recursive `[System.IO.Directory]::Enumerate*` call. It never recurses inline.

- [Callers below the walker](#callers-below-the-walker)

## Context

A recursive listing is the easiest way to find a file and the easiest way to make a command slow and its result wrong. An unbounded walk
enters `.git`, `node_modules`, and vendored modules, loads the whole tree into memory, and returns files the caller never meant to touch. The
cost grows with the repository, so a command that is fast today slows down as the tree grows, and nothing in the code says why.

### Raw .NET, one way

On Windows the PowerShell file cmdlets carry per-call provider and AV/AMSI overhead that `System.IO` avoids (ADR-PWSH-PESTER#9 names the
same effect for tests). `Get-ChildItem` also wraps every entry in a `PSObject`, so a large listing pays for properties the caller discards.
Raw .NET returns plain strings.

Raw calls alone are not enough: each author then writes the loop, the pruning, and the depth handling again, and each copy differs. One
function, `Get-ChildPath`, is the single way, so the depth, the pruning, and the link rule are decided once.

### Shallow by default

Most searches target a known place: a module's own files, a folder's direct children, a config tree a few levels down. A default of 2 covers
those and costs almost nothing. A default of "all levels" makes the rare deep walk free to write and the common walk expensive to run.

The default is a setting, so it lives where every setting default lives: on the config type, once. A function parameter, a literal at a call
site, and a constant in the walker would each be a second declaration. A caller that needs more says so with `-Depth`, which makes the cost
visible in review.

### Nothing unbounded

A depth is a promise about cost. `AllDirectories` makes no promise, and a full list built before filtering holds the entire tree in memory
even when the caller wants three files. A bounded, lazy walk visits only what its depth allows.

Some work does cover a whole tree: copying a package tree, snapshotting a build. These are legitimate, so the rule does not forbid them. It
asks the call site to state a depth that fits the tree and to say why, so a whole-tree walk is a decision someone made rather than a
default nobody noticed.

### Pruned, and never through a link

A search for `*.yml` below `automation/` should not return the vendored modules' files, and a search below the repository root should not
enter `.git`. Pruning by folder name, before descending, is far cheaper than filtering a full listing afterwards.

Vendor pruning is a global config value rather than a list entry or a parameter default, because the same repository question, "do
searches include third-party code?", has one answer for every command. A caller that needs vendored files passes `-PruneVendor $false`.

A link can point back into its own ancestry, so a walk that follows links can run forever or leave the tree. The walker lists the link as an
entry and does not descend into it.

### A compiled type for the hot path

Measured on twelve seeded random folders at depths 1 to 4, the type listed them in 4.3 ms, `Get-ChildItem` took 16.7 ms, and a
PowerShell-only walk with the same pruning took 13.2 ms; on the largest sampled folder the PowerShell loop was slower than the cmdlet. The
per-item PowerShell cost is the cost, and a compiled type removes it. This is the case ADR-AUTO-TYPES makes for a native type, and
ADR-PWSH-TYPES describes how the type is hosted.

### Callers below the walker

The internal modules load before the combined types assembly is built, so they cannot call `FolderWalker`. `Config`, `Repository`, and
`Objects` sit below `Folders` in the dependency order for the same reason. Their listings are one level deep, so a single inline
`Directory.Enumerate*` call is complete, bounded, and needs no stack walk. Anything that needs recursion belongs in a module above
`Folders`.

## Decision

Enumerate the filesystem with `Get-ChildPath`, to a bounded depth that defaults to 2, with the config's exclude names and the vendor folder
pruned and links never entered. Back it with a compiled type. Code that loads before the walker lists one level inline.

### How this is enforced

- **`Get-ChildPath` and `FolderWalker`** — the one walk; its tests cover the default depth, an explicit depth, pruning, ordering, a missing
  root, a tree deeper than the depth that is never entered, and a link that is listed and not followed.
- **`folder-walk` config** — `Test-ShippedConfigs` validates the shipped values against the config type that declares the defaults.
- **Code review** — a `Get-ChildItem` or an unbounded `AllDirectories` call is checked against this ADR.

## Consequences

- A search costs what its depth allows, not what the repository has grown to.
- Vendored, generated, and `.git` content stays out of results unless a caller asks for it.
- A deep or whole-tree walk is visible at its call site as a stated depth with a reason.
- One walker carries the depth, pruning, and link behaviour, so a fix or a speed-up reaches every caller.
- Modules below `Folders` carry a small inline one-level listing, which is the price of loading before the walker.
