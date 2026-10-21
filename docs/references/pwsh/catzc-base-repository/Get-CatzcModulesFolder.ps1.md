# pwsh/Catzc.Base.Repository/Get-CatzcModulesFolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
