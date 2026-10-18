# automation/Catzc.Base.QualityGates/private/Write-TestAutomationWorkerSummary.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes the end-of-run worker table — one row per worker, on the run's wall-clock timeline.

### description

Renders a framed section (Write-Header / Write-Footer) with one table row per worker, ordered by each worker's wall-clock start time (queue
number — the submission order — stays visible in the # column, so a pool that starts workers out of order still reads truthfully). Each row
carries the worker's file and test tallies, its start offset on the run's single timeline, and its own wall-clock duration. The footer line
sums the tallies and names the run's total wall clock — the parallel phases mean the workers' durations add up to more than the run took, so
the summation is printed as its own row rather than implied.

### parameter WorkerSummaries

The per-worker summary objects from Invoke-TestAutomationWorkers (QueueNumber, Label, Files, Tests, Passed, Failed, Skipped, StartSeconds,
DurationSeconds).

### parameter DurationSeconds

The run's total wall clock across both phases, for the summation row.
