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
