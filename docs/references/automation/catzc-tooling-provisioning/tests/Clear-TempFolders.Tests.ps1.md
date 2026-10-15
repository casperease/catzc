---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Clear-TempFolders.Tests.ps1.md
    kind: test-asset
    body_sha: "9cf1c2e39a24"
---

# automation/Catzc.Tooling.Provisioning/tests/Clear-TempFolders.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `if (-not $IsWindows) {`.

```text
FileShare.None is a MANDATORY lock only on Windows; on Unix it is advisory and does not block
delete, so the "locked" file would be removed and this case cannot be set up.
```

## comment:2

Above `$result = Clear-TempFolders -Path @($folder, $folder, ($folder +...`.

```text
The third entry is the same folder with a trailing separator (dedup must canonicalize it away). Use
the platform separator — a hardcoded '\' is a literal filename char on Unix, i.e. a DIFFERENT path.
```
