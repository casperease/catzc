<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-git/New-RepositorySnapshot.ps1.md"
  header: "generated"
---
#>

function New-RepositorySnapshot {
    [Catzc.Base.Timeouts.TimeLimit(120)]
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $SourceRoot = (Get-RepositoryRoot),

        [string] $Destination = (Join-Path ([System.IO.Path]::GetTempPath()) ('catzc-snapshot-' + [guid]::NewGuid().ToString('N'))),

        [ValidateRange(1, 10)]
        [int] $Attempts = 3,

        [switch] $Committed
    )

    Assert-Command git
    $SourceRoot = [System.IO.Path]::GetFullPath($SourceRoot).TrimEnd('\', '/')
    Assert-PathExist ([Catzc.Base.Git.GitWorkTree]::GitFolder($SourceRoot))
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

            # The provenance marker goes in first, so a cleanup recognises even a half-built snapshot as one it may delete.
            $marker = [ordered]@{
                sourceRoot = $SourceRoot
                commit     = $commit
                createdAt  = [DateTimeOffset]::UtcNow.ToString('o')
                pid        = $PID
            }
            [System.IO.File]::WriteAllText([Catzc.Base.Git.GitWorkTree]::SnapshotMarker($Destination),
                (ConvertTo-Json -InputObject $marker), [System.Text.UTF8Encoding]::new($false))

            # The committed form checks the commit out in the snapshot itself, so nothing of the working tree reaches it to verify.
            if ($Committed) {
                $checkoutSeconds = Get-TimeoutSeconds -Command 'New-RepositorySnapshot'
                Invoke-Executable "git -C `"$Destination`" checkout --quiet --detach $commit" -PassThru -Silent -TimeoutSeconds $checkoutSeconds | Out-Null
                # Status counts against HEAD: '1', '2' and 'u' lines are changed entries, '?' lines untracked files.
                $modified = 0
                $deleted = 0
                $untracked = 0
                break
            }

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
            # A folder renamed only in case keeps its old case in the index, so each target takes its source folder's name on disk.
            $diskFolders = @{}
            foreach ($relativePath in $relativePaths) {
                $sourceFile = Join-Path $SourceRoot $relativePath
                # A tracked file deleted from the working tree stays deleted in the snapshot.
                if (-not [System.IO.File]::Exists($sourceFile)) {
                    continue
                }
                $listed = ''
                $onDisk = ''
                foreach ($segment in @($relativePath -split '/' | Select-Object -SkipLast 1)) {
                    $listed = "$listed/$segment"
                    if (-not $diskFolders.ContainsKey($listed)) {
                        # The bounded walker, one level, nothing pruned: a tracked file under .vendor or out keeps its folder's case too.
                        $found = @([Catzc.Base.Folders.FolderWalker]::Walk([System.IO.Path]::Join($SourceRoot, $onDisk),
                                1, [string[]] @($segment), $false, $true, [string[]] @()))
                        $diskFolders[$listed] = [System.IO.Path]::Join($onDisk,
                            [System.IO.Path]::GetFileName(($found.Count -eq 1) ? $found[0] : $segment))
                    }
                    $onDisk = $diskFolders[$listed]
                }
                $targetFile = [System.IO.Path]::Join($Destination, $onDisk,
                    [System.IO.Path]::GetFileName($relativePath))
                [System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($targetFile)) | Out-Null
                [System.IO.File]::Copy($sourceFile, $targetFile, $true)
            }

            # The snapshot's status must equal the source's; --no-optional-locks keeps the source's index untouched by the check.
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
            $failure = $_
            if ([Catzc.Base.Git.GitWorkTree]::IsSnapshot($Destination)) {
                try {
                    Remove-RepositorySnapshot -Path $Destination
                }
                catch {
                    Write-Message "The half-built snapshot '$Destination' was not removed: $($_.Exception.Message)" -ForegroundColor Yellow
                }
            }
            throw $failure
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
