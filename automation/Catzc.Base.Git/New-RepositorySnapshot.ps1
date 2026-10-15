<#
.SYNOPSIS
    Creates a verified, isolated snapshot of a repository's working tree as it is right now.
.DESCRIPTION
    Builds a throwaway copy of the source repository that is byte-identical to its working tree: HEAD plus every...
    [ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)
    [comment:1](/docs/references/automation/catzc-base-git/New-RepositorySnapshot.ps1.md#comment1)
.PARAMETER SourceRoot
    The repository to snapshot. Defaults to the repository root (Get-RepositoryRoot).
.PARAMETER Destination
    The folder to create the snapshot in; it must not exist yet.
    [comment:2](/docs/references/automation/catzc-base-git/New-RepositorySnapshot.ps1.md#comment2)
.PARAMETER Attempts
    How many times to build the snapshot when verification finds it differs from its source. Default 3.
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

        [string] $Destination = (Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-snapshot-' + [guid]::NewGuid().ToString('N'))),

        [ValidateRange(1, 10)]
        [int] $Attempts = 3
    )

    Assert-Command git
    $SourceRoot = [System.IO.Path]::GetFullPath($SourceRoot).TrimEnd('\', '/')
    Assert-PathExist (Join-Path $SourceRoot '.git')
    $Destination = [System.IO.Path]::GetFullPath($Destination).TrimEnd('\', '/')
    if (Test-Path -LiteralPath $Destination) {
        throw "Cannot create a repository snapshot at '$Destination': the folder already exists."
    }

    # The source's git directory, read in-process: a plain checkout's .git, or a linked worktree's gitdir.
    $sourceGitDirectory = [Catzc.Base.Git.GitRefs]::GitDirectory($SourceRoot)

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    for ($attempt = 1; ; $attempt++) {
        $commit = [Catzc.Base.Git.GitRefs]::ResolveCommit($sourceGitDirectory, 'HEAD')
        $mismatch = $null

        # A half-built snapshot is never left behind: every failure below removes it, then lets the error propagate.
        try {
            Invoke-Executable "git clone --quiet --shared --no-checkout `"$SourceRoot`" `"$Destination`"" -PassThru -Silent | Out-Null

            # The provenance marker goes in first, so the cleanup below (and any later Remove-RepositorySnapshot)...
            # [comment:3](/docs/references/automation/catzc-base-git/New-RepositorySnapshot.ps1.md#comment3)
            $marker = [ordered]@{
                sourceRoot = $SourceRoot
                commit     = $commit
                createdAt  = [DateTimeOffset]::UtcNow.ToString('o')
                pid        = $PID
            }
            [System.IO.File]::WriteAllText((Join-Path $Destination '.git/catzc-snapshot.json'),
                (ConvertTo-Json -InputObject $marker), [System.Text.UTF8Encoding]::new($false))

            $sourceIndex = [Catzc.Base.Git.GitRefs]::IndexPath($sourceGitDirectory)
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

            # The gate: the snapshot's status must equal the source's.
            # [comment:4](/docs/references/automation/catzc-base-git/New-RepositorySnapshot.ps1.md#comment4)
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
                $mismatch = [pscustomobject]@{ Count = $differences.Count; Sample = $sample }
            }

            # Status counts relative to HEAD: '1'/'2'/'u' lines are changed entries (deleted when either side of the...
            # [comment:5](/docs/references/automation/catzc-base-git/New-RepositorySnapshot.ps1.md#comment5)
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
        if (-not $mismatch) {
            break
        }
        Remove-RepositorySnapshot -Path $Destination
        if ($attempt -ge $Attempts) {
            throw ("The snapshot of '$SourceRoot' does not match its source ($($mismatch.Count) differing status line(s))" +
                " after $Attempts attempt(s) — is a file changing continuously, or is there a nested repository?`n$($mismatch.Sample)")
        }
        Write-Message ("The source changed while the snapshot was copied ($($mismatch.Count) differing status line(s));" +
            " rebuilding it (attempt $($attempt + 1) of $Attempts).") -ForegroundColor Yellow
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
