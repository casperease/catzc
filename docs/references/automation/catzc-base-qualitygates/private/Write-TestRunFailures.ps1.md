---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestRunFailures.ps1.md
    kind: reference
    body_sha: d299d155eac7
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Write-TestRunFailures.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one place a test run's failures reach the console, shared by Invoke-TestFile and Test-Automation, at every
-Output level: a failure is the one thing a quiet run must still show, and the worker's Pester output does not
carry it to a redirected console. Renders a framed section (Write-Header / Write-Footer, red) with one
'FAIL <ExpandedPath>' line per failed row followed by its whole ErrorMessage, then one
'FAIL <file> (failed before its tests ran)' line per file the files sidecar marks Failed with an error of its own
— a file that throws while Pester discovers it, or in its BeforeAll, yields no row, so its error is only there.
Writes nothing when there is no failure.
```
