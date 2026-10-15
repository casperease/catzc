<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
  config:
    synopsis: Moves every long comment of the repository's code and config files into the file's comment page, one-way.
    description: |-
      A long comment leaves the file with nothing behind: its prose moves verbatim into the file's comment page under
      docs/references as a section `## comment:N`, which names the code line the comment sat above, so each comment has
      exactly one living copy
      ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). Nothing is dropped:
      Build-CommentView puts every section back above its code line, and the engine's round-trip test proves the view
      equals the original. The file's head lists the page as its `relatives.page`.

      What moves is configured in comments.yml
      ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)): the file languages in
      scope, the minimum prose lines, the comment heads each language keeps (`.SYNOPSIS`, `.EXAMPLE`, `#Requires`, …),
      and where each folder's pages live. The scope is Get-CommentScope's: tracked files of those languages outside
      tests/, minus vendored, generated, fixture and contract files.

      A page that exists already keeps its sections as written; new comments are appended after its highest number, and
      a number is never reused. A second run over an exported file changes nothing. Source files keep their own line
      endings; pages are written canonical.
      A source-tree tool: it throws in build mode (Assert-SourceTree).
    parameters:
      Path: 'Files or folders to export. Default: every file in scope.'
      RepositoryRoot: 'The repository root paths and pages resolve against. Default: the loaded repository root.'
      DryRun: Report what would move without writing any file.
      PassThru: Return one Catzc.Base.QualityGates.CommentFileResult per file that changes.
    outputs: |-
      [string[]] the repository-relative files changed (or, under -DryRun, that would change); with -PassThru, the
      results.
    examples:
      - Export-Comments -Path automation/Catzc.Base.Files -DryRun -PassThru
      - Export-Comments -Path automation/Catzc.Base.Files/Write-FileIfChanged.ps1
---
#>

function Export-Comments {
    [CmdletBinding()]
    [OutputType([string[]], [Catzc.Base.QualityGates.CommentFileResult])]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-SourceTree

    $config = Get-Config -Config comments
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)

    # Several files may share a page only by configuration error; each page is read once and carried forward.
    $pageTexts = @{}
    $results = [System.Collections.Generic.List[Catzc.Base.QualityGates.CommentFileResult]]::new()
    $scope = @(Get-CommentScope -RepositoryRoot $RepositoryRoot -Path $Path)
    foreach ($entry in $scope) {
        $filePath = Join-Path $RepositoryRoot $entry.File
        $pagePath = Join-Path $RepositoryRoot $entry.Page
        if (-not $pageTexts.ContainsKey($entry.Page)) {
            $pageTexts[$entry.Page] = if (Test-Path -LiteralPath $pagePath -PathType Leaf) {
                [System.IO.File]::ReadAllText($pagePath)
            }
        }
        $text = [System.IO.File]::ReadAllText($filePath)
        $result = [Catzc.Base.QualityGates.CommentEngine]::Export($text, $entry.Extension, $entry.Language, $entry.File, $entry.Page,
            $pageTexts[$entry.Page], $config)
        if (-not $result.Changed) {
            continue
        }
        $pageTexts[$entry.Page] = $result.PageText
        $results.Add($result)
        if (-not $DryRun) {
            Write-FileIfChanged -Path $pagePath -Content $result.PageText | Out-Null
            [System.IO.File]::WriteAllText($filePath, $result.Text, $utf8NoBom)
        }
    }

    $moved = 0
    foreach ($result in $results) {
        $moved += $result.MovedCount
    }
    $verb = if ($DryRun) {
        'would move'
    }
    else {
        'moved'
    }
    if ($results.Count -eq 0) {
        Write-Message "Comments: nothing to move in $($scope.Count) file(s)."
    }
    else {
        Write-Message "Comments: $verb $moved comment(s) from $($results.Count) of $($scope.Count) file(s) into their pages."
    }

    if ($PassThru) {
        return $results.ToArray()
    }
    [string[]] @($results | ForEach-Object File)
}
