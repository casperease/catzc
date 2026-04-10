<#
.SYNOPSIS
    Maintains the file-scoped namespace on each C# type source, derived from its module folder.
.DESCRIPTION
    Every automation C# type lives at automation/<Module>/types/<Type>.cs and belongs to namespace <Module>
    (ADR native-csharp-types). The namespace is NOT hand-authored: this formatter writes/repairs the
    `namespace <Module>;` line from the file's folder, so the folder stays the single source of truth and a
    move between modules is a safe refactor — re-running Format-Types rewrites the line to the new folder, and
    Test-Types fails CI on any drift. The declared namespace is what lets the editor's C# toolchain compile and
    analyze these files (no CA1050), so the rule is visible in-editor (everything-as-code).

    For each types/*.cs: the line is inserted after the leading comment/using block (before the first type or
    attribute) when absent, corrected when it names the wrong module, and left untouched when already correct.
    Files are written back as UTF-8 without a BOM with LF line endings (repo convention). Logic is never
    changed — only the namespace line.
.PARAMETER Path
    One or more files or directories to process. Defaults to every automation/<Module>/types/*.cs file.
.PARAMETER DryRun
    Report which files would change without writing them (the returned list is the same either way).
.PARAMETER PassThru
    Return a result object ({ ChangedCount, ChangedFiles, DryRun }) instead of only logging.
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
    foreach ($file in $files) {
        # Module = the folder that contains this file's types/ folder: <Module>/types/<file>.cs.
        $module = Split-Path -Path (Split-Path -Path (Split-Path -Path $file -Parent) -Parent) -Leaf

        $original = [System.IO.File]::ReadAllText($file)
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
            ChangedCount = $changedFiles.Count
            ChangedFiles = $changedFiles.ToArray()
            DryRun       = [bool] $DryRun
        }
    }

    $changedFiles.ToArray()
}
