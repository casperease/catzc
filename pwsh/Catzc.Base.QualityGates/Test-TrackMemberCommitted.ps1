function Test-TrackMemberCommitted {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    # A member's committed fact is declared, and the git index is what it must agree with
    # ([DDR-TRACK-TRACKISPLACEDCLUSTER](/docs/drs/design/tracks.md#rule-ddr-track-trackisplacedcluster)); a committed
    # member with nothing on disk yet, such as an empty landing address, has nothing to disagree with.
    $root = Get-RepositoryRoot
    $members = @(Get-TrackMember)
    $issues = @(foreach ($member in $members) {
            $tracked = @(Get-GitTrackedPath $member.path)
            $onDisk = Test-Path -LiteralPath (Join-Path $root $member.path)
            if ($member.committed -and $tracked.Count -eq 0 -and $onDisk) {
                "track '$($member.track)': member '$($member.path)' is declared committed, but git tracks none of it"
            }
            elseif (-not $member.committed -and $tracked.Count -gt 0) {
                "track '$($member.track)': member '$($member.path)' is declared not committed, but git tracks $($tracked.Count) file(s) of it, e.g. '$($tracked[0])'"
            }
        })

    Write-QualityGateReport -Subject track-member-committed -Title Test-TrackMemberCommitted -Issues ([string[]] @($issues)) `
        -Facts ([ordered]@{ Members = $members.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
