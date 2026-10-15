<#
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/private/Get-ModuleDependencyConfig.ps1
    kind: function
    module: Catzc.Base.ModuleSystem
    visibility: private
    adrs: []
---
#>

<#
.SYNOPSIS
    Returns the declared module dependency map from configs/dependencies.yml.
.DESCRIPTION
    A module absent from the map is unconstrained, and a malformed file throws here at load, not at first use.
.EXAMPLE
    (Get-ModuleDependencyConfig)['Catzc.Tooling.Core']
#>
function Get-ModuleDependencyConfig {
    param()

    (Get-Config -Config dependencies).modules
}
