<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Get-Track.ps1
    kind: automation-function
    module: Catzc.Base.Variants
    visibility: public
    relatives:
      test: automation/Catzc.Base.Variants/tests/Get-Track.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK
  config:
    synopsis: Returns the repository's tracks — all of them, the named ones, or the track that owns a path.
    description: |-
      The `tracks` repo-wide variant (configs/variants.yml, [ADR-DSGN-TRACK](/docs/adr/design/tracks.md)) declares each
      track: its root folder, its class (core, adapter, external-port, verification or unordered,
      [ADR-DSGN-TRACK#2](/docs/adr/design/tracks.md#rule-adr-dsgn-track2)) and the file languages of its tech-stack
      ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). Each result is a VariantTrack, in declared
      order; the shape is validated by the VariantsConfig type.

      -Path answers "which track does this file belong to?"
      ([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1)): the track whose root is the path's first
      segment (a bare root folder, e.g. 'docs', is its own track's path). A file at the repository root, a path under
      out/ (gitignored output, never a track), and a root folder no track declares return nothing.
    parameters:
      Name: The track name(s) to return. An unknown name throws, naming the config file.
      Path: A repository-relative path ('/' or '\' separated); returns the track that owns it.
    examples:
      - Get-Track
      - '(Get-Track -Name automation).class                       # -> core'
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

    $tracks = @(Get-Variant -Name tracks -Default @())

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
        foreach ($track in $tracks) {
            if ($track.root -ceq $segments[0]) {
                return $track
            }
        }
        return
    }

    $tracks
}
