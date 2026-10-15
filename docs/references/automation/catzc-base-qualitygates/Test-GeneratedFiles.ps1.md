---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-GeneratedFiles.ps1.md
    kind: comment-page
    body_sha: ee20e3d770d8
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One gate for every generator's drift
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
Each writer runs in its report-only mode — -DryRun -PassThru, which composes the content and writes
nothing — and every file it reports as changed is one issue naming the file, the generator, and the
command that regenerates it:

  Build-AdrIndex               [index](/docs/adr/index.md) from adrs.yml
  Build-Glossary               [glossary](/docs/adr/glossary.md) from the configs/glossary.yml sources
  Build-Readme                 the READMEs generated from their docs/references articles (readme.yml)
  Build-ContractReference      the per-unit contract pages docs/references/contracts/<unit>.md from the contract assets
  Build-GitKeep               every managed .gitkeep from the shipped assets/gitkeep
  Build-TerminologyDictionary  the .cspell/<category>.txt lists from terminology.yml
  Build-EnglishDictionary      the committed english.txt.gz, checked from its stamp (Get-EnglishDictionaryDrift)
                               — its -DryRun re-flattens cspell's tries through node, so the stamp is the
                               cheap equivalent: the pinned cspell version and the gz's word count
  Build-RootConfig             every opted-in managed root file (rootconfig.yml); a file rendered by a
                               generator is attributed to that generator — New-Importer, New-GitIgnore,
                               New-VSCodeSettings, New-VSCodeExtensions, New-VSCodeLaunch,
                               New-VSCodePipelineSchema, New-GoWorkspace (one issue per stale file of a
                               multi-file generator, e.g. each go/tests/<folder>/go.mod)

Collects every stale file and ends with Write-QualityGateReport: the report lands in
out/test-generated-files/, and the gate throws once listing every issue (or returns the result with -PassThru).
The generators read and write the source tree, so the gate needs the source mode (Assert-SourceTree).
```

## comment:2

Section `.PARAMETER Generator` of the comment-based help.

```text
Check only these generators (default: every one). Build-RootConfig selects every managed root file;
a generator it renders (New-Importer, …) selects only that generator's files.
```
