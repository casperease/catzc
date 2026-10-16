<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Format-FileMeta.ps1
    name: format-file-meta
    filetype: ps1
    kind: function
    subkind: formatter
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/Format-FileMeta.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1
    adrs:
      - ADR-AUTO-DRYRUN#2
      - ADR-REPO-FILEMETA#3
      - ADR-REPO-FORMAT#9
  config:
    synopsis: Imprints the derived facts into the meta block of every in-scope Markdown file.
    description: |-
      The output is byte-identical on every run, so a second run changes no file. The authored `config` part is kept as written, and a
      file whose block holds a key no meta kind owns is reported and left unchanged.
    parameters:
      Path: 'Files or folders to format. Default: every in-scope file.'
      RepositoryRoot: 'The repository root paths are relative to. Default: the loaded repository root.'
      DryRun: Report what would change without writing any file.
      PassThru: Return a result object ({ ChangedCount; ChangedFiles; FileCount; DryRun }) instead of only the changed paths.
    outputs: |-
      [string[]] the repository-relative paths changed (or, under -DryRun, that would change); with -PassThru, the result
      object.
    examples:
      - Format-FileMeta
      - Format-FileMeta -DryRun -PassThru
      - Format-FileMeta -Path docs/references
---
#>

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
