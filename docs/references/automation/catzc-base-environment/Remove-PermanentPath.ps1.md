---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Remove-PermanentPath.ps1.md
    kind: comment-page
    body_sha: "093109b98a65"
    adrs: []
---

# automation/Catzc.Base.Environment/Remove-PermanentPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Cross-platform PATH removal:
- Windows: removes from the User-scope registry PATH.
- Linux/macOS: removes the marked block from the PowerShell profile.
- Always: removes from $env:PATH for the current session.

Idempotent — no error if the path is not present.
```

## comment:2

Section `.PARAMETER Label` of the comment-based help.

```text
Identity marker for Unix profile blocks. Must match the label used
when Add-PermanentPath was called. Defaults to the leaf folder name.
```

## comment:3

Section `.PARAMETER Sync` of the comment-based help.

```text
After removing, call Sync-SessionPath to refresh the session PATH
from the registry (Windows only).
```

## comment:4

Above `if ($IsWindows) {`.

```text
--- Persistent PATH ---
Get-EnvironmentPath / Set-EnvironmentPath are the registry seam — kept thin so tests Mock them instead
of touching the real machine PATH. See their help.
```
