---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md
    kind: comment-page
    body_sha: "487b8fd1b3ed"
    adrs:
      - ADR-REPO-FOLDERS#4
---

# automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `foreach ($path in ([System.IO.Directory]::EnumerateFiles($moduleDirectory,...`.

```text
Module-root .ps1: a test is misplaced; the rest are public functions whose file basename is the exported
name (one function per file), tracked for the cross-module duplicate-export check.
```

## comment:5

Above `if ($name -match '^\.') {`.

```text
Dot-prefixed entries are tooling (a schema sidecar, an editor dotfile), not module config
([ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4)).
```
