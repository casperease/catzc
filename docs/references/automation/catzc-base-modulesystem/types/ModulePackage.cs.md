---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/ModulePackage.cs.md
    kind: comment-page
    body_sha: "78764f7fbacf"
---

# automation/Catzc.Base.ModuleSystem/types/ModulePackage.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
A named group of repository-root-relative file artifacts a DiskModule owns beyond its own folder, declared
in configs/files.yml. The unit Copy-Automation excludes by name (-ExcludePackages); package names are
globally unique across modules.
```
