<#
.SYNOPSIS
    The link gate: fails on any off-form, dangling, or dead link or citation
    ([ADR-REPO-LINK](/docs/adr/repository/markdown-links.md)).
.DESCRIPTION
    Runs the same engine as Format-Links, read-only, and reports every violation: a code link not yet in canonical
    repository-rooted form, a markdown link that is rooted or climbs above the repository root, a rule citation
    spelled `ADR-X:n`, a link target or #fragment that does not exist, an unknown citation code or rule, an absolute
    URL into this repository outside .github/, and a docs path in a PowerShell string that names no file. A fixable
    violation is fixed by running Format-Links, and its issue says so; the rest need a person. Informational
    findings (a comment line that stays over its limit) are counted but never fail the gate.

    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
    through Write-QualityGateReport, which writes out/test-links/, prints every issue, and throws once listing them
    all. Each issue reads '<file>:<line>:<column> [<type>] <message>'. A source-tree gate: it throws in build mode.
.PARAMETER Path
    Files or folders to check. Default: every git-tracked file.
.PARAMETER Kind
    Which link kinds to check: Code, Markdown, or Both (default).
.PARAMETER RepositoryRoot
    The repository root links resolve against. Default: the loaded repository root.
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-links.
.PARAMETER PassThru
    Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount, FixableCount, InformationCount })
    instead of throwing.
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

    $result = Invoke-LinkEngine -RepositoryRoot $RepositoryRoot -Path $Path -Kind $Kind -Wrap (Get-Config -Config links).wrap
    $violations = @($result.Findings | Where-Object { $_.IsViolation })
    $information = @($result.Findings | Where-Object { -not $_.IsViolation })
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
    }
    Write-QualityGateReport -Subject links -Title Test-Links -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
