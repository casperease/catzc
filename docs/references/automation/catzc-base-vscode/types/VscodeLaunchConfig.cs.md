---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/types/VscodeLaunchConfig.cs.md
    kind: comment-page
    body_sha: ebd990426161
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The VS Code launch-profile registry, configs/vscode-launch.yml — the single authored source that New-VSCodeLaunch
renders to the managed .vscode/launch.json ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)).
Constructing an instance MAPS and VALIDATES the parsed YAML, collecting every violation into one throw.
Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.VSCode.VscodeLaunchConfig), so
Get-Config -Config vscode-launch returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Load-time rules:
  - only the top-level keys 'version' and 'configurations';
  - 'version' is a non-empty string (the VS Code launch schema version, e.g. '0.2.0');
  - 'configurations' is a non-empty list of well-formed profiles (VscodeLaunchProfile), names unique
    case-insensitively.
```
