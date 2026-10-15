<#
.SYNOPSIS
    The link quality gate: fails on any off-form, dangling, or dead link or citation
    ([ADR-REPO-LINK](/docs/adr/repository/markdown-links.md)).
.DESCRIPTION
    Read-only twin of Format-Links: each issue says whether Format-Links can fix it or a person must.
    [ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5),
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-Links.ps1.md#comment1)
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
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-Links.ps1.md#comment2)
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
