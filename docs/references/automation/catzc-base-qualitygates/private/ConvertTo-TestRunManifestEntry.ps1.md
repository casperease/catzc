# automation/Catzc.Base.QualityGates/private/ConvertTo-TestRunManifestEntry.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Derives the run.json entries that come from a worker run.

### description

The part of a run's terminal manifest (Write-TestRunManifest) that only the worker run knows: each shard's exit code, the wall-clock
duration, and where the run executed — `location` plus, for a snapshot, its provenance (Get-TestRunLocationSummary). A run that crashed
before its workers returned has no worker run; it records no exit codes, a zero duration, and no location.

### parameter WorkerRun

Invoke-TestAutomationWorkers' result, or $null.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` the entries to merge into run.json.
