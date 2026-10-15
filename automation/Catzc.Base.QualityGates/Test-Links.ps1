<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-Links.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-LINK
      - ADR-REPO-LINK#5
      - ADR-X
---
#>

<#
.SYNOPSIS
    The link quality gate: fails on any off-form, dangling, or dead link or citation.
.DESCRIPTION
    Read-only twin of Format-Links: each issue says whether Format-Links can fix it or a person must.
.PARAMETER Path
    Files or folders to check. Default: every git-tracked file.
.PARAMETER Kind
    Which link kinds to check: Code, Markdown, or Both (default).
.PARAMETER RepositoryRoot
    The repository root links resolve against. Default: the loaded repository root.
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-links.
.PARAMETER PassThru
    Report-mode string citations show up in Reported and never fail the gate.
.OUTPUTS
    Throws on any violation; with -PassThru, returns the result object.
.EXAMPLE
    Test-Links
.EXAMPLE
    (Test-Links -Kind Code -PassThru).Issues
#>
function Test-Links {
    [CmdletBinding()]
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
        $settings.string_citations.IsReport -and $finding.Type -eq [Catzc.Base.QualityGates.LinkFindingType]::StringColon
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
    }
    $report = Write-QualityGateReport -Subject links -Title Test-Links -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
    if ($PassThru) {
        $report | Add-Member -NotePropertyName Reported -NotePropertyValue $reportedLines
        $report
    }
}
