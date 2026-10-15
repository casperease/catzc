<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Format-Types.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-PWSH-PESTER#9
---
#>

<#
.SYNOPSIS
    Maintains the file-scoped namespace on each C# type source, derived from its module folder.
.DESCRIPTION
    The folder is the single source of the namespace, so moving a type between modules is a safe refactor.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Format-Types.ps1.md#comment1)
.PARAMETER Path
    One or more files or directories to process. Defaults to every automation/<Module>/types/*.cs file.
.PARAMETER DryRun
    Report which files would change without writing them (the returned list is the same either way).
.PARAMETER PassThru
    Return a result object ({ ChangedCount, ChangedFiles, BlockScopedFiles, DryRun }) instead of only logging.
.OUTPUTS
    [string[]] The paths of the files that changed (or, under -DryRun, would change).
.EXAMPLE
    Format-Types
.EXAMPLE
    Format-Types -DryRun
#>
function Format-Types {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]] $Path,

        [switch] $DryRun,

        [switch] $PassThru
    )

    # The .cs sources exist only in the source tree (a build ships the compiled assembly, not the sources).
    Assert-SourceTree

    $root = Get-RepositoryRoot
    $files = [System.Collections.Generic.List[string]]::new()
    if ($Path) {
        foreach ($item in $Path) {
            if ([System.IO.Path]::IsPathRooted($item) -and [System.IO.File]::Exists($item)) {
                $files.Add($item)
            }
            elseif (Test-Path -Path $item -PathType Container) {
                # A types file sits two levels below its module (types/), so a folder as wide as automation is three levels up.
                foreach ($typeFile in Get-ChildPath $item -File -Filter '*.cs' -Depth 3) {
                    $files.Add($typeFile)
                }
            }
            else {
                $files.Add((Resolve-Path -Path $item).Path)
            }
        }
    }
    else {
        # [System.IO] enumeration: each cmdlet call on this path adds about 20ms.
        # [comment:3](/docs/references/automation/catzc-base-qualitygates/Format-Types.ps1.md#comment3)
        $automationRoot = [System.IO.Path]::GetFullPath((Join-Path $root 'automation'))
        foreach ($moduleDirectory in [System.IO.Directory]::EnumerateDirectories($automationRoot)) {
            if ([System.IO.Path]::GetFileName($moduleDirectory).StartsWith('.', [System.StringComparison]::Ordinal)) {
                continue
            }
            $typesPath = Join-Path $moduleDirectory 'types'
            if ([System.IO.Directory]::Exists($typesPath)) {
                foreach ($typeFile in [System.IO.Directory]::EnumerateFiles($typesPath, '*.cs')) {
                    $files.Add($typeFile)
                }
            }
        }
    }

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    $changedFiles = [System.Collections.Generic.List[string]]::new()
    $blockScopedFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $files) {
        # Module = the folder that contains this file's types/ folder: <Module>/types/<file>.cs.
        $module = [System.IO.Path]::GetFileName([System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($file)))

        $original = [System.IO.File]::ReadAllText($file)
        # A block-scoped namespace is no authored shape and not a one-line fix, so it is reported for a hand edit.
        # [comment:2](/docs/references/automation/catzc-base-qualitygates/Format-Types.ps1.md#comment2)
        if ($original -notmatch '(?m)^\s*namespace\s+\S+?\s*;' -and $original -match '(?m)^\s*namespace\s+\S+?\s*\{') {
            $blockScopedFiles.Add($file)
            Write-Message "block-scoped namespace (rewrite it by hand as 'namespace $module;'): $file"
        }
        $text = Set-CSharpFileScopedNamespace -Content $original -Namespace $module

        if ($text -cne $original) {
            if (-not $DryRun) {
                [System.IO.File]::WriteAllText($file, $text, $utf8NoBom)
            }
            $changedFiles.Add($file)
            $verb = if ($DryRun) {
                'would set namespace on'
            }
            else {
                'set namespace on'
            }
            Write-Message "${verb}: $file -> namespace $module"
        }
    }

    $summaryVerb = if ($DryRun) {
        'would change'
    }
    else {
        'changed'
    }
    Write-Message "Done. $($changedFiles.Count) of $($files.Count) type file(s) $summaryVerb."

    if ($PassThru) {
        return [pscustomobject]@{
            ChangedCount     = $changedFiles.Count
            ChangedFiles     = $changedFiles.ToArray()
            BlockScopedFiles = $blockScopedFiles.ToArray()
            DryRun           = [bool] $DryRun
        }
    }

    $changedFiles.ToArray()
}
