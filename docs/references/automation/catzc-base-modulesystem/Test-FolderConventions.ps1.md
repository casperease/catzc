---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Test-FolderConventions.ps1.md
    kind: comment-page
    body_sha: "139574debb47"
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-FOLDERS#4
---

# automation/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the module
folders of <RepositoryRoot>/automation (dot-prefixed folders are infrastructure, not modules). It scans the tree
once with [System.IO] and collects every issue
([ADR-REPO-FOLDERS](/docs/adr/repository/conventional-folders.md)):

  - every module subdirectory is a conventional folder: private, tests, assets, types, configs;
  - no test file (*.Tests.ps1) sits at the module root or in private/ — tests belong in tests/;
  - no public function (a module-root .ps1, named for its function) is exported by more than one module — the
    last-loaded module would win silently;
  - configs/ is flat and holds only kebab-case .yml files (dot-prefixed entries are tooling and are skipped);
  - no module keeps internal config in assets/config/ (it belongs in configs/) or test fixtures in assets/test/
    (they belong in tests/assets/).

The folder convention is the module system's own contract (folder = module, location = visibility), so the
gate lives with the module system rather than in .internal, which is the loader and not a module.
```

## comment:2

Above `foreach ($path in ([System.IO.Directory]::EnumerateFiles($moduleDirectory,...`.

```text
Module-root .ps1: a test is misplaced; the rest are public functions whose file basename is the exported
name (one function per file), tracked for the cross-module duplicate-export check.
```

## comment:3

Above `if ($name -match '^\.') {`.

```text
Dot-prefixed entries are tooling (a schema sidecar, an editor dotfile), not module config
([ADR-REPO-FOLDERS#4](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders4)).
```
