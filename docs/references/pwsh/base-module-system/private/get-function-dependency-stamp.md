# pwsh/Base.ModuleSystem/private/Get-FunctionDependencyStamp.ps1

The content key of the function call graph: it changes when any script the graph reads is added, removed, renamed or edited.

## help

### synopsis

Returns a SHA-256 stamp over the path and content hash of each listed script.

### description

Folds one `<path below the modules root>|<content hash>` line per script, in the order given, with `Catzc.Base.Globs.DurableHash`
(line-end-neutral), so the same sources give the same stamp on every machine.

### parameter `File`

The scripts the graph reads, in listing order.

### parameter `ModulesRoot`

The modules folder the script paths are made relative to.

### example 1

```powershell
Get-FunctionDependencyStamp -File $scripts -ModulesRoot (Get-CatzcModulesRoot)
```
