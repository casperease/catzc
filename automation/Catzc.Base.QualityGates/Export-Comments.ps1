<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-PRIN-CONFIG#1
      - ADR-PRIN-ONELIVE#1
---
#>

<#
.SYNOPSIS
    Moves every long comment of the repository's code and config files into the file's comment page, one-way.
.DESCRIPTION
    A second run changes nothing, and page numbers are never reused, so an exported file stays stable.
.PARAMETER Path
    Files or folders to export. Default: every file in scope.
.PARAMETER RepositoryRoot
    The repository root paths and pages resolve against. Default: the loaded repository root.
.PARAMETER DryRun
    Report what would move without writing any file.
.PARAMETER PassThru
    Return one Catzc.Base.QualityGates.CommentFileResult per file that changes.
.OUTPUTS
    [string[]] the repository-relative files changed (or, under -DryRun, that would change); with -PassThru, the
    results.
.EXAMPLE
    Export-Comments -Path automation/Catzc.Base.Files -DryRun -PassThru
.EXAMPLE
    Export-Comments -Path automation/Catzc.Base.Files/Write-FileIfChanged.ps1
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
    $links = Get-Config -Config links
    $limits = Get-LinkLineLimit -RepositoryRoot $RepositoryRoot -Override $links.line_limit
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
        $limit = $links.default_line_limit
        if ($limits.ContainsKey($entry.Extension)) {
            $limit = $limits[$entry.Extension]
        }
        $text = [System.IO.File]::ReadAllText($filePath)
        $result = [Catzc.Base.QualityGates.CommentEngine]::Export($text, $entry.Extension, $entry.Language, $entry.File, $entry.Page,
            $pageTexts[$entry.Page], $config, $limit)
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
