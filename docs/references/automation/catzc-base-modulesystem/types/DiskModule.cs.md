---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/DiskModule.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f1d34517b03b
---

# automation/Catzc.Base.ModuleSystem/types/DiskModule.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System.Collections.Generic;`, written with `//`.

```text
An on-disk automation module — a folder under automation/. Kind 'named' for a non-dot folder (Catzc.*),
'hidden' for a dot-prefixed infrastructure folder (.internal, .vendor, .compiled, .scriptanalyzer). Carries
its repository-root-relative folder path and the named packages (extra file artifacts) it owns via
configs/files.yml. This is the facet Copy-Automation copies.
```
