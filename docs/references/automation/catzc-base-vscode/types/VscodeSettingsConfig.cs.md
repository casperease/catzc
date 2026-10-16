---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vscode/types/VscodeSettingsConfig.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8df00d95ce3c"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The VS Code workspace-settings registry, configs/vscode-settings.yml — the single authored source that
New-VSCodeSettings renders to the managed .vscode/settings.json
([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)). The settings are VS Code's own keys (dotted,
camelCase — 'markdown.preview.fontSize', '[powershell]'), data passed through to the editor as-is, so the type
keeps them as an ordered passthrough map (`settings`) rather than typing each key. Constructing an instance MAPS
and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.VSCode.VscodeSettingsConfig), so
Get-Config -Config vscode-settings returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Load-time rules:
  - only the top-level key 'settings', a required, non-empty map;
  - a language-override key ('[markdown]') maps to a map of that language's settings, as VS Code requires;
  - 'search.exclude', when authored, is a map of glob -> true/false — the map New-VSCodeSettings completes with
    the managed root-config targets (an authored false un-excludes past a broader glob).
```
