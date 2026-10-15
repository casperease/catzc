# docs/references/automation/catzc-base-vscode/types/VscodeExtensionsConfig.cs.md

`automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The VS Code extension-recommendation registry, configs/vscode-extensions.yml — the single authored source that
New-VSCodeExtensions renders to the managed .vscode/extensions.json
([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)). Constructing an instance MAPS and VALIDATES
the parsed YAML, collecting every violation into one throw. Registered in Catzc.Base.Config/configs/configs.yml
(type: Catzc.Base.VSCode.VscodeExtensionsConfig), so Get-Config -Config vscode-extensions returns this typed
model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Load-time rules:
  - only the top-level key 'recommendations', a non-empty list;
  - each entry is a publisher.name extension id (id characters around a single dot), unique case-insensitively.
```
