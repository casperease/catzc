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

    # A member's declared committed fact must agree with the git index.
    $root = Get-RepositoryRoot
    $members = @(Get-TrackMember)
    # A generator's member takes generated from that generator's target, never from its own declaration too.
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
    # Every root entry but .git lies in a track: a member covers it, or it holds one (.ado holds .ado/pipelines).
    $memberPaths = @($members | ForEach-Object { $_.path })
    $issues += @(foreach ($entry in [System.IO.Directory]::GetFileSystemEntries($root)) {
            $name = [System.IO.Path]::GetFileName($entry)
            if ($name -ceq '.git' -or (Get-Track -Path $name)) {
                continue
            }
            if (@($memberPaths | Where-Object { $_.StartsWith("$name/", [System.StringComparison]::Ordinal) }).Count -gt 0) {
                continue
            }
            "root entry '$name' lies in no track; add it as a member of the track that owns it in variants.yml"
        })

    Write-QualityGateReport -Subject track-member-committed -Title Test-TrackMemberCommitted -Issues ([string[]] @($issues)) `
        -Facts ([ordered]@{ Members = $members.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
