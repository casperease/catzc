---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e924b6ed9eff
    adrs:
      - ADR-REPO-FOLDERS#4
---

# automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($path in ([System.IO.Directory]::EnumerateFiles($moduleDirectory,...`, written with `#`.

```text
Module-root .ps1: a test is misplaced; the rest are public functions whose file basename is the exported
name (one function per file), tracked for the cross-module duplicate-export check.
```

## comment:2

Above `if ($name -match '^\.') {`, written with `#`.

```text
Dot-prefixed entries are tooling (a schema sidecar, an editor dotfile), not module config
([ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4)).
```
