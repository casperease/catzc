# pwsh/Base.ModuleSystem/types/ProfilesConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The named module sets of configs/profiles.yml, for Copy-CatzcModule -ModuleProfile, Test-InIsolation and the
exporter: each profile is a SEED list of module names that Get-ModuleProfile expands to its declared-dependency
closure plus the fixed infrastructure; an EMPTY seed means the full repository. Constructing an instance MAPS
and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.ModuleSystem.ProfilesConfig), so
Get-Config -Config profiles returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

Load-time rules:
  - only the top-level key 'profiles', a required, non-empty map;
  - each profile name is snake_case;
  - each profile is a list (possibly empty) of non-empty module names — never a single string or a map.
Module-name existence is not checked here: it is Get-ModuleProfile's concern.
```
