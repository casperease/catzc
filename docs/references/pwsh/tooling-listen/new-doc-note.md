# pwsh/Tooling.Listen/New-DocNote.ps1

The writer of a note in the listen mode: it turns one settled change into the session's next numbered note file, a record of raw fact with
no interpretation.

## help

### synopsis

Writes one note for one settled change: `notes/<id>.md`, written once and never again.

### description

A note is raw fact, the editor's correction as it stands: the path, the change, the file kind and tier, the writer, the rules the change
cites, the commit the reference is pinned at, the diff against seen/ (this change) and the diff against baseline/ (the file's arc over the
session). It holds no interpretation; understanding is the processor's. The id is the next four-digit number in the session.

### parameter `Session`

The session folder. Default: the newest session.

### parameter `Change`

One Get-DocChange record against seen/; taken from the pipeline too.

### outputs

`[pscustomobject]` with Id and Path (the note file).

### example 1

```powershell
Wait-DocChange | New-DocNote
```
