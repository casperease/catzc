# pwsh/Base.VSCode/types/VscodeExtensionsConfig.cs

The typed record of the VS Code extension-recommendation registry, `configs/vscode-extensions.yml`: the one authored file that
`New-VsCodeExtensions` renders to the managed `.vscode/extensions.json`
([ADR-REPO-ROOTCFG](../../../../drs/repository/generated-root-configs.md)). It is registered in `Catzc.Base.Config/configs/configs.yml`
(`type: Catzc.Base.VSCode.VscodeExtensionsConfig`), so `Get-Config -Config vscode-extensions` returns this typed model. Its properties mirror
the YAML mapping
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an instance maps and validates the parsed YAML, collecting every violation into one throw:

- only the top-level key `recommendations` is allowed, a non-empty list;
- each entry is a `publisher.name` extension id (id characters around a single dot), unique case-insensitively.
