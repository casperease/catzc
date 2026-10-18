# automation/Catzc.Base.Languages/private/Get-GeneratorPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the repository-relative path of the file a generator command is defined in.

### description

A generated file's head names its generator by that path, so a reader opens the writer straight from the head. The command is looked
up among the loaded functions, and one that is not loaded is an error: a head never names a generator that cannot be found.

It rests on [ADR-REPO-FILEMETA#7](../../../../adr/repository/file-meta.md#rule-adr-repo-filemeta7).

### parameter Name

The generator command, such as Build-AdrIndex.

### outputs

`[string]` The path relative to the root the catzc code lives in (the repository root in the mono repo), with forward slashes.

### example 1

```powershell
Get-GeneratorPath Build-AdrIndex
```
