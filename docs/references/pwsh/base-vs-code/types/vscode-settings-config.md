# pwsh/Base.VSCode/types/VscodeSettingsConfig.cs

The typed record of the VS Code workspace-settings registry, `configs/vscode-settings.yml`: the one authored file that `New-VsCodeSettings`
renders to the managed `.vscode/settings.json` ([ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md)). It is registered
in `Catzc.Base.Config/configs/configs.yml` (`type: Catzc.Base.VSCode.VscodeSettingsConfig`), so `Get-Config -Config vscode-settings` returns
this typed model. Its properties mirror the YAML mapping
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Settings

The settings are VS Code's own keys (dotted, camelCase: `markdown.preview.fontSize`, `[powershell]`), data passed through to the editor as
is. The type keeps them as an ordered passthrough map (`settings`) rather than typing each key.

## Validation

Constructing an instance maps and validates the parsed YAML, collecting every violation into one throw:

- only the top-level key `settings` is allowed, a required, non-empty map;
- a language-override key (`[markdown]`) maps to a map of that language's settings, as VS Code requires;
- `search.exclude`, when authored, is a map of glob to true or false, the map `New-VsCodeSettings` completes with the managed root-config
  targets (an authored false un-excludes past a broader glob).

## Other keys

- **`hidden_actions`** — the editor actions kept off its menus: menu id (`ViewTitle`, ...) to the command ids hidden there, written into the
  editor's own hidden-menu state by `Set-VsCodeHiddenAction`. Empty when none are declared.
- **`carried`** — the map settings another writer adds rows to: map setting key to the setting key that lists the rows that writer owns. The
  generator carries those rows and the owner key through from the settings file on disk, so neither writer overwrites the other. Empty by
  default.
