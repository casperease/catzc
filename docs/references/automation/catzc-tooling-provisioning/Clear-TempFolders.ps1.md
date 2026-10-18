# automation/Catzc.Tooling.Provisioning/Clear-TempFolders.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

### parameter Path

The temp folder(s) to clear. Defaults to the current user's temp location(s) (`$env:TEMP`, `$env:TMP`, and `[IO.Path]::GetTempPath()`,
de-duplicated). Pass an explicit path to target a specific folder.

### parameter DryRun

Report what would be removed without deleting anything. The returned summary's Removed count is the number of top-level entries that would
be deleted; nothing is touched. See [ADR-AUTO-DRYRUN](../../../adr/automation/dry-run.md).

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

## comment:1

Above `$removed = 0`, written with `#`.

```text
Delete via .NET, NOT Remove-Item: across tens of thousands of temp entries Remove-Item's
per-item cmdlet overhead dominates (minutes vs seconds). Top-level entries only — Directory.Delete
recurses each subtree. A file or directory held open by a running process throws and is skipped.
In dry-run, count every top-level entry as a would-remove and delete nothing (a lock can only be
observed by attempting the delete, so dry-run reports the intent, not the lock outcome).
```
