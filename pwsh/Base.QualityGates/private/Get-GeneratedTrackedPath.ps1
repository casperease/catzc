function Get-GeneratedTrackedPath {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Variants.GeneratedTarget])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $Path
    )

    # A path is generated when a writer row's output takes it, never because it holds a head; the most literal glob names its writer.
    $paths = [string[]] @($Path | ForEach-Object { $_ -replace '\\', '/' })
    if ($paths.Count -eq 0) {
        return
    }
    $globsOf = [ordered]@{}
    $classOf = @{}
    foreach ($target in @(Get-GeneratedTarget)) {
        if (-not $globsOf.Contains($target.generator)) {
            $globsOf[$target.generator] = [System.Collections.Generic.List[string]]::new()
            $classOf[$target.generator] = $target.class
        }
        $globsOf[$target.generator].Add($target.path)
    }
    # Each writer's targets compete as one row under the writer registry's claim rule; a tie goes to the first row.
    $rows = @(foreach ($name in $globsOf.Keys) {
            [Catzc.Base.Variants.GeneratedWriterRow]::new($name, [ordered]@{ class = $classOf[$name]; outputs = $globsOf[$name].ToArray() })
        })
    $claimed = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($row in $rows) {
        $mine = [Catzc.Base.Objects.GlobPattern]::MatchingPaths([string[]] @($row.outputs | ForEach-Object path), $paths)
        if ($mine.Count -eq 0) {
            continue
        }
        $owned = Get-GeneratedWriterOutputPath -Writer $row -Writers $rows -Path $mine
        foreach ($file in @($owned)) {
            if ($claimed.Add($file)) {
                [Catzc.Base.Variants.GeneratedTarget]::new($file, $row.name, $row.class)
            }
        }
    }
}
