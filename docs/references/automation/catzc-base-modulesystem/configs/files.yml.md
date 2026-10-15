---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/configs/files.yml.md
    kind: comment-page
    body_sha: e3b59c48e9b1
    adrs: []
---

# automation/Catzc.Base.ModuleSystem/configs/files.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `modules:`.

```text
files.yml — module -> packages, for Copy-Automation (Catzc.Base.ModuleSystem).

Each automation module may declare packages. A package is a named group of repository-root-relative file
artifacts the module owns beyond its own folder. Copy-Automation copies a selected module's folder plus its
packages, minus any named in -ExcludePackages; package names are globally unique (the exclude unit). Only
modules that own extra artifacts appear here. Paths are repository-root-relative and forward-slashed.

Loaded via Get-Config -Config files; mapped and validated by the FilesConfig type (a 'modules' map whose
entries have a non-empty 'packages' map; snake_case, globally-unique package names; non-empty path lists).
```
