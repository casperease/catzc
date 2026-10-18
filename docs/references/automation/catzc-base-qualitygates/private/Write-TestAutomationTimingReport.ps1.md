# automation/Catzc.Base.QualityGates/private/Write-TestAutomationTimingReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders the over-limit timing section of a Test-Automation run and returns whether it fails the run.

### description

Validates the run's rows against the per-level time limits (Get-TestTimingViolation owns the per-row check) and, when any test is over,
writes the framed report — red and run-failing under -EnforceTimings, yellow and report-only otherwise (timings are machine-dependent, so
enforcement is the caller's opt-in). Silent when nothing is over.

### parameter Rows

The run's aggregated per-test rows.

### parameter Limits

The per-level millisecond limits (level tag -> limit).

### parameter EnforceTimings

Turn the report into a run failure (the returned value).

### outputs

`[bool]` $true when violations exist AND -EnforceTimings was passed — the run's timing verdict.
