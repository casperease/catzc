# docs/references/automation/catzc-base-qualitygates/private/Get-TestRunLockHolder.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-TestRunLockHolder.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A mutex carries no owner data, so the run that holds the test-run lock writes a record beside it
(Enter-TestRunLocation). This reads that record and says plainly what it can and cannot tell, never guessing:

- a live holder: '<entry point> (pid <n>, started <time>, run <folder>)';
- no record: the holder left no lock record;
- a stale record: the process it names is no longer running (or the pid now belongs to another process,
  detected by its start time), so the record does not describe the current holder.
```

## comment:2

Above `$toInstant = {`.

```text
ConvertFrom-Json turns ISO timestamps into [datetime] (kind kept from the 'Z'/offset suffix); a string
cast would drop sub-second precision and the zone, so both shapes are read as instants here.
```
