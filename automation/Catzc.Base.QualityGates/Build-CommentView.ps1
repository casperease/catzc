<#
.SYNOPSIS
    Writes the annotated view: every file that carries comment residues, with each section of its comment page put
    back where its residue stands.
.DESCRIPTION
    The inverse of Export-Comments.
    [ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1),
    [ADR-REPO-OUTDIR#1](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir1)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Build-CommentView.ps1.md#comment1)
.PARAMETER Path
    Files or folders to build the view of. Default: every file in scope.
.PARAMETER RepositoryRoot
    The repository root paths, pages and the view folder resolve against. Default: the loaded repository root.
.PARAMETER DryRun
    Report which views would change without writing them.
.OUTPUTS
    [string[]] the view files written (or, under -DryRun, that would be), repository-relative.
.EXAMPLE
    Build-CommentView
.EXAMPLE
    Build-CommentView -Path automation/Catzc.Base.Files
#>
function Build-CommentView {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun
    )

    Assert-SourceTree

    $config = Get-Config -Config comments
    $written = [System.Collections.Generic.List[string]]::new()
    $scope = @(Get-CommentScope -RepositoryRoot $RepositoryRoot -Path $Path)
    foreach ($entry in $scope) {
        $text = [System.IO.File]::ReadAllText((Join-Path $RepositoryRoot $entry.File))
        if ([Catzc.Base.QualityGates.CommentEngine]::FindResidues($text, $entry.Extension).Count -eq 0) {
            continue
        }
        $pagePath = Join-Path $RepositoryRoot $entry.Page
        $pageText = $null
        if (Test-Path -LiteralPath $pagePath -PathType Leaf) {
            $pageText = [System.IO.File]::ReadAllText($pagePath)
        }
        $view = [Catzc.Base.QualityGates.CommentEngine]::View($text, $entry.Extension, $pageText)
        $viewRelative = "$($config.view)/$($entry.File)"
        if (Write-FileIfChanged -Path (Join-Path $RepositoryRoot $viewRelative) -Content $view -DryRun:$DryRun) {
            $written.Add($viewRelative)
        }
    }

    $verb = if ($DryRun) {
        'would write'
    }
    else {
        'wrote'
    }
    if ($written.Count -gt 0) {
        Write-Message "Comment view: $verb $($written.Count) annotated file(s) under $($config.view)."
    }
    [string[]] $written.ToArray()
}
