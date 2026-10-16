<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-Links.ps1
    kind: gate-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-LINK
      - ADR-X
  config:
    synopsis: 'The link quality gate: fails on any off-form, dangling, or dead link or citation.'
    description: |-
      Runs the same engine as Format-Links, read-only, and reports every violation: a code link not yet in canonical
      repository-rooted form, a markdown link that is rooted or climbs above the repository root, a rule citation
      spelled `ADR-X:n` in prose, a comment, or a code string literal, a link target or #fragment that does not exist,
      an unknown citation code or rule, an absolute URL into this repository outside .github/, and a docs path in a
      PowerShell string that names no file. A fixable violation is fixed by running Format-Links, and its issue says so;
      the rest need a person. Informational findings (a comment line that stays over its limit) are counted but never
      fail the gate.

      The string-citation check (`ADR-X:n` in a string literal,
      [ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5)) takes its mode and exempt globs
      from links.yml's string_citations: in gate mode its findings are issues; in report mode they are printed as its
      work list and counted (ReportedCount), and never fail the gate.

      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
      through Write-QualityGateReport, which writes out/test-links/, prints every issue, and throws once listing them
      all. Each issue reads '<file>:<line>:<column> [<type>] <message>'. It needs the source tree: it throws in build mode.
    parameters:
      Path: 'Files or folders to check. Default: every git-tracked file.'
      Kind: 'Which link kinds to check: Code, Markdown, or Both (default).'
      RepositoryRoot: 'The repository root links resolve against. Default: the loaded repository root.'
      OutputFolder: The report base folder. Defaults to <out>/test-links.
      PassThru: |-
        Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount, FixableCount, InformationCount,
        ReportedCount, Reported }) instead of throwing.
    outputs: Throws on any violation; with -PassThru, returns the result object.
    examples:
      - Test-Links
      - (Test-Links -Kind Code -PassThru).Issues
---
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
