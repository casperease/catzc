---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/ProfilesConfig.cs.md
    kind: comment-page
    body_sha: "2741cc263f90"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The named module sets of configs/profiles.yml, for Copy-Automation -ModuleProfile, Test-InIsolation and the
exporter: each profile is a SEED list of module names that Get-ModuleProfile expands to its declared-dependency
closure plus the fixed infrastructure; an EMPTY seed means the full repository. Constructing an instance MAPS
and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.ModuleSystem.ProfilesConfig), so
Get-Config -Config profiles returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Load-time rules:
  - only the top-level key 'profiles', a required, non-empty map;
  - each profile name is snake_case;
  - each profile is a list (possibly empty) of non-empty module names — never a single string or a map.
Module-name existence is not checked here: it is Get-ModuleProfile's concern.
```
