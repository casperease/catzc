<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-TrackNamespace.ps1.md"
  header: "generated"
---
#>

function Test-TrackNamespace {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    # A path under a track drops its track's namespace unless the track exempts it.
    $tracked = @(Get-GitTrackedPath '.')
    $tracks = @(Get-Track | Where-Object { $_.namespace })
    $found = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($track in $tracks) {
        $prefix = "$($track.namespace)$($track.join)"
        foreach ($path in $tracked) {
            $segment = $track.NamespaceSegmentOf($path)
            if ($segment) {
                [void] $found.Add("track '$($track.name)': '$segment' spells the namespace '$prefix' on disk; drop it from the name, or exempt the file under the track's namespace_exempt")
            }
        }
    }

    Write-QualityGateReport -Subject track-namespace -Title Test-TrackNamespace -Issues ([string[]] @($found)) `
        -Facts ([ordered]@{ Tracks = $tracks.Count; Paths = $tracked.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
