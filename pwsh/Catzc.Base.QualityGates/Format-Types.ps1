<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Format-Types.ps1
    name: format-types
    filetype: ps1
    role: function
    subkind: formatter
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1
    docs: "[Format-Types.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Format-Types.ps1.md)"
    cites:
      - ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS
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
                # A types file sits two levels below its module (types/), so a folder as wide as pwsh/ is three levels up.
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
        $modulesRoot = [System.IO.Path]::GetFullPath((Join-Path $root (Get-CatzcModulesFolder)))
        foreach ($moduleDirectory in [System.IO.Directory]::EnumerateDirectories($modulesRoot)) {
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
