---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestDiscovery.ps1.md
    kind: comment-page
    body_sha: f072c8aee8aa
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestDiscovery.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single discovery pass Test-Automation shares between its pre-run inspections: Get-TestTagViolations
(the mandatory tier/category check) and Split-TestAutomationFiles (the phase split) both consume the one
result, so the tree is discovered once per run, not once per question. Run.SkipRun makes it inspect every
test regardless of tag filters — nothing executes. A Go test folder is discovered through the Go bridge
(ConvertTo-PesterRunTarget), which reads its Go tests from the source without running go. Pester must already
be loaded (Test-Automation lazy-loads it before calling this).
```
