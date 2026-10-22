# pwsh/Catzc.Tooling.Listen/Find-DocPattern.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Searches the session's committed reference for a pattern, tier by tier: the one search the processor and its scouts use.

### description

Reads only reference/, the repository at the pinned commit with committed files only (New-DocSnapshot), never the live tree, so every scout
sees the same truth and every match is stated at one commit. Files are searched in ordinal path order; a binary file (a NUL in its first
8000 bytes, git's test) is skipped. Each match carries its file's kind and tier, so a caller searches the rules first and the rest after. A
slice that does not exist in the reference yields nothing.

### parameter `Session`

The session folder. Default: the newest session.

### parameter `Pattern`

The regular expression to find, case-sensitive.

### parameter `Tier`

Only files in these tiers (listen.yml's tier names, or its rest tier).

### parameter `Path`

Only under this repository-relative folder: a scout's slice. Default: the whole reference.

### outputs

`[pscustomobject]` per matching line: Path (repository-relative), Line, Text, Kind, Tier.

### example 1

```powershell
Find-DocPattern 'ADR-AUTO-FAILFAST-[A-Z]+' -Tier rules -Path docs/drs
```
