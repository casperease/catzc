---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Add-PermanentPath.ps1.md
    kind: comment-page
    body_sha: "3f12322f6ce7"
---

# automation/Catzc.Base.Environment/Add-PermanentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Cross-platform PATH persistence:
- Windows: writes to the User-scope registry PATH.
- Linux/macOS: appends a marked block to the PowerShell profile.
- Always: updates $env:PATH for the current session.

Idempotent — skips if the path is already present.
```

## comment:2

Section `.PARAMETER Label` of the comment-based help.

```text
Identity marker for Unix profile blocks. Defaults to the leaf folder name.
Must match when calling Remove-PermanentPath.
```

## comment:3

Section `.PARAMETER Sync` of the comment-based help.

```text
After adding, call Sync-SessionPath to merge any other new registry
entries into the current session (Windows only).
```

## comment:4

Above `if ($IsWindows) {`.

```text
--- Persistent PATH ---
Get-EnvironmentPath / Set-EnvironmentPath are the registry seam — kept thin so tests Mock them instead
of touching the real machine PATH. See their help.
```

## comment:5

Above `if ($IsWindows) {`.

```text
--- Persistent PATH ---
Get-EnvironmentPath / Set-EnvironmentPath are the registry seam — kept thin so tests Mock them instead
of touching the real machine PATH. See their help.
```
