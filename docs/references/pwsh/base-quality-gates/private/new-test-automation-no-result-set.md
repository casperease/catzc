# pwsh/Base.QualityGates/private/New-TestAutomationNoResultSet.ps1

Builds the failed row set a test worker reports when Invoke-Pester returns no result object, so a run that lost its result fails with the
reason and never reads as a pass.

## help

### synopsis

Builds one failed container row and one failed file row per test path for a worker whose Pester run returned no result.

### description

Reads the counts from the results file when it is whole (the run object can be lost although the file was written), strips the colour codes
from the error Pester printed, and folds both, with the path of the worker's console log, into one message. It returns an object with `Rows`
(one failed `no Pester result` container per test path) and `Files` (one failed file per test path, with a zero, unmeasured duration, so the
dealing history keeps the file's decayed last duration).

### parameter `TestPath`

The test files the worker ran.

### parameter `ResultsPath`

The worker's NUnit results file, read for its counts when it exists.

### parameter `LogPath`

The worker's console log, named in the message so the reader finds what Pester printed.

### parameter `PesterError`

The error Pester printed after its run, if any; its colour codes are stripped before it joins the message.
