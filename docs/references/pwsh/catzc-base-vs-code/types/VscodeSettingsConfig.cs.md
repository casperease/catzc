# pwsh/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The VS Code workspace-settings registry, configs/vscode-settings.yml — the single authored source that
New-VsCodeSettings renders to the managed .vscode/settings.json
([ADR-REPO-ROOTCFG](/docs/drs/repository/generated-root-configs.md)). The settings are VS Code's own keys (dotted,
camelCase — 'markdown.preview.fontSize', '[powershell]'), data passed through to the editor as-is, so the type
keeps them as an ordered passthrough map (`settings`) rather than typing each key. Constructing an instance MAPS
and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.VSCode.VscodeSettingsConfig), so
Get-Config -Config vscode-settings returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

Load-time rules:
  - only the top-level key 'settings', a required, non-empty map;
  - a language-override key ('[markdown]') maps to a map of that language's settings, as VS Code requires;
  - 'search.exclude', when authored, is a map of glob -> true/false — the map New-VsCodeSettings completes with
    the managed root-config targets (an authored false un-excludes past a broader glob).
```

## comment:2

Above `public IReadOnlyDictionary<string, string[]> hidden_actions { get; }`, written with `//`.

```text
The editor actions kept off its menus: menu id (ViewTitle, …) -> the command ids hidden there, written into the editor's own
hidden-menu state by Set-VsCodeHiddenAction; empty when none are declared.
```

## comment:3

Above `public IReadOnlyDictionary<string, string> carried { get; }`, written with `//`.

```text
The map settings another writer adds rows to: map setting key -> the setting key that lists the rows that writer owns. The generator
carries those rows and the owner key through from the settings file on disk, so neither writer overwrites the other; empty by default.
```
