---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/New-TestRunFinalManifest.ps1.md
    kind: comment-page
    body_sha: "4e2672175c02"
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/New-TestRunFinalManifest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The record Invoke-TestRun stamps in its finally, on every exit path (Write-TestRunManifest): the terminal status
and timestamps, the tiers, category, and modules it ran, the failure counts, the run's context
(Get-TestRunContext, when the run got far enough to have one), what only the worker run knows
(ConvertTo-TestRunManifestEntry), and — for a run with an opt-out tag — the tag and how many tests it excluded.
```
