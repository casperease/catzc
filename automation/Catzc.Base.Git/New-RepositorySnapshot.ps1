<#
.SYNOPSIS
    Creates a verified, isolated snapshot of a repository's working tree as it is right now.
.DESCRIPTION
    Builds a throwaway copy of the source repository that is byte-identical to its working tree: HEAD plus
    every uncommitted change, staged and unstaged, plus every untracked file git does not ignore. Ignored
    content (out/, build caches, tool folders) is not copied, so the snapshot starts with a clean out/.

    The build uses git for the history and plain file copies for the content:

    1. `git clone --shared --no-checkout` — the snapshot borrows the source's object store through
       alternates, so no object is copied; staged blobs that exist only in the source's index are borrowed
       too.
    2. The source index is copied over the snapshot's, so staged-versus-unstaged state matches exactly.
    3. Every tracked and untracked-not-ignored file is copied from the source working tree, byte for byte.
       Copying the working-tree bytes (rather than `git checkout-index`) keeps the snapshot exact under
       line-ending conversion: a checkout re-applies core.autocrlf and can write different bytes than the
       working tree holds. A tracked file missing from the working tree is not copied — it stays deleted.
    4. Verification: `git status --porcelain=v2` in the snapshot must equal the source's, line for line. Any
       difference (a file edited during the copy, a nested repository, a split index) throws, and the
       half-built snapshot is removed — a run never proceeds on a snapshot that differs from its source.

    A marker file inside the snapshot's .git folder records its provenance; Remove-RepositorySnapshot refuses
    any folder without it. The snapshot is announced once it is ready (ADR-AUTO-CONSOLE:10).
.PARAMETER SourceRoot
    The repository to snapshot. Defaults to the repository root (Get-RepositoryRoot).
.PARAMETER Destination
    The folder to create the snapshot in; it must not exist yet. Defaults to a fresh
    <temp>/catzc-snapshot-<guid> folder.
.OUTPUTS
    [pscustomobject] with Path, SourceRoot, Commit, Modified, Untracked, Deleted (file counts relative to
    HEAD, from the verified status), and DurationSeconds.
.EXAMPLE
    $snapshot = New-RepositorySnapshot
    try {
        # ... work in $snapshot.Path ...
    }
    finally {
        Remove-RepositorySnapshot $snapshot.Path
    }
.EXAMPLE
    New-RepositorySnapshot -SourceRoot C:\projects\other -Destination C:\tmp\other-snapshot
#>
function New-RepositorySnapshot {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $SourceRoot = (Get-RepositoryRoot),

        [string] $Destination
    )

    Assert-Command git
    $SourceRoot = [System.IO.Path]::GetFullPath($SourceRoot).TrimEnd('\', '/')
    Assert-PathExist (Join-Path $SourceRoot '.git')
    if (-not $Destination) {
        $Destination = Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-snapshot-' + [guid]::NewGuid().ToString('N'))
    }
    $Destination = [System.IO.Path]::GetFullPath($Destination).TrimEnd('\', '/')
    if (Test-Path -LiteralPath $Destination) {
        throw "Cannot create a repository snapshot at '$Destination': the folder already exists."
    }

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $commit = (Invoke-Executable "git -C `"$SourceRoot`" rev-parse HEAD" -PassThru -Silent).Output.Trim()

    # A half-built snapshot is never left behind: every failure below removes it before rethrowing.
    try {
        Invoke-Executable "git clone --quiet --shared --no-checkout `"$SourceRoot`" `"$Destination`"" -PassThru -Silent | Out-Null

        # The provenance marker goes in first, so the cleanup below (and any later Remove-RepositorySnapshot)
        # recognises even a half-built snapshot as one it may delete.
        $marker = [ordered]@{
            sourceRoot = $SourceRoot
            commit     = $commit
            createdAt  = [DateTimeOffset]::UtcNow.ToString('o')
            pid        = $PID
        }
        [System.IO.File]::WriteAllText((Join-Path $Destination '.git/catzc-snapshot.json'),
            (ConvertTo-Json -InputObject $marker), [System.Text.UTF8Encoding]::new($false))

        # --git-path resolves the index of a linked worktree as well as of a plain checkout.
        $sourceIndex = (Invoke-Executable "git -C `"$SourceRoot`" rev-parse --path-format=absolute --git-path index" -PassThru -Silent).Output.Trim()
        [System.IO.File]::Copy($sourceIndex, (Join-Path $Destination '.git/index'), $true)

        $listing = Invoke-Executable "git -C `"$SourceRoot`" -c core.quotepath=off ls-files --cached --others --exclude-standard" -PassThru -Silent
        # --cached lists an unmerged path once per stage; copy it once.
        $relativePaths = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($line in ($listing.Output -split '\r?\n')) {
            if ($line) {
                [void]$relativePaths.Add($line)
            }
        }
        foreach ($relativePath in $relativePaths) {
            $sourceFile = Join-Path $SourceRoot $relativePath
            # A tracked file deleted from the working tree stays deleted in the snapshot.
            if (-not [System.IO.File]::Exists($sourceFile)) {
                continue
            }
            $targetFile = Join-Path $Destination $relativePath
            [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($targetFile)) | Out-Null
            [System.IO.File]::Copy($sourceFile, $targetFile, $true)
        }

        # The gate: the snapshot's status must equal the source's. --no-optional-locks keeps the source's index
        # untouched (a plain status may rewrite it, racing other git commands on the source).
        $statusCommand = 'git --no-optional-locks -C "{0}" -c core.quotepath=off status --porcelain=v2 --untracked-files=all'
        $sourceStatus = @((Invoke-Executable ($statusCommand -f $SourceRoot) -PassThru -Silent).Output -split '\r?\n' | Where-Object { $_ })
        $snapshotStatus = @((Invoke-Executable ($statusCommand -f $Destination) -PassThru -Silent).Output -split '\r?\n' | Where-Object { $_ })
        $differences = @(Compare-Object -ReferenceObject $sourceStatus -DifferenceObject $snapshotStatus -CaseSensitive)
        if ($differences.Count -gt 0) {
            $sample = @($differences | Select-Object -First 5 | ForEach-Object {
                    $side = if ($_.SideIndicator -eq '<=') {
                        'source only'
                    }
                    else {
                        'snapshot only'
                    }
                    "  [$side] $($_.InputObject)"
                }) -join "`n"
            throw ("The snapshot of '$SourceRoot' does not match its source ($($differences.Count) differing status line(s)) —" +
                " was a file changed while it was copied?`n$sample")
        }

        # Status counts relative to HEAD: '1'/'2'/'u' lines are changed entries (deleted when either side of
        # the XY code is D), '?' lines are untracked files.
        $modified = 0
        $deleted = 0
        $untracked = 0
        foreach ($line in $sourceStatus) {
            if ($line.StartsWith('? ')) {
                $untracked++
            }
            elseif ($line -match '^[12u] (\S\S) ') {
                if ($Matches[1].Contains('D')) {
                    $deleted++
                }
                else {
                    $modified++
                }
            }
        }
    }
    catch {
        if ([System.IO.File]::Exists((Join-Path $Destination '.git/catzc-snapshot.json'))) {
            Remove-RepositorySnapshot -Path $Destination
        }
        throw
    }
    $stopwatch.Stop()

    $shortCommit = $commit.Substring(0, [Math]::Min(7, $commit.Length))
    Write-Message ("Snapshot ready in {0:0.0} s: '{1}' @ {2} + {3} modified, {4} untracked, {5} deleted file(s) -> '{6}'" -f
        $stopwatch.Elapsed.TotalSeconds, $SourceRoot, $shortCommit, $modified, $untracked, $deleted, $Destination)

    [pscustomobject]@{
        Path            = $Destination
        SourceRoot      = $SourceRoot
        Commit          = $commit
        Modified        = $modified
        Untracked       = $untracked
        Deleted         = $deleted
        DurationSeconds = [Math]::Round($stopwatch.Elapsed.TotalSeconds, 2)
    }
}
