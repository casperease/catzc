<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Format-FileMeta.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN#2
      - ADR-REPO-FILEMETA#3
      - ADR-REPO-FORMAT#9
---
#>

<#
.SYNOPSIS
    Imprints the derived facts into the meta block of every in-scope Markdown file.
.DESCRIPTION
    The output is byte-identical on every run, so a second run changes no file.
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
    Format-FileMeta
.EXAMPLE
    Format-FileMeta -DryRun -PassThru
.EXAMPLE
    Format-FileMeta -Path docs/references
#>
# The repository's preview switch is -DryRun, so ShouldProcess and -WhatIf are deliberately absent.
# [comment:2](/docs/references/automation/catzc-base-qualitygates/Format-FileMeta.ps1.md#comment2)
function Format-FileMeta {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [switch] $DryRun,

        [switch] $PassThru
    )

    Assert-SourceTree

    $result = Invoke-FileMetaEngine -RepositoryRoot $RepositoryRoot -Path $Path
    $saved = Save-FileMetaResult -Result $result -RepositoryRoot $RepositoryRoot -DryRun:$DryRun
    $toFix = @($saved.Fixed)
    foreach ($file in $toFix) {
        if ($DryRun) {
            Write-Message "Would format $($file.Path) (meta block)."
        }
        else {
            Write-Message "Formatted $($file.Path) (meta block)."
        }
    }
    foreach ($unowned in $saved.Unowned) {
        Write-Message "$($unowned.Path) needs a decision by hand: '$($unowned.Actual)' is a key no meta kind owns — expected $($unowned.Expected)." -Warning
    }

    $verb = if ($DryRun) {
        'would format'
    }
    else {
        'formatted'
    }
    Write-Message "File meta: $verb $($toFix.Count) of $($result.FileCount) file(s)."

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
