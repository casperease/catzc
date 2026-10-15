<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/Get-Track.ps1
    kind: function
    module: Catzc.Base.Variants
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns the repository's tracks — all of them, the named ones, or the track that owns a path.
.DESCRIPTION
    -Path matches the first path segment to a root; root files, out/ and undeclared folders return nothing.
    [ADR-DSGN-TRACK](/docs/adr/design/tracks.md),
    [ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1),
    [ADR-DSGN-TRACK#2](/docs/adr/design/tracks.md#rule-adr-dsgn-track2),
    [ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)
    [comment:1](/docs/references/automation/catzc-base-variants/Get-Track.ps1.md#comment1)
.PARAMETER Name
    The track name(s) to return. An unknown name throws, naming the config file.
.PARAMETER Path
    A repository-relative path ('/' or '\' separated); returns the track that owns it.
.EXAMPLE
    Get-Track
.EXAMPLE
    (Get-Track -Name automation).class                       # -> core
.EXAMPLE
    (Get-Track -Path 'docs/adr/design/tracks.md').name        # -> docs
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
