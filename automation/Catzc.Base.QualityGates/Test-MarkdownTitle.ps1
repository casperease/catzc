<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1
    kind: gate-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-FORMAT#{6,7}
  config:
    synopsis: |-
      The Markdown title and heading quality gate: fails on any in-scope file whose H1 is not a title
      or whose headings are not in normal form.
    description: |-
      Runs the same check as Format-MarkdownTitle, read-only, and reports every file whose first line after any YAML
      front matter is not an H1 title (an H1 that is the file's path, or no H1), every heading with a trailing reference
      group, every unquoted dora-explains paragraph, every link to an anchor that moves, and every duplicate anchor. Running
      Format-MarkdownTitle fixes all of them except a Duplicate, an Untitled file and a Missing title, which the author
      writes; each issue says which.
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
      through Write-QualityGateReport, which writes out/test-markdown-title/, prints every issue, and throws once
      listing them all. It needs the source tree: it throws in build mode.
    parameters:
      Path: 'Files or folders to check. Default: every in-scope file.'
      RepositoryRoot: 'The repository root titles are relative to. Default: the loaded repository root.'
      OutputFolder: The report base folder. Defaults to <out>/test-markdown-title.
      PassThru: Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount }) instead of throwing.
    outputs: Throws on any violation; with -PassThru, returns the result object.
    examples:
      - Test-MarkdownTitle
      - (Test-MarkdownTitle -PassThru).Issues
---
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
