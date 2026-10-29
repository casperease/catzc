# pwsh/Base.QualityGates/private/Wait-PesterRunner.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## help

### synopsis

Polls a started PesterRunner until it finishes, then returns its results, killing every unfinished worker if the call is stopped.

### description

It polls the runner with Wait(200) so a Ctrl-C or a pipeline stop reaches PowerShell between polls, instead of being held until every worker
has finished. When the pool is done it returns the runner, whose results are the pool's results.

In a finally it calls Stop() on the runner, which kills every unfinished worker tree. A finished pool stops nothing, so the call is safe on
the normal path too, and it runs before the caller's own finally frees the location.

### parameter `Runner`

The started PesterRunner to poll.

### parameter `PollMilliseconds`

The wait between polls, in milliseconds, from 10 to 5000. Defaults to 200.

## comment:1

Above `try {`, written with `#`.

```text
Short waits hand control back to PowerShell between polls, so a Ctrl-C or a PowerShell Stop() ends the call; one blocking wait
would hold the stop until every worker had finished.
```
