<#
.SYNOPSIS
    Resolves the rootconfig registry into the list of opted-in managed root files Build-RootConfig generates.
.DESCRIPTION
    Filters the validated registry (Get-Config -Config rootconfig) down to the entries with optIn true — the
    files the automation actually manages. Opted-out entries are inert: validated for shape when the config
    loads, but neither written nor treated as owned. The full registry semantics live in
    configs/rootconfig.yml; see docs/adr/repository/generated-root-configs.md.
.PARAMETER Config
    The parsed rootconfig config (Get-Config -Config rootconfig): a `{ files }` object.
.OUTPUTS
    [object[]] The opted-in RootConfigFile entries, in registry order.
#>
function Get-RootConfigTargets {
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        $Config
    )

    @($Config.files | Where-Object { $_.optIn })
}
