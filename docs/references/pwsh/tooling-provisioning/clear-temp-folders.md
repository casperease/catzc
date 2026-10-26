# pwsh/Tooling.Provisioning/Clear-TempFolders.ps1

The cleaner of the user's temp folders: it deletes their top-level entries, keeps the folders, and returns a summary of what it removed and
skipped.

## help

### synopsis

Deletes the contents of the user's temp folder(s).

### description

Removes every top-level entry from each temp folder, best-effort: a file or directory still in use by a running process is locked, so it is
skipped (never an error). A bloated temp folder (tens of thousands of leftover entries) slows NTFS file/directory creation noticeably — new
dirs cost more as the directory index and 8.3 short-name generation churn — so periodic clearing keeps temp-heavy work (builds, test
sandboxes) fast.

Idempotent and safe to re-run. The temp folders themselves are kept; only their contents are removed. Returns a summary object (Removed /
Skipped / Folders).

### parameter `Path`

The temp folder(s) to clear. Defaults to the current user's temp location(s) (`$env:TEMP`, `$env:TMP`, and `[IO.Path]::GetTempPath()`,
de-duplicated). Pass an explicit path to target a specific folder.

### parameter `DryRun`

Report what would be removed without deleting anything. The returned summary's Removed count is the number of top-level entries that would
be deleted; nothing is touched. See [ADR-AUTO-DRYRUN](../../../drs/automation/dry-run.md).

### example 1

```powershell
Clear-TempFolders
Clears the current user's temp folder(s).
```

### example 2

```powershell
Clear-TempFolders -DryRun
Reports what would be removed (in the returned summary's Removed count) without deleting anything.
```

## How it deletes

The deletion goes through .NET, not `Remove-Item`: across tens of thousands of temp entries the per-item cmdlet overhead dominates, minutes
against seconds. Only the top-level entries are walked, since `Directory.Delete` recurses each subtree. A file or directory held open by a
running process throws and is skipped.

## Dry run

A lock can only be observed by attempting the delete, so a dry run reports the intent, not the lock outcome: it counts every top-level entry
as a would-remove and deletes nothing.
