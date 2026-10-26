# pwsh/Base.Modules/private/Get-PlaceModuleEntry.ps1

The private lister of the modules one place of a module type holds on disk, used by `Get-CatzcModule`.

## help

### synopsis

Lists the modules one place of a module type holds on disk, each as its root, shape, name and folder.

### description

A folder place yields each non-dot folder under it, a file place each file of its extension, and a root place the place itself; the module
name is the one the place gives the path (ModulePlace.NameOf), so the prefix and the dot rule live in that one type. The folder is where the
module's files are listed: the folder itself, or nothing for a file module. Private: Get-CatzcModule is the one caller.

It rests on [ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE](../../../../drs/automation/module-model.md#rule-adr-auto-module-deployabletrackmodule).

### parameter `Place`

The ModulePlace of the module type.

### parameter `Directory`

The directory on disk that holds the place's root.

### outputs

`[pscustomobject]` Root (repository-relative), Shape (folder, file or root), Name and Folder (the module directory, or null).

### example 1

```powershell
Get-PlaceModuleEntry -Place $place -Directory $directory
```
