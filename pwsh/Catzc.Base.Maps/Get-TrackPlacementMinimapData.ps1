<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1
    name: get-track-placement-minimap-data
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.Maps/tests/Get-TrackPlacementMinimapData.Tests.ps1
    docs: "[Get-TrackPlacementMinimapData.ps1.md](docs/references/pwsh/catzc-base-maps/Get-TrackPlacementMinimapData.ps1.md)"
    cites:
      - ADR-AZ-NAMING
      - ADR-DSGN-TRACK
---
#>

function Get-TrackPlacementMinimapData {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Maps.MinimapData], [string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string[]] $Adr,

        [switch] $AsJson
    )

    # Every track under its track type, in registry order; a subject file lights its own track, its vendor as the note.
    $tracks = @(Get-Track)
    $types = [string[]] @($tracks | ForEach-Object type | Select-Object -Unique)
    $count = @{}
    $reasons = @{}
    foreach ($item in @(Get-MinimapSubject -Adr $Adr)) {
        if (-not $item.Facts -or -not $item.Facts['track']) {
            continue
        }
        $vendor = if ($item.Facts['vendor']) {
            "$($item.Facts['vendor'])"
        }
        else {
            $null
        }
        $reason = [Catzc.Base.Maps.MinimapReason]::new($item.Path, 'track', $item.Requested, $vendor)
        Add-MinimapHit -Count $count -Reasons $reasons -At @("$($item.Facts['tracktype'])", "$($item.Facts['track'])") -Reason $reason
    }
    $cells = [string[][]] @(foreach ($track in $tracks) {
            , [string[]] @($track.type, $track.name)
        })
    $axes = [ordered]@{ track_type = $types; track = [string[]] @($tracks | ForEach-Object name) }
    $data = New-MinimapData -Id ([Catzc.Base.Maps.MinimapData]::TrackPlacement) -Axes $axes -Cells $cells -Count $count -Reasons $reasons
    if ($AsJson) {
        return $data.ToJson()
    }
    $data
}
