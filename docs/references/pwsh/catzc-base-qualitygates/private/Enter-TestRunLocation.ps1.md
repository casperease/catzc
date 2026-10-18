# pwsh/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Claims where a test run executes — its location: in place in the working folder, or in an isolated snapshot of it.

### description

A test run never waits for another
([ADR-AUTO-TEST-RUNSNEVERWAIT](../../../../adr/automation/test-automation.md#rule-adr-auto-test-runsneverwait)). Concurrent runs share real
state in a checkout — the out/ build folders, the .compiled assembly, the git index and working tree — so only one run at a time may use the
working folder itself. This is the one claim path both entry points use:

- The working folder's lock — a named `[System.Threading.Mutex]` keyed on the repository root, machine-wide through the Global\ namespace —
  is tried without waiting. Free (or abandoned: the previous holder died mid-run): the run owns the working folder and runs in place. The
  holder writes a lock record (out/.test-run-lock.json: pid, entry point, start time, run folder) so a concurrent run can say who holds the
  folder.
- Held: the run announces who holds the folder (from the lock record, or plainly that the record is missing or stale) and runs in a verified
  snapshot of the working folder instead (New-RepositorySnapshot) — HEAD plus every uncommitted change, frozen at this moment — primed by
  one full import that materialises its generated files.
- -Isolated: the run takes the snapshot path without touching the lock, for a deterministic run that is immune to edits made in the working
  folder while it runs.
- Inside a worker of a run that already holds its location (CATZC_TEST_RUN_LOCATION_HELD): the parent's location covers this process and its
  repository root — the claim returns in place without a lock (claiming would only ever find our own parent's lock). An explicit -Isolated
  still gets its snapshot.

A run that takes the working folder also tries the user's system-test lock (Enter-SystemTestLock), without waiting: L3 changes state that
belongs to the user, not to this checkout, so a second clone's in-place run must not run L3 at the same time. SystemTests on the location
says whether this run may run L3; a run that owns the working folder but not the system-test lock names its holder (SystemTestHolder), and
Resolve-TestRunMaxLevel skips L3 for it.

The location is the one record of where the run executes: the run's context (Get-TestRunContext), its worker run
(Invoke-TestAutomationWorkers), and its report and run.json entries (Get-TestRunLocationSummary) all read this object. The caller MUST pass
it to Exit-TestRunLocation in a finally.

### parameter `EntryPoint`

The entry point claiming the location ('Test-Automation', 'Invoke-TestFile', …) — written to the lock record and named in the announcements.

### parameter `RunDirectory`

The run's report folder — written to the lock record so a concurrent run can name it.

### parameter `Isolated`

Run in a snapshot even when the working folder is free.

### parameter `KeepSandbox`

Keep a snapshot after the run instead of deleting it — recorded on the location as KeepSandbox, which Exit-TestRunLocation honours and the
run's report states.

### outputs

`[pscustomobject]` the location: Mode ('in-place'|'snapshot'), SourceRoot (the working folder), Root (where the run executes — the working
folder, or the snapshot), Mutex (owned, or $null), LockPath (the lock record
this run wrote, or $null), Holder (who held the folder when this
run went to a snapshot, or $null),
Snapshot (New-RepositorySnapshot's result, or $null), KeepSandbox (whether a snapshot is kept after the
run), SystemTests (whether this run may run L3), SystemTestLock (Enter-SystemTestLock's result when this run took it, or
$null), and SystemTestHolder (who holds the system-test lock when this run owns the working folder
but not that lock, or $null).

## comment:1

Above `$sourceCache = Join-Path (Get-OutputRoot) 'cache'`, written with `#`.

```text
The snapshot starts with the working folder's quality-check result caches (out/cache), which it would not
otherwise carry: each entry is keyed on a file's content and the stamps of the check's inputs
([ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](/docs/adr/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions)), so it holds in a copy of the same
tree and a file the snapshot changed is simply a new key. Without them every snapshot run would format and
analyse every file from cold. The snapshot's own updates stay in the snapshot.
```

## comment:2

Above `Write-Message 'Priming the snapshot: one import materialises its generated...`, written with `#`.

```text
Prime the snapshot with one full import, as a fresh clone's first import does: the janitors materialise
the generated, gitignored files the snapshot does not carry (module manifests, READMEs, root configs,
cspell dictionaries), once, before any worker starts — workers import with -SkipJanitors and would
otherwise find them missing, or race each other generating manifests. The snapshot is never committed to:
Sync-GeneratedFile recognises it by its provenance marker (Test-RepositorySnapshot).
Non-interactive, from the engine model
([ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine-differencesdeclaredonce)): no person can answer a
prompt here, so one fails at
once instead of waiting out the time limit.
```
