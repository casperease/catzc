# pwsh/Base.Repository/Get-CatzcModulesFolder.ps1

The one spelling of the modules folder name, relative to the repository root and '/'-separated.

## help

### synopsis

Returns the folder that holds the modules, relative to the repository root and '/'-separated.

### description

The name a source-tree tool joins onto a repository root it was given (a fixture root, a sandbox, the working root) or prefixes to a
repository-relative path: Get-CatzcModulesRoot relative to Get-RepositoryRoot, so the folder is spelled in one place, the importer's
bootstrap constant, and nowhere else ([ADR-AUTO-LAYERS](../../../drs/automation/layers.md)). Throws when the modules root lies outside the
repository, as in an installed bundle, since only the source tree has a modules folder.

### example 1

```powershell
Join-Path $repositoryRoot (Get-CatzcModulesFolder)
```

### example 2

```powershell
"$(Get-CatzcModulesFolder)/.compiled"
```
