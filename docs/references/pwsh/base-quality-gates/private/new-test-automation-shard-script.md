# pwsh/Base.QualityGates/private/New-TestAutomationShardScript.ps1

Generates one parallel worker's runner script and returns its shard descriptor. The script is what a worker process runs for its share of
the test files.

## help

### synopsis

Generates one parallel worker's runner script and returns its shard descriptor.

### description

Writes `<RunDirectory>/shard-<N>.ps1` — the script a PesterRunner worker executes as `pwsh -NoProfile -File` (modeled on Test-InIsolation's
generated runner). The worker dot-sources the repository importer (-SkipJanitors), starts watching the process that launched it
(WorkerParentWatch — the worker kills itself when that parent is gone, so a run whose parent died never leaves workers behind), then sets
strict mode for its own scope, whichever entry script loaded the modules: the test scopes chain to that scope, so every test body runs
strict ([ADR-AUTO-TEST-FILEPARALLELISM](../../../../drs/automation/test-automation.md#rule-adr-auto-test-fileparallelism)) — the module code
under test is strict through its own module scope. It then imports vendored Pester — resolved inside the worker, after the import, from the
worker's own code root (Get-CatzcModulesRoot/.vendor/Pester), so Pester always comes from the tree the worker loaded
([ADR-AUTO-ASSETDEP-INTERNALASSETDEPENDENCY](../../../../drs/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep-internalassetdependency))
— builds its run configuration through the ONE shared builder (New-PesterRunConfiguration, reached via module scope — the same builder
Invoke-TestFile uses, so the worker and manual paths cannot drift), runs the shard's test files with the run's exclude tags, writes Pester's
NUnit results to `results-shard-<N>.xml`, reduces its live result to rows (ConvertTo- TestAutomationRowSet — tier/category resolution needs
the live .Block chain, so it must happen inside the worker) into `rows-shard-<N>.json`, writes each test file's whole Pester duration
(set-up included) into `files-shard-<N>.json` — the measurement the next run schedules by (Select-TestShardAssignment) — with the file's own
Result and ErrorMessage (the error of a file that failed while Pester discovered or set it up, which no test row can carry; empty when the
file loaded), and exits 0 (green) or 1 (the run did not pass — failed tests, or a container/discovery error that fails the run with zero
failed tests). Any other exit code — or a missing rows sidecar — means the worker itself crashed, which the parent surfaces loudly.

### parameter `ShardIndex`

The shard's zero-based index — names the script, results, and rows files.

### parameter `TestPath`

The shard's test files (absolute `*.Tests.ps1` paths).

### parameter `RunDirectory`

The run directory the script and its artifacts are written into (must exist).

### parameter `ExcludeTag`

Tags excluded from the worker's run (from Get-TestExcludeTag). Empty means no tag filter.

### parameter `IncludeTag`

Tags a test must carry to run (the -Rule provenance filter). Empty means no include filter.

### parameter `Verbosity`

Pester output verbosity inside the worker (the run's -Output value).

### parameter `FullNameFilter`

Filter the worker's run to tests whose full name contains this text — the manual single-check path (Invoke-TestFile). Empty means no name
filter (the harness never sets one).

### parameter `EntryScript`

The run seam ([ADR-AUTO-TEST-SAMETESTSBOTHRUNS](../../../../drs/automation/test-automation.md#rule-adr-auto-test-sametestsbothruns)): the
script the worker dot-sources to load the modules. Empty (the default) is the source run's `<repo>/importer.ps1 -SkipJanitors`; the build
run passes the build's `Import-Catzc.ps1`. Everything after the load — Pester from the code root, the shared configuration builder, the row
sidecar — is identical for both runs, except that the configuration hands the entry script to the Go bridge, so the Go tests start the same
engine the worker loaded.

### parameter `EntryParameter`

Named arguments for -EntryScript, rendered into the dot-source line as `-Name 'value'` (a $true value renders as a bare switch). Ignored
without -EntryScript. The build run passes @{ RepositoryRoot = `<repo>` } so out/ and repo-relative paths keep resolving in the repository.

### parameter `LanguageExecutable`

The managed tool per test language and the executable per engine other than pwsh the run's source session located
(Get-LanguageTestExecutable: @{ go = `<path>`; python = `<uv path>`; `<engine>` = `<path>` }), rendered into the worker as a hashtable
literal and handed through the configuration to the language bridge; an empty entry means there is none. The worker never locates a tool: a
build's engine has no tools.yml entry.

### outputs

`[pscustomobject]` with ShardIndex, Label, ScriptPath, ResultsPath, RowsPath, FilesPath.

## Entry script

The entry script is the one seam between the source run and the build run: it decides which script loads the modules. The source run, the
default, uses the repository importer. The build run uses the build's `Import-Catzc.ps1` with its named arguments. The build run's entry
also reaches the language bridge, so the Go and Python tests start the build too (New-PesterRunConfiguration).

## Language tools

The tools this source session located reach the language bridge as a hashtable literal, in language order. A build's engine cannot locate
them itself.

## Pester configuration

The Pester configuration comes from the one shared builder, New-PesterRunConfiguration, so this worker path and the manual single-check path
(Invoke-TestFile) cannot drift apart. The worker has the full toolset imported, so it reaches the private function through module scope.
Only the strict-mode setting stays inline: strict mode is scope-dynamic and the test scopes chain to the process's top scope, so the worker
script itself must set it, and tests run strict
([ADR-AUTO-TEST-FILEPARALLELISM](../../../../drs/automation/test-automation.md#rule-adr-auto-test-fileparallelism)).

## comment:1

Above `$content = @"`, written with `#`.

```text
The Pester configuration comes from the one shared builder, so this path and Invoke-TestFile never drift.
Pester returns nothing for an error after its run, so the worker records a failed container with the last message it printed.
```
