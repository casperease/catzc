function Get-DocChange {
    <#
    .SYNOPSIS
        Lists the files of the watched folder whose bytes on disk differ from the session's seen copy, or from its baseline.

    .DESCRIPTION
        Compares the watched folder on disk with a session's index (seen.json or baseline.json). A file whose length and last-write time
        match its entry is unchanged without being read; any other file is hashed, and an equal hash is unchanged too, so a save of the
        same bytes is no change. Git state plays no part.

        Each change is one record: Path (repository-relative), Change (added, modified, deleted, or renamed when a deleted and an added
        file share a hash), From (the old path of a rename), Kind (the file kind, Get-FileKind), Tier (listen.yml's tier of that kind),
        Source (who made the file's current bytes: agent, editor or unknown, from the write ledgers) and Agent (the agent's session id),
        Rules (the ADR codes the file cites, after the change, or before it for a deletion) and Diff (the unified diff against the copy).

    .PARAMETER Session
        The session folder. Default: the newest session.

    .PARAMETER Against
        Seen (default): the changes not yet noted. Baseline: the file's whole arc over the session.

    .PARAMETER Path
        Only these repository-relative paths.

    .OUTPUTS
        [pscustomobject] per change, in ordinal path order.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $Session,

        [ValidateSet('Seen', 'Baseline')]
        [string] $Against = 'Seen',

        [string[]] $Path
    )

    $Session = Resolve-ListenSession $Session
    $manifest = [System.IO.File]::ReadAllText((Join-Path $Session 'manifest.json')) | ConvertFrom-Json
    $watch = $manifest.watch
    $copy = Join-Path $Session $Against.ToLowerInvariant()
    $index = Read-ListenIndex (Join-Path $Session "$($Against.ToLowerInvariant()).json")
    $root = Get-RepositoryRoot
    $watched = [System.IO.Path]::GetFullPath((Join-Path $root $watch))

    $wanted = if ($Path) {
        [System.Collections.Generic.HashSet[string]]::new([string[]] @($Path | ForEach-Object { $_.Replace('\', '/') }), [System.StringComparer]::Ordinal)
    }
    else {
        $null
    }

    $live = @{}
    foreach ($file in Get-ChildPath $watched -File -Depth 64 -Exclude @() -PruneVendor $false) {
        $relative = "$watch/" + [System.IO.Path]::GetRelativePath($watched, $file).Replace('\', '/')
        if ($wanted -and -not $wanted.Contains($relative)) {
            continue
        }
        $live[$relative] = $file
    }

    $added = [ordered]@{}
    $modified = [System.Collections.Generic.List[string]]::new()
    foreach ($relative in $live.Keys) {
        $info = [System.IO.FileInfo]::new($live[$relative])
        $entry = $index[$relative]
        if ($null -eq $entry) {
            $added[$relative] = [Catzc.Base.Globs.DurableHash]::HashFile($info.FullName)
            continue
        }
        if ($info.Length -eq $entry.length -and $info.LastWriteTimeUtc.Ticks -eq $entry.ticks) {
            continue
        }
        if ([Catzc.Base.Globs.DurableHash]::HashFile($info.FullName) -ne $entry.hash) {
            $modified.Add($relative)
        }
    }

    $deleted = [System.Collections.Generic.List[string]]::new()
    foreach ($relative in $index.Keys) {
        if ($wanted -and -not $wanted.Contains($relative)) {
            continue
        }
        if (-not $live.ContainsKey($relative)) {
            $deleted.Add($relative)
        }
    }

    $copyOf = {
        param($relative)
        Join-Path $copy $relative.Substring($watch.Length + 1)
    }
    $changes = [System.Collections.Generic.List[object]]::new()
    $newChange = {
        param($relative, $change, $from, $before, $after)
        $tier = Get-ListenTier $relative
        $cited = if ($after -and [System.IO.File]::Exists($after)) {
            [System.IO.File]::ReadAllText($after)
        }
        else {
            [System.IO.File]::ReadAllText($before)
        }
        $writer = if ($after -and [System.IO.File]::Exists($after)) {
            $info = [System.IO.FileInfo]::new($after)
            Get-ListenSource $relative -Hash ([Catzc.Base.Globs.DurableHash]::HashFile($after)) -WrittenAt ([DateTimeOffset] $info.LastWriteTimeUtc)
        }
        else {
            Get-ListenSource $relative
        }
        [pscustomobject]@{
            Path   = $relative
            Change = $change
            From   = $from
            Kind   = $tier.Kind
            Tier   = $tier.Tier
            Source = $writer.source
            Agent  = $writer.agent
            Rules  = Get-ListenCitedRule $cited
            Diff   = Get-ListenDiff -Before $before -After $after
        }
    }

    # A deleted file whose hash an added file carries is a rename; each added file pairs with one deleted file at most.
    $renamedFrom = @{}
    foreach ($relative in $deleted) {
        foreach ($candidate in @($added.Keys)) {
            if (-not $renamedFrom.ContainsKey($candidate) -and $added[$candidate] -eq $index[$relative].hash) {
                $renamedFrom[$candidate] = $relative
                break
            }
        }
    }
    $renamedSources = [System.Collections.Generic.HashSet[string]]::new([string[]] @($renamedFrom.Values), [System.StringComparer]::Ordinal)

    foreach ($relative in $added.Keys) {
        if ($renamedFrom.ContainsKey($relative)) {
            $from = $renamedFrom[$relative]
            $changes.Add((& $newChange $relative 'renamed' $from (& $copyOf $from) $live[$relative]))
        }
        else {
            $changes.Add((& $newChange $relative 'added' $null '' $live[$relative]))
        }
    }
    foreach ($relative in $modified) {
        $changes.Add((& $newChange $relative 'modified' $null (& $copyOf $relative) $live[$relative]))
    }
    foreach ($relative in $deleted) {
        if (-not $renamedSources.Contains($relative)) {
            $changes.Add((& $newChange $relative 'deleted' $null (& $copyOf $relative) ''))
        }
    }

    $changes.Sort([Comparison[object]] { param($left, $right) [string]::CompareOrdinal($left.Path, $right.Path) })
    $changes
}
