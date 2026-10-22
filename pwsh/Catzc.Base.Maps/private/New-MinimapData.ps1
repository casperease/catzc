<#
---
catzc:
  immutable:
    with_body_sha: "467566e9fbc6"
  edges:
    docs: "[New-MinimapData.ps1.md](../../../docs/references/pwsh/catzc-base-maps/private/New-MinimapData.ps1.md)"
---
#>

function New-MinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData])]
    param(
        [Parameter(Mandatory)]
        [string] $Id,

        [Parameter(Mandatory)]
        [System.Collections.Specialized.OrderedDictionary] $Axes,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[][]] $Cells,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [hashtable] $Count,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [hashtable] $Reasons
    )

    # Each cell is keyed by its place joined with a tab: Count holds what it holds, Reasons the MinimapReason list that lights it.
    $axisList = [Catzc.Base.Maps.MinimapAxis[]] @(foreach ($name in $Axes.Keys) {
            [Catzc.Base.Maps.MinimapAxis]::new($name, [string[]] @($Axes[$name]))
        })
    $cellList = [System.Collections.Generic.List[Catzc.Base.Maps.MinimapCell]]::new()
    $litList = [System.Collections.Generic.List[Catzc.Base.Maps.MinimapCell]]::new()
    foreach ($at in $Cells) {
        $key = $at -join "`t"
        $held = if ($Count.ContainsKey($key)) {
            [int] $Count[$key]
        }
        else {
            0
        }
        $cellList.Add([Catzc.Base.Maps.MinimapCell]::new($at, $held))
        if ($Reasons.ContainsKey($key)) {
            $litList.Add([Catzc.Base.Maps.MinimapCell]::new($at, $held, [Catzc.Base.Maps.MinimapReason[]] @($Reasons[$key])))
        }
    }
    [Catzc.Base.Maps.MinimapData]::new($Id, $axisList, $cellList.ToArray(), $litList.ToArray())
}
