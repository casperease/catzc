# pwsh/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: checks that every generated file equals what its generator would write now.

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
                             New-VsCodePipelineSchema, New-GoWorkspace (one issue per stale file of a
                             multi-file generator, e.g. each go/tests/<folder>/go.mod)
```

Then the stamp check ([ADR-REPO-FILEMETA-COMPOSEDFILES](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-composedfiles)): every
tracked file .gitattributes marks linguist-generated opens with with_body_sha, the hash of the content below its head, and a stamp that is
not the hash of the body is one issue (Get-GeneratedStampDrift). A generated file whose writer writes no head yet is counted as unstamped in
the report's facts, never failed.

Collects every stale file and ends with Write-QualityGateReport: the report lands in out/test-generated-files/, and the gate throws once
listing every issue (or returns the result with -PassThru). The generators read and write the source tree, so the gate needs the source mode
(Assert-SourceTree).

### parameter `Generator`

Check only these generators (default: every one). Build-RootConfig selects every managed root file; a generator it renders (New-Importer, …)
selects only that generator's files.

### parameter `Changed`

Check only what git reports changed against HEAD: the stamp check reads only the changed generated files (Get-GeneratedStampDrift -Changed),
and a writer's dry run runs only when a changed path matches the inputs or outputs globs of its generated-files.yml entry; a writer with
neither list runs whenever anything changed, and with nothing changed no writer runs. Catches a hand edit of a generated file and a
generator change whose output was not re-rendered.

### parameter `StampOnly`

Run the stamp check alone and no writer's dry run: the cheap check the import janitor makes, about 0.3 s over the changed set. Combine it
with Changed; the writers' dry runs stay the full run's.

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-generated-files).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Generators } instead of throwing on issues.

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

## comment:1

Above `$checkedWriters = @(if (-not $StampOnly) {`, written with `#`.

```text
Each registered writer is run by its check; the registry (generated-files.yml) says which check and, for a file result, which property holds the path.
@() around the whole if: an empty list must stay an array under strict mode.
```
