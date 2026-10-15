---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Sync-SessionPath.ps1.md
    kind: comment-page
    body_sha: "6b2d1f216402"
    adrs:
      - ADR-AUTO-CONSOLE#11
---

# automation/Catzc.Base.Environment/Sync-SessionPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads Machine and User PATH from the Windows registry and rebuilds
$env:PATH. Registry entries form the base; session-only entries
(e.g. from Add-PermanentPath or a tool's install script) are kept
only if their directory still exists on disk.

This handles both directions:
- New entries added to the registry by an installer appear in the session.
- Entries removed from the registry by an uninstaller disappear from
  the session (even if the directory still exists on disk).

On Linux/macOS this function is a no-op — package managers update PATH
through profile scripts that take effect on next shell launch.
```

## comment:2

Above `$seen = [System.Collections.Generic.HashSet[string]]::new(`.

```text
Add any registry entries not yet in the session
@() so an empty $kept yields an empty array, not $null (HashSet's ctor rejects a null collection).
```

## comment:3

Above `$added = @($newPaths)`.

```text
Rewrite the session PATH only when an entry arrives or leaves, and say which
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)) — on a
clean devbox nothing changes, so the import stays quiet.
```

## comment:4

Above `$seen = [System.Collections.Generic.HashSet[string]]::new(`.

```text
Add any registry entries not yet in the session
@() so an empty $kept yields an empty array, not $null (HashSet's ctor rejects a null collection).
```

## comment:5

Above `$added = @($newPaths)`.

```text
Rewrite the session PATH only when an entry arrives or leaves, and say which
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)) — on a
clean devbox nothing changes, so the import stays quiet.
```
