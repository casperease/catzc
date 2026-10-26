# pwsh/.internal/tests/Test-ScriptAnalyzer.Tests.ps1

The tests that run PSScriptAnalyzer over the repository's own files, through the same engine `Test-ScriptAnalyzer` uses.

## Why it is greedy

The analysis shards across `min(ProcessorCount - 1, 10)` background pwsh processes of its own. Stacked on the parallel worker pool, that
fan-out oversubscribes the machine and inflates neighbouring tests' wall clock against the level time limits, so the greedy phase runs it
after the pool instead.

## Which files

The files come from the one shared selector, `Get-ModuleSourceFile`, so this test cannot drift from `Test-ScriptAnalyzer`
([ADR-PWSH-FORMAT-EVERYFILECOVERED](../../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-everyfilecovered)). The
selector covers:

- module `*.ps1` files (the root and `private/`);
- `tests/**/*.Tests.ps1`, recursively, so `tests/types/` is included;
- the `.internal` and `.scriptanalyzer` infrastructure folders (bootstrap, TestKit, custom analyzer rules and their tests);
- the root `importer.ps1`;
- authored `.psd1` config.

`.vendor`, `.compiled` and generated manifests are excluded as build output. The list is sorted for stable, reproducible shard assignment.

## The engine

`Get-ScriptAnalyzerDiagnostics` is the one analysis engine `Test-ScriptAnalyzer` runs: the file list is sharded across background processes,
each importing the vendored analyzer once. Its result cache skips every file the analyzer last found clean whose bytes and analyzer inputs
are unchanged since ([ADR-AUTO-CACHE-CROSSSESSIONFILES](../../../../drs/automation/caching.md#rule-adr-auto-cache-crosssessionfiles)); a
pipeline, without the cache, analyzes every file. A shard error fails the run loudly inside the engine.
