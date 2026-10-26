# pwsh/Base.QualityGates/Get-FileMetaFact.ps1

The read-only door to the file facts: it derives what the imprint would write into each file's meta block from the registries, git and the
disk, and writes nothing.

## help

### synopsis

The place facts and the edges of files, as the imprint would write them, read from the registries, git and the disk and never from a head.

### description

The one read-only door to the file facts: given paths, it takes each file that `Get-FileMetaScope` lists, reads its body apart from any meta
block, and returns the facts of every imprint kind that selects it by the file's class and language, writing nothing. A head on the file
changes no output, because the facts are derived, never read back
([ADR-REPO-FILEMETA-NOREADBACK](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-noreadback)). The imprint calls it with the
state it has already read.

Each kind's processor is the function the registry names, found in this module's scope; a kind with no such function fails the run and names
the function it expected. A test fixture follows the precedent of `Invoke-FileMetaEngine.Tests.ps1`: it defines its processor at script
scope (`function script:Get-WidgetPathFileMetaFact`) so the lookup finds it, and removes it after. A processor must return exactly the keys
its kind declares, so a kind can never write a key another kind owns. Each key goes into `edges`, the one part an imprint kind writes, and
comes back in registry order, which is the order it is written.

It rests on [ADR-REPO-FILEMETA-SUBSCRIBEBYFUNCTION](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-subscribebyfunction).

### parameter `State`

What the carrier's state reader read from the one file in -Path; the imprint passes it so the file is read once.

### parameter `Path`

Repository-relative paths of files or folders; a folder stands for its tracked files.

### parameter `Config`

The meta-kind registry. Defaults to file-meta.yml.

### outputs

`[pscustomobject]` Per file, @{ Path; Edges }, the edges an ordered dictionary of key to value in registry order; with -State, @{ Edges }
for the one file.

### example 1

```powershell
Get-FileMetaFact pwsh/Base.Maps | Select-Object Path, { $_.Edges['cites'] }
```
