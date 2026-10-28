function Remove-Generated {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string[]])]
    param(
        [string] $RepositoryRoot = (Get-RepositoryRoot)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $targets = @(Get-GeneratedTarget | Where-Object { $_.class -ceq 'rollable' })
    $files = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    $inputDepth = [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::InputDepth
    $pruned = [Catzc.Base.Folders.PathSet]::Pruned((Get-Config -Config folder-walk))
    foreach ($target in $targets) {
        if ($target.path.IndexOfAny([char[]] '*?[') -lt 0) {
            if ([System.IO.File]::Exists([System.IO.Path]::Combine($root, $target.path))) {
                [void] $files.Add($target.path)
            }
            continue
        }
        $prefix = [Catzc.Base.Objects.GlobPattern]::new($target.path).LiteralPrefix
        $rest = $target.path.Substring($prefix.Length).Split('/')
        $depth = if ($rest -contains '**') {
            $inputDepth
        }
        else {
            $rest.Count
        }
        $folder = [System.IO.Path]::Combine($root, $prefix)
        if (-not [System.IO.Directory]::Exists($folder)) {
            continue
        }
        $found = [Catzc.Base.Folders.FolderWalker]::WalkRelative($folder, $depth, $pruned, $root)
        foreach ($file in [Catzc.Base.Objects.GlobPattern]::MatchingPaths([string[]] @($target.path), [string[]] @($found[0]))) {
            [void] $files.Add($file)
        }
    }
    foreach ($file in $files) {
        if ($PSCmdlet.ShouldProcess($file, 'Remove generated file')) {
            [System.IO.File]::Delete([System.IO.Path]::Combine($root, $file))
            $file
        }
    }
}
