<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
    kind: function
    module: Catzc.Base.RootConfig
    visibility: private
    adrs:
      - ADR-REPO-ROOTCFG
---
#>

<#
.SYNOPSIS
    Resolves the rootconfig registry into the list of opted-in managed root files Build-RootConfig generates.
.DESCRIPTION
    Opted-out entries are inert: validated for shape on load, but neither written nor treated as owned.
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
