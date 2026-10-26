function Get-FormatScope {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [string[]] $Path,

        [string] $OutputRoot = (Get-OutputRoot)
    )

    $root = [System.IO.Path]::GetFullPath($RepositoryRoot)
    $output = [System.IO.Path]::GetFullPath($OutputRoot)
    $files = [System.Collections.Generic.List[string]]::new()
    if ($Path) {
        foreach ($item in $Path) {
            $full = [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $item).ProviderPath)
            if (Test-Path -LiteralPath $full -PathType Leaf) {
                $files.Add($full)
                continue
            }
            $underOutput = [System.IO.Path]::GetRelativePath($output, $full) -replace '\\', '/'
            if (-not ($underOutput -eq '..' -or $underOutput.StartsWith('../'))) {
                foreach ($file in @(Get-ChildPath $full -File)) {
                    $files.Add($file)
                }
                continue
            }
            $relative = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'
            Assert-False ($relative -eq '..' -or
                $relative.StartsWith('../')) -ErrorText "Get-FormatScope: the folder '$item' lies outside the repository '$root'; pass its files instead."
            foreach ($tracked in @(Get-GitTrackedPath $relative)) {
                $files.Add([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $tracked)))
            }
        }
    }
    else {
        foreach ($tracked in @(Get-GitTrackedPath '.')) {
            $files.Add([System.IO.Path]::GetFullPath([System.IO.Path]::Combine($root, $tracked)))
        }
    }

    # A loop over File.Exists, not a Test-Path pipeline: over the whole tree the pipeline alone took about 1.5 s more.
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $present = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $files) {
        if ([System.IO.File]::Exists($file) -and $seen.Add($file)) {
            $present.Add($file)
        }
    }
    $inside = @($present | Where-Object {
            $relative = [System.IO.Path]::GetRelativePath($root, $_)
            -not ($relative -eq '..' -or $relative.StartsWith('..' + [System.IO.Path]::DirectorySeparatorChar))
        })
    if ($inside.Count -eq 0) {
        return , [string[]] $present.ToArray()
    }
    $relativeOf = @{}
    foreach ($file in $inside) {
        $relativeOf[$file] = [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
    }
    $exemptClasses = 'linguist-vendored', 'catzc-contract', 'binary'
    $attributes = Get-GitAttributeValue -RepositoryRoot $root -Path @($relativeOf.Values) -Attribute $exemptClasses
    $kept = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $present) {
        $classes = if ($relativeOf.ContainsKey($file)) {
            $attributes[$relativeOf[$file]]
        }
        $exempt = $false
        if ($classes) {
            foreach ($class in $exemptClasses) {
                if ($classes[$class] -in 'set', 'true') {
                    $exempt = $true
                    break
                }
            }
        }
        if (-not $exempt) {
            $kept.Add($file)
        }
    }
    , [string[]] $kept.ToArray()
}
