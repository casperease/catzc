# docs/references/automation/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md

`automation/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The GitHub sibling of Test-AdoPipelineTriggerGlob: recomputes the ordered, '!'-negation `paths` list a
globset projects to (Get-GlobSetTrigger) and compares it against what a workflow actually declares
(Get-PipelineTrigger) — both on.push.paths and on.pull_request.paths. GitHub paths are ordered
(last-match-wins), so the comparison is element-by-element, not a set. Unlike ADO, a GitHub workflow is
not named in globs.yml, so the globset-to-workflow pairing is passed explicitly.

A drifted workflow is one issue naming the filters that differ, and a missing workflow file is one issue.
The gate ends with Write-QualityGateReport
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): the report lands in
out/test-github-workflow-trigger-glob/, and the gate throws once listing every issue (or returns the result
with -PassThru).
```
