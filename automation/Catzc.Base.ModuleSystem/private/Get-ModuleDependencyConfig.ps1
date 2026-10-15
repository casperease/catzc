<#
.SYNOPSIS
    Returns the declared module dependency map from configs/dependencies.yml.
.DESCRIPTION
    A module absent from the map is unconstrained, and a malformed file throws here at load, not at first use.
    [comment:1](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyConfig.ps1.md#comment1)
.EXAMPLE
    (Get-ModuleDependencyConfig)['Catzc.Tooling.Core']
#>
function Get-ModuleDependencyConfig {
    param()

    (Get-Config -Config dependencies).modules
}
