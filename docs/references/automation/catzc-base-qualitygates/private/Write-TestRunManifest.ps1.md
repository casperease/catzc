---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestRunManifest.ps1.md
    kind: comment-page
    body_sha: "42730ed03f00"
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/Write-TestRunManifest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A run directory's artifact files alone cannot tell a finished run from one still executing (or one that
crashed mid-flight): a reader listing the folder while workers stream would see "missing" shard files
and misread a partial run as the whole truth. run.json closes that gap — Test-Automation writes it once
at run start ({ status: 'running', … }) and once more, terminally, in a finally ({ status:
'passed'|'failed'|'crashed', … }), so completeness is read from the manifest, never inferred from which
files happen to exist yet. A run whose owning process died never reaches that finally; the next run in the
same report folder rewrites it as 'abandoned' (Set-AbandonedTestRun, from the ownerPid/ownerStart the
'running' record carries).

The write is atomic: the JSON lands in a temp file first and is moved over run.json in one filesystem
operation (the compiled-DLL pattern), so a concurrent reader never sees a half-written manifest.
```
