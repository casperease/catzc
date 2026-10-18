---
catzc:
  immutable:
    with_body_sha: bff1eea7aa5d
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRunLockHolder.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-test-run-lock-holder-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Get-TestRunLockHolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

### parameter Path

The lock record's path (out/.test-run-lock.json).

### outputs

`[pscustomobject]` with Known (the record names a live process), Description (the phrase for the announcement), and Record (the parsed
record, or $null).

## comment:1

Above `$toInstant = {`, written with `#`.

```text
ConvertFrom-Json turns ISO timestamps into [datetime] (kind kept from the 'Z'/offset suffix); a string
cast would drop sub-second precision and the zone, so both shapes are read as instants here.
```
