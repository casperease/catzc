# pwsh/Base.ModuleSystem/configs/files.yml

Maps a module to its packages, the repository files it owns beyond its own folder, which `Copy-CatzcModule` carries with it.

## Packages

A package is a named group of repository-root-relative file artifacts. `Copy-CatzcModule` copies a selected module's folder plus its
packages, minus any named in `-ExcludePackages`. Package names are globally unique, because the name is the exclude unit. Only modules that
own extra artifacts appear. Paths are repository-root-relative and forward-slashed.

## Validation

The file loads through `Get-Config -Config files` into the typed record ([FilesConfig](../types/files-config.md)): a `modules` map whose
entries ([ModuleFiles](../types/module-files.md)) each hold a non-empty `packages` map with snake_case names and non-empty path lists.
