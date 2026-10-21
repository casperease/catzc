# pwsh/Catzc.Base.Files/Get-CodeCaller.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the tracked files that name a type, a function or a config key.

### description

The callers of a name, for a change that replaces one shape with another and must move every in-tree caller in the same change
([PDR-ONELIVE](../../../adr/principles/one-living-version.md)). It reads every file `Get-GitTrackedPath` lists under -Path and returns,
sorted and once each, the repo-relative path of every file whose text holds any of the names, in any case. A binary file (one holding a NUL
character) and a tracked file deleted from the working tree are skipped; an untracked file is never read, so a new file counts once it is
staged.

### parameter `Name`

The literal names to look for: a type (`WidgetConfig`), a function, or a config key. A file that holds any of them is listed.

### parameter `Path`

The repository-relative, '/'-separated paths whose tracked files are read; '.' (the default) for all.

### outputs

`[string]`

### example 1

```powershell
Get-CodeCaller 'LanguagesConfig' -Path pwsh
```
