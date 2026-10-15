---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Set-AbandonedTestRun.ps1.md
    kind: comment-page
    body_sha: "7655a4ccf034"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Set-AbandonedTestRun.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A run stamps run.json 'running' at start and a terminal status in a finally (Write-TestRunManifest). When the
owning process itself dies — a closed terminal, a killed console — the finally never runs, and the manifest
would claim 'running' forever. A run records its owner (ownerPid, ownerStart — the start time tells a reused
PID apart, WorkerParentWatch.IsAlive), so the next run in the same report folder sweeps the folder first: each
'running' manifest whose owner is no longer alive is rewritten as 'abandoned' (the rest of its content kept,
plus abandonedAt), with one announcement line per run. A 'running' manifest that names no owner has no live
owner to protect and is abandoned too. A live owner's run, and every terminal status, is left untouched.

Best-effort per run: an unreadable or unparseable run.json is skipped, never fails the run that sweeps.
```

## comment:2

Above `$abandoned = [ordered]@{}`.

```text
ConvertFrom-Json turns an ISO timestamp into a local DateTime, which would be written back with the local
offset; every run record stamps UTC, so a date goes back as the UTC round-trip string it was read from.
```
