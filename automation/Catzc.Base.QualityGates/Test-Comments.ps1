<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-Comments.ps1
    kind: function
    subkind: gate
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Test-Comments.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
  config:
    synopsis: 'Quality gate: every long comment lives in its file''s comment page, and every page section still names a code line of the file.'
    description: |-
      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the files in
      scope (Get-CommentScope). A file keeps no long comment and the prose lives once, in the file's comment page
      ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)); it lists every issue:

      - a comment long enough to move that is still in the file (run Export-Comments);
      - a page section whose code line the file no longer has, so its prose belongs to nothing.

      What the configured thresholds are is comments.yml's
      ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)). A source-tree tool: it
      throws in build mode (Assert-SourceTree).
    parameters:
      Path: 'Files or folders to check. Default: every file in scope.'
      RepositoryRoot: 'The repository root paths and pages resolve against. Default: the loaded repository root.'
      OutputFolder: 'The report base folder. Default: the reports.yml folder for this gate.'
      PassThru: Return the report object instead of throwing on issues.
    outputs: '[pscustomobject] With -PassThru only.'
    examples:
      - Test-Comments
      - Test-Comments -Path automation/Catzc.Base.Files -PassThru
---
#>

function Test-Comments {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
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
