function Get-GeneratedWriterInputFile {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [AllowEmptyCollection()]
        [string[]] $InputGlob,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    # Only a glob with no literal folder walks the root, so a narrow writer pays only for the folders its own globs reach.
    $files = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $folders = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $walks = @{}
    $inputDepth = [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::InputDepth
    foreach ($glob in @($InputGlob | Where-Object { $_ })) {
        if ($glob.IndexOfAny([char[]] '*?[') -lt 0) {
            if ([System.IO.File]::Exists((Join-Path $RepositoryRoot $glob))) {
                [void] $files.Add($glob)
            }
            continue
        }
        $prefix = [Catzc.Base.Objects.GlobPattern]::new($glob).LiteralPrefix
        $rest = $glob.Substring($prefix.Length).Split('/')
        $depth = if ($rest -contains '**') {
            $inputDepth
        }
        else {
            $rest.Count
        }
        if (-not $walks.ContainsKey($prefix) -or $walks[$prefix] -lt $depth) {
            $walks[$prefix] = $depth
        }
    }
    $levels = { param([string] $Prefix) $Prefix.Split('/', [System.StringSplitOptions]::RemoveEmptyEntries).Count }
    # One walk per folder lists its files and folders apart, already relative to the root, so nothing is cut per path here.
    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $pruned = [Catzc.Base.Folders.PathSet]::Pruned((Get-Config -Config folder-walk))
    foreach ($prefix in @($walks.Keys | Sort-Object { & $levels $_ })) {
        $covered = @($walks.Keys | Where-Object {
                $_ -ne $prefix -and $prefix.StartsWith($_, [System.StringComparison]::Ordinal) -and
                ((& $levels $prefix) - (& $levels $_) + $walks[$prefix]) -le $walks[$_]
            }).Count -gt 0
        $folder = [System.IO.Path]::Combine($root, $prefix)
        if ($covered -or -not [System.IO.Directory]::Exists($folder)) {
            continue
        }
        $found = [Catzc.Base.Folders.FolderWalker]::WalkRelative($folder, $walks[$prefix], $pruned, $root)
        $files.UnionWith($found[0])
        $folders.UnionWith($found[1])
    }
    [pscustomobject]@{
        File   = [string[]] @($files)
        Folder = [string[]] @($folders)
    }
}
