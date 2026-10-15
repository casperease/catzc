<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1
    kind: gate-function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-FORMAT#6
      - ADR-REPO-FORMAT#7
---
#>

<#
.SYNOPSIS
    The Markdown title and heading quality gate: fails on any in-scope file whose H1 is not a title
    or whose headings are not in normal form.
.DESCRIPTION
    Format-MarkdownTitle fixes every finding but a Duplicate anchor, an Untitled file and a Missing title, which the...
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
            elseif ("$($_.Kind)" -in 'Untitled', 'Missing') {
                'write the title by hand'
            }
            else {
                'run Format-MarkdownTitle'
            }
            "$($_.Path):$($_.Line) [$($_.Kind)] expected '$($_.Expected)', found '$($_.Actual)' — $remedy"
        })

    Write-QualityGateReport -Subject markdown-title -Title Test-MarkdownTitle -Issues $issues `
        -Facts ([ordered]@{ FileCount = $result.FileCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
