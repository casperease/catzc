<#
.SYNOPSIS
    Returns the declared module dependency map from configs/dependencies.yml.
.DESCRIPTION
    Loads the declared (allowed) module-to-module dependency graph via Get-Config, which discovers...
    [comment:1](/docs/references/automation/catzc-base-modulesystem/private/Get-ModuleDependencyConfig.ps1.md#comment1)
.EXAMPLE
    (Get-ModuleDependencyConfig)['Catzc.Tooling.Core']
#>
function Get-ModuleDependencyConfig {
    param()

    (Get-Config -Config dependencies).modules
}
