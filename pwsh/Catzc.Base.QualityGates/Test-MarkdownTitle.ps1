<#
---
catzc:
  immutable:
    with_body_sha: a5ca1c4df47e
  edges:
    docs: "[Test-MarkdownTitle.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-MarkdownTitle.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-FORMAT-MARKDOWNTITLE
      - ADR-REPO-FORMAT-PLAINHEADINGS
---
#>

function Test-MarkdownTitle {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
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
