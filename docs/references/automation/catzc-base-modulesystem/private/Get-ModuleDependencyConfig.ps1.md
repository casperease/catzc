# automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyConfig.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the declared module dependency map from configs/dependencies.yml.

### description

Loads the declared (allowed) module-to-module dependency graph via Get-Config, which discovers configs/dependencies.yml, maps and validates
it as a Catzc.Base.ModuleSystem.DependenciesConfig, and caches it for the session. Re-run the importer (.\importer.ps1) to clear the cache.

The returned object is a read-only ordered dictionary: module name -> list of names (modules or groups) it is allowed to depend on. A module
absent from this map is unconstrained (may depend on anything). A malformed file throws here, at load time.

### example 1

```powershell
(Get-ModuleDependencyConfig)['Catzc.Tooling.Core']
```
