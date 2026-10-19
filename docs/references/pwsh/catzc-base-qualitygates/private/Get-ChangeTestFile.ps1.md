# pwsh/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Maps changed repository paths to the test files that cover them.

### description

The tests half of Test-Change's plan, by convention alone (one function per file,
[ADR-PWSH-ONEFUNC](../../../../adr/automation/pwsh/one-function-per-file.md)): a changed test file is itself; a changed function file
`pwsh/<Module>/[private/]<Name>.ps1` is covered by `pwsh/<Module>/tests/<Name>.Tests.ps1`; a changed C# type `pwsh/<Module>/types/<Type>.cs`
by `pwsh/<Module>/tests/types/<Type>.Tests.ps1`. Only test files that exist are returned, as repo-relative, '/'-separated paths, sorted
ordinally, each once; a change no convention covers contributes nothing. With -Module, a change anywhere under `pwsh/<Module>/` (dot folders
excepted) brings in every test file under that module's tests/ instead.

### parameter `Path`

The changed repo-relative, '/'-separated paths.

### parameter `RepositoryRoot`

The repository root the paths are relative to.

### parameter `Module`

Widen to every test file of each module a change touches.

### outputs

`[string]`

### example 1

```powershell
Get-ChangeTestFile -Path 'pwsh/Catzc.Base.Files/Get-GitChangedPath.ps1' -RepositoryRoot (Get-RepositoryRoot)
```
