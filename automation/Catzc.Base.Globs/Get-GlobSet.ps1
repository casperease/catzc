<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/Get-GlobSet.ps1
    kind: function
    module: Catzc.Base.Globs
    visibility: public
    adrs:
      - ADR-FLOW-CD-GLOBS#1
---
#>

<#
.SYNOPSIS
    Returns globsets from the globs.yml registry — all of them, or the named ones.
.DESCRIPTION
    An unknown name throws and names the config file, so a typo fails loudly instead of returning nothing.
.PARAMETER Name
    The globset name(s) to return. Omit for every globset, in registry order.
.EXAMPLE
    Get-GlobSet
.EXAMPLE
    (Get-GlobSet -Name automation).Matches('automation/importer.ps1')
#>
function Get-GlobSet {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Globs.GlobSet])]
    param(
        [ArgumentCompleter({ (Get-Config -Config globs).Names })]
        [string[]] $Name
    )

    $config = Get-Config -Config globs
    if (-not $PSBoundParameters.ContainsKey('Name')) {
        return $config.globsets
    }
    foreach ($setName in $Name) {
        $config.Get($setName)
    }
}
