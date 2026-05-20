<#
.SYNOPSIS
    Deletes the contents of the user's temp folder(s).
.DESCRIPTION
    Removes every top-level entry from each temp folder, best-effort: a file or directory still in use by
    a running process is locked, so it is skipped (never an error). A bloated temp folder (tens of
    thousands of leftover entries) slows NTFS file/directory creation noticeably — new dirs cost more as
    the directory index and 8.3 short-name generation churn — so periodic clearing keeps temp-heavy work
    (builds, test sandboxes) fast.

    Idempotent and safe to re-run. The temp folders themselves are kept; only their contents are removed.
    Returns a summary object (Removed / Skipped / Folders).
.PARAMETER Path
    The temp folder(s) to clear. Defaults to the current user's temp location(s) (`$env:TEMP`, `$env:TMP`,
    and `[IO.Path]::GetTempPath()`, de-duplicated). Pass an explicit path to target a specific folder.
.EXAMPLE
    Clear-TempFolders
    Clears the current user's temp folder(s).
.EXAMPLE
    Clear-TempFolders -DryRun
    Reports what would be removed (in the returned summary's Removed count) without deleting anything.
.PARAMETER DryRun
    Report what would be removed without deleting anything. The returned summary's Removed count is the
    number of top-level entries that would be deleted; nothing is touched. See
    docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
#>
function Clear-TempFolders {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string[]] $Path = @($env:TEMP, $env:TMP, [System.IO.Path]::GetTempPath()),

        [switch] $DryRun
    )

    $folders = $Path |
        Where-Object { $_ } |
        ForEach-Object { $_.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) } |
        Select-Object -Unique

    $totalRemoved = 0
    $totalSkipped = 0
    foreach ($folder in $folders) {
        if (-not [System.IO.Directory]::Exists($folder)) {
            Write-Verbose "Temp folder not found, skipping: $folder"
            continue
        }

        # Delete via .NET, NOT Remove-Item: across tens of thousands of temp entries Remove-Item's
        # per-item cmdlet overhead dominates (minutes vs seconds). Top-level entries only — Directory.Delete
        # recurses each subtree. A file or directory held open by a running process throws and is skipped.
        # In dry-run, count every top-level entry as a would-remove and delete nothing (a lock can only be
        # observed by attempting the delete, so dry-run reports the intent, not the lock outcome).
        $removed = 0
        $skipped = 0
        foreach ($file in [System.IO.Directory]::GetFiles($folder)) {
            if ($DryRun) {
                $removed++; continue
            }
            try {
                [System.IO.File]::Delete($file); $removed++
            }
            catch {
                $skipped++; Write-Verbose "Skipped (in use): $file"
            }
        }
        foreach ($dir in [System.IO.Directory]::GetDirectories($folder)) {
            if ($DryRun) {
                $removed++; continue
            }
            try {
                [System.IO.Directory]::Delete($dir, $true); $removed++
            }
            catch {
                $skipped++; Write-Verbose "Skipped (in use): $dir"
            }
        }

        $verb = if ($DryRun) {
            'Would clear'
        }
        else {
            'Cleared'
        }
        Write-Message "$verb temp '$folder' — removed $removed, skipped $skipped (in use)"
        $totalRemoved += $removed
        $totalSkipped += $skipped
    }

    [pscustomobject]@{
        Removed = $totalRemoved
        Skipped = $totalSkipped
        Folders = @($folders)
    }
}
