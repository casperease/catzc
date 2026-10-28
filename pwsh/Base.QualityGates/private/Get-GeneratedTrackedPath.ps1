function Get-GeneratedTrackedPath {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedTarget])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    # A path is generated when a writer row's output takes it, never because it holds a head; the first target that takes it names its writer.
    $claimed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    $paths = [string[]] @($Path | ForEach-Object { $_ -replace '\\', '/' })
    if ($paths.Count -eq 0) {
        return
    }
    foreach ($target in @(Get-GeneratedTarget)) {
        foreach ($file in [Catzc.Base.Objects.GlobPattern]::MatchingPaths([string[]] @($target.path), $paths)) {
            if ($claimed.Add($file)) {
                [Catzc.Base.Variants.GeneratedTarget]::new($file, $target.generator, $target.class)
            }
        }
    }
}
