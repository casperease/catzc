<#
.SYNOPSIS
    Resolves the rootconfig registry into the list of opted-in managed root files Build-RootConfig generates.
.DESCRIPTION
    Opted-out entries are inert: validated for shape on load, but neither written nor treated as owned.
    [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)
    [comment:1](/docs/references/automation/catzc-base-rootconfig/private/Get-RootConfigTargets.ps1.md#comment1)
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
