# pwsh/Base.QualityGates/private/Get-TestRunLockHolder.ps1

Reads the test-run lock record and describes who holds the working folder, so a waiting run can say whom it waits for.

## help

### synopsis

Reads the test-run lock record and describes who holds the working folder.

### description

A mutex carries no owner data, so the run that holds the test-run lock writes a record beside it (Enter-TestRunLocation). This reads that
record and says plainly what it can and cannot tell, never guessing:

- a live holder: '`<entry point>` (pid `<n>`, started `<time>`, run `<folder>`)';
- no record: the holder left no lock record;
- a stale record: the process it names is no longer running (or the pid now belongs to another process, detected by its start time), so the
  record does not describe the current holder.

### parameter `Path`

The lock record's path (out/.test-run-lock.json).

### outputs

`[pscustomobject]` with Known (the record names a live process), Description (the phrase for the announcement), and Record (the parsed
record, or $null).

## Timestamps

ConvertFrom-Json turns an ISO timestamp into a `[datetime]` and keeps its kind from the `Z` or offset suffix. A string cast would drop the
sub-second precision and the zone, so the record's values are read as instants in both shapes.
