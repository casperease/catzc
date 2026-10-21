<#
---
catzc:
  immutable:
    with_body_sha: d6a13b352dc9
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-Comments.Tests.ps1
    docs: "[Test-Comments.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-Comments.ps1.md)"
    cites:
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-PRIN-CONFIG-VARYINGBEHAVIOURISCONFIG
      - ADR-PRIN-ONELIVE-ONEVERSION
---
#>

function Test-Comments {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $config = Get-Config -Config comments
    $issues = [System.Collections.Generic.List[string]]::new()
    $pageCount = 0
    $scope = @(Get-CommentScope -RepositoryRoot $RepositoryRoot -Path $Path)
    foreach ($entry in $scope) {
        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $entry.File))
        foreach ($block in [Catzc.Base.QualityGates.CommentEngine]::FindBlocks($text, $entry.Extension, $entry.Language, $config)) {
            $issues.Add("$($entry.File):$($block.StartLine + 1): a $($block.ProseLineCount)-line comment is still in the file — run Export-Comments")
        }

        $pagePath = Join-Path $RepositoryRoot $entry.Page
        if (-not (Test-Path -LiteralPath $pagePath -PathType Leaf)) {
            continue
        }
        $pageText = [System.IO.File]::ReadAllText($pagePath)
        $pageCount++
        foreach ($number in [Catzc.Base.QualityGates.CommentEngine]::Orphans($text, $pageText)) {
            $issues.Add("$($entry.Page): section comment:$number names a code line $($entry.File) no longer has")
        }
    }

    $facts = [ordered]@{
        FileCount = $scope.Count
        PageCount = $pageCount
    }
    Write-QualityGateReport -Subject comments -Title Test-Comments -Issues $issues.ToArray() -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
