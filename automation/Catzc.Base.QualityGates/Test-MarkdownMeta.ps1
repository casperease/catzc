<#
.SYNOPSIS
    The Markdown meta quality gate: fails on any in-scope file whose meta block differs from what Format-MarkdownMeta would write
    ([ADR-REPO-FORMAT#9](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format9),
    [ADR-REPO-MDMETA#3](/docs/adr/repository/markdown-meta.md#rule-adr-repo-mdmeta3)).
.DESCRIPTION
    A key no meta kind owns is reported too: the author decides whether it belongs in `config` or goes.
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
.PARAMETER Path
    Files or folders to check. Default: every in-scope file.
.PARAMETER RepositoryRoot
    The repository root paths are relative to. Default: the loaded repository root.
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-markdown-meta.
.PARAMETER PassThru
    Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount }) instead of throwing.
.OUTPUTS
    Throws on any violation; with -PassThru, returns the result object.
.EXAMPLE
    Test-MarkdownMeta
.EXAMPLE
    (Test-MarkdownMeta -PassThru).Issues
#>
function Test-MarkdownMeta {
    [CmdletBinding()]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $result = Invoke-MarkdownMetaEngine -RepositoryRoot $RepositoryRoot -Path $Path
    $issues = @($result.Files | ForEach-Object { $_.Findings } | ForEach-Object {
            $remedy = if ("$($_.Kind)" -eq 'Unowned') {
                'move it under config, or remove it'
            }
            else {
                'run Format-MarkdownMeta'
            }
            "$($_.Path):$($_.Line) [$($_.Kind)] expected '$($_.Expected)', found '$($_.Actual)' — $remedy"
        })

    Write-QualityGateReport -Subject markdown-meta -Title Test-MarkdownMeta -Issues $issues `
        -Facts ([ordered]@{ FileCount = $result.FileCount }) -OutputFolder $OutputFolder -PassThru:$PassThru
}
