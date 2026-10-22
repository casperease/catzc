# pwsh/Catzc.Tooling.Listen/New-DocNote.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
