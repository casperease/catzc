# docs/references/automation/catzc-base-modulesystem/types/DiskModule.cs.md

`automation/Catzc.Base.ModuleSystem/types/DiskModule.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System.Collections.Generic;`.

```text
An on-disk automation module — a folder under automation/. Kind 'named' for a non-dot folder (Catzc.*),
'hidden' for a dot-prefixed infrastructure folder (.internal, .vendor, .compiled, .scriptanalyzer). Carries
its repository-root-relative folder path and the named packages (extra file artifacts) it owns via
configs/files.yml. This is the facet Copy-Automation copies.
```
