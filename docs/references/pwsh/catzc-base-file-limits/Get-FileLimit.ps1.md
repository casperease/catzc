# pwsh/Base.FileLimits/Get-FileLimit.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the length and width limits of a file from the file-limits config.

### description

A file name or extension override wins first, then the file's language picks its class, and a language value wins over the class default.
Each limit names where it came from. A file that no override and no language declares fails, so no tracked file escapes unlimited.

### parameter `Path`

The files to resolve, by path; the file need not exist.

### outputs

`[Catzc.Base.FileLimits.ResolvedFileLimit]` The language, class, length, width and the source of each.

### example 1

```powershell
Get-FileLimit -Path pwsh/Base.Folders/Get-ChildPath.ps1
```
