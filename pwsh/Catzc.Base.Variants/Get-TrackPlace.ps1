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
