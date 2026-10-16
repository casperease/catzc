<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/Build-CommentView.ps1
    name: build-comment-view
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Build-CommentView.Tests.ps1
    cites:
      - ADR-PRIN-ONELIVE#1
      - ADR-REPO-OUTDIR#1
  config:
    synopsis: |-
      Writes the annotated view: every file that has a comment page, with each section of the page put back above the
      code line it names.
    description: |-
      The inverse of Export-Comments. A file keeps no long comment and the prose lives once, in the file's comment page
      ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)); the view
      is the generated, gitignored copy a reader or an agent opens to see a file with its comments inline. It is written
      under comments.yml's `view` folder in out/
      ([ADR-REPO-OUTDIR#1](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir1)), at the file's own
      repository path, so `out/annotated/<path>` is the annotated `<path>`. Only files whose view differs from the file
      get one; a section whose code line is gone is left out (Test-Comments reports it).

      Idempotent: a view whose content is current is not rewritten (Write-FileIfChanged), so a second run is a fast
      no-op. A source-tree tool: it throws in build mode (Assert-SourceTree).
    parameters:
      Path: 'Files or folders to build the view of. Default: every file in scope.'
      RepositoryRoot: 'The repository root paths, pages and the view folder resolve against. Default: the loaded repository root.'
      DryRun: Report which views would change without writing them.
    outputs: '[string[]] the view files written (or, under -DryRun, that would be), repository-relative.'
    examples:
      - Build-CommentView
      - Build-CommentView -Path automation/Catzc.Base.Files
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
