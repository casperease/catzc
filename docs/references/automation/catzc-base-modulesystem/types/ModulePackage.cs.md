---
catzc:
  immutable:
    with_body_sha: "9c4b35f39f0b"
    path: docs/references/automation/catzc-base-modulesystem/types/ModulePackage.cs.md
    folder: docs/references/automation/catzc-base-modulesystem/types
    name: module-package-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.ModuleSystem/types/ModulePackage.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A named group of repository-root-relative file artifacts a DiskModule owns beyond its own folder, declared
in configs/files.yml. The unit Copy-Automation excludes by name (-ExcludePackages); package names are
globally unique across modules.
```
