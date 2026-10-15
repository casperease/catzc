<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/Get-ConfigValue.ps1
    kind: function
    module: Catzc.Base.Config
    visibility: public
    adrs:
      - ADR-AUTO-ENVVAR#7
      - ADR-CONF-ADDRESSING#3
      - ADR-CONF-ADDRESSING#4
      - ADR-CONF-ADDRESSING#5
      - ADR-CONF-LOADING#1
      - ADR-CONF-LOADING#2
---
#>

<#
.SYNOPSIS
    Resolves a global config address to the value at that node (a leaf or a subtree).
.DESCRIPTION
    The returned node may be a live reference into the config cache, so treat it as read-only.
    [comment:1](/docs/references/automation/catzc-base-config/Get-ConfigValue.ps1.md#comment1)
.PARAMETER Address
    The key path is optional: the address global.<config> alone returns the whole config as a subtree.
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
