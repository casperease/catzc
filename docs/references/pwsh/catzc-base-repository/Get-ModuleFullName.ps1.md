# pwsh/Base.Repository/Get-ModuleFullName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the full name of the module a folder holds.

### description

The one lookup from a module folder to its full name, the reverse of Get-CatzcModuleRoot. A module's folder drops the namespace its full
name carries ([DDR-TRACK-MODULENAMESPACE](../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)). The one manifest in the folder
names it, as the bootstrap wrote it from the resolver; else the module loaded from the folder; else the folder is its own name, as a local
module carries no namespace. The manifest is read first because it is the declared name and the cheapest answer: Get-Config builds its index
through this lookup on every import.

### parameter `Path`

The module folder, relative or absolute.

### parameter `RepositoryRoot`

The live repository the folder is read against: a staged burst copy is named by the live module folder it mirrors under this root. Default:
the current repository.

### example 1

```powershell
Get-ModuleFullName (Join-Path (Get-CatzcModulesRoot) 'Base.Repository')
```

## comment:1

Above `$levels = @($full) + @([System.IO.Directory]::EnumerateDirectories($full))`, written with `#`.

```text
A staged burst copy mirrors the repository and carries a .burst-base beside each staged file, in the folder or one level
down; it is named by the live module folder it mirrors, the nearest ancestor-relative path that exists in the repository.
```
