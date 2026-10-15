<#
.SYNOPSIS
    Resolves a global config address to the value at that node (a leaf or a subtree).
.DESCRIPTION
    A global config address is a by-reference handle into a named config: global.<config>.<key>[.<key>...] (see ADR...
    [ADR-CONF-LOADING#1](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading1),
    [ADR-CONF-LOADING#2](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading2),
    [ADR-CONF-ADDRESSING#4](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing4),
    [ADR-CONF-ADDRESSING#5](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing5),
    [ADR-CONF-ADDRESSING#3](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing3),
    [ADR-AUTO-ENVVAR#7](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar7)
    [comment:1](/docs/references/automation/catzc-base-config/Get-ConfigValue.ps1.md#comment1)
.PARAMETER Address
    The global config address: global.<config>.<key>[.<key>...] — e.g.
    [comment:2](/docs/references/automation/catzc-base-config/Get-ConfigValue.ps1.md#comment2)
.PARAMETER Module
    Passthrough to Get-Config to disambiguate the rare config name present in more than one module.
.EXAMPLE
    Get-ConfigValue -Address 'global.myproperty.name'
    # the leaf value at the 'name' key of the 'myproperty' config
.EXAMPLE
    Get-ConfigValue -Address 'global.database'
    # the whole 'database' config as a subtree
#>
function Get-ConfigValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ValidatePattern('(?-i)^global\.[a-z0-9]+(-[a-z0-9]+)*(\.[^.]+)*$')]
        [string] $Address,

        [string] $Module
    )

    $parts = $Address -split '\.'
    $configName = $parts[1]
    $keyPath = [string[]]@()
    if ($parts.Count -gt 2) {
        $keyPath = $parts[2..($parts.Count - 1)]
    }

    $config = Get-Config -Config $configName -Module $Module
    Resolve-ConfigKeyPath -Node $config -Segment $keyPath -Address $Address
}
