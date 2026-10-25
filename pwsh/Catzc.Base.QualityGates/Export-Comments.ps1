<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Export-Comments.ps1.md"
  header: "generated"
---
#>

function Export-Comments {
    [CmdletBinding()]
    [OutputType([string[]], [Catzc.Base.QualityGates.CommentFileResult])]
    param(
        [Catzc.Base.Asserts.ValidatePathGiven()]
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
