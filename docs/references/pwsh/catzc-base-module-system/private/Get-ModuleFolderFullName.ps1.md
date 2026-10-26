# pwsh/Base.ModuleSystem/private/Get-ModuleFolderFullName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$full = [System.IO.Path]::GetFullPath($Path).TrimEnd('\', '/')`, written with `#`.

```text
A module folder drops the namespace its full name carries: the loaded module names it, else the manifest the bootstrap
wrote from the resolver, else the folder is its own name (a local module carries no namespace).
```
