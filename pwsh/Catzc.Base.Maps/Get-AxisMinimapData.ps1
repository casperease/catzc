<#
---
catzc:
  immutable:
    with_body_sha: "5d1a470cef4b"
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-AxisMinimapData.Tests.ps1
    docs: "[Get-AxisMinimapData.ps1.md](docs/references/pwsh/catzc-base-maps/Get-AxisMinimapData.ps1.md)"
---
#>

function Get-AxisMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Adr,

        [switch] $AsJson
    )

    $axis = (Get-Config -Config maps).minimap_axis
    $rows = [string[]] @($axis.rows | ForEach-Object Key)
    $columns = [string[]] @($axis.columns)
    $map = Get-ValueChainMap
    $count = @{}
    foreach ($cell in $map.Cells) {
        $row = $axis.RowOf($cell.Stack)
        if ($row -and $columns -ccontains $cell.Concern) {
            $key = "$row`t$($cell.Concern)"
            $count[$key] = [int] $count[$key] + $cell.AdrCount
        }
    }
    $reasons = @{}
    $highlight = Get-ValueChainHighlight -Adr $Adr
    # An ADR whose concerns all fall outside the columns lights its whole row instead: the place [row, '*'].
    $inside = @{}
    $outside = [System.Collections.Generic.List[object]]::new()
    foreach ($cell in $highlight.Cells) {
        $row = $axis.RowOf($cell.Stack)
        if (-not $row) {
            continue
        }
        foreach ($reason in $highlight.ReasonsOf($cell.Stack, $cell.Concern)) {
            if ($columns -ccontains $cell.Concern) {
                $inside[$reason.Adr] = $true
            }
            else {
                $outside.Add([pscustomobject]@{ Row = $row; Concern = $cell.Concern; Reason = $reason })
            }
        }
    }
    $rowWide = [System.Collections.Generic.List[string]]::new()
    foreach ($item in $outside) {
        if ($inside.ContainsKey($item.Reason.Adr)) {
            continue
        }
        $key = "$($item.Row)`t*"
        if (-not $reasons.ContainsKey($key)) {
            $reasons[$key] = [System.Collections.Generic.List[Catzc.Base.Maps.MinimapReason]]::new()
            $rowWide.Add($item.Row)
        }
        $note = "concern $($item.Concern), outside the axis"
        $reasons[$key].Add([Catzc.Base.Maps.MinimapReason]::new($item.Reason.Adr, 'concern', $item.Reason.Requested, $note))
    }
    foreach ($cell in $highlight.Cells) {
        $row = $axis.RowOf($cell.Stack)
        if (-not $row -or $columns -cnotcontains $cell.Concern) {
            continue
        }
        $key = "$row`t$($cell.Concern)"
        if (-not $reasons.ContainsKey($key)) {
            $reasons[$key] = [System.Collections.Generic.List[Catzc.Base.Maps.MinimapReason]]::new()
        }
        foreach ($reason in $highlight.ReasonsOf($cell.Stack, $cell.Concern)) {
            $basis = if ($reason.Override) {
                'concern'
            }
            else {
                'domain'
            }
            $reasons[$key].Add([Catzc.Base.Maps.MinimapReason]::new($reason.Adr, $basis, $reason.Requested, $reason.Domain))
        }
    }
    $cells = [string[][]] @(foreach ($row in $rows) {
            foreach ($column in $columns) {
                , [string[]] @($row, $column)
            }
            if ($rowWide -ccontains $row) {
                , [string[]] @($row, '*')
            }
        })
    $axes = [ordered]@{ domain = $rows; concern = $columns }
    $data = New-MinimapData -Id ([Catzc.Base.Maps.MinimapData]::Axis) -Axes $axes -Cells $cells -Count $count -Reasons $reasons
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
