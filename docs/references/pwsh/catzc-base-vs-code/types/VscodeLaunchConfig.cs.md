# pwsh/Base.VSCode/types/VscodeLaunchConfig.cs

The typed record of the VS Code launch-profile registry, `configs/vscode-launch.yml`: the single authored source that `New-VsCodeLaunch`
renders to the managed `.vscode/launch.json` ([ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md)). It is registered in
`Catzc.Base.Config/configs/configs.yml` (`type: Catzc.Base.VSCode.VscodeLaunchConfig`), so `Get-Config -Config vscode-launch` returns this
typed model. Its properties mirror the YAML mapping
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an instance maps and validates the parsed YAML, collecting every violation into one throw:

- only the top-level keys `version` and `configurations` are allowed;
- `version` is a non-empty string, the VS Code launch schema version, for example `0.2.0`;
- `configurations` is a non-empty list of well-formed profiles (`VscodeLaunchProfile`), with names unique case-insensitively.
