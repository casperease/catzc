---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Clear-TempFolders.ps1.md
    kind: comment-page
    body_sha: "3f487a9ec475"
---

# automation/Catzc.Tooling.Provisioning/Clear-TempFolders.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Removes every top-level entry from each temp folder, best-effort: a file or directory still in use by
a running process is locked, so it is skipped (never an error). A bloated temp folder (tens of
thousands of leftover entries) slows NTFS file/directory creation noticeably — new dirs cost more as
the directory index and 8.3 short-name generation churn — so periodic clearing keeps temp-heavy work
(builds, test sandboxes) fast.

Idempotent and safe to re-run. The temp folders themselves are kept; only their contents are removed.
Returns a summary object (Removed / Skipped / Folders).
```

## comment:2

Section `.PARAMETER Path` of the comment-based help.

```text
The temp folder(s) to clear. Defaults to the current user's temp location(s) (`$env:TEMP`, `$env:TMP`,
and `[IO.Path]::GetTempPath()`, de-duplicated). Pass an explicit path to target a specific folder.
```

## comment:3

Section `.PARAMETER DryRun` of the comment-based help.

```text
Report what would be removed without deleting anything. The returned summary's Removed count is the
number of top-level entries that would be deleted; nothing is touched. See
[ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
```

## comment:4

Above `$removed = 0`.

```text
Delete via .NET, NOT Remove-Item: across tens of thousands of temp entries Remove-Item's
per-item cmdlet overhead dominates (minutes vs seconds). Top-level entries only — Directory.Delete
recurses each subtree. A file or directory held open by a running process throws and is skipped.
In dry-run, count every top-level entry as a would-remove and delete nothing (a lock can only be
observed by attempting the delete, so dry-run reports the intent, not the lock outcome).
```

## comment:5

Above `$removed = 0`.

```text
Delete via .NET, NOT Remove-Item: across tens of thousands of temp entries Remove-Item's
per-item cmdlet overhead dominates (minutes vs seconds). Top-level entries only — Directory.Delete
recurses each subtree. A file or directory held open by a running process throws and is skipped.
In dry-run, count every top-level entry as a would-remove and delete nothing (a lock can only be
observed by attempting the delete, so dry-run reports the intent, not the lock outcome).
```
