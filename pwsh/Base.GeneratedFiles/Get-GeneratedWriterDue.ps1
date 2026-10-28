function Get-GeneratedWriterDue {
    [CmdletBinding()]
    [OutputType([Catzc.Base.GeneratedFiles.GeneratedWriterDue])]
    param(
        [string[]] $Name,

        [string[]] $ChangedPath,

        [string] $RepositoryRoot = (Get-RepositoryRoot),

        [string] $MemoPath = (Join-Path (Get-OutputRoot) 'cache/generated-writers.json')
    )

    # A dirty tree is not a stale output: only a missing output or a changed input stamp makes a writer due.
    $writers = @(Get-GeneratedWriterOrder | Where-Object { -not $Name -or $_.name -in $Name })
    $memo = Get-GeneratedWriterMemo -MemoPath $MemoPath
    $walk = Get-GeneratedWriterInputFile -InputGlob @($writers | ForEach-Object { [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::Inputs($_) }) -RepositoryRoot $RepositoryRoot
    $stamps = Get-GeneratedWriterStamp -Writer @($writers | Where-Object { [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::Inputs($_).Count -gt 0 }) -Walk $walk -RepositoryRoot $RepositoryRoot
    $changed = $null
    foreach ($writer in $writers) {
        $inputs = [Catzc.Base.GeneratedFiles.GeneratedWriterGraph]::Inputs($writer)
        $outputs = @($writer.outputs | ForEach-Object path)
        $hasLists = ($inputs.Count + $outputs.Count) -gt 0
        if (-not $hasLists) {
            if ($null -eq $changed) {
                $changed = [string[]] @(if ($PSBoundParameters.ContainsKey('ChangedPath')) {
                        $ChangedPath
                    }
                    else {
                        Get-GitChangedPath
                    })
            }
            [Catzc.Base.GeneratedFiles.GeneratedWriterDue]::new($writer.name, $changed.Count -gt 0, $hasLists)
            continue
        }
        $due = $false
        foreach ($output in $outputs) {
            if ($output.IndexOfAny([char[]] '*?[') -lt 0 -and
                -not [System.IO.File]::Exists((Join-Path $RepositoryRoot $output))) {
                $due = $true
                break
            }
        }
        if (-not $due) {
            $due = $memo[$writer.name] -cne $stamps[$writer.name]
        }
        [Catzc.Base.GeneratedFiles.GeneratedWriterDue]::new($writer.name, $due, $hasLists)
    }
}
