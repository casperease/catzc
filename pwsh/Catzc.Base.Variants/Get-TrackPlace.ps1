<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/Get-TrackPlace.ps1
    name: get-track-place
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
