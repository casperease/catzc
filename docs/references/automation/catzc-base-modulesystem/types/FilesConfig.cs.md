---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/FilesConfig.cs.md
    kind: comment-page
    body_sha: "7e9c2c7f565b"
    adrs:
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Base.ModuleSystem/types/FilesConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The module -> packages bindings of configs/files.yml, for Copy-Automation: per module, the named packages of
repository-root-relative file artifacts it owns beyond its own folder. Constructing an instance MAPS and
VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.ModuleSystem.FilesConfig), so
Get-Config -Config files returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Load-time rules:
  - only the top-level key 'modules', a required, non-empty map;
  - every module entry is well-formed (ModuleFiles);
  - each package name is globally unique across all modules (it is the -ExcludePackages unit).
Module keys are module folder names ('Catzc.Base.Repository', '.internal'), so they are not snake_case-checked.
```
