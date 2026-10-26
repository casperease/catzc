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

### example 1

```powershell
Get-ModuleFullName (Join-Path (Get-CatzcModulesRoot) 'Base.Repository')
```
