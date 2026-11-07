# pwsh/Base.ModuleSystem/New-ImporterCore.ps1

Renders the list of module folders a console import loads at once: the module system itself and every module its declared dependencies
need. The list is generated into `pwsh/.internal/assets/importer-core.txt` by the root-config writer, so it is never kept by hand.

## help

### synopsis

Returns the module folders of the importer core, the closure of Catzc.Base.ModuleSystem over the declared dependency graph.

### description

The core is the module that decides the import mix, Catzc.Base.ModuleSystem, and every module the declared graph says it needs
(`Get-ModuleDependencyClosure` over `configs/dependencies.yml`). Each module is written as the name of its folder in the code root, one per
line, sorted ordinally, as the importer enumerates folders. A module of the closure with no folder in the code root stops the render with a
named error, and no fallback is written. Build-RootConfig writes the result below the generated-file head, so the importer reads a list
that follows the graph.

### parameter `RepositoryRoot`

The repository root whose engine-track modules name the folders. Defaults to this repository.

### outputs

`[string]` The folder names, one per line, with a trailing newline.

### example 1

```powershell
New-ImporterCore
```
