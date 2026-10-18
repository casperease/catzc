# automation/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Builds the one Pester configuration every test invocation path shares — shard workers and the manual single-check entry point alike.

### description

The single living copy of "how this repository invokes Pester" (see one-living-version): Run.Path + PassThru, output verbosity, the run's
exclude tags, optionally the NUnit result file (shard workers) and a full-name filter (the manual single-check path). Both the generated
shard scripts (New-TestAutomationShardScript, via module scope inside the worker) and Invoke-TestFile consume this, so the two invocation
paths cannot drift apart. The strict-mode discipline itself (Set-StrictMode -Version Latest before Invoke-Pester — tests run strict, see
[ADR-AUTO-TEST#25](../../../../adr/automation/test-automation.md#rule-adr-auto-test25)) stays with the CALLER: strict mode is scope-dynamic,
so only the scope that invokes Pester can set it for the tests.

### parameter Path

The test file(s) or folder(s) to run. A Go test folder runs through the Go bridge (ConvertTo-PesterRunTarget).

### parameter ExcludeTag

Tags excluded from the run (from Get-TestExcludeTag). Empty means no tag filter.

### parameter IncludeTag

Tags a test must carry to run (Pester Filter.Tag) — the -Rule provenance filter. Empty means no include filter (the default); a test still
also has to clear ExcludeTag.

### parameter Verbosity

Pester output verbosity.

### parameter ResultsPath

When given, enables the NUnit result file at this path (the shard workers' `results-shard-<N>.xml`).

### parameter FullNameFilter

When given, filters the run to tests whose full name matches (the manual single-check path).

### parameter EntryScript

The engine entry of a build run (the build's Import-Catzc.ps1), handed to the language bridge so the Go and Python tests start the build;
empty for the source run.

### parameter LanguageExecutable

The managed tool per test language and the executable per engine other than pwsh the run's source session located
(Get-LanguageTestExecutable: @{ go = `<path>`; python = `<uv path>`; `<engine>` = `<path>` }), handed to the language bridge; an empty entry
means there is none.

### outputs

`[object]` A PesterConfiguration, the configured, ready-to-invoke configuration, typed object because Pester is vendored and loads later.
