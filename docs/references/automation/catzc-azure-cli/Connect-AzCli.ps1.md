# docs/references/automation/catzc-azure-cli/Connect-AzCli.ps1.md

`automation/Catzc.Azure.Cli/Connect-AzCli.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `if (-not $Force) {`.

```text
Idempotent: skip if already logged in with the correct identity
-NoAssert: non-zero exit means "not logged in" — an expected state, not an error
```

## comment:2

Above `Write-Verbose "Authenticating via $($PSCmdlet.ParameterSetName)"`.

```text
No post-login assertion needed — Invoke-Executable throws on non-zero exit
codes via Assert-LastExitCodeWasZero. If az login fails, we never reach the
Write-Message below.
```
