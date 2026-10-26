# pwsh/Tooling.Listen/Get-DocChange.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the files of the watched folder whose bytes on disk differ from the session's seen copy, or from its baseline.

### description

Compares the watched folder on disk with a session's index (seen.json or baseline.json). A file whose length and last-write time match its
entry is unchanged without being read; any other file is hashed, and an equal hash is unchanged too, so a save of the same bytes is no
change. Git state plays no part.

Each change is one record: Path (repository-relative), Change (added, modified, deleted, or renamed when a deleted and an added file share a
hash; each added file pairs with one deleted file at most), From (the old path of a rename), Kind (the file kind, Get-FileKind), Tier
(listen.yml's tier of that kind), Source (who made the file's current bytes: agent, editor or unknown, from the write ledgers) and Agent
(the agent's session id), Rules (the ADR codes cited in the diff's added and removed lines, not the whole file's) and Diff (the unified diff
against the copy).

### parameter `Session`

The session folder. Default: the newest session.

### parameter `Against`

Seen (default): the changes not yet noted. Baseline: the file's whole arc over the session.

### parameter `Path`

Only these repository-relative paths.

### outputs

`[pscustomobject]` per change, in ordinal path order.

### example 1

```powershell
Get-DocChange -Against Baseline -Path docs/drs/index.md
```
