function Get-GeneratedWriterDue {
    [CmdletBinding()]
    [OutputType([Catzc.Base.GeneratedFiles.GeneratedWriterDue])]
    param(
        [string[]] $Name,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $MemoPath = (Join-Path (Get-OutputRoot) 'cache/generated-writers.json')
    )

    # A dirty tree is not a stale output: only a missing output or a changed input stamp makes a writer due.
    $order = @(Get-GeneratedWriterOrder)
    $writers = @($order | Where-Object { -not $Name -or $_.name -in $Name })
    $memo = Get-GeneratedWriterMemo -MemoPath $MemoPath
    $walk = Get-GeneratedWriterInputFile -InputGlob @($writers | ForEach-Object { [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::Inputs($_) }) -RepositoryRoot $RepositoryRoot
    $stamps = Get-GeneratedWriterStamp -Writer @($writers | Where-Object { [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::Inputs($_).Count -gt 0 }) -Walk $walk -RepositoryRoot $RepositoryRoot
    # A wildcard output is missing when the index tracks a path under it that is gone from disk, read once for every writer.
    $wildcards = [string[]] @($writers | ForEach-Object { $_.outputs | ForEach-Object path } | Where-Object { $_.IndexOfAny([char[]] '*?[') -ge 0 })
    $tracked = [string[]] @(if ($wildcards.Count -gt 0) {
            Get-GitTrackedPath -Path ([string[]] @($wildcards | ForEach-Object { [Catzc.Base.Objects.GlobPattern]::new($_).LiteralPrefix } | ForEach-Object { $_ ? $_ : '.' }))
        })
    foreach ($writer in $writers) {
        $due = $false
        foreach ($output in @($writer.outputs | ForEach-Object path)) {
            if ($output.IndexOfAny([char[]] '*?[') -lt 0) {
                $due = -not [System.IO.File]::Exists((Join-Path $RepositoryRoot $output))
            }
            else {
                $known = [Catzc.Base.Objects.GlobPattern]::MatchingPaths([string[]] @($output), $tracked)
                $gone = [string[]] @($known | Where-Object { -not [System.IO.File]::Exists((Join-Path $RepositoryRoot $_)) })
                # A tracked path another writer's narrower glob claims is that writer's to render.
                $due = $gone.Count -gt 0 -and @(Get-GeneratedWriterOutputPath -Writer $writer -Writers $order -Path $gone).Count -gt 0
                # A rollable glob with nothing left on disk was rolled off whole, even when the index no longer lists it.
                if (-not $due -and $writer.class -ceq 'rollable' -and $known.Count -eq $gone.Count) {
                    $found = (Get-GeneratedWriterInputFile -InputGlob @($output) -RepositoryRoot $RepositoryRoot).File
                    $due = [Catzc.Base.Objects.GlobPattern]::MatchingPaths([string[]] @($output), [string[]] @($found)).Count -eq 0
                }
            }
            if ($due) {
                break
            }
        }
        if (-not $due) {
            $due = $memo[$writer.name] -cne $stamps[$writer.name]
        }
        [Catzc.Base.GeneratedFiles.GeneratedWriterDue]::new($writer.name, $due)
    }
}
