function Format-Types {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Catzc.Base.Asserts.ValidatePathGiven()]
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
                # A types file sits under <module>/types, so a folder as wide as pwsh/ is three levels up.
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
        # [System.IO] on this hot path: each cmdlet call here costs about 20 ms.
        $modulesRoot = [System.IO.Path]::GetFullPath((Join-Path $root (Get-CatzcModulesFolder)))
        foreach ($moduleDirectory in Get-ChildPath $modulesRoot -Depth 1 -Directory) {
            if ([System.IO.Path]::GetFileName($moduleDirectory).StartsWith('.', [System.StringComparison]::Ordinal)) {
                continue
            }
            foreach ($typeFile in [Catzc.Base.Folders.PathSet]::new().AddPattern((Join-Path $moduleDirectory 'types'),
                    '*.cs', 1).ToArray()) {
                $files.Add($typeFile)
            }
        }
    }

    $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
    $changedFiles = [System.Collections.Generic.List[string]]::new()
    $blockScopedFiles = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $files) {
        # The namespace is the full name of the module whose types/ folder holds the file (<module>/types/<file>.cs); the folder drops it.
        $module = Get-ModuleFullName ([System.IO.Path]::GetDirectoryName([System.IO.Path]::GetDirectoryName($file)))

        $original = [System.IO.File]::ReadAllText($file)
        # A block-scoped namespace is no shape this repo authors, so it is reported for a hand edit.
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
