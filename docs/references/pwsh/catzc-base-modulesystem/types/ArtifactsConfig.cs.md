# pwsh/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The publish targets of configs/artifacts.yml: the feeds a CI build promotes the versioned, immutable gold
module-manifest artifact to (the BVT's gold output,
[ADR-AUTO-TEST-BUILDVERIFICATIONTEST](/docs/adr/automation/test-automation.md#rule-adr-auto-test-buildverificationtest)). No publish code reads the
targets yet — they are inert config surface — but the file still loads validated. Constructing an instance MAPS
and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.ModuleSystem.ArtifactsConfig), so
Get-Config -Config artifacts returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-snakecasemirrorsyaml)).

Load-time rules:
  - exactly the top-level keys 'ado', 'github', and 'artifactory', each required;
  - each is a well-formed publish target (ArtifactsTarget: 'enabled' plus that target's coordinates).
```
