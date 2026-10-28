# pwsh/Base.QualityGates/Test-GeneratedFiles.ps1

The gate over generated files: it checks that every generated file equals what its generator would write now.

## help

### synopsis

Checks that every generated file equals what its generator would write now.

### description

One gate for every generator's drift
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)). Each writer runs in its
report-only mode — -DryRun -PassThru, which composes the content and writes nothing — and every file it reports as changed is one issue
naming the file, the generator, and the command that regenerates it:

```text
Build-DrsIndex               [index](/docs/drs/index.md) from drs.yml
Build-Glossary               [glossary](/docs/drs/glossary.md) from the configs/glossary.yml sources
Build-Readme                 the READMEs generated from their docs/references articles (readme.yml)
Build-ContractReference      the per-unit contract pages docs/references/contracts/<unit>.md from the contract assets
Build-GitKeep               every managed .gitkeep from the shipped assets/gitkeep
Build-TerminologyDictionary  the .cspell/<category>.txt lists from terminology.yml
Build-EnglishDictionary      the committed english.txt.gz, checked from its stamp (Get-EnglishDictionaryDrift)
                             — its -DryRun re-flattens cspell's tries through node, so the stamp is the
                             cheap equivalent: the pinned cspell version and the gz's word count
Build-RootConfig             every opted-in managed root file (rootconfig.yml); a file rendered by a
                             generator is attributed to that generator — New-Importer, New-GitIgnore,
                             New-VsCodeSettings, New-VsCodeExtensions, New-VsCodeLaunch,
                             New-GoWorkspace (one issue per stale file of a
                             multi-file generator, e.g. each go/tests/<folder>/go.mod)
```

The walk is over the writer registry, never over the heads
([ADR-REPO-FILEMETA-INTUNEWITHGENERATOR](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-intunewithgenerator)): the tracked
generated paths are those a writer row's output takes (Get-GeneratedTrackedPath, the answer the `generated` filter view selects), and a file
with a head on no declared output is authored, so it is never read. A writer's dry run renders each file whole, head included, so a stale
body and a hand-edited head are drift alike. A writer of the snapshot class reads outside the tree and a writer with no check has no dry
run, so their files are listed in the report's Skipped fact, never failed. The head's with_body_sha is the fast path of the changed-only
checks alone (Get-GeneratedStampDrift): a changed file whose stamp is the hash of its body needs no render of its own, and any miss renders
its writer. The full run renders every writer, so no cached verdict stands in for the render.

Collects every stale file and ends with Write-QualityGateReport: the report lands in out/test-generated-files/, and the gate throws once
listing every issue (or returns the result with -PassThru). The generators read and write the source tree, so the gate needs the source mode
(Assert-SourceTree).

### parameter `Generator`

Check only these generators (default: every one). Build-RootConfig selects every managed root file; a generator it renders (New-Importer, …)
selects only that generator's files.

### parameter `Changed`

Check only what git reports changed against HEAD: a writer's dry run runs when Get-GeneratedWriterDue says it is due, by a missing output or
a changed stamp of the inputs of its writer row, or when one of its changed tracked outputs misses its stamp. Catches a generator change
whose output was not re-rendered and a hand edit of a generated file's body; a head edited by hand over an intact body is the full run's to
find.

### parameter `StampOnly`

Ask no due rows: only a writer one of whose tracked outputs misses its stamp renders, the cheap check the import janitor makes over the
changed set. Combine it with Changed; the writers' due renders stay the full run's.

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-generated-files).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Facts } instead of throwing on issues; its facts are Generators, Tracked
(the tracked generated paths read) and Skipped (each writer whose files no dry run checks, with why).

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-GeneratedFiles
```

### example 2

```powershell
(Test-GeneratedFiles -Generator Build-DrsIndex, New-Importer -PassThru).Issues
```

## Writers

Each registered writer is run by its check. The registry (the writer rows of the modules' `generated.yml`) says which check, and for a file
result which property holds the path. The list is wrapped in `@()` as a whole so that an empty list stays an array under strict mode.

## Gate freshness

A writer whose check is `gate` has no dry run, so the full run (not `-Changed`) also proves it fresh from the commits
(Get-GeneratedGateDrift). The writer is stale when a generated input, the output of another writer whose glob is one of this writer's
inputs, was committed after the last commit of its own outputs: its outputs were rendered from an older input. The judgement is per writer,
not per file: a stale writer is one issue naming the upstream writer and the newer commit, whatever number of its files there are. An
authored input is not judged here, and a writer with no committed output is not stale.

## Changed only

With `-Changed`, only the writers that Get-GeneratedWriterDue names run their dry run, with those whose changed outputs miss their stamp.
That is the one reading of the writers' inputs and outputs lists.
