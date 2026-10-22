# pwsh/Catzc.Tooling.Listen/Update-DocSnapshot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Moves a session's seen copy forward for the named files, so the next Get-DocChange no longer reports them.

### description

For each repository-relative path: a file on disk is copied into seen/ and its seen.json entry rewritten; a file gone from disk is removed
from both. A path outside the watched folder is refused. baseline/ never moves.

### parameter `Session`

The session folder. Default: the newest session.

### parameter `Path`

The repository-relative paths to move forward; for a rename, both the old and the new path.

### example 1

```powershell
Update-DocSnapshot -Path docs/how-to/old-name.md, docs/how-to/new-name.md
```
