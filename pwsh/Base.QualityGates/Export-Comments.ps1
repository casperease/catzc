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

        [string] $StagedFolder,

        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-SourceTree

    $config = Get-Config -Config comments
    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)

    # Several files may share a page only by configuration error; each page is read once and carried forward.
    $pageTexts = @{}
    $results = [System.Collections.Generic.List[Catzc.Base.QualityGates.CommentFileResult]]::new()
    $sourceRoot = $RepositoryRoot
    $scopePath = $Path
    if ($StagedFolder) {
        $sourceRoot = [System.IO.Path]::GetFullPath($StagedFolder, [System.IO.Path]::GetFullPath($RepositoryRoot))
        $scopePath = @(if ($Path) {
                $Path
            }
            else {
                $sourceRoot
            })
    }
    $scope = @(Get-CommentScope -RepositoryRoot $sourceRoot -Path $scopePath)
    foreach ($entry in $scope) {
        $filePath = Join-Path $sourceRoot $entry.File
        $pagePath = Join-Path $sourceRoot $entry.Page
        if (-not $pageTexts.ContainsKey($entry.Page)) {
            $readPath = if ($StagedFolder -and -not (Test-Path -LiteralPath $pagePath -PathType Leaf)) {
                Join-Path $RepositoryRoot $entry.Page
            }
            else {
                $pagePath
            }
            $pageTexts[$entry.Page] = if (Test-Path -LiteralPath $readPath -PathType Leaf) {
                [System.IO.File]::ReadAllText($readPath)
            }
        }
        $text = [System.IO.File]::ReadAllText($filePath)
        $result = [Catzc.Base.QualityGates.CommentEngine]::Export($text, $entry.Extension, $entry.Language, $entry.File,
            $entry.Page,
            $pageTexts[$entry.Page], $config)
        if (-not $result.Changed) {
            continue
        }
        $pageTexts[$entry.Page] = $result.PageText
        $results.Add($result)
        if (-not $DryRun) {
            $repositoryPage = Join-Path $RepositoryRoot $entry.Page
            $basePath = "$pagePath.burst-base"
            if ($StagedFolder -and -not (Test-Path -LiteralPath $basePath) -and (Test-Path -LiteralPath $repositoryPage -PathType Leaf)) {
                $null = New-Item -ItemType Directory -Path (Split-Path -Parent $pagePath) -Force
                [System.IO.File]::WriteAllText($basePath, (Get-FileHash -Algorithm SHA256 -LiteralPath $repositoryPage).Hash)
            }
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
