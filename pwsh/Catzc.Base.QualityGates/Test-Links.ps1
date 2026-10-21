<#
---
catzc:
  immutable:
    with_body_sha: a33b5ced352a
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
    docs: "[Test-Links.ps1.md](../../docs/references/pwsh/catzc-base-quality-gates/Test-Links.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-LINK-ONECITATIONSPELLING
      - ADR-REPO-LINK-STRINGSAREDATA
---
#>

function Test-Links {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path,

        [Catzc.Base.QualityGates.LinkKind] $Kind = [Catzc.Base.QualityGates.LinkKind]::Both,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $settings = Get-Config -Config links
    $result = Invoke-LinkEngine -RepositoryRoot $RepositoryRoot -Path $Path -Kind $Kind -Wrap $settings.wrap
    # The string-citation check fails the gate only in gate mode; in report mode its findings are its work list.
    $isReported = {
        param($finding)
        $settings.string_citations.IsReport -and $finding.Type -eq [Catzc.Base.QualityGates.LinkFindingType]::StringNumbered
    }
    $violations = @($result.Findings | Where-Object { $_.IsViolation -and -not (& $isReported $_) })
    $reported = @($result.Findings | Where-Object { $_.IsViolation -and (& $isReported $_) })
    $information = @($result.Findings | Where-Object { -not $_.IsViolation })
    $reportedLines = [string[]] @(foreach ($finding in $reported) {
            "$finding — run Format-Links"
        })
    Write-ReportModeFinding -Check string_citations -Finding $reportedLines
    $issues = @(foreach ($violation in $violations) {
            if ($violation.IsFixable) {
                "$violation — run Format-Links"
            }
            else {
                "$violation"
            }
        })

    $facts = [ordered]@{
        FileCount        = $result.FileCount
        FixableCount     = @($violations | Where-Object { $_.IsFixable }).Count
        InformationCount = $information.Count
        ReportedCount    = $reported.Count
        Reported         = $reportedLines
    }
    Write-QualityGateReport -Subject links -Title Test-Links -Issues $issues -Facts $facts -OutputFolder $OutputFolder -PassThru:$PassThru
}
