# pwsh/Tooling.Listen/private/Read-ListenIndex.ps1

A private helper of the listen module that reads a session's index file back into a hashtable; the counterpart of `Write-ListenIndex`.

## help

### synopsis

Reads a session's file index (seen.json or baseline.json) as path to { length, ticks, hash }.

### description

The index file must exist; an index of no files reads as an empty hashtable.

### parameter `Path`

The index file.

### outputs

`[hashtable]` path to { length, ticks, hash }.
