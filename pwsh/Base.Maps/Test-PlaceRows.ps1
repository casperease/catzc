<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-maps/Test-PlaceRows.ps1.md"
  header: "generated"
---
#>

function Test-PlaceRows {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }
    $places = (Get-Config -Config maps).minimap_places
    foreach ($file in @(Get-ChildPath $Path -File -Filter 'code-locations.json')) {
        $data = Get-Content -LiteralPath $file -Raw | ConvertFrom-Json
        if (-not $data.PSObject.Properties['place_rows']) {
            continue
        }
        foreach ($row in @($data.place_rows.rows)) {
            if (-not [Catzc.Base.Maps.PlaceRows]::IsNormal($row, $places)) {
                "$($file): row '$row' is not in the place normal form"
            }
        }
        if ($data.place_rows.counters.Length -gt $places.row_chars) {
            "$($file): counters '$($data.place_rows.counters)' are longer than $($places.row_chars) characters"
        }
    }
}
