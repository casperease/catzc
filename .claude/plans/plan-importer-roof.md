---
plan:
  status: blocked
  value: high
  reviewed: 2026-11-07
  waits_on: the first slow console import in out/import-times.jsonl (the antivirus proof the user chose to wait for)
  class: feature
  targets:
    [
      pwsh/.internal,
      pwsh/Base.Timeouts,
      pwsh/Base.ModuleSystem,
      pwsh/Base.RootConfig,
      pwsh/Base.Config,
      pwsh/Base.ConfigExtensions,
      pwsh/Base.Repository,
      pwsh/Base.Docs,
      pwsh/Base.QualityGates,
      docs/drs/automation/importer.md,
      docs/drs/automation/pwsh,
    ]
---

# Importer roof

A console import stays under 3 s at all times (the user, 2026-11-06, after an import read 34.9 s, module import 34.1 s; an earlier one read
25.3 s on 2026-11-04). Measured the same day from `.\importer.ps1 -DiagnoseLoadTime` in a non-interactive pwsh on the same tree: 8.5 s, of
which the initializer 0.2 s, the module import 3.0 s (all modules 2915 ms: parse and compile 1535 ms, the types step 490 ms,
`Base.QualityGates` 336 ms; the import mix 1396 ms) and the finalizer 5.4 s. A console skips the mix and defers the janitors, so a warm
console import should read near 2.4 s: about 1.6 s of module import and 0.8 s of initializer.

## Why its value

The importer is the entry to every session and every cats command. The two slow imports cost the user half a minute each, and nothing on the
importer's line said why.

## Decided

- The slow imports are not a code path (diagnosed 2026-11-06, read-only). Not a types compile: the assembly has existed since 2026-11-04,
  the console took the cache-hit branch, and a real compile measured cold costs 4.4 s. Not a lock: `Wait-ImportBurst` runs before the
  stopwatch, and a console defers the janitors and the mix past the first prompt. Not the host kind, the lazy types, the user's profile, a
  real console window, a fresh terminal's `PATH` or the agent variables: six reproductions, one per variant, read 3.1 to 3.6 s of module
  import.
- **The evidence points at the antivirus scan of a first import.** Every slow import was the first after Defender dropped its results: the
  boot of 2026-11-04 23:16 (import 23:18, 25.3 s), the signature updates of 2026-11-06 13:52 (import 14:29, 34.9 s) and 18:34 (import about
  19:55, 27.6 s); every fast reproduction ran after one of them; and the slow process used 11 s of CPU in a 34.9 s import, so it waited on
  another process. A correlation, not a controlled proof: the exclusions and the scanner's activity need admin rights to read. Whether the
  wait is the on-access scan of 1452 script files or the script scan at parse decides the fix, and the importer's two numbers for those
  (file read, parse and compile) tell them apart in a slow import.
- **The fix is the user's choice once the ledger has shown one slow import** (asked 2026-11-06): an antivirus exclusion or a Dev Drive for
  the tree (a security control on a regulated box, admin rights), a background warm import when the signature version changes, or loading
  modules on first use so an import parses a fraction of the scripts.
- **An import says whether it computed or waited.** The console line shows three numbers and no cause. Every console import appends one line
  to an import ledger under `out/` with the wall seconds of the initializer, the vendor import, the types step, the module loop and the
  finalizer, the process's CPU seconds over the same span, and the seconds since the process started; and when the total is over the roof,
  the "Loaded in" line adds the CPU seconds, so a starved import names itself at the prompt.
- **The roof is declared once**, `import.console_seconds` on `TimeoutsConfig`, default 3, read by the importer after the load for its own
  line; it fails nothing, since an import must never throw for being slow. The type lands first, then one fresh import, which rebuilds the
  Bash hook, then the yml line.
- **A warm console import reads 3.6 to 3.7 s today, over the roof** (seven measured imports, 2026-11-06, the ledger's first line among them:
  3.8 s of CPU in 3.7 s, so it computes the whole time). Where it goes: the module loop 2.9 s over 58 modules and 1452 script files, of
  which parse and compile 1.9 to 2.0 s; `Base.QualityGates` alone 0.45 to 0.54 s; the types step 0.8 to 1.0 s on a console import although
  its load is deferred (the ledger's always-on pair around the whole step; the diagnosis switch showed 0.39 s for its inner part); the
  bootstrap 0.17 s; the vendor module 0.12 s; the initializer 0.2 s.
- The roof and the ledger landed on 2026-11-06: `import.console_seconds: 3` on `TimeoutsConfig` and in `timeouts.yml`, and every console
  import appends a line to `out/import-times.jsonl` (the phases, parse and compile, a 20-file read probe, the CPU seconds, the antivirus
  signature version) and names its CPU seconds on the "Loaded in" line when over the roof. Three plain console imports after it read 3.5 s
  each, 3.8 s of CPU: types 0.8 to 1.0, modules 2.2 to 2.4, parse and compile 1.84 to 1.94, the probe 5 to 6 ms.
- The types step's content check reads only the type names from the assembly's own metadata in one pass (landed 2026-11-06:
  `Test-TypesAssemblyContent` 329 ms to 48 ms, the check still looking at the real assembly on every import; a cut that read the names from
  the manifest beside it was rejected as a cached verdict). The types step reads 0.5 to 0.6 s and three plain console imports 3.1, 3.0 and
  3.1 s. Left in the step: the combined source hash, 283 ms on its first call in a process and 96 ms on a second, so about 190 ms is first
  use (a yml read of 25 ms measured, the rest unseparated); the source validation loop 87 ms; the drift check 69 ms.
- **The loader stays one dot-source per file** (measured 2026-11-06 on `Base.QualityGates`, 252 files, fresh processes,
  `out/meister-c2-loader-report.md`): today's form 358 ms; one in-memory script block for the module 227 ms, but its functions carry no file
  and an error reads "no file, line N"; one concatenated file 340 to 368 ms, with the concatenation's name and lines. No form is both faster
  and true to a function's own file. Pure parse over the modules' 1041 script files is about 610 ms, 0.58 ms a file, and the same text as
  one string per module parses no faster, so the module loop is parse and compile volume, not per-file overhead.
- **Under the record the warm import ends at 3.0 to 3.1 s**; what is left inside it is small (the combined source hash's first use about 190
  ms, the validation loop 87 ms, the bootstrap 170 ms).
- **A console session loads its modules on first use** (the user, 2026-11-06): the core at import and each other module when one of its
  commands is first looked up. Designed read-only against the tree the same day:
  - _Mechanism_: the session's one pre-lookup hook, extended from the types to the modules, the types first; its name filter is a compiled
    delegate over one case-insensitive dictionary of command name to module, since the hook stays for the session and a script hook costs 12
    to 14 microseconds on every command lookup where the compiled filter measured free. The engine's own auto-loading loses to
    ADR-PWSH-MODPATH-SURGICALREMOVAL (the importer leaves the module path alone) and cannot see the source layout; stub functions lose to
    ADR-PWSH-MANIFEST-ONEDEFINITIONPERNAME and would hide a command's `TimeLimit`; the not-found hook runs after the engine's module-path
    search, 58 to 65 ms a miss.
  - _The map_ is the name-to-file map the collision check already builds at every import and drops; kept, it costs nothing and has no cache
    to invalidate. The collision check and the generated manifests cover every module at import, deferred or not.
  - _The core_ is the declared closure of the module that decides the mix, `Catzc.Base.ModuleSystem`: 21 modules, 275 of 1036 function
    files, generated as a flat list by a root-config generator from `Get-ModuleDependencyClosure`, never listed by hand; a missing list
    defers everything and nothing throws. Load order needs no work: modules load in folder order today and a function file holds only a
    function (ADR-AUTO-MODULE-TOPOLOGICALORDER).
  - _Which sessions_: one key `moduleLoad` in the cells of `types-load.yml`, default eager; the Windows console source cell flips first.
    Headless sessions, the test workers and the build rows stay eager: a broken file fails where the run starts, and the test harness
    reaches into loaded modules.
  - _What a console user sees_: `Get-Module` lists the core; a wildcard `Get-Command` sees loaded modules only; a deferred command's first
    call pays its module's parse, 10 to 540 ms; the janitors after the first prompt pull `Base.QualityGates`, so about 0.6 s moves from the
    import to the second prompt and is not saved; a parse error in a deferred module fails its first use, not the import. Command-name
    completion keeps every name: the completion entry appends the index's names without loading a module.
  - _Expected_: the module loop 0.8 to 1.0 s against 2.2 to 2.4, a console import 1.6 to 2.0 s, allowing 2.4 s for the types step's swing.
  - `.claude/CLAUDE.md` says the importer imports all modules, twice; its wording is the user's to change, in task-user-runs-and-commits.
- **The slow first import waits for its proof** (the user, 2026-11-06): nothing is built for it before the ledger has shown one.
- **Cuts inside the record come first, each measured before it lands.** ADR-AUTO-IMPORTER-RESOLVEDAFTERLOAD has the importer load every
  module of the code root and resolve the mix from the loaded toolset, so loading modules on first use is a change of that rule and the
  user's call; it is brought to the user only when the cuts below leave a warm import over 3 s, with their numbers. The types step is a
  guard, and a guard's verdict is never cached across sessions beyond what its own stamp files already do, so its cut is to find what its
  0.8 to 1.0 s is, not to skip a check.

## Open steps

No open step: the switch landed on 2026-11-07 (`moduleLoad: lazy` on the Windows console source cell). Three plain console imports read 1.8
s each (types 0.4, the module loop 1.0 to 1.1, parse and compile about 510 ms, 1.9 s of CPU); a lazy session holds 24 modules after import,
completes `Build-Bic` to `Build-Bicep` with its module unloaded, and loads the quality-gates module in 428 ms at the first lookup of one of
its commands. The plan waits on the ledger's first slow import line, which decides the antivirus question the user chose to prove first; it
closes when that line is read and its fix is either landed in a plan of its own or declined with the line's numbers.

## Refs

- ADR-AUTO-IMPORTER ([importer](../../docs/drs/automation/importer.md)), ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
  ([fail-fast-with-asserts](../../docs/drs/automation/fail-fast-with-asserts.md)).
