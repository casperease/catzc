function Get-BuildSourceStamp {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $Selection
    )

    $tokens = [System.Collections.Generic.SortedDictionary[string, string]]::new([System.StringComparer]::Ordinal)
    $isCounted = {
        param([string] $Path)
        -not ($Path.StartsWith('docs/', [System.StringComparison]::Ordinal) -or
            $Path.StartsWith('.claude/', [System.StringComparison]::Ordinal) -or
            $Path.StartsWith('.unordered/', [System.StringComparison]::Ordinal) -or
            "/$Path".Contains('/tests/'))
    }

    $tracked = Invoke-Executable 'git --no-optional-locks -c core.quotepath=off ls-files -s' -WorkingDirectory $RepositoryRoot -PassThru -Silent -NoAssert
    if ($tracked.ExitCode -ne 0) {
        throw "Invoke-ModuleBuild: a build is stamped from the files git lists, but git cannot list them under '$RepositoryRoot' ($($tracked.Errors))."
    }
    foreach ($line in ([string] $tracked.Output).Split("`n")) {
        $tab = $line.IndexOf("`t")
        if ($tab -lt 0) {
            continue
        }
        $path = $line.Substring($tab + 1).TrimEnd("`r")
        if (& $isCounted $path) {
            $tokens[$path] = $line.Substring(0, $tab).Split(' ')[1]
        }
    }

    # A modified or deleted tracked file and an untracked one carry their working content, not the index entry.
    $changed = Invoke-Executable 'git --no-optional-locks -c core.quotepath=off ls-files -m' -WorkingDirectory $RepositoryRoot -PassThru -Silent -NoAssert
    $untracked = Invoke-Executable 'git --no-optional-locks -c core.quotepath=off ls-files --others --exclude-standard' -WorkingDirectory $RepositoryRoot -PassThru -Silent -NoAssert
    $working = [System.Collections.Generic.List[string]]::new()
    foreach ($listing in @($changed, $untracked)) {
        foreach ($line in ([string] $listing.Output).Split("`n")) {
            $path = $line.TrimEnd("`r")
            if (-not $path -or -not (& $isCounted $path)) {
                continue
            }
            if ([System.IO.File]::Exists([System.IO.Path]::Combine($RepositoryRoot, $path))) {
                $working.Add($path)
            }
            else {
                $tokens[$path] = 'absent'
            }
        }
    }
    # The same object id git stores, so a file edited and put back stamps as the committed one.
    for ($start = 0; $start -lt $working.Count; $start += 100) {
        $chunk = $working.GetRange($start, [System.Math]::Min(100, $working.Count - $start))
        $hashed = Invoke-Executable "git --no-optional-locks hash-object -- $(($chunk | ForEach-Object { '"' + $_ + '"' }) -join ' ')" -WorkingDirectory $RepositoryRoot -PassThru -Silent
        $ids = @(([string] $hashed.Output).Split("`n") | ForEach-Object { $_.Trim() } | Where-Object { $_ })
        for ($position = 0; $position -lt $chunk.Count; $position++) {
            $tokens[$chunk[$position]] = $ids[$position]
        }
    }

    $builder = [System.Text.StringBuilder]::new()
    [void] $builder.Append($Selection).Append("`n")
    foreach ($entry in $tokens.GetEnumerator()) {
        [void] $builder.Append($entry.Key).Append('|').Append($entry.Value).Append("`n")
    }
    [Catzc.Base.Globs.DurableHash]::HashFold($builder.ToString())
}
