# pwsh/Base.Globs/Test-AdoPipelineTriggerGlob.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: checks each ADO pipeline's trigger path filters against its globset's projection — the trigger-drift quality gate.

### description

Answers "do the ADO pipelines have the proper glob trigger setup?": for every pipeline-bound globset, it recomputes the vendor-native
trigger the set projects to (Get-GlobSetTrigger) and compares it against what the bound pipeline file actually declares
(Get-PipelineTrigger). Both the `trigger:` and the `pr:` path filters must match, on include AND exclude, compared as sets (ADO path filters
are order-independent). The pipeline is resolved from the globset's `pipeline:` binding: `pipelines/<pipeline>.yaml`.

Each drifted pipeline is one issue naming the filters that differ, and a missing pipeline file is one issue; the fix for either is
"regenerate the pipeline trigger from globs.yml". The gate ends with Write-QualityGateReport
([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): the report lands in
out/test-ado-pipeline-trigger-glob/, and the gate throws once listing every issue (or returns the result with -PassThru).

It rests on [FDR-CD-GLOBS-NAMEDGLOBSETS](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-namedglobsets) and
[FDR-CD-GLOBS-NATIVEPATHFILTER](../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-nativepathfilter).

### parameter `Name`

The globset(s) to check — a declared, pipeline-bound name. Omit for every pipeline-bound globset.

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-ado-pipeline-trigger-glob).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Pipelines } instead of throwing.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-AdoPipelineTriggerGlob
```

### example 2

```powershell
(Test-AdoPipelineTriggerGlob -Name gadget -PassThru).Issues
```
