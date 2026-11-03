# pwsh/Base.ModuleSystem/private/Get-FunctionDependencyFile.ps1

Reads the cross-session result file of the function call graph and trusts it only for the stamp it was written for.

## help

### synopsis

Returns the stored call graph rows when the file holds the given stamp, else null.

### description

An absent file, an unreadable file and a file written for other script contents each return null, so the caller parses. The rows come back
with the shape they were saved in.

### parameter `Path`

The result file.

### parameter `Stamp`

The content stamp the file must hold.

### example 1

```powershell
Get-FunctionDependencyFile -Path $cachePath -Stamp $stamp
```
