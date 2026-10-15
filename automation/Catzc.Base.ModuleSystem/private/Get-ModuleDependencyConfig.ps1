<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyConfig.ps1
    kind: private-function
    module: Catzc.Base.ModuleSystem
    visibility: private
  config:
    synopsis: Returns the declared module dependency map from configs/dependencies.yml.
    description: |-
      Loads the declared (allowed) module-to-module dependency graph via Get-Config, which
      discovers configs/dependencies.yml, maps and validates it as a
      Catzc.Base.ModuleSystem.DependenciesConfig, and caches it for the session. Re-run the importer
      (.\importer.ps1) to clear the cache.

      The returned object is a read-only ordered dictionary: module name -> list of names (modules or
      groups) it is allowed to depend on. A module absent from this map is unconstrained (may depend on
      anything). A malformed file throws here, at load time.
    examples:
      - (Get-ModuleDependencyConfig)['Catzc.Tooling.Core']
---
#>

function Get-ModuleDependencyConfig {
    param()

    (Get-Config -Config dependencies).modules
}
