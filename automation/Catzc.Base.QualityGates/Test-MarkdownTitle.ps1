<#
.SYNOPSIS
    The Markdown title and heading quality gate: fails on any in-scope file whose title is not its repository path
    or whose headings are not in normal form
    ([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6),
    [ADR-REPO-FORMAT#7](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format7)).
.DESCRIPTION
    Runs the same check as Format-MarkdownTitle, read-only, and reports every file whose first line after any YAML
    front matter is not the H1 `# <repository-relative path>`, every heading with a trailing reference group, every
    unquoted dora-explains paragraph, every link to an anchor that moves, and every duplicate anchor. Running
    Format-MarkdownTitle fixes all of them except a Duplicate, which the author rewords; each issue says which.
    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
    through Write-QualityGateReport, which writes out/test-markdown-title/, prints every issue, and throws once
    listing them all. It needs the source tree: it throws in build mode.
.PARAMETER Path
    Files or folders to check. Default: every in-scope file.
.PARAMETER RepositoryRoot
    The repository root titles are relative to. Default: the loaded repository root.
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-markdown-title.
.PARAMETER PassThru
    Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount }) instead of throwing.
.OUTPUTS
    Throws on any violation; with -PassThru, returns the result object.
.EXAMPLE
    Test-MarkdownTitle
.EXAMPLE
    (Test-MarkdownTitle -PassThru).Issues
#>
function Test-MarkdownTitle {
    [CmdletBinding()]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $result = Invoke-MarkdownTitleEngine -RepositoryRoot $RepositoryRoot -Path $Path
    $issues = @($result.Files | ForEach-Object { $_.Findings } | ForEach-Object {
            $remedy = if ("$($_.Kind)" -eq 'Duplicate') {
                'reword it by hand'
            }
            else {
                'run Format-MarkdownTitle'
            }
            "$($_.Path):$($_.Line) [$($_.Kind)] expected '$($_.Expected)', found '$($_.Actual)' — $remedy"
        })

    Write-QualityGateReport -Subject markdown-title -Title Test-MarkdownTitle -Issues $issues `
        -Facts ([ordered]@{ FileCount = $result.FileCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
