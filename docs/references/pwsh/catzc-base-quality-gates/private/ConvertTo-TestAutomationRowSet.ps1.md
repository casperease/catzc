# pwsh/Catzc.Base.QualityGates/private/ConvertTo-TestAutomationRowSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reduces a live Pester run object to plain per-test rows that survive a process boundary.

### description

Tier/category resolution walks a test's live .Block chain (Get-TestLevelTag / Get-TestCategoryTag), which does not survive serialization —
so a parallel worker reduces its own result to these rows before exiting, and the parent aggregates the rows (JSON sidecars) from every
shard. The row set is the one shape the run reports consume: tests.csv/summary.md (Write-TestAutomationReport), the over-limit timing check,
and the skip report (Write-TestAutomationSkipReport) all read rows, never a Pester object across a boundary. Emits one row per discovered
test, in Pester's order, including Skipped and NotRun tests.

### parameter `Result`

The live Pester run object (Invoke-Pester -Configuration `<with Run.PassThru>`), in the process that ran it.

### outputs

`[pscustomobject]` rows: ExpandedPath, ExpandedName, Result, DurationMs, Level, Category, Rules, File, Line, ErrorMessage, ErrorStack,
SkipReason. Rules is the ';'-joined ADR provenance citations (Get-TestRuleTags), '' when the test carries none — resolved in-worker like
Level/Category because the .Block chain does not survive the process boundary. File is the test's run file (Get-TestRunFile): its test file,
or for a Go bridge test its Go test folder, with Line 0.

## comment:1

Above `$block = $test.PSObject.Properties['Block'] ? $test.Block : $null`, written with `#`.

```text
A test a failed setup never ran carries no error of its own: the nearest block above it that holds one
names the cause.
```
