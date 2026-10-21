<#
---
catzc:
  immutable:
    with_body_sha: "49af9d12da84"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1
    docs: "[Build-CommentView.ps1.md](docs/references/pwsh/catzc-base-quality-gates/Build-CommentView.ps1.md)"
    cites:
      - ADR-PRIN-ONELIVE-ONEVERSION
      - ADR-REPO-OUTDIR-OUTPUTROOTFUNCTION
---
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
        $pagePath = Join-Path $RepositoryRoot $entry.Page
        $pageText = $null
        if (Test-Path -LiteralPath $pagePath -PathType Leaf) {
            $pageText = [System.IO.File]::ReadAllText($pagePath)
        }
        if (-not $pageText) {
            continue
        }
        $view = [Catzc.Base.QualityGates.CommentEngine]::View($text, $entry.Extension, $pageText)
        if ($view -ceq $text) {
            continue
        }
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
