<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/Format-MarkdownTitle.ps1
    name: format-markdown-title
    filetype: ps1
    kind: function
    subkind: formatter
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-qualitygates/Format-MarkdownTitle.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
    cites:
      - ADR-AUTO-DRYRUN#2
      - ADR-REPO-FORMAT#{6,7}
  config:
    synopsis: Makes the H1 of every in-scope Markdown file its title and brings its headings into normal form.
    description: |-
      Makes each file's first line after any YAML front matter its title, an H1 that is not the file's path: an H1 that is
      the path followed by one code-span line takes that line's text as its wording (the line goes), and a file with no
      title is reported, since only a person can write one. Then each heading below it is made plain
      words: a trailing group of code spans or a citation moves to its own line below the heading, a dora-explains
      entry's DORA paragraph becomes a > blockquote, and every link to an anchor that changed is re-pointed
      (Get-MarkdownHeadingFinding). A duplicate anchor is reported, not fixed — the author rewords it. The scope is every
      git-tracked *.md file except those .gitattributes marks vendored or generated and the test fixture trees
      (Get-MarkdownScope). Files are written as UTF-8 without a BOM, with their own line endings kept; a file
      already in form is not touched, so a second run changes nothing. Test-MarkdownTitle is the gate. A source-tree
      tool: it throws in build mode (Assert-SourceTree).
    parameters:
      Path: 'Files or folders to title. Default: every in-scope file.'
      RepositoryRoot: 'The repository root titles are relative to. Default: the loaded repository root.'
      DryRun: Report what would change without writing any file.
      PassThru: Return a result object ({ ChangedCount; ChangedFiles; FileCount; DryRun }) instead of only the changed paths.
    outputs: |-
      [string[]] the repository-relative paths changed (or, under -DryRun, that would change); with -PassThru, the result
      object.
    examples:
      - Format-MarkdownTitle
      - Format-MarkdownTitle -DryRun -PassThru
      - Format-MarkdownTitle -Path docs/references
---
#>

function Format-MarkdownTitle {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-SourceTree

    $result = Invoke-MarkdownTitleEngine -RepositoryRoot $RepositoryRoot -Path $Path
    $byHand = 'Duplicate', 'Untitled', 'Missing'
    $toFix = @($result.Files | Where-Object { @($_.Findings | Where-Object Kind -NotIn $byHand).Count -gt 0 })

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    foreach ($file in $toFix) {
        $kinds = (@($file.Findings | Where-Object Kind -NotIn $byHand | ForEach-Object Kind) | Sort-Object -Unique) -join ', '
        if ($DryRun) {
            Write-Message "Would format $($file.Path) ($kinds)."
        }
        else {
            [System.IO.File]::WriteAllText((Join-Path $RepositoryRoot $file.Path), $file.Fixed, $utf8NoBom)
            Write-Message "Formatted $($file.Path) ($kinds)."
        }
    }
    foreach ($finding in @($result.Files | ForEach-Object { $_.Findings } | Where-Object Kind -In $byHand)) {
        Write-Message "$($finding.Path):$($finding.Line) needs a decision by hand ($($finding.Kind)): '$($finding.Actual)' — expected $($finding.Expected)." -Warning
    }

    $verb = if ($DryRun) {
        'would format'
    }
    else {
        'formatted'
    }
    Write-Message "Markdown titles and headings: $verb $($toFix.Count) of $($result.FileCount) file(s)."

    $changedFiles = [string[]] @($toFix | ForEach-Object { $_.Path } | Sort-Object)
    if ($PassThru) {
        return [pscustomobject]@{
            ChangedCount = $changedFiles.Count
            ChangedFiles = $changedFiles
            FileCount    = $result.FileCount
            DryRun       = [bool] $DryRun
        }
    }
    $changedFiles
}
