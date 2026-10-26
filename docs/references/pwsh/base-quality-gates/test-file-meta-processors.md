# pwsh/Base.QualityGates/Test-FileMetaProcessors.ps1

The processor check: every meta kind must resolve to a processor function, and every convention-named processor function must belong to a
kind.

## help

### synopsis

Checks that every meta kind resolves to a processor function and that every convention-named processor function belongs to a kind.

### description

A kind whose function is missing fails the run that reads the registry, and a function no kind names is never called, so this gate lists
both orphans. A function is a processor candidate when it is named `Get-<Kind>FileMetaFact` or `Get-<Kind>MarkdownConfigContribution`.

It rests on [ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate) and
[ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-subscribebyfunction).

### parameter `Config`

The meta-kind registry. Default: the shipped one.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-file-meta-processors/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; KindCount; ProcessorCount }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-FileMetaProcessors
```
