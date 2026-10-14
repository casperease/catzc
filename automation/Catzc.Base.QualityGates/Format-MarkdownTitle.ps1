<#
.SYNOPSIS
    Titles every in-scope Markdown file with its repository path and brings its headings into normal form
    ([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6),
    [ADR-REPO-FORMAT#7](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format7)).
.DESCRIPTION
    Makes each file's first line after any YAML front matter the H1 `# <repository-relative path>`: a different H1 is
    replaced and its wording kept as the body's first line (path H1, blank line, old title between single
    backticks), and a file that opens without one gets the title inserted. Then each heading below it is made plain
    words: a trailing group of code spans or a citation moves to its own line below the heading, a dora-explains
    entry's DORA paragraph becomes a > blockquote, and every link to an anchor that changed is re-pointed
    (Get-MarkdownHeadingFinding). A duplicate anchor is reported, not fixed — the author rewords it. The scope is every
    git-tracked *.md file except those .gitattributes marks vendored or generated and the test fixture trees
    (Get-MarkdownTitleScope). Files are written as UTF-8 without a BOM, with their own line endings kept; a file
    already in form is not touched, so a second run changes nothing. Test-MarkdownTitle is the gate. A source-tree
    tool: it throws in build mode (Assert-SourceTree).
.PARAMETER Path
    Files or folders to title. Default: every in-scope file.
.PARAMETER RepositoryRoot
    The repository root titles are relative to. Default: the loaded repository root.
.PARAMETER DryRun
    Report what would change without writing any file.
.PARAMETER PassThru
    Return a result object ({ ChangedCount; ChangedFiles; FileCount; DryRun }) instead of only the changed paths.
.OUTPUTS
    [string[]] the repository-relative paths changed (or, under -DryRun, that would change); with -PassThru, the result
    object.
.EXAMPLE
    Format-MarkdownTitle
.EXAMPLE
    Format-MarkdownTitle -DryRun -PassThru
.EXAMPLE
    Format-MarkdownTitle -Path docs/references
#>
# Uses -DryRun, not ShouldProcess/-WhatIf — see
# [ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2).
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
    $toFix = @($result.Files | Where-Object { @($_.Findings | Where-Object Kind -NE 'Duplicate').Count -gt 0 })

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    foreach ($file in $toFix) {
        $kinds = (@($file.Findings | Where-Object Kind -NE 'Duplicate' | ForEach-Object Kind) | Sort-Object -Unique) -join ', '
        if ($DryRun) {
            Write-Message "Would format $($file.Path) ($kinds)."
        }
        else {
            [System.IO.File]::WriteAllText((Join-Path $RepositoryRoot $file.Path), $file.Fixed, $utf8NoBom)
            Write-Message "Formatted $($file.Path) ($kinds)."
        }
    }
    foreach ($duplicate in @($result.Files | ForEach-Object { $_.Findings } | Where-Object Kind -EQ 'Duplicate')) {
        Write-Message "$($duplicate.Path):$($duplicate.Line) needs rewording by hand: '$($duplicate.Actual)' — expected $($duplicate.Expected)." -Warning
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
