<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Format-Types.ps1
    kind: function
    subkind: formatter
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/Format-Types.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1
    adrs:
      - ADR-PWSH-PESTER#9
  config:
    synopsis: Maintains the file-scoped namespace on each C# type source, derived from its module folder.
    description: |-
      Every automation C# type lives at automation/<Module>/types/<Type>.cs and belongs to namespace <Module>
      (ADR native-csharp-types). The namespace is NOT hand-authored: this formatter writes/repairs the
      `namespace <Module>;` line from the file's folder, so the folder stays the single source of truth and a
      move between modules is a safe refactor — re-running Format-Types rewrites the line to the new folder, and
      Test-Formatting (its -DryRun) fails CI on any drift. The declared namespace is what lets the editor's C#
      toolchain compile and analyze these files (no CA1050), so the rule is visible in-editor (everything-as-code).

      For each types/*.cs: the line is inserted after the leading comment/using block (before the first type or
      attribute) when absent, corrected when it names the wrong module, and left untouched when already correct.
      Files are written back as UTF-8 without a BOM with LF line endings (repo convention). Logic is never
      changed — only the namespace line. A block-scoped `namespace X { … }` is the one shape it cannot fix: it is
      left untouched and reported in BlockScopedFiles (Test-Formatting turns each into an issue).

      A source-tree tool: it rewrites the repository's type sources, so it throws in build mode
      (Assert-SourceTree).
    parameters:
      Path: One or more files or directories to process. Defaults to every automation/<Module>/types/*.cs file.
      DryRun: Report which files would change without writing them (the returned list is the same either way).
      PassThru: Return a result object ({ ChangedCount, ChangedFiles, BlockScopedFiles, DryRun }) instead of only logging.
    outputs: '[string[]] The paths of the files that changed (or, under -DryRun, would change).'
    examples:
      - Format-Types
      - Format-Types -DryRun
---
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
