<#
.SYNOPSIS
    Returns globsets from the globs.yml registry — all of them, or the named ones.
.DESCRIPTION
    The typed read of the single source of truth (ADR-GLOBS:1): configs/globs.yml, loaded and validated
    through Get-Config as a [Catzc.Base.Globs.GlobsConfig]. Each result is a [Catzc.Base.Globs.GlobSet]
    carrying the compiled include/exclude patterns, Matches(), and the unit's TriggerPath. An unknown name
    throws, naming the config file.
.PARAMETER Name
    The globset name(s) to return. Omit for every globset, in registry order.
.EXAMPLE
    Get-GlobSet
.EXAMPLE
    (Get-GlobSet -Name automation).TriggerPath
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
