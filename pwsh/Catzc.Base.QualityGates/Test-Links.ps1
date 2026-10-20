<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Test-Links.ps1
    name: test-links
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
    docs: "[Test-Links.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-Links.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-LINK-ONECITATIONSPELLING
---
#>

function Test-Links {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
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
