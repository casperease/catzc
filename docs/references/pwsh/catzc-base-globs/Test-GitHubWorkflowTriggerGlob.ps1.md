# pwsh/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: checks a GitHub workflow's trigger path filters against a globset's projection — the trigger-drift quality gate for GitHub
Actions.

### description

The GitHub sibling of Test-AdoPipelineTriggerGlob: recomputes the ordered, '!'-negation `paths` list a globset projects to
(Get-GlobSetTrigger) and compares it against what a workflow actually declares (Get-PipelineTrigger) — both on.push.paths and
on.pull_request.paths. GitHub paths are ordered (last-match-wins), so the comparison is element-by-element, not a set. Unlike ADO, a GitHub
workflow is not named in globs.yml, so the globset-to-workflow pairing is passed explicitly.

A drifted workflow is one issue naming the filters that differ, and a missing workflow file is one issue. The gate ends with
Write-QualityGateReport ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)): the report
lands in out/test-github-workflow-trigger-glob/, and the gate throws once listing every issue (or returns the result with -PassThru).

It rests on [ADR-FLOW-CD-GLOBS-NAMEDGLOBSETS](../../../adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs-namedglobsets) and
[ADR-FLOW-CD-GLOBS-NATIVEPATHFILTER](../../../adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs-nativepathfilter).

### parameter `Name`

The globset the workflow should trigger on.

### parameter `WorkflowPath`

The workflow file, repo-relative (e.g. '.github/workflows/ci-automation.yml') or absolute.

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-github-workflow-trigger-glob).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; GlobSet; Workflow } instead of throwing.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-GitHubWorkflowTriggerGlob -Name automation -WorkflowPath .github/workflows/ci-automation.yml
```
