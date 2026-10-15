<#
.SYNOPSIS
    Maintains the file-scoped namespace on each C# type source, derived from its module folder.
.DESCRIPTION
    Every automation C# type lives at automation/<Module>/types/<Type>.cs and belongs to namespace <Module> (ADR...
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
            if (Test-Path -Path $item -PathType Container) {
                Get-ChildItem -Path $item -Recurse -Filter '*.cs' -File |
                    ForEach-Object { $files.Add($_.FullName) }
            }
            else {
                $files.Add((Resolve-Path -Path $item).Path)
            }
        }
    }
    else {
        $automationRoot = Join-Path $root 'automation'
        Get-ChildItem -Path $automationRoot -Directory |
            Where-Object { $_.Name -notmatch '^\.' } |
            ForEach-Object {
                $typesPath = Join-Path $_.FullName 'types'
                if (Test-Path $typesPath) {
                    Get-ChildItem -Path $typesPath -Filter '*.cs' -File |
                        ForEach-Object { $files.Add($_.FullName) }
                    }
                }
    }

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    $changedFiles = [System.Collections.Generic.List[string]]::new()
    $blockScopedFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $files) {
        # Module = the folder that contains this file's types/ folder: <Module>/types/<file>.cs.
        $module = Split-Path -Path (Split-Path -Path (Split-Path -Path $file -Parent) -Parent) -Leaf

        $original = [System.IO.File]::ReadAllText($file)
        # A block-scoped `namespace X { … }` is not a shape this repo authors, and rewriting it is not a one-line...
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
