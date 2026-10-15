---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/New-TestAutomationShardScript.ps1.md
    kind: reference
    body_sha: b07c653bcc38
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-TEST#25
      - ADR-AUTO-TEST#30
---

# automation/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Writes <RunDirectory>/shard-<N>.ps1 — the script a PesterRunner worker executes as `pwsh -NoProfile
-File` (modeled on Test-InIsolation's generated runner). The worker dot-sources the repository importer
(-SkipJanitors), starts watching the process that launched it (WorkerParentWatch — the worker kills itself
when that parent is gone, so a run whose parent died never leaves workers behind), then sets strict mode
for its own scope, whichever entry script loaded the modules: the
test scopes chain to that scope, so every test body runs strict
([ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)) — the module code under
test is strict through its own module scope. It then imports vendored Pester — resolved inside the worker,
after the import, from the worker's own code root (Get-CatzcModulesRoot/.vendor/Pester), so Pester always
comes from the tree the worker loaded
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)) — builds its
run configuration through the ONE shared builder
(New-PesterRunConfiguration, reached via module scope — the same builder Invoke-TestFile uses, so the
worker and manual paths cannot drift), runs the shard's test files with the run's exclude tags, writes
Pester's NUnit results to results-shard-<N>.xml, reduces its live result to rows (ConvertTo-
TestAutomationRowSet — tier/category resolution needs the live .Block chain, so it must happen inside the
worker) into rows-shard-<N>.json, writes each test file's whole Pester duration (set-up included) into
files-shard-<N>.json — the measurement the next run schedules by (Select-TestShardAssignment) — with the
file's own Result and ErrorMessage (the error of a file that failed while Pester discovered or set it up,
which no test row can carry; empty when the file loaded), and
exits 0 (green) or 1 (the run did not pass — failed tests, or a
container/discovery error that fails the run with zero failed tests). Any other exit code — or a missing
rows sidecar — means the worker itself crashed, which the parent surfaces loudly.
```

## comment:2

Section `.PARAMETER EntryScript` of the comment-based help.

```text
The run seam ([ADR-AUTO-TEST#30](/docs/adr/automation/test-automation.md#rule-adr-auto-test30)): the script the
worker dot-sources to load the modules. Empty (the
default) is the source run's `<repo>/importer.ps1 -SkipJanitors`; the build run passes the build's
`Import-Catzc.ps1`. Everything after the load — Pester from the code root, the shared configuration
builder, the row sidecar — is identical for both runs, except that the configuration hands the entry script
to the Go bridge, so the Go tests start the same engine the worker loaded.
```

## comment:3

Section `.PARAMETER EntryParameter` of the comment-based help.

```text
Named arguments for -EntryScript, rendered into the dot-source line as `-Name 'value'` (a $true value
renders as a bare switch). Ignored without -EntryScript. The build run passes
@{ RepositoryRoot = <repo> } so out/ and repo-relative paths keep resolving in the repository.
```

## comment:4

Section `.PARAMETER LanguageExecutable` of the comment-based help.

```text
The managed tool per test language and the executable per engine other than pwsh the run's source session
located (Get-LanguageTestExecutable: @{ go = <path>; python = <uv path>; <engine> = <path> }), rendered into the
worker as a hashtable literal and handed through the configuration to the language bridge; an empty entry means
there is none. The worker never locates a tool: a build's engine has no tools.yml entry.
```

## comment:5

Above `[string] $FullNameFilter,`.

```text
Filter the worker's run to tests whose full name contains this text — the manual single-check path
(Invoke-TestFile). Empty means no name filter (the harness never sets one).
```

## comment:6

Above `$entryLine = if ($EntryScript) {`.

```text
The one seam between the two runs: which entry script loads the modules. Source run (default) —
the repository importer; build run — the build's Import-Catzc.ps1 with its named arguments.
```

## comment:7

Above `$entryLiteral = "$EntryScript" -replace "'", "''"`.

```text
The build run's entry also reaches the language bridge, so the Go and Python tests start the build
(New-PesterRunConfiguration).
```

## comment:8

Above `$languageEntries = foreach ($language in ($LanguageExecutable.Keys |...`.

```text
The tools this source session located reach the language bridge the same way, as a hashtable literal in
language order: a build's engine cannot locate them.
```

## comment:9

Above `$content = @"`.

```text
The Pester configuration itself comes from the ONE shared builder (New-PesterRunConfiguration) so this
worker path and the manual single-check path (Invoke-TestFile) can never drift apart — the worker has
the full toolset imported, so it reaches the private through module scope like ConvertTo-
TestAutomationRowSet below. Only the strict-mode discipline stays inline: strict is scope-dynamic and
the test scopes chain to the process's top scope, so the worker script itself must be the one to set
it (tests run strict — [ADR-AUTO-TEST#25](/docs/adr/automation/test-automation.md#rule-adr-auto-test25)).
```
