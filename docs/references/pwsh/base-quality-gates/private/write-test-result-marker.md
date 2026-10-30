# pwsh/Base.QualityGates/private/Write-TestResultMarker.ps1

Keeps one test result per test file that ran, `out/test-results/<repository path of the test file>.result.json`, and returns the files
written.

## help

### synopsis

Keeps one test result per test file that ran, `out/test-results/<repository path of the test file>.result.json`.

### description

The editor's lamps read a test failure from the result's outcome, start time and scope (DDR-FILTER-ENGINEADAPTSSOURCES). Every runner that
executes test files writes through this function: `Invoke-TestFile`, `Test-Automation` and `Test-CatzcBuild` (through `Invoke-TestRun`). A
file outside the repository gets none.

### parameter `Outcome`

One item per test file the run executed: `Path` (the file's source path), `Failed` (whether it failed) and `FailedCount`.

### parameter `RunDirectory`

The run's folder, named in a written result.

### parameter `Runner`

The command that ran the files, stored in the result.

### parameter `StartedAt`

The run's start as ISO text. The lamps compare it with the module's file times, never the result file's own time.

### parameter `MinLevel`

The lowest test level the run covered; part of the result's scope.

### parameter `MaxLevel`

The highest test level the run covered; part of the result's scope.

### parameter `Category`

The test category the run covered, `Logic`, `Integrity` or `Both`; part of the result's scope.

### parameter `Rule`

The rule tags the run was limited to; part of the result's scope.

### parameter `Filtered`

The run was filtered to some tests (`-FullNameFilter` or `-Rule`), so it records failures only and never writes a pass.

### parameter `Isolated`

The run executed in a snapshot, not in the working folder.

### parameter `RepositoryRoot`

The root the results' paths are relative to; the repository root by default.

### parameter `OutputRoot`

The output root that holds `test-results`; the repository's by default.

### outputs

`[string[]]` The result files written.

## Results

A result is JSON: `result` (`failed` or `passed`), `failedCount`, `startedAt`, `runner`, `pid`, `isolated`, `scope` (`minLevel`, `maxLevel`,
`category`, `rule`, `filtered`) and `runDirectory`. It is written under a temporary name and moved into place, so a peer's reader never sees
half a file.

## Scope

A failure is always written, so the file holds the newest failure. A pass replaces a stored failure only when its scope covers the failure's
scope: its levels reach at least as low and as high, and its category is `Both` or the same. A narrower pass leaves the failure standing,
and a filtered pass writes nothing, since it ran only some of the tests. A stored result that does not parse is treated as none.
