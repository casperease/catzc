# pwsh/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every member of a pipeline-bound globset matches one of its ADO trigger include patterns.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the native-trigger projection of
the real tree ([ADR-FLOW-CD-GLOBS-NATIVEPATHFILTER](../../../adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs-nativepathfilter)). Its safety property: every member of
a pipeline-bound set matches at least one ADO include pattern (Get-GlobSetTrigger), so an ADO include-only trigger is always a SUPERSET of
exact membership and can never under-trigger (miss a deploy); the in-pipeline Test-GlobSetAffected check supplies exactness on top. Each
uncovered member is an issue. (GitHub is exact by construction: its ordered '!'-negation paths are the scan program itself.)

Whether a pipeline file declares the projected trigger is a separate quality gate (Test-AdoPipelineTriggerGlob).

### parameter `OutputFolder`

The report base folder. Defaults to out/test-glob-set-trigger-coverage/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; GlobSets }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-GlobSetTriggerCoverage
```
