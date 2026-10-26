# pwsh/Base.QualityGates/private/Set-AbandonedTestRun.ps1

Marks every run under a report folder that says `running` but whose owning process is gone as `abandoned`.

## help

### synopsis

Marks every run under a report folder that says 'running' but whose owning process is gone as 'abandoned'.

### description

A run stamps run.json 'running' at start and a terminal status in a finally (Write-TestRunManifest). When the owning process itself dies — a
closed terminal, a killed console — the finally never runs, and the manifest would claim 'running' forever. A run records its owner
(ownerPid, ownerStart — the start time tells a reused PID apart, WorkerParentWatch.IsAlive), so the next run in the same report folder
sweeps the folder first: each 'running' manifest whose owner is no longer alive is rewritten as 'abandoned' (the rest of its content kept,
plus abandonedAt), with one announcement line per run. A 'running' manifest that names no owner has no live owner to protect and is
abandoned too. A live owner's run, and every terminal status, is left untouched.

Best-effort per run: an unreadable or unparseable run.json is skipped, never fails the run that sweeps.

### parameter `OutputFolder`

The report base folder whose run directories (`<OutputFolder>/<stamp>/run.json`) are swept.

### outputs

`[string]` Each run directory marked abandoned.

### example 1

```powershell
Set-AbandonedTestRun -OutputFolder (Join-Path (Get-OutputRoot) 'test-automation')
```

## Dates

ConvertFrom-Json turns an ISO timestamp into a local `DateTime`, which would be written back with the local offset. Every run record stamps
UTC, so a date goes back as the UTC round-trip string it was read from.
