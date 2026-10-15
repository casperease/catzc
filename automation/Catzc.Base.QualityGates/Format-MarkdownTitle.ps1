<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Format-MarkdownTitle.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN#2
      - ADR-REPO-FORMAT#6
      - ADR-REPO-FORMAT#7
---
#>

<#
.SYNOPSIS
    Makes the H1 of every in-scope Markdown file its title and brings its headings into normal form.
.DESCRIPTION
    A duplicate heading anchor and a file with no title are reported, not fixed, since only the author can reword or...
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Format-MarkdownTitle.ps1.md#comment1)
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
# The repository's preview switch is -DryRun, so ShouldProcess and -WhatIf are deliberately absent.
# [comment:2](/docs/references/automation/catzc-base-qualitygates/Format-MarkdownTitle.ps1.md#comment2)
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
