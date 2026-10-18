# pwsh/Catzc.Base.QualityGates/Invoke-TestFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Runs one or more test files by hand as a single worker shard — the blessed single-check entry point.

### description

The manual counterpart of a Test-Automation worker: it generates a one-shard runner through the SAME generator the parallel harness uses
(New-TestAutomationShardScript, which builds its Pester configuration through the one shared New-PesterRunConfiguration) and executes it as
a child pwsh worker (PesterRunner, live output). Parity is by construction, not imitation — the manual path cannot drift from the harness
path because it IS the harness path, one shard wide.

Why a child process and not an in-session Invoke-Pester: a worker starts from a fresh process — a freshly imported toolset with empty
session caches, no state left by earlier commands, and its own top scope set strict by the shard script
([ADR-AUTO-TEST-FILEPARALLELISM](../../../adr/automation/test-automation.md#rule-adr-auto-test-fileparallelism)) — exactly the conditions CI
runs under. A bare Invoke-Pester from an interactive session runs the same tests against whatever that session has accumulated; this entry
point closes that gap.

Use it for the manual single-check flow in docs/how-to/pwsh/manual-test-plan.md: pass the row's test file and (optionally) its
FullNameFilter. No category exclusion is applied — a hand-run of a named check should run exactly that check. The run's artifacts (worker
script, results-shard-0.xml, rows-shard-0.json, run.json) land in a timestamped folder under out/test-file/. run.json is the same state
record Test-Automation writes (Write-TestRunManifest): 'running' when the worker starts, then 'passed', 'failed' or 'crashed' on every exit
path, with where the run executed (in place, or a snapshot with its provenance) — so every test run of
[ADR-AUTO-TEST-TESTRUN](../../../adr/automation/test-automation.md#rule-adr-auto-test-testrun) leaves one record shape. An earlier run in
out/test-file/ whose process died is marked 'abandoned' first (Set-AbandonedTestRun).

It never waits for another test run's use of the working folder
([ADR-AUTO-TEST-RUNSNEVERWAIT](../../../adr/automation/test-automation.md#rule-adr-auto-test-runsneverwait), Enter-TestRunLocation): when
the working folder is free it runs in place; when another run holds it, it runs in a verified snapshot of the working folder instead — the
test files map to the same repository-relative paths inside the snapshot, a test file outside the repository runs as given, and the
artifacts still land in the working folder's out/test-file/. Every tier up to L3 runs in place; a snapshot run skips the L3 vertical system
tests, which change state outside the repository, and says so (Resolve-TestRunMaxLevel,
[ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../../adr/automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree)). The opt-in L4 tests
run only with -MaxLevel 4
([ADR-AUTO-TEST-TESTINGINPRODUCTION](../../../adr/automation/test-automation.md#rule-adr-auto-test-testinginproduction)).

### parameter `Path`

The test file(s) to run — absolute, or repository-root-relative (never resolved against $PWD; see
[ADR-AUTO-NOPWD](../../../adr/automation/never-depend-on-pwd.md)).

### parameter `FullNameFilter`

Filter to tests whose full name contains this text (wrapped in wildcards) — the manual-test-plan row's FullNameFilter column, verbatim.

### parameter `Output`

Pester output verbosity inside the worker. Defaults to 'Detailed' — a hand-run wants one line per test.

### parameter `MaxLevel`

The highest tier to run (alias: -Level): 3 by default, every tier but the opt-in L4; 4 runs the file's L4 tests too.

### parameter `TimeoutSeconds`

Hard ceiling for the worker; on expiry it is killed and this throws. Defaults to this function's `[TimeLimit]` (360 s on a devbox, 600 s in
a pipeline), unless timeouts.yml overrides it
([ADR-PWSH-ASSERT-DECLAREDTIMELIMIT](../../../adr/pwsh/assert-idioms.md#rule-adr-pwsh-assert-declaredtimelimit)).

### parameter `Isolated`

Run in a snapshot of the working folder even when it is free — immune to edits made while it runs.

### parameter `KeepSandbox`

Keep the snapshot (when the run used one) after the run instead of deleting it, for a post-mortem.

### parameter `PassThru`

Return a result object ({ Result, ExitCode, Rows, RunDirectory, Location }) instead of nothing. Rows are the worker's per-test rows (the
same shape Test-Automation aggregates; File paths are working-folder paths even for a snapshot run) — the live Pester object cannot cross
the process boundary. Location is the run's location as the run directory's run.json records it: 'in-place' or 'snapshot'.

### outputs

None by default; the result object with -PassThru. The worker's Pester output streams either way, and a failed run ends with every failure's
message (Write-TestRunFailures): each failed test, and each file that failed before its tests ran.

### example 1

```powershell
Invoke-TestFile pwsh/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
```

### example 2

```powershell
Invoke-TestFile pwsh/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1 -FullNameFilter 'Generated README copy-ins'
```

## comment:1

Above `$reportBase = Join-Path (Get-OutputRoot -EnsureExists) 'test-file'`, written with `#`.

```text
A timestamped run folder under out/test-file/, like the harness's out/test-automation/<stamp>/. Earlier runs whose
process died never stamped their run.json: mark them 'abandoned' first, as Test-Automation does.
```

## comment:2

Above `$location = Enter-TestRunLocation -EntryPoint 'Invoke-TestFile' -RunDirectory...`, written with `#`.

```text
Claim where the run executes — in place, or in a snapshot when another run holds the working folder
(Enter-TestRunLocation owns the why). The worker inherits CATZC_TEST_RUN_LOCATION_HELD, as Test-Automation's
workers do, so a test that drives Invoke-TestFile for real inside this run runs in place in this run's
root rather than claiming a location of its own.
```

## comment:3

Above `$effectiveMaxLevel = Resolve-TestRunMaxLevel -Location $location -Requested...`, written with `#`.

```text
Every tier asked for that the location allows: in place that includes the L3 system tests; a snapshot skips
them and says so (Resolve-TestRunMaxLevel owns the why). L4 only when asked for.
```

## comment:4

Above `$files = if ([System.IO.File]::Exists($shard.FilesPath)) {`, written with `#`.

```text
Every failure's message, on the console at every -Output level (the worker's own output does not reach a
redirected console): failed tests from the rows, and a file that failed before its tests ran from the
files sidecar.
```
