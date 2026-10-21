# pwsh/Catzc.Base.QualityGates/private/Get-TestRunLocationSummary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders where a test run executed, for the report header and the run manifest.

### description

One reading of the location a worker run executed in — the run's location from Enter-TestRunLocation, which Invoke-TestAutomationWorkers
returns as its Location — in the two shapes its consumers need: a one-line text for summary.md's Location line, and the run.json entries —
`location` (the location's Mode, 'in-place' or 'snapshot') plus, for a snapshot, its provenance (path, source root, commit, change counts,
whether it was kept, and who held the working folder). No location (a fully protected run executed nowhere, or the workers crashed) renders
as empty text and no entries.

### parameter `Location`

The location the worker run executed in (Enter-TestRunLocation's object), or $null.

### outputs

`[pscustomobject]` with Text (`[string]`) and Manifest (`[ordered]` entries to merge into run.json).
