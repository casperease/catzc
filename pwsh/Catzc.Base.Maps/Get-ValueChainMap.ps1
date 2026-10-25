<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-maps/Get-ValueChainMap.ps1.md"
  warning: "Generated Header"
---
#>

function Get-ValueChainMap {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.ValueChainMap], [string])]
    param(
        [switch] $AsJson
    )

    $map = [Catzc.Base.Maps.ValueChainMap]::Build([Catzc.Base.Drs.DrsConfig]::Stacks, [Catzc.Base.Drs.DrsConfig]::Concerns,
        (ConvertTo-BclValue @(Get-DrsRuleSet)))
    if ($AsJson) {
        return $map.ToJson()
    }
    $map
}
