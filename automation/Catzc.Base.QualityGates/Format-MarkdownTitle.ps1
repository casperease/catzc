<#
.SYNOPSIS
    Titles every in-scope Markdown file with its repository path
    ([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6)).
.DESCRIPTION
    Makes each file's first line after any YAML front matter the H1 `# <repository-relative path>`: a different H1 is
    replaced, and a file that opens without one gets the title inserted. The scope is every git-tracked *.md file
    except those .gitattributes marks vendored or generated and the test fixture trees (Get-MarkdownTitleScope).
    Files are written as UTF-8 without a BOM, with their own line endings kept; a file already titled is not
    touched, so a second run changes nothing. Test-MarkdownTitle is the gate. A source-tree tool: it throws in
    build mode (Assert-SourceTree).
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
# [ADR-AUTO-DRYRUN#2](/docs/adr/automation/prefer-dryrun-over-shouldprocess.md#rule-adr-auto-dryrun2).
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
    $toFix = @($result.Findings | Where-Object { $_.Kind -ne 'Ok' })

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    foreach ($finding in $toFix) {
        if ($DryRun) {
            Write-Message "Would title $($finding.Path) (was '$($finding.Actual)')."
        }
        else {
            [System.IO.File]::WriteAllText((Join-Path $RepositoryRoot $finding.Path), $finding.Fixed, $utf8NoBom)
            Write-Message "Titled $($finding.Path) (was '$($finding.Actual)')."
        }
    }

    $verb = if ($DryRun) {
        'would title'
    }
    else {
        'titled'
    }
    Write-Message "Markdown titles: $verb $($toFix.Count) of $($result.FileCount) file(s)."

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
