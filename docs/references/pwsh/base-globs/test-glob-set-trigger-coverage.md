# pwsh/Base.Globs/Test-GlobSetTriggerCoverage.ps1

The coverage quality gate of the native-trigger projection: it proves that an Azure DevOps include-only trigger can never under-trigger for
a pipeline-bound globset.

## help

### synopsis

Checks that every member of a pipeline-bound globset matches one of its ADO trigger include patterns.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the
native-trigger projection of the real tree
([FDR-GLOBS-NATIVEPATHFILTER](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-nativepathfilter)). Its safety property: every member of
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
