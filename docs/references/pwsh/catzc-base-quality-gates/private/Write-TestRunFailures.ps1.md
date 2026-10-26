# pwsh/Catzc.Base.QualityGates/private/Write-TestRunFailures.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes every failure of a finished test run to the console: each failed test with its message, and each test file that failed before any of
its tests ran.

### description

The one place a test run's failures reach the console, shared by Invoke-TestFile and Test-Automation, at every -Output level: a failure is
the one thing a quiet run must still show, and the worker's Pester output does not carry it to a redirected console. Renders a framed
section (Write-Header / Write-Footer, red) with one 'FAIL `<ExpandedPath>`' line per failed row, grouped by ErrorMessage in the order each
message first failed: a group's paths come first, then its whole message once, headed by '`<n>` failures share this message:' when the group
holds more than one, so one cause behind many cases prints once. Then one 'FAIL `<file>` (failed before its tests ran)' line per file the
files sidecar marks Failed with an error of its own — a file that throws while Pester discovers it, or in its BeforeAll, yields no row, so
its error is only there. Writes nothing when there is no failure.

### parameter `Rows`

The run's test rows (ConvertTo-TestAutomationRowSet's shape: Result, ExpandedPath, ErrorMessage).

### parameter `Files`

The run's per-file entries from the files sidecars (New-TestAutomationShardScript: File, Result, ErrorMessage).

### example 1

```powershell
Write-TestRunFailures -Rows $rows -Files $files
```

## comment:1

Above `$byMessage = [ordered]@{}`, written with `#`.

```text
Rows that share a message share a cause: each is named, and the message is written once, in the order it first
failed.
```
