---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/configs/files.yml.md
    folder: docs/references/automation/catzc-base-modulesystem/configs
    name: files-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d0d37274d764
---

# automation/Catzc.Base.ModuleSystem/configs/files.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `modules:`, written with `#`.

```text
files.yml — module -> packages, for Copy-Automation (Catzc.Base.ModuleSystem).

Each automation module may declare packages. A package is a named group of repository-root-relative file
artifacts the module owns beyond its own folder. Copy-Automation copies a selected module's folder plus its
packages, minus any named in -ExcludePackages; package names are globally unique (the exclude unit). Only
modules that own extra artifacts appear here. Paths are repository-root-relative and forward-slashed.

Loaded via Get-Config -Config files; mapped and validated by the FilesConfig type (a 'modules' map whose
entries have a non-empty 'packages' map; snake_case, globally-unique package names; non-empty path lists).
```
