<#
---
catzc:
  immutable:
    with_body_sha: fe694630132f
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
    docs: "[Format-MarkdownTitle.ps1.md](docs/references/pwsh/catzc-base-quality-gates/Format-MarkdownTitle.ps1.md)"
    cites:
      - ADR-AUTO-DRYRUN-BRANCHBEFORESIDEEFFECT
      - ADR-REPO-FORMAT-MARKDOWNTITLE
      - ADR-REPO-FORMAT-PLAINHEADINGS
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
