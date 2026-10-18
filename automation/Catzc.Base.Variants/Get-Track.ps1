<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/Get-Track.ps1
    name: get-track
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
    cites:
      - ADR-DSGN-TRACK
  config:
    synopsis: Returns the repository's tracks — all of them, the named ones, or the track that owns a path.
    description: |-
      The `tracks` repo-wide variant (configs/variants.yml, [ADR-DSGN-TRACK](/docs/adr/design/tracks.md)) declares each
      track: its places, its type ([ADR-DSGN-TRACKTYPE#1](/docs/adr/design/track-types.md#rule-adr-dsgn-tracktype1)),
      its vendor when it has one and the file languages of its tech-stack
      ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). Each result is a VariantTrack, in declared
      order; the shape is validated by the VariantsConfig type.

      -Path answers "which track does this file belong to?"
      ([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)): the track with the longest place that
      contains the path ([ADR-DSGN-TRACKTYPE#5](/docs/adr/design/track-types.md#rule-adr-dsgn-tracktype5)), so a narrower
      place wins over a wider one (a bare place, e.g. 'docs', is its own track's path). A file at the repository root, a
      path under out/ (gitignored output, never a track), and a path no place contains return nothing.
    parameters:
      Name: The track name(s) to return. An unknown name throws, naming the config file.
      Path: A repository-relative path ('/' or '\' separated); returns the track that owns it.
    examples:
      - Get-Track
      - '(Get-Track -Name automation).type                        # -> modules'
      - '(Get-Track -Path ''docs/adr/design/tracks.md'').name        # -> docs'
---
#>

function Get-Track {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Catzc.Base.Variants.VariantTrack])]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [ArgumentCompleter({ Get-Track | ForEach-Object name })]
        [string[]] $Name,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string] $Path
    )

    $tracks = @(Get-Variant -Name tracks)

    if ($PSCmdlet.ParameterSetName -eq 'Name') {
        foreach ($trackName in $Name) {
            $match = @($tracks | Where-Object { $_.name -ceq $trackName })
            if ($match.Count -eq 0) {
                throw "Unknown track '$trackName' (declared in automation/Catzc.Base.Variants/configs/variants.yml: $(@($tracks | ForEach-Object name) -join ', '))."
            }
            $match[0]
        }
        return
    }

    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        $segments = @($Path.Replace('\', '/').Split('/') | Where-Object { $_ -and $_ -ne '.' })
        if ($segments.Count -eq 0 -or $segments[0] -eq 'out') {
            return
        }
        $normalized = $segments -join '/'
        $best = $null
        $bestLength = -1
        foreach ($track in $tracks) {
            $length = $track.PlaceLengthOf($normalized)
            if ($length -gt $bestLength) {
                $best = $track
                $bestLength = $length
            }
        }
        return $best
    }

    $tracks
}
