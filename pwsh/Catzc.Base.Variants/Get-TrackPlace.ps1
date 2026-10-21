<#
---
catzc:
  immutable:
    with_body_sha: f553a9fea4c7
  edges:
    test: pwsh/Catzc.Base.Variants/tests/Get-TrackPlace.Tests.ps1
    docs: "[Get-TrackPlace.ps1.md](docs/references/pwsh/catzc-base-variants/Get-TrackPlace.ps1.md)"
    cites:
      - ADR-DSGN-TRACK
---
#>

function Get-TrackPlace {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ArgumentCompleter({ Get-Track | ForEach-Object name })]
        [string] $Track,

        [Parameter(Mandatory)]
        [string] $TrackKind
    )

    $entry = Get-Track -Name $Track
    $place = $entry.KindPlace($TrackKind)
    if ($null -eq $place) {
        $declared = if ($entry.kinds.Count -gt 0) {
            @($entry.kinds.Keys) -join ', '
        }
        else {
            'none'
        }
        throw "Track '$Track' names no kind '$TrackKind' (its kinds: $declared); declare it under kinds: of the track in the variants config, Catzc.Base.Variants configs/variants.yml."
    }
    $place
}
