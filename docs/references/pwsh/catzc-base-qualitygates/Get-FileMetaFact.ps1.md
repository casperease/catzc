# pwsh/Catzc.Base.QualityGates/Get-FileMetaFact.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The place facts and the edges of files, as the imprint would write them, read from the registries, git and the disk and never from a head.

### description

The one read-only door to the file facts: given paths, it takes each file that `Get-FileMetaScope` lists, reads its body apart from any meta
block, and returns the facts of every imprint kind that selects it by the file's class and language, writing nothing. A head on the file
changes no output, because the facts are derived, never read back
([ADR-REPO-FILEMETA-NOREADBACK](../../../adr/repository/file-meta.md#rule-adr-repo-filemeta-noreadback)). A sidecar-carried file is skipped:
its facts belong to its description file, which is in scope on its own. The imprint calls it with the state it has already read.

Each kind's processor is the function the registry names, found in this module's scope; a kind with no such function fails the run and names
the function it expected. A processor must return exactly the keys its kind declares, so a kind can never write a key another kind owns.
Each key goes into the part its kind names, `immutable` or `edges`, and comes back in registry order, which is the order it is written.

It rests on [ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION](../../../adr/repository/file-meta.md#rule-adr-repo-filemeta-subscribebyfunction).

### parameter `State`

What the carrier's state reader read from the one file in -Path; the imprint passes it so the file is read once.

### parameter `Path`

Repository-relative paths of files or folders; a folder stands for its tracked files.

### parameter `Config`

The meta-kind registry. Defaults to file-meta.yml.

### outputs

`[pscustomobject]` Per file, @{ Path; Immutable; Edges }, each part an ordered dictionary of key to value in registry order; with -State, @{
Immutable; Edges } for the one file.

### example 1

```powershell
Get-FileMetaFact pwsh/Catzc.Base.Maps | Select-Object Path, { $_.Immutable['track'] }
```
