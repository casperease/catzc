<#
---
catzc:
  immutable:
    with_body_sha: bfc833eb8595
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-CodeLocationsMinimapData.Tests.ps1
    docs: "[Get-CodeLocationsMinimapData.ps1.md](docs/references/pwsh/catzc-base-maps/Get-CodeLocationsMinimapData.ps1.md)"
---
#>

function Get-CodeLocationsMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Adr,

        [Catzc.Base.Maps.WorldMap] $WorldMap,

        [hashtable] $Facts,

        [switch] $AsJson
    )

    $count = @{}
    $reasons = @{}
    $places = [System.Collections.Generic.List[string[]]]::new()
    foreach ($item in @(Get-MinimapSubject -Adr $Adr -WorldMap $WorldMap -Facts $Facts)) {
        if (-not $item.Facts -or -not $item.Facts['track']) {
            continue
        }
        $module = if ($item.Facts['module']) {
            "$($item.Facts['module'])"
        }
        else {
            '-'
        }
        $segments = $item.Path -split '/'
        $at = [array]::IndexOf($segments, $module)
        $folder = if ($at -ge 0 -and $at -lt $segments.Count - 2) {
            $segments[($at + 1)..($segments.Count - 2)] -join '/'
        }
        else {
            '.'
        }
        $place = [string[]] @("$($item.Facts['track'])", $module, $folder)
        if (-not $count.ContainsKey($place -join "`t")) {
            $places.Add($place)
        }
        $reason = [Catzc.Base.Maps.MinimapReason]::new($item.Path, 'citation', $item.Requested, $null)
        Add-MinimapHit -Count $count -Reasons $reasons -At $place -Reason $reason
    }
    $sorted = @($places | Sort-Object { $_ -join "`t" })
    $axes = [ordered]@{
        track  = [string[]] @($sorted | ForEach-Object { $_[0] } | Select-Object -Unique)
        module = [string[]] @($sorted | ForEach-Object { $_[1] } | Select-Object -Unique)
        folder = [string[]] @($sorted | ForEach-Object { $_[2] } | Select-Object -Unique)
    }
    $data = New-MinimapData -Id ([Catzc.Base.Maps.MinimapData]::CodeLocations) -Axes $axes -Cells ([string[][]] $sorted) -Count $count -Reasons $reasons
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
