<#
.SYNOPSIS
    Imprints the derived facts into the meta block of every in-scope Markdown file
    ([ADR-REPO-FORMAT#9](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format9),
    [ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)).
.DESCRIPTION
    The output is byte-identical on every run, so a second run changes no file. The authored `config` part is kept as written, and a
    file whose block holds a key no meta kind owns is reported and left unchanged.
.PARAMETER Path
    Files or folders to format. Default: every in-scope file.
.PARAMETER RepositoryRoot
    The repository root paths are relative to. Default: the loaded repository root.
.PARAMETER DryRun
    Report what would change without writing any file.
.PARAMETER PassThru
    Return a result object ({ ChangedCount; ChangedFiles; FileCount; DryRun }) instead of only the changed paths.
.OUTPUTS
    [string[]] the repository-relative paths changed (or, under -DryRun, that would change); with -PassThru, the result
    object.
.EXAMPLE
    Format-MarkdownMeta
.EXAMPLE
    Format-MarkdownMeta -DryRun -PassThru
.EXAMPLE
    Format-MarkdownMeta -Path docs/references
#>
# The repository's preview switch is -DryRun, so ShouldProcess and -WhatIf are deliberately absent.
# [ADR-AUTO-DRYRUN#2](/docs/adr/automation/dry-run.md#rule-adr-auto-dryrun2)
function Format-MarkdownMeta {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-SourceTree

    $result = Invoke-MarkdownMetaEngine -RepositoryRoot $RepositoryRoot -Path $Path
    $toFix = @($result.Files | Where-Object { @($_.Findings | Where-Object Kind -EQ 'Drift').Count -gt 0 })

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    foreach ($file in $toFix) {
        if ($DryRun) {
            Write-Message "Would format $($file.Path) (meta block)."
        }
        else {
            [System.IO.File]::WriteAllText((Join-Path $RepositoryRoot $file.Path), $file.Fixed, $utf8NoBom)
            Write-Message "Formatted $($file.Path) (meta block)."
        }
    }
    foreach ($unowned in @($result.Files | ForEach-Object { $_.Findings } | Where-Object Kind -EQ 'Unowned')) {
        Write-Message "$($unowned.Path) needs a decision by hand: '$($unowned.Actual)' is a key no meta kind owns — expected $($unowned.Expected)." -Warning
    }

    $verb = if ($DryRun) {
        'would format'
    }
    else {
        'formatted'
    }
    Write-Message "Markdown meta: $verb $($toFix.Count) of $($result.FileCount) file(s)."

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
