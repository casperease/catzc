# automation/Catzc.Base.QualityGates/private/Get-CommittedTypesDrift.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reports why the committed combined types assembly is not the current one.

### description

The build ships the committed `automation/.compiled/Catzc.Types.<hash>.dll` by copy, so that file must be the assembly of the current type
sources: exactly one `Catzc.Types.*.dll`, named for the combined hash of the sources (Get-CombinedTypeHash, the one implementation the
loader and the janitor share), and no pending git change under automation/.compiled — the importer rebuilds the DLL when a `types/*.cs`
changes, and a rebuild that was not committed shows there. Each failure is one reason; none means the committed assembly is current.

### parameter `RepositoryRoot`

The repository whose automation/.compiled is checked.

### outputs

`[string[]]` One reason per drift found; nothing when the committed assembly is current.

### example 1

```powershell
Get-CommittedTypesDrift -RepositoryRoot (Get-RepositoryRoot)
```
