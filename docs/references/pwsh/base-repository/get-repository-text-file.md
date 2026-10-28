# pwsh/Base.Repository/Get-RepositoryTextFile.ps1

The listing of a folder's own files that a source may stand in for.

## help

### synopsis

Returns the full paths of a folder's own files that match a filter, in ordinal order, from the active text source or the working tree.

### description

Outside a source, it lists the folder on disk the way Directory.GetFiles does, and an absent folder lists nothing. Inside
Use-RepositoryTextSource, a repository folder lists the source paths one segment below it. A folder outside the repository lists from disk
in either mode. Only the folder's own files are listed, never a subfolder's, so the listing stays bounded.

### parameter `Folder`

The folder, either absolute or relative to the repository root.

### parameter `Filter`

A wildcard that each file name must match, such as `*.yml`. It is case-insensitive. Default: every file.

### outputs

`[string]`, one full path per file.

### example 1

```powershell
Get-RepositoryTextFile 'pwsh/Base.Config/configs/widgets' -Filter '*.yml'
```
