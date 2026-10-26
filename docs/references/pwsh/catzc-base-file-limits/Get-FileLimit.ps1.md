# pwsh/Base.FileLimits/Get-FileLimit.ps1

The resolver of a file's length and width limits from the file-limits config, each with the source it came from.

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
