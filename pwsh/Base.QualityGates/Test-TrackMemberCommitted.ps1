<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-TrackMemberCommitted.ps1.md"
  header: "generated"
---
#>

function Test-TrackMemberCommitted {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $root = Get-RepositoryRoot
    $members = @(Get-TrackMember)
    # A member a catzc generator writes takes its generated fact from that generator's target, never from its own
    # declaration as well.
    $targets = @(Get-GeneratedTarget)
    $issues = @(foreach ($member in $members) {
            if ($member.generated) {
                $writers = @($targets | Where-Object {
                        [Catzc.Base.Objects.GlobPattern]::MatchingPaths([string[]] @($_.path), [string[]] @($member.path)).Count -gt 0
                    })
                if ($writers.Count -gt 0) {
                    "track '$($member.track)': member '$($member.path)' declares generated, but $($writers[0].generator) already writes it as a generated target; drop the declaration"
                }
            }
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
