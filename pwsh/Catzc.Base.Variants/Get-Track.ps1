<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-variants/Get-Track.ps1.md"
  warning: "Generated Header"
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
                throw "Unknown track '$trackName' (declared in the variants config, Catzc.Base.Variants configs/variants.yml:$(@($tracks | ForEach-Object name) -join ', '))."
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
